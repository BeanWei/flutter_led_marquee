import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:card_settings/card_settings.dart';
import 'package:scroll/plugin/marquee.dart';

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
  final _initModel = MarqueeModel();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marquee',
      home: HomePage(MODEL: _initModel),

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

      routes: {
        "home": (BuildContext context) => new HomePage(),
        "setting": (BuildContext context) => new SettingPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  MarqueeModel MODEL;

  HomePage({Key key, this.MODEL}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    double statusBarH = MediaQueryData.fromWindow(window).padding.top;

    // 内容样式
    String content = widget.MODEL.Content;
    double font_size = widget.MODEL.FontSize;
    Color font_color = colorParse(widget.MODEL.FontColor);

    // 内容边距
    double sp = (screenH-font_size)/2;

    return new Scaffold(
      backgroundColor: Colors.black,
      body: new Center(
        child: new GestureDetector(
            onDoubleTap: (){
              Navigator.pushNamed(context, "setting");
            },
            //backgroundColor: Colors.black,
            child: ListView(
                children: [
                  _buildMarquee(content, font_size, font_color),
                ].map((marquee){
                  return Padding(
                    //padding: EdgeInsets.all(16.0),
                      padding: EdgeInsets.fromLTRB(0, sp-24, 0, sp+statusBarH),
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
    );
  }

  Widget _buildMarquee(scrollText, font_size, font_color) {
    return Marquee(
      text: scrollText,
      style: TextStyle(fontSize: font_size, color: font_color),
      blankSpace: 60,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: _buildPortraitLayout(),
      ),
    );
  }

  CardSettings _buildPortraitLayout() {
    return CardSettings(
      children: <Widget>[
        CardSettingsHeader(label: '自定义',),
        _buildCardSettingsParagraph(5),
        // TODO: 添加跑马灯速度，滚动文字风格样式
        _buildCardSettingsFontSizePicker(),
        _buildCardSettingsListPicker_FontColor(),
        //_buildCardSettingsListPicker_FontFamily(),
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


// Edit content model , this below data is the init data.
class MarqueeModel {
  String Content = "Welcome the LED Marquee Application by@Bean.Wei";
  double FontSize = 58;
  String FontColor = 'FF0000';
}