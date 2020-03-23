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

  // 通过条件rgb的值将颜色调暗
  static Color setRGB(Color color){
    int R = color.red;
    int G = color.green;
    int B = color.blue;
    double x = 0.8;
    return Color.fromRGBO((R*x).round(), (G*x).round(), (B*x).round(), 0.6);

  }


  // 将数字补零
  static setNumber(int num){
    if(num < 10){
      return '0'+num.toString();
    }else{
      return num.toString();
    }
  }

  // 给定一个日期，返回该月的天数
  static int getMonthLength(DateTime dateTime){


  }

}