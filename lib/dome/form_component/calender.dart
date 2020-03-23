
import 'package:flutter/material.dart';
import 'package:flutter_app/dome/basicWidget/button.dart';


enum CalenderType {
  single,
  multiple,
  range
}

class Calendar {


  static Future<List<DateTime>> show(
      BuildContext context,
      {
        DateTime minDate,
        DateTime maxDate,
        CalenderType type = CalenderType.single,
        Color color = const Color(0xffee0a24),
        bool showConfirm = true,
        String confirmText = "确定",
        String confirmDisabledText = "确定",
        List<DateTime> initDate,
      }){
    DateTime _minDate = minDate?? DateTime.now();
    DateTime _maxDate = maxDate?? _minDate.add(Duration(days: 365));
    assert(_maxDate.isAfter(_minDate));
    if(type == CalenderType.range){
      assert(initDate == null || initDate.length == 2);
      if(initDate != null && initDate.length == 2){
        assert(initDate[0].isBefore(initDate[1]));
      }
    }
    if(type == CalenderType.single){
      assert(initDate == null || initDate.length == 1);
    }
    return showModalBottomSheet<List<DateTime>>(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(20.0)
          )
        ),
        builder: (context){
          return Container(
            height: 510.0,
            width: double.infinity,
            child: CalendarBox(
              maxDate: _maxDate,
              minDate: _minDate,
              type: type,
              color: color,
              showConfirm: showConfirm,
              confirmText: confirmText,
              confirmDisabledText: confirmDisabledText,
              initDate:initDate,
            ),
          );
        }
    );
  }


}

class CalendarBox extends StatefulWidget {

  CalendarBox({
    Key key,
    this.minDate,
    this.maxDate,
    this.type,
    this.color,
    this.showConfirm,
    this.confirmText,
    this.confirmDisabledText,
    this.initDate,
  }):super(key: key);

  final DateTime minDate;
  final DateTime maxDate;
  final CalenderType type;
  final Color color;
  final bool showConfirm;
  final String confirmText;
  final String confirmDisabledText;
  final List<DateTime> initDate;

  @override
  _CalendarBoxState createState() => _CalendarBoxState();
}

class _CalendarBoxState extends State<CalendarBox> {
  @override
  Widget build(BuildContext context) {
    viewPortWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          title(),
          week(),
          Expanded(
            child: Container(
              child: ListView.builder(
                controller: _controller,
                itemCount: _month.length,
                itemBuilder: (context, index){
                  return MonthDetail(
                    viewPortWidth: viewPortWidth,
                    date: _month[index],
                    showTitle: index == 0 ? false:true,
                    type: widget.type,
                    selectedDateList: selectedDateList,
                    onClick: onClick,
                    color: widget.color,
                  );
                },
              ),
            ),
          ),
          (){
            if(widget.showConfirm){
              return footer();
            }else{
              return Container();
            }
          }()
        ],
      ),
    );
  }

  /// 组件的title
  Widget title(){
    return Container(
      height: 44.0,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Center(
            child: Text('日期选择', style: TextStyle(fontSize: 16.0),),
          ),
          Positioned(
            child: Icon(Icons.clear, size: 28.0, color: Colors.grey,),
            right: 20.0,
          )
        ],
      ),
    );
  }

  Widget week(){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: _boxShadow,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 44.0,
            child: Center(
              child: Text(weekTime, style: TextStyle(fontSize: 14.0)),
            ),
          ),
          Wrap(
            direction: Axis.horizontal,
            children: weeks.map((item){
              return Container(
                height: 30.0,
                width: MediaQuery.of(context).size.width/7,
                child: Center(
                  child: Text(item),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget footer(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: MyButton(
        color: widget.color,
        size: ButtonSize.normal,
        shape: ShapeType.round,
        block: true,
        disabled: disabled,
        text: buttonText,
        onClick: (){
          List<DateTime> result = [];
          if(widget.type == CalenderType.range){
            DateTime startTime = selectedDateList[0];
            DateTime endTime = selectedDateList[1];

            while(startTime.isBefore(endTime) || startTime == endTime){
              result.add(startTime);
              startTime = startTime.add(Duration(days: 1));
            }
          }else{
            result = selectedDateList;
          }
          Navigator.of(context).pop(result);
        },
      ),
    );
  }

  List<String> weeks = ['日', '一', '二', '三', '四', '五', '六'];
  double viewPortWidth;
  ScrollController _controller = ScrollController(initialScrollOffset: 0);
  List<BoxShadow> _boxShadow = [];
  List<MyDate> _month = [];
  String weekTime;
  /// 单选模式存储位置
  List<DateTime> selectedDateList = [];
  bool disabled = false;
  String buttonText = "确定";


  DateTime startTime;
  DateTime endTime;

  @override
  void initState() {
    super.initState();
    _controller.addListener(scrollListen);
    initTime();
    initValue();



  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(scrollListen);
  }

  void scrollListen(){
    double scrollTop = _controller.offset;
    double boxHeight = 44 + 64 * 5.0;
    int index = (scrollTop / boxHeight).floor();
    setWeekTime(_month[index]);
    if(scrollTop == 0.0){
      _boxShadow = [];

    }else{
      _boxShadow = [
        BoxShadow(
            color: Color.fromRGBO(125, 126, 128, 0.16),
            offset: Offset(-3, 8),
            blurRadius: 10,
            spreadRadius: 0
        )
      ];
    }
    setState(() {});
  }

  void setWeekTime(MyDate date){
    weekTime = date.date.year.toString() + "年" + date.date.month.toString() + '月';
  }

  void initTime(){
    MyDate minDate = MyDate(date: widget.minDate);

    MyDate maxDate = MyDate(date: widget.maxDate);
    while(maxDate >= minDate){
      MyDate time = MyDate(date: DateTime(minDate.date.year, minDate.date.month, 1));
      _month.add(time);
      minDate.setMonth(num: 1);
    }

    setWeekTime(_month[0]);
    setState(() {});
  }

  void initValue(){
    buttonText = widget.confirmText;
    selectedDateList = widget.initDate?? [];
    if(widget.type == CalenderType.range){
      if(widget.initDate == null){
        DateTime startTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
        DateTime endTime = startTime.add(Duration(days: 1));
        selectedDateList.clear();
        selectedDateList.addAll([startTime, endTime]);
        print(selectedDateList);
      }
    }
  }

  void onClick(date){

    switch(widget.type){
      case CalenderType.single:
          setSingleDate(date);
        break;
      case CalenderType.multiple:
        setMultipleDate(date);
        break;
      case CalenderType.range:
        setRangeDate(date);
        break;

    }

    setState(() {});
  }

  void setSingleDate(DateTime date){
    if(selectedDateList.length == 0){
      selectedDateList.add(date);
    }else{
      selectedDateList = [date];
    }
  }

  void setMultipleDate(DateTime date){
    if(selectedDateList.indexOf(date) > -1){
      selectedDateList.remove(date);
    }else{
      selectedDateList.add(date);
    }
  }

  void setRangeDate(DateTime date){
    if(selectedDateList.length == 0 || selectedDateList.length == 2){
      selectedDateList.clear();
      selectedDateList.add(date);
      disabled = true;
      buttonText = widget.confirmDisabledText;
    }else{
      disabled = false;
      buttonText = widget.confirmText;
      DateTime startTime = selectedDateList[0];
      if(startTime.isAfter(date)){
        selectedDateList.clear();
        selectedDateList.add(date);
      }else{
        selectedDateList.add(date);
      }
    }
  }

}



class MonthDetail extends StatelessWidget {

  MonthDetail({
    this.viewPortWidth,
    this.date,
    this.showTitle = true,
    this.onClick,
    this.type,
    this.selectedDateList,
    this.color,
  });

  final double viewPortWidth;
  final MyDate date;
  final bool showTitle;
  final Function onClick;
  final CalenderType type;
  final List<DateTime> selectedDateList;
  final Color color;


  @override
  Widget build(BuildContext context) {
    String time = date.date.year.toString() +"年"+ date.date.month.toString()+'月';
    int week = DateTime(date.date.year, date.date.month, 1).weekday;
    List<int> days = List.generate(week == 7 ? 0:week, (_) => 0);
    days.addAll(date.getMonthCount());
    return Container(
      child: Column(
        children: <Widget>[
          (){
            if(showTitle){
              return SizedBox(
                width: double.infinity,
                height: 44.0,
                child: Center(
                  child: Text(time),
                ),
              );
            }else{
              return Container();
            }
          }(),
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                child: Container(
                  child: Center(
                    child: Text(
                      date.date.month.toString(),
                      style: TextStyle(
                          fontSize: 160,
                          color: Color.fromRGBO(242, 243, 245, 0.8)
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                child: Wrap(
                  direction: Axis.horizontal,
                  children: days.map((item) => day(item)).toList(),
                ),
              )
            ],
          )
        ],
      ),
    );
  }



  Widget day(int day){
    DateTime time = DateTime(date.date.year, date.date.month, day);
    MyDayStyle myDayStyle = MyDayStyle(time: time, selectedDateList: selectedDateList, type: type, color: color);
    return GestureDetector(
      onTap: (){
        DateTime time = DateTime(date.date.year, date.date.month, day);
        onClick(time);
      },
      child: Container(
        width: viewPortWidth/7,
        height: 64,
        decoration: day == 0 ? null:myDayStyle.boxDecoration,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Center(
              child: Text(day.toString() == '0' ? "" : day.toString(), style: myDayStyle.textStyle,),
            ),
            Positioned(
                top: 40.0,
                child: Opacity(
                  opacity: myDayStyle.opacity,
                  child: Text(myDayStyle.text,
                    style: TextStyle(
                        color: Colors.white),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}



class MyDate {

  MyDate({this.date});

  DateTime date;

  void setMonth({int num = 1}){
    int day = 0;
    int year = date.year;
    int month = date.month;
    for(var i = 0; i < num; i++){
      month = month + 1 > 12 ? 1:month + 1;
      year = month + 1 > 12 ? year + 1: year;
      day = day + getMonthCount(year: year, month: month).length;
    }
    date = date.add(Duration(days: day));
  }

  /// 判断平年闰年；
  bool isLeapYear({int year}){
    year = year ?? date.year;
    return (year % 400 == 0) || (year % 100 != 0 && year % 4 == 0);
  }

  /// 获取每个月的天数
  List<int> getMonthCount({int year, int month}){
    year = year ?? date.year;
    month = month ?? date.month;

    final List monthDays = [ 31, null, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];

    int count = monthDays[month - 1]?? (isLeapYear(year: year) ? 29:28);

    return List.generate(count, (day) => day + 1);
  }

  /// 比较两个时间的大小
  bool operator >= (MyDate myDate){
    return date.isAfter(myDate.date) || date == myDate.date;
  }

}

class MyDayStyle{

  MyDayStyle({this.time, this.selectedDateList, this.type, this.color}){
    init();
  }

  final DateTime time;
  final List<DateTime> selectedDateList;
  final CalenderType type;
  final Color color;

  double opacity = 0.0;
  String text = '';
  BoxDecoration boxDecoration;
  TextStyle textStyle;

  void init(){
    switch(type){
      case CalenderType.single:
        if(selectedDateList.indexOf(time) > -1){
          boxDecoration = BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(4.0))
          );
          textStyle = TextStyle(
            color: Colors.white
          );
        }
        break;
      case CalenderType.multiple:
        if(selectedDateList.indexOf(time) > -1){
          DateTime beforeDay = time.add(Duration(days: -1));
          DateTime afterDay = time.add(Duration(days: 1));
          BorderRadius radius;
          if(selectedDateList.indexOf(beforeDay) > -1 && selectedDateList.indexOf(afterDay) > -1){
            radius = null;
          }else if(selectedDateList.indexOf(beforeDay) > -1 && selectedDateList.indexOf(afterDay) == -1){
            radius = BorderRadius.only(bottomRight: Radius.circular(4.0), topRight: Radius.circular(4.0));
          }else if(selectedDateList.indexOf(beforeDay) == -1 && selectedDateList.indexOf(afterDay) > -1){
            radius = BorderRadius.only(bottomLeft: Radius.circular(4.0), topLeft: Radius.circular(4.0));
          }else{
            radius = BorderRadius.all(Radius.circular(4.0));
          }
          boxDecoration = BoxDecoration(
              color: color,
              borderRadius: radius
          );
          textStyle = TextStyle(
              color: Colors.white
          );
        }
        break;
      case CalenderType.range:
        if(selectedDateList.length == 1){
          if(selectedDateList.indexOf(time) > -1){
            boxDecoration = BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(4.0))
            );
            textStyle = TextStyle(
                color: Colors.white
            );
            opacity = 1.0;
            text = "开始";
          }
        }else if(selectedDateList.length == 2){
          if(time.isAfter(selectedDateList[0])  && time.isBefore(selectedDateList[1])){
            boxDecoration = BoxDecoration(
              color: color.withOpacity(0.1),
            );
            textStyle = TextStyle(
                color: color
            );
          }else if(time == selectedDateList[0]){
            boxDecoration = BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4.0), topLeft: Radius.circular(4.0))
            );
            textStyle = TextStyle(
                color: Colors.white
            );
            opacity = 1.0;
            text = "开始";
          }else if(time == selectedDateList[1]){
            boxDecoration = BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(4.0), topRight: Radius.circular(4.0))
            );
            textStyle = TextStyle(
                color: Colors.white
            );
            opacity = 1.0;
            text = "结束";
          }
        }
        break;
    }
  }

}


