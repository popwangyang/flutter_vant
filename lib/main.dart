import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_app/dome/matrix4.dart';
import 'package:flutter_app/dome/sliverAppBar.dart';
import 'package:flutter_app/dome/tabbarSample.dart';
import 'package:flutter_app/dome/drawerSample.dart';
import 'package:flutter_app/dome/buttomSample.dart';
import 'package:flutter_app/dome/statefulWidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appName = "自定义主题";
    return Container(
      child: MaterialApp(
        title: appName,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.lightBlue[600],
          accentColor: Colors.orange[600]
        ),
        home: ButDome(),
      ),
    );
  }
}

