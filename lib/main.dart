import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:flutter_led_marquee/plugin/marquee.dart';


//void main() => runApp(MyApp());
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
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    double statusBarH = MediaQueryData.fromWindow(window).padding.top;

    // 滚动文本
    String scrollText = '😀😁这😂😃是😄😅一😆😉个😊😋测😎😍试😘😗哈哈哈😙😚';

    // 字体大小
    double font_size = 58;

    // 内容边距
    double sp = (screenH-font_size)/2;

    return new Scaffold(
        backgroundColor: Colors.black,
        body: ListView(
          children: [
            _buildMarquee(scrollText, font_size),
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
    );
  }

  Widget _buildMarquee(scrollText, font_size) {
    return Marquee(
      text: scrollText,
      style: TextStyle(fontSize: font_size, color: Colors.white),
      blankSpace: 60,
    );
  }
}


