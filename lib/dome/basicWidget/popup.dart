import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

typedef List<Widget> CreateWidgetList();

class Popup{

  // 弹出底部菜单列表模态对话框
  static Future<int> showModalBottom(BuildContext context) {
    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      elevation: 100.0,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      builder: (BuildContext context) {
        return Container(
          height: 400,
          child: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: listWidget(context),
              ),
              Expanded(
                flex: 1,
                child: listWidget(context),
              ),
              Expanded(
                flex: 1,
                child: listWidget(context),
              )
            ],
          ),
        );
      },
    );
  }

  static Widget listWidget(BuildContext context){
    return Container(
      child: CupertinoPicker.builder(
          itemExtent: 40,
          onSelectedItemChanged: (index){
            print(index);
          },
          childCount: 20,
          backgroundColor: Colors.white,
          itemBuilder: (context, index){
            return Text('ppp');
          }
      ),
    );
  }

}