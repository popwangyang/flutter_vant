import 'dart:async';

import 'package:flutter/material.dart';

class ColorHex extends Color{

  ColorHex(String color):super(_getColorFromHex(color));

  static int _getColorFromHex(String color){
    String hex = color.replaceFirst('#', '').toUpperCase();
    if(hex.length == 6){
      hex = 'FF' + hex;
    }
    return int.parse(hex, radix: 16);
  }

}

class Utils {
  static Timer timer;

  static bool flag = true;


  // 防抖函数
  static antiShake(Function fn, Duration time){

    Utils.timer?.cancel();
    Utils.timer = Timer(time, fn);

  }

  // 节流函数
  static throttle(Function fn, Duration time){
    if(Utils.flag){
      Utils.flag = false;
      Future.delayed(time, (){
        fn();
        Utils.flag = true;
      });
    }
  }



}