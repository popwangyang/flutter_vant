import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'util.dart';
import 'dataModel.dart';

typedef PickChange = Function(List result);

typedef StatelessBuilder = Widget Function(BuildContext context);


class Picker extends StatefulWidget {
  Picker({
    this.columns,
    this.initValue,
    this.pickerThemeData = PickerThemeData.defaultStyle,
    this.showToolbar = true,
    this.title = "标题",
    this.titleBuilder,
    this.onChange,
    this.onConfirm,
    this.onCancel,
  }):assert(columns is List<ObjectCascadePicker> || columns is List<ObjectPicker>),
     assert(initValue != null);

  final List<dynamic> columns;
  final List<int> initValue;
  final PickerThemeData pickerThemeData;
  final showToolbar;  // 是否展示顶部操栏
  final String title;
  final StatelessBuilder titleBuilder;
  final PickChange onChange;
  final Function onConfirm;
  final Function onCancel;

  @override
  _PickerState createState() => _PickerState();
}

class _PickerState extends State<Picker> {
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
          topTip(),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              child: Flex(
                direction: Axis.horizontal,
                children: pickerItemList.map((item){
                  return MyPicker(
                    pickerThemeData: widget.pickerThemeData,
                    data: item,
                    controller: _scrollControlers[pickerItemList.indexOf(item)],
                  );
                }).toList()
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget topTip(){
    if(widget.showToolbar){
      return Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: ColorHex("#f2f4f6"),
                    width: 1.0,
                    style: BorderStyle.solid
                )
            )
        ),
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            topTipButton(text: '取消', event: (){
              if(widget.onCancel != null){
                widget.onCancel();
              }
            }),
          topTipTitle(),
          topTipButton(text: '确认', event: (){
              if(widget.onConfirm != null){
                widget.onConfirm(results);
              }
            })
          ],
        ),
      );
    }else{
      return Container();
    }
  }

  Widget topTipTitle(){
    if(widget.showToolbar != null){
      if(widget.titleBuilder != null){
        return widget.titleBuilder(context);
      }
      return Text(widget.title, style: widget.pickerThemeData.itemTextStyle,);
    }else{
      return Container();
    }
  }

  Widget topTipButton({ String text, Function event }){
    return FlatButton(
      onPressed: event,
      child: Text(text,
        style: TextStyle(
            color: ColorHex('#1986fa'),
            fontSize: 16.0
        ),),
    );
  }



  List<FixedExtentScrollController> _scrollControlers = [];
  List pickerItemList = [];
  List results = [];
  int _scrollControllesIndex;
  List<int> initValue;


  @override
  void initState() {
    super.initState();
    initValue = widget.initValue;
    init();
  }

  void init(){
    if(this.widget.columns is List<ObjectPicker>){
      initObjectPicker();
    }else{
      initObjectCascadePicker();
    }
  }

  void initObjectPicker(){
    for(var i = 0; i < widget.columns.length; i++){
      int index = widget.initValue[i];
      ObjectPicker item = widget.columns[i];
      pickerItemList.add(item.values);
      setScrollController(index, i);
    }
  }

  void initObjectCascadePicker(){
     pickerItemList = [];
     List<ObjectCascadePicker> data = widget.columns;
     List<Map<String, dynamic>> children;
     pickerItemList.add(getPickerItem(data));
     for(var i = 0; i < initValue.length; i++){
       int index = initValue[i];
       if(i == 0){
         children = data[index].children;
         pickerItemList.add(getPickerItem(children));
       }else if(i == 1){
         List<Map<String, dynamic>> text = children[index]['children'];
         pickerItemList.add(getPickerItem(text));
       }
       if(_scrollControlers.length < initValue.length){
         setScrollController(index, i);
       }
     }
  }

  List getPickerItem(List arr){
    return arr.map((item) {
      if(item is ObjectCascadePicker){
        return item.text;
      }else{
        return item['text'];
      }
    }).toList();
  }

  void setScrollController(int index, int i){
    FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: widget.initValue[i]);
    scrollController.addListener((){
      scrollListenEvent(i);
    });
    _scrollControlers.add(scrollController);
    results.add({
      'index': index,
      'value': pickerItemList[i][index]
    });
  }

  void scrollListenEvent(int index){
    _scrollControllesIndex = index;
    Function setResultsEvent;
    if(widget.columns is ObjectPicker){
      setResultsEvent = setResults;
    }else{
      setResultsEvent = setResults1;
    }
    Utils.throttle(setResultsEvent, Duration(milliseconds: 500));
  }

  void setResults(){
    // 选择中的索引;
    int selectedItem = _scrollControlers[_scrollControllesIndex].selectedItem;
    var resultItem = {
      'index': selectedItem,
      'value': widget.columns[_scrollControllesIndex].values[selectedItem]
    };
    results.fillRange(_scrollControllesIndex, _scrollControllesIndex+1, resultItem);
    if(widget.onChange != null){
      widget.onChange(results);
    }
  }

  void setResults1(){
    int selectedItem = _scrollControlers[_scrollControllesIndex].selectedItem;
    initValue[_scrollControllesIndex] = selectedItem;
    for(var i = _scrollControllesIndex+1; i < initValue.length; i++){
      initValue[i] = 0;
      _scrollControlers[i].jumpToItem(0);
    }
    setState(() {
      initObjectCascadePicker();
      int index = 0;
      results = initValue.map((item) {
        int _index = index++;
        return {
          "index": item,
          "value": pickerItemList[_index][item]
        };
      }).toList();
      if(widget.onChange != null){
        widget.onChange(results);
      }
    });
  }
}

class MyPicker extends StatefulWidget {
  MyPicker({
    Key key,
    this.pickerThemeData,
    this.onChange,
    this.data,
    this.controller
  }):super(key: key);

  final PickerThemeData pickerThemeData;
  final Function onChange;
  final List<dynamic> data;
  final FixedExtentScrollController controller;


  @override
  _MyPickerState createState() => _MyPickerState();
}

class _MyPickerState extends State<MyPicker> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        child: CupertinoPicker(
          diameterRatio: 1.07,
          backgroundColor: Colors.white,
          itemExtent: widget.pickerThemeData.itemExtentHeight,
          useMagnifier: false,
          squeeze: 1.4,
          scrollController: widget.controller,
          onSelectedItemChanged: (val){
            _index = val;
            if(_onChange != null){
              Utils.throttle(
                  _onChange,
                  Duration(milliseconds: 500)
              );
            }
          },
          children: widget.data.map((item){
            return Container(
              height: widget.pickerThemeData.itemExtentHeight,
              alignment: Alignment.center,
              child: Text(item, style: TextStyle(
                  fontSize: 16.0
              ),),
            );
          }).toList(),
        ),
      ),
    );
  }

  Function _onChange;
  int _index;

  @override
  void initState() {
    super.initState();
    _index = 0;
    if(widget.onChange != null){
      _onChange = (){
        widget.onChange(widget.data[_index], _index);
      };
    }
  }
}







// 选择器的子项的高度
const double _itemExtentHeight = 44.0;
// 选择器子项的文本样式
const TextStyle _textStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.black
);
// 选择器标题的样式
const TextStyle _toolBarStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.black
);

class PickerThemeData {

  const PickerThemeData({
    this.itemExtentHeight = _itemExtentHeight,
    this.itemTextStyle = _textStyle,
    this.toolBarStyle = _toolBarStyle,
  });

  final double itemExtentHeight;
  final TextStyle itemTextStyle;
  final TextStyle toolBarStyle;

  static const PickerThemeData defaultStyle =  const PickerThemeData();


}






