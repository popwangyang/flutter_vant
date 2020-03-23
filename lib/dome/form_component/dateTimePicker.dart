

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'calender.dart';
import '../util.dart';

enum DateTimerPickerType{
  dateTime,
  date,
  yearMonth,
  time,
}

typedef Formatter = String Function(String val, String type);

typedef FilterOptions = List<String> Function(String type, List<String> options);

class DateTimePicker extends StatefulWidget {

  DateTimePicker({
    Key key,
    this.initialDate,
    this.type = DateTimerPickerType.dateTime,
    this.minDate,
    this.maxDate,
    this.formatter,
    this.filter,
  }):super(key: key){
    initialDate = initialDate?? DateTime.now().add(Duration(hours: 8));
    assert(minDate == null && maxDate == null || minDate.isBefore(maxDate));
  }


  DateTime initialDate;
  final DateTimerPickerType type;
  final DateTime minDate;
  final DateTime maxDate;
  final Formatter formatter;
  final FilterOptions filter;




  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              child: Flex(
                  direction: Axis.horizontal,
                  children: columns.map((item){
                    List<String> list = widget.filter != null ? widget.filter(item['type'], item['value']) : item['value'];
                    FixedExtentScrollController controllers = scrollControllers[columns.indexOf(item)];
                    if(list.length < item['value'].length){
                      controllers = FixedExtentScrollController(initialItem: 0);
                    }
                    return pickerItem(list, item['type'], controllers);
                  }).toList()
              ),
            ),
          )
        ],
      ),
    );
  }


  Widget pickerItem(List data, String type,  FixedExtentScrollController controller){

    return Expanded(
      flex: 1,
      child: CupertinoPicker.builder(
        diameterRatio: 1.07,
        backgroundColor: Colors.white,
        itemExtent: 44.0,
        useMagnifier: false,
        squeeze: 1.4,
        scrollController: controller,
        childCount: data.length,
        itemBuilder: (context, index){
          return Container(
            height: 44.0,
            alignment: Alignment.center,
            child: (){
              if(widget.formatter != null){
                return Text(widget.formatter(data[index], type), style: TextStyle(
                    fontSize: 16.0
                ),);
              }else{
                return Text(data[index], style: TextStyle(
                    fontSize: 16.0
                ),);
              }
            }(),
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> columns = [];
  List<FixedExtentScrollController> scrollControllers = [];
  List<int> initValue = [];
  List<String> result = [];
  /// 选择范围中的最小时间
  DateTime minDate;
  /// 选择范围中的最大时间
  DateTime maxDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /// 初始化时间选择区间
    initTimeRang();
    /// 初始化选项
    initColumns();

  }

  void initTimeRang(){
    if(widget.minDate == null && widget.maxDate == null){
      int year = widget.initialDate.year;
      minDate = DateTime(year - 10);
      maxDate = DateTime(year + 11);
    }else{
      minDate = widget.minDate;
      maxDate = widget.maxDate;
    }
  }

  void initColumns(){
    List<String> yearRang = List.generate(maxDate.year - minDate.year, (_) => Utils.setNumber(minDate.year + _));
    List<String> monthRang = List.generate(12, (_) => Utils.setNumber(1 + _));
    List<String> dayRang = List.generate(31, (_) =>  Utils.setNumber(_+1));
    List<String> hourRang = List.generate(24, (_) =>  Utils.setNumber(_));
    List<String> minuteRang = List.generate(60, (_) => Utils.setNumber(_));
    int yearIndex = yearRang.indexOf(Utils.setNumber(widget.initialDate.year));
    int monthIndex = monthRang.indexOf(Utils.setNumber(widget.initialDate.month));
    int dayIndex = dayRang.indexOf(Utils.setNumber(widget.initialDate.day));
    int hourIndex = hourRang.indexOf(Utils.setNumber(widget.initialDate.hour));
    int minuteIndex = minuteRang.indexOf(Utils.setNumber(widget.initialDate.minute));
    List<int> indexArr = [];
    switch(widget.type){
      case DateTimerPickerType.dateTime:
        indexArr = [yearIndex, monthIndex, dayIndex, hourIndex, minuteIndex];
        columns = [
          {"type": 'year', 'value': yearRang},
          {"type": 'month', 'value': monthRang},
          {"type": 'day', 'value': dayRang},
          {"type": 'hour', 'value': hourRang},
          {"type": 'minute', 'value': minuteRang},
          ];
        result = [
          Utils.setNumber(widget.initialDate.year),
          Utils.setNumber(widget.initialDate.month),
          Utils.setNumber(widget.initialDate.day),
          Utils.setNumber(widget.initialDate.hour),
          Utils.setNumber(widget.initialDate.minute),
        ];
        break;
      case DateTimerPickerType.date:
        indexArr = [yearIndex, monthIndex, dayIndex];
        columns = [
          {"type": 'year', 'value': yearRang},
          {"type": 'month', 'value': monthRang},
          {"type": 'day', 'value': dayRang},
        ];
        result = [
          Utils.setNumber(widget.initialDate.year),
          Utils.setNumber(widget.initialDate.month),
          Utils.setNumber(widget.initialDate.day),
        ];
        break;
      case DateTimerPickerType.yearMonth:
        indexArr = [yearIndex, monthIndex];
        columns = [
          {"type": 'year', 'value': yearRang},
          {"type": 'month', 'value': monthRang},
        ];
        result = [
          Utils.setNumber(widget.initialDate.year),
          Utils.setNumber(widget.initialDate.month),
        ];
        break;
      case DateTimerPickerType.time:
        indexArr = [hourIndex, minuteIndex];
        columns = [
          {"type": 'hour', 'value': hourRang},
          {"type": 'minute', 'value': minuteRang},
        ];
        result = [
          Utils.setNumber(widget.initialDate.hour),
          Utils.setNumber(widget.initialDate.minute),
        ];
        break;
    }
    for(var i = 0; i< columns.length; i++){
      FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: indexArr[i]);
      scrollController.addListener((){
        listenerScroller(i);
      });
      scrollControllers.add(scrollController);
    }
  }

  void listenerScroller(int index){
    // 选择中的索引;
    int selectedItem = scrollControllers[index].selectedItem;
    String resultItem = columns[index]['value'][selectedItem];
    switch(widget.type){
      case DateTimerPickerType.dateTime:
      case DateTimerPickerType.date:
        result.fillRange(index, index+1, index == 0 ? resultItem.substring(0, 4): resultItem.substring(0, 2));
        if(index == 0 || index == 1){
          Utils.throttle(setMonthRang, Duration(milliseconds: 500));
        }
        break;
      case DateTimerPickerType.yearMonth:
        result.fillRange(index, index+1, index == 0 ? resultItem.substring(0, 4): resultItem.substring(0, 2));
        break;
      case DateTimerPickerType.time:
        result.fillRange(index, index+1, resultItem.substring(0, 2));
        break;
    }
  }

  setMonthRang(){
    setState(() {
      bool isLast = scrollControllers[2].selectedItem == (columns[2]['value'].length - 1) ? true:false;
      DateTime dateTime = DateTime(int.parse(result[0]), int.parse(result[1]));
      MyDate myDate = MyDate(date: dateTime);
      List item = myDate.getMonthCount().map((item) => Utils.setNumber(item)).toList();
      columns.fillRange(2, 3, {'value': item, 'type': 'day'});
      if(isLast || scrollControllers[2].selectedItem + 1 > item.length){
        scrollControllers[2].jumpToItem(columns[2]['value'].length - 1);
      }else{
        scrollControllers[2].jumpToItem(scrollControllers[2].selectedItem);
      }
    });
  }



}




