import 'package:flutter/material.dart';
import 'package:flutter_app/dome/dialog.dart';
import 'package:flutter_app/dome/dialog/dialog.dart';
import 'package:flutter_app/dome/dialog/toast.dart';
import 'package:flutter_app/dome/dialog/popup.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'basicWidget/button.dart';
import 'package:flutter_app/dome/form_component/calender.dart';
import 'package:flutter_app/dome/form_component/checkBox.dart';
import 'package:flutter_app/dome/form_component/dateTimePicker.dart';
import 'package:flutter_app/dome/form_component/picker/dataModel.dart';


class DomePage extends StatefulWidget {
  @override
  _DomePageState createState() => _DomePageState();
}

class _DomePageState extends State<DomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("实验页面"),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DateTimePicker(
                  type: DateTimerPickerType.time,
                  filter: (type, options){
                    if(type == 'minute'){
                      options.retainWhere((item) => int.parse(item) % 5 == 0);
                      return options;
                    }
                    return options;
                  },
                  formatter: (val, type){
                    if(type == 'year'){
                      return "$val年";
                    }else if(type == 'month'){
                      return "$val月";
                    }else if(type =='day'){
                      return "$val日";
                    }else if(type =="hour"){
                      return "$val时";
                    }else if(type =='minute'){
                      return "$val分";
                    }
                    return val;
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool value = true;
  List<ObjectPicker> columns = [];
  List<Map<String, dynamic>> aa = [
    {
      'values': ['01', '02'],
      'defaultIndex':0
    },
    {
      'values': ['01', '02'],
      'defaultIndex':0
    },
    {
      'values': ['01', '02'],
      'defaultIndex':0
    },
    {
      'values': ['01', '02'],
      'defaultIndex':0
    },
    {
      'values': ['01', '02'],
      'defaultIndex':0
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    columns = aa.map((item) => ObjectPicker.fromJson(item)).toList();
  }
}




