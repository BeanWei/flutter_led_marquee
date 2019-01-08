import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter_led_marquee/plugin/marquee.dart';

void main() {
  // 全屏显示
  SystemChrome.setEnabledSystemUIOverlays([]);
  // 强制横屏
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marquee',
      //home: HomePage(MODEL: _initModel),
      home: SettingPage(),

      // Card them
      theme: ThemeData(
        accentColor: Colors.indigo[400], // background color of card headers
        cardColor: Colors.white, // background color of fields
        backgroundColor: Colors.indigo[100], // color outside the card
        primaryColor: Colors.teal, // color of page header
        buttonColor: Colors.lightBlueAccent[100], // background color of buttons
        textTheme: TextTheme(
          button:
          TextStyle(color: Colors.deepPurple[900]), // style of button text
          subhead: TextStyle(color: Colors.grey[800]), // style of input text
        ),
        primaryTextTheme: TextTheme(
          title: TextStyle(color: Colors.lightBlue[50]), // style for headers
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.indigo[400]), // style for labels
        ),
      ),
    );
  }
}

class SettingPage extends StatefulWidget {
  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {

  // form model
  final _marqueeModel = MarqueeModel();

  bool _autoValidate = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // form key
  final GlobalKey<FormState> _scrollTextContentKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _scrollTextFontSizeKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _scrollTextFontColorKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _scrollTextSpeedKey = GlobalKey<FormState>();

  // 双击返回退出应用
  int _lastClickTime = 0;
  Future<bool> _onWillPop() {
    int nowTime = new DateTime.now().microsecondsSinceEpoch;
    if (_lastClickTime != 0 && nowTime - _lastClickTime > 800) {
      return showDialog(
          context: context,
          builder: (context) =>
          new AlertDialog(
            title: new Text('提示'),
            content: new Text('是否退出应用'),
            actions: <Widget>[
              new FlatButton(onPressed: () {
                Navigator.of(context).pop(false);
              },
                child: new Text('否'),),
              new FlatButton(onPressed: () {
                //Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => route == null);
                Navigator.of(context).pop(true);
              },
                child: new Text('是'),),
            ],
          )
      ) ?? false;
    } else {
      _lastClickTime = new DateTime.now().microsecondsSinceEpoch;
      new Future.delayed(const Duration(milliseconds: 800), () {
        _lastClickTime = 0;
      });
      return new Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          key: _scaffoldKey,
          body: Form(
            key: _formKey,
            child: _buildPortraitLayout(),
          ),
        ),
        onWillPop: _onWillPop
    );
  }

  CardSettings _buildPortraitLayout() {
    return CardSettings(
      children: <Widget>[
        CardSettingsHeader(label: '自定义',),
        _buildCardSettingsParagraph(5),
        _buildCardSettingsFontSizePicker(),
        _buildCardSettingsListPicker_FontColor(),
        // TODO: 添加滚动文字风格样式
        //_buildCardSettingsListPicker_FontFamily(),
        _buildCardSettingsTextScrollSpeedPicker(),
        _buildCardSettingsButton_Save(),
        _buildCardSettingsButton_Reset(),
      ],
    );
  }

  CardSettingsParagraph _buildCardSettingsParagraph(int lines) {
    return CardSettingsParagraph(
      key: _scrollTextContentKey,
      label: '滚动文本',
      initialValue: _marqueeModel.Content,
      numberOfLines: lines,
      onSaved: (value) => _marqueeModel.Content = value,
    );
  }

  CardSettingsDouble _buildCardSettingsFontSizePicker({TextAlign labelAligin}) {
    return CardSettingsDouble (
      key: _scrollTextFontSizeKey,
      label: '文字大小',
      labelAlign: labelAligin,
      initialValue: _marqueeModel.FontSize,
      validator: (value) {
        if (value == null) return '请输入文字大小';
        if (value < 10) return '大小不可小于10';
        if (value > 480) return '大小不可超过480';
        return null;
      },
      onSaved: (value) => _marqueeModel.FontSize = value,
    );
  }

  CardSettingsColorPicker _buildCardSettingsListPicker_FontColor() {
    return CardSettingsColorPicker(
      key: _scrollTextFontColorKey,
      label: '字体颜色',
      initialValue: intelligentCast<Color>(_marqueeModel.FontColor),
      onSaved: (value) => _marqueeModel.FontColor = colorToString(value),
    );
  }

  CardSettingsListPicker _buildCardSettingsTextScrollSpeedPicker() {
    return CardSettingsListPicker(
      key: _scrollTextSpeedKey,
      label: '滚动速度',
      initialValue: _marqueeModel.ScrollSpeed,
      hintText: '选择滚动速度',
      autovalidate: _autoValidate,
      options: <String>['慢', '正常', '快'],
      validator: (String value) {
        if (value == null || value.isEmpty) return '必须选择一种滚动速度';
        return null;
      },
      onSaved: (value) => _marqueeModel.ScrollSpeed = value,
    );
  }

  // handlers
  CardSettingsButton _buildCardSettingsButton_Save() {
    return CardSettingsButton(
      label: '确定',
      onPressed: _savePressed,
    );
  }
  CardSettingsButton _buildCardSettingsButton_Reset() {
    return CardSettingsButton(
      label: '重置',
      onPressed: _resetPressed,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
    );
  }

  // Event handles
  Future _savePressed() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) {
        return new HomePage(MODEL: _marqueeModel,);
      }));
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
  void _resetPressed() {
    _formKey.currentState.reset();
  }
}

class HomePage extends StatefulWidget {
  MarqueeModel MODEL;

  HomePage({Key key, this.MODEL}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // 禁用返回按钮
  Future<bool> _onWillPop()=>new Future.value(false);

  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    // TODO: 无法获取状态栏高度.
    //double statusBarH = MediaQueryData.fromWindow(window).padding.top;

    // 内容样式
    String content = widget.MODEL.Content;
    double font_size = widget.MODEL.FontSize;
    Color font_color = colorParse(widget.MODEL.FontColor);
    double textScrollSpeed;
    switch (widget.MODEL.ScrollSpeed) {
      case '慢':
        textScrollSpeed = 50.0;
        break;
      case '正常':
        textScrollSpeed = 100.0;
        break;
      case '快':
        textScrollSpeed = 200.0;
        break;
    }

    // 内容边距
    double sp = (screenH-font_size)/2;

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        backgroundColor: Colors.black,
        body: new Center(
          child: new GestureDetector(
              onDoubleTap: (){
                Navigator.pop(context);
              },
              //backgroundColor: Colors.black,
              child: ListView(
                  children: [
                    _buildMarquee(content, font_size, font_color, textScrollSpeed),
                  ].map((marquee){
                    return Padding(
                        padding: EdgeInsets.fromLTRB(0, sp, 0, sp),
                        child: Container(
                            height: screenH,
                            color: Colors.black,
                            child: marquee
                        )
                    );
                  }).toList()
              )
          ),
        ),
      ),
    );
  }

  Widget _buildMarquee(scrollText, font_size, font_color, textScrollSpeed) {
    return Marquee(
      text: scrollText,
      style: TextStyle(fontSize: font_size, color: font_color),
      blankSpace: 60,
      velocity: textScrollSpeed, // set slow/normal/fast 50,100,200
    );
  }
}

// Edit content model , this below data is the init data.
class MarqueeModel {
  String Content = "Welcome the LED Marquee Application by@Bean.Wei";
  double FontSize = 58;
  String FontColor = 'FF0000';
  String ScrollSpeed = '正常';
}