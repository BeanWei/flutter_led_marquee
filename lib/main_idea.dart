/// 重写编辑页面，加入全部特性，Duang.Duang.Duang
///
///TODO: 数据的传递及获取


import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _count = 1;
  int speedValue = 1;
  Map<int, int> s = {0: 0};
  AnimationController _controller;
  static const List<IconData> ficons = const[Icons.image, Icons.text_fields];
  @override
  void initState() {
    _controller = new AnimationController(vsync: this, duration: const Duration(milliseconds: 120),);
  }
  Widget build(BuildContext context) {
    List<Widget> _mycards = new List.generate(_count, (int i) => (new _Card(s: s[i],)));
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;
    return Scaffold(
      appBar: AppBar(
        title: Text('LED弹幕'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.star_border),
            onPressed: (){},
          )
        ],
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Column(
              children: _mycards
            ),
            new Padding(
              padding: new EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
              child: new Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('弹幕滚动速度:     '),
                      Text('慢'),
                      Radio(
                          value: 0,
                          groupValue: speedValue,
                          activeColor: Colors.blueAccent,
                          onChanged: (T) {
                            updateSpeedValue(T);
                          }
                      ),
                      Text('      正常'),
                      Radio(
                          value: 1,
                          groupValue: speedValue,
                          activeColor: Colors.blueAccent,
                          onChanged: (T) {
                            updateSpeedValue(T);
                          }
                      ),
                      Text('      快'),
                      Radio(
                          value: 2,
                          groupValue: speedValue,
                          activeColor: Colors.blueAccent,
                          onChanged: (T) {
                            updateSpeedValue(T);
                          }
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      new Expanded(
                          child: new RaisedButton(
                            //borderSide:new BorderSide(color: Theme.of(context).primaryColor),
                            child: new Text('确定',style: new TextStyle(color: Theme.of(context).primaryColor),),
                            onPressed: (){},
                          )
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: new Column(
        mainAxisSize: MainAxisSize.min,
        children: new List.generate(ficons.length, (int index) {
          Widget child = new Container(
            height: 70.0,
            width: 56.0,
            alignment: FractionalOffset.topCenter,
            child: new ScaleTransition(
              scale: new CurvedAnimation(
                parent: _controller,
                curve: new Interval(
                  0.0,
                  1.0 - index / ficons.length / 2.0,
                  curve: Curves.easeOut
                )
              ),
              child: new FloatingActionButton(
                heroTag: null,
                backgroundColor: backgroundColor,
                mini: true,
                child: Icon(ficons[index], color: foregroundColor,),
                onPressed: () {
                  _addcard(index);
                },
              ),
            ),
          );
          return child;
        }).toList()..add(
          new FloatingActionButton(
            heroTag: null,
            child: new AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform: new Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                  alignment: FractionalOffset.center,
                  child: new Icon(_controller.isDismissed ? Icons.add : Icons.close),
                );
              },
            ),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
          )
        ),
      )
    );
  }

  void _addcard(index) {
    setState(() {
      s[_count] = index;
      _count = _count + 1;
    });
  }

  void updateSpeedValue(int v) {
    setState(() {
      speedValue = v;
    });
  }

//  Widget _card() {
//    return new Card(
//      child: ListTile(
//        title: Text('DEMO'),
//        subtitle: Text('xxxx.com'),
//        leading: Icon(Icons.edit_location, color: Colors.blueAccent,),
//      ),
//    );
//  }
}

class _Card extends StatefulWidget {
  int s;
  _Card({Key key, this.s}) : super(key: key);
  @override
  _CardState createState() => _CardState();
}

class _CardState extends State<_Card> {
  List colorstype = ["红色", "黄色", "白色"];
  List fontsize = ["正常", "大", "超大"];
  List imgsize = ["正常", "大", "超大"];
  List<DropdownMenuItem<String>> _dropDownMenuColors;
  List<DropdownMenuItem<String>> _dropDownMenuFontSize;
  List<DropdownMenuItem<String>> _dropDownMenuImgSize;
  String _selectedColor;
  String _selectedFontSize;
  String _selectedImgSize;
  @override
  void initState() {
    _dropDownMenuColors = buildAndGetDropDownMenuItems(colorstype);
    _dropDownMenuFontSize = buildAndGetDropDownMenuItems(fontsize);
    _dropDownMenuImgSize = buildAndGetDropDownMenuItems(imgsize);
    super.initState();
  }
  List<DropdownMenuItem<String>> buildAndGetDropDownMenuItems(List s) {
    List<DropdownMenuItem<String>> items = new List();
    for (String str in s) {
      items.add(new DropdownMenuItem(value: str, child: new Text(str)));
    }
    return items;
  }

  void changedDropDownColor(String selectedColor) {
    setState(() {
      _selectedColor = selectedColor;

    });
  }
  void changedDropDownFontSize(String selectedFontSize) {
    setState(() {
      _selectedFontSize = selectedFontSize;

    });
  }
  void changedDropDownImgSize(String selectedImgSize) {
    setState(() {
      _selectedImgSize = selectedImgSize;

    });
  }

  File _image;
  Future getImagefromG() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }
  Future getImagefromC() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (widget.s == 0) {
      return new Card(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: new Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlineButton(
                      borderSide:new BorderSide(color: Theme.of(context).primaryColor),
                      child: new Text('本地图片',style: new TextStyle(color: Theme.of(context).primaryColor),),
                      onPressed: (){
                        getImagefromG();
                      },
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: OutlineButton(
                      borderSide:new BorderSide(color: Theme.of(context).primaryColor),
                      child: new Text('拍照新建',style: new TextStyle(color: Theme.of(context).primaryColor),),
                      onPressed: (){
                        getImagefromC();
                      },
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Center(
                      child: _image == null
                          ? Text('暂未未选择图片...')
                          : Image.file(_image, width: 60, height: 60,),
                    ),
                    flex: 3,
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: DropdownButton(
                        value: _selectedImgSize,
                        items: _dropDownMenuImgSize,
                        hint: Text('选择图片大小'),
                        onChanged: changedDropDownImgSize,
                      ),
                    ),

                    flex: 1,
                  ),
                  Expanded(
                    child: IconButton(icon: Icon(Icons.delete), onPressed: null),
                    flex: 1,
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return new Card(
        child: new Column(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                //contentPadding: EdgeInsets.all(10.0),
                icon: Icon(Icons.text_fields),
                labelText: '输入文本',
              ),
              obscureText: true,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: DropdownButton(
                      value: _selectedColor,
                      items: _dropDownMenuColors,
                      hint: Text('选择文本颜色'),
                      onChanged: changedDropDownColor,
                    ),
                  ),

                  flex: 1,
                ),
                Expanded(
                  child: Center(
                    child: DropdownButton(
                      value: _selectedFontSize,
                      items: _dropDownMenuFontSize,
                      hint: Text('选择文字大小'),
                      onChanged: changedDropDownFontSize,
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: IconButton(icon: Icon(Icons.delete), onPressed: null),
                  flex: 1,
                ),
              ],
            )
          ],
        ),
      );
    }
  }
}

