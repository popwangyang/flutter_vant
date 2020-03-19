import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../util.dart';
import 'dart:math';

enum ButtonType{
  primary,
  info,
  warning,
  danger
}

enum LoadingType{
  spinner,
  circular
}

enum ShapeType{
  square,
  round
}

enum ButtonSize{
  large,
  normal,
  small,
  mini
}

class MyButton extends StatefulWidget {
  MyButton({
    Key key,
    this.text = '按钮',
    this.type,
    this.plain = false,
    this.hairline = false,
    this.loading = false,
    this.block = false,
    this.shape = ShapeType.square,
    this.loadingType = LoadingType.circular,
    this.size = ButtonSize.normal,
    this.disabled = false,
    this.icon,
    this.color,
    this.onClick
  });

  final String text;
  final ButtonType type;
  final bool plain;
  final bool hairline;
  final bool loading;
  final bool disabled;
  final bool block;
  final LoadingType loadingType;
  final ShapeType shape;
  final IconData icon;
  final ButtonSize size;
  final Color color;
  final VoidCallback onClick;


  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          buttonTheme: ButtonThemeData(minWidth: 0)
      ),
      child: Container(
        child: FlatButton(
          padding: _edgeInsetsGeometry,
          highlightColor: Utils.setRGB(buttonTheme.backgroundColor),
          splashColor: Colors.transparent,
          disabledColor: buttonTheme.backgroundColor.withOpacity(0.5),
          disabledTextColor: buttonTheme.textColor,
          color: buttonTheme.backgroundColor,
          textColor: buttonTheme.textColor,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: buttonTheme.borderColor,
                  width: widget.hairline ? 1.0 : 1.5
              ),
              borderRadius: BorderRadius.all(
                  Radius.circular(widget.shape == ShapeType.square ? 4.0:26.0)
              )
          ),
          onPressed: onPress,
          child: Container(
            child: Row(
              mainAxisSize: _mainAxisSize,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                loading(),
                iconWidget(),
                Text(widget.text, style: TextStyle(fontSize: 16.0),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  ButtonTheme buttonTheme = ButtonTheme.defaultTheme;
  MainAxisSize _mainAxisSize = MainAxisSize.min;
  EdgeInsetsGeometry _edgeInsetsGeometry;
  Color primaryColor = Colors.white;
  VoidCallback onPress;

  @override
  void initState() {
    super.initState();
    setButtonTheme();
    setButtonSize();
    if(!widget.loading && !widget.disabled){
      onPress = widget.onClick;
    }
    if(widget.block){
      _mainAxisSize = MainAxisSize.max;
    }
  }


  /// 根据type参数设置按钮的主题
  void setButtonTheme(){
    switch(widget.type){
      case ButtonType.primary:
        primaryColor = ColorHex('#07c160');
        break;
      case ButtonType.danger:
        primaryColor = ColorHex('#ee0a24');
        break;
      case ButtonType.info:
        primaryColor = ColorHex('#1989fa');
        break;
      case ButtonType.warning:
        primaryColor = ColorHex('#ff976a');
        break;
    }
    if(widget.color != null){
      primaryColor = widget.color;
      buttonTheme = ButtonTheme(
          backgroundColor: primaryColor,
          textColor: Colors.white,
          borderColor: Colors.transparent
      );
    }
    if(widget.type != null){
      if(widget.plain){
        buttonTheme = ButtonTheme(
            backgroundColor: Colors.white,
            textColor: primaryColor,
            borderColor: primaryColor
        );
      }else{
        buttonTheme = ButtonTheme(
            backgroundColor: primaryColor,
            textColor: Colors.white,
            borderColor: Colors.transparent
        );
      }
    }
  }

  /// 根据size参数设置按钮的大小
  void setButtonSize(){
    switch(widget.size){
      case ButtonSize.large:
        _mainAxisSize = MainAxisSize.max;
        _edgeInsetsGeometry = EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 20.0
        );
        break;
      case ButtonSize.normal:
        _edgeInsetsGeometry = EdgeInsets.symmetric(
            horizontal: 18.0,
            vertical: 12.0
        );
        break;
      case ButtonSize.small:
        _edgeInsetsGeometry = EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0
        );
        break;
      case ButtonSize.mini:
        _edgeInsetsGeometry = EdgeInsets.symmetric(
            horizontal: 6.0,
            vertical: 4.0
        );
        break;
    }
  }

  Widget loading(){
    if(!widget.loading){
      return Container(
        width: 0,
        height: 0,
      );
    }

    Widget loadingWidget;
    if(widget.loadingType == LoadingType.circular){
      loadingWidget = CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: new AlwaysStoppedAnimation<Color>(buttonTheme.textColor),
      );
    }else{
      loadingWidget = CupertinoActivityIndicator();
    }
    return Container(
      width: 24.0,
      height: 24.0,
      padding: EdgeInsets.all(3.0),
      margin: EdgeInsets.only(right: 6.0),
      child: loadingWidget,
    );
  }

  Widget iconWidget(){
    if(widget.icon == null){
      return Container(
        width: 0,
        height: 0,
      );
    }
    return Container(
      child: Icon(
        widget.icon,
        size: 20,
        color: widget.plain ? buttonTheme.backgroundColor:buttonTheme.textColor,
      ),
      margin: EdgeInsets.only(right: 6.0),
    );
  }

}


class ButtonTheme {

  const ButtonTheme({
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0xffeaebec),
    this.textColor = Colors.black,
 });

  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  static const ButtonTheme defaultTheme =  const ButtonTheme();
}
