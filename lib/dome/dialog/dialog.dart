import 'dart:async';

import 'package:flutter/material.dart';

class DialogAlert extends StatefulWidget {
  DialogAlert({
    Key key,
    this.message,
    this.title,
    this.complete,
    this.isConfirm = false,
    this.beforeClose,
    this.slotContent
  }):super(key: key);

  final String message;
  final String title;
  final Completer complete;
  final bool isConfirm;
  final Function beforeClose;
  final Widget slotContent;

  final TextStyle titleStyle = TextStyle(
      color: Colors.black,
      fontSize: 16.0
  );

  final TextStyle contentStyle  = TextStyle(
      color: Colors.black54,
      fontSize: 14.0
  );

  final TextStyle buttonStyle1 = TextStyle(
      color: Colors.blue,
      fontSize: 16.0
  );

  final TextStyle buttonStyle2 = TextStyle(
      color: Colors.black54,
      fontSize: 16.0
  );
  @override
  _DialogAlertState createState() => _DialogAlertState();
}

class _DialogAlertState extends State<DialogAlert> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360.0,
      padding: EdgeInsets.only(top: 20.0),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          alertTitle(widget.title),
          alertContent(widget.message),
          alertButton(context)
        ],
      ),
    );
  }
  Widget alertTitle(String title){
    Widget result;
    if(title != null){
      result = Container(
        height: 30.0,
        child: Center(
          child: Text(title, style: widget.titleStyle,),
        ),
      );
    }else{
      result = Container();
    }
    return result;
  }

  Widget alertContent(String message){
    if(widget.slotContent != null){
      return widget.slotContent;
    }else{
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Center(
          child: Text(message, style: widget.contentStyle, textAlign: TextAlign.center,),
        ),
      );
    }
  }

  Widget alertButton(BuildContext context){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Color.fromRGBO(235, 237, 240, 1), width: 1.0))
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
              (){
            if(widget.isConfirm){
              return  Expanded(
                  child: button(context, type: 'cancel')
              );
            }else{
              return Container();
            }
          }(),
          Expanded(
              child: button(context, type: 'ok')
          ),
        ],
      ),
    );
  }

  Widget button(BuildContext context, { String type }){
    var style = type == 'cancel' ? widget.buttonStyle2 : widget.buttonStyle1;
    var text = type == 'cancel' ? '取消':'确定';
    var result = type == 'cancel' ? false:true;
    var borderWidth = type == 'cancel' ? 1.0:0.0;
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Color.fromRGBO(235, 237, 240, 1), width: borderWidth))
      ),
      child: FlatButton(
        child: (){
          if(loading && result){
            return SizedBox(
              width: 30.0,
              height: 30.0,
              child: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }else{
            return Text(text, style: style,);
          }
        }(),
        padding: EdgeInsets.zero,
        onPressed: (){
          if(widget.beforeClose != null){
            Function done = (){
              widget.complete.complete(result);
              Navigator.of(context).pop();
            };
            if(result){
              setState(() {
                loading = true;
              });
            }
            widget.beforeClose(type, done);
          }else{
            widget.complete.complete(result);
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  bool loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = false;
  }
}

class MYDialog{

  static Future<dynamic> alert(
      BuildContext context,
      String message,
      {
        String title,
        bool maskClosable = false,
        Function beforeClose,
        Widget content
      }
      ){
    var complete = Completer();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return  Material(
            type: MaterialType.transparency,
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    if(maskClosable){
                      Navigator.of(context).pop();
                      complete.complete(false);
                    }
                  },
                ),
                Center(
                  child: DialogAlert(
                      message: message,
                      title: title,
                      complete: complete,
                      beforeClose: beforeClose,
                      slotContent: content
                  ),
                )
              ],
            ),
          );
        }
    );
    return complete.future;
  }

  static Future<dynamic> confirm(
      BuildContext context,
      String message,
      {
        String title,
        bool maskClosable = false,
        Function beforeClose,
        Widget content
      }
      ){
    var complete = Completer();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return  Material(
            type: MaterialType.transparency,
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    if(maskClosable){
                      Navigator.of(context).pop();
                      complete.complete(false);
                    }
                  },
                ),
                Center(
                  child: DialogAlert(
                    message: message,
                    title: title,
                    complete: complete,
                    isConfirm: true,
                    beforeClose: beforeClose,
                    slotContent: content
                  ),
                )
              ],
            ),
          );
        }
    );
    return complete.future;
  }
}

