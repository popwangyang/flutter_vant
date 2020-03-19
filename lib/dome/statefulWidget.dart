import 'package:flutter/material.dart';

class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {

  int num = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("验证父子组件的更新问题"),
        ),
        body: Center(
          child: StatefulBuilder(
            builder: (context, setState){
              return Text("ppp");
            },
          ),
        ),
      ),
    );
  }
}

class ChildWidget1 extends StatefulWidget {
  ChildWidget1({Key key, this.onChange, this.num}):super(key: key);
  final Function onChange;
  final int num;
  @override
  _ChildWidget1State createState() => _ChildWidget1State();
}

class _ChildWidget1State extends State<ChildWidget1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: (){
          widget.onChange();
        },
        child: Text("按钮${widget.num}"),
      ),
    );
  }
}


class ChildWidget extends StatelessWidget {

  ChildWidget({Key key, this.onChange, this.num}):super(key: key);
  final Function onChange;
  final int num;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: (){
          onChange();
        },
        child: Text("按钮$num"),
      ),
    );
  }
}

