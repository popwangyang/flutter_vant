import 'package:flutter/material.dart';
import 'package:flutter_app/dome/dialog.dart';
import 'package:flutter_app/dome/dialog/dialog.dart';
import 'package:flutter_app/dome/dialog/toast.dart';
import 'package:flutter_app/dome/dialog/popup.dart';
import 'package:flutter_app/dome/dialog/picker.dart';
import 'dialog/util.dart';
import 'dialog/dataModel.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'basicWidget/button.dart';
import 'package:flutter_app/dome/form_component/calender.dart';

class ButDome extends StatelessWidget {


  @override
  Widget build(BuildContext context) {


    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("按钮组件"),
        ),
        floatingActionButton: Builder(builder: (BuildContext context){
          return FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: "点击按钮",
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            elevation: 7.0,
            highlightElevation: 16.0,
            onPressed: (){
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("你点击了按钮"),
              ));
            },
          );
        },),
        body: Container(
          color: ColorHex('#f7f8fa'),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MyButton(
                  type: ButtonType.info,
                  text: '按钮',
                  loadingType: LoadingType.circular,
                  onClick: (){
                    Calendar.show(context, type: CalenderType.multiple);
                  },
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
