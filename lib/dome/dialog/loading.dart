import 'package:flutter/material.dart';

class LoadBox extends StatelessWidget {

  LoadBox({Key key, this.loadText}):super(key: key);
  final String loadText;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: 120,
        height: 120,
        child: Container(
          decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(8.0)
                  )
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  loadText,
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Show {
  Show({this.context});
  BuildContext context;

  void show(){}

  void close(){
    Navigator.pop(context);
  }
}


class Loading extends Show{

  Loading(
      this.context,
      {
        this.title = '加载中...',
        this.maskClosable = false,
      }) :super(context: context){
    assert(context != null);
  }


  final String title;
  final BuildContext context;
  final bool maskClosable;

  @override
  void show(){
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
                      close();
                    }
                  },
                ),
                Center(
                  child: LoadBox(loadText: title,),
                )
              ],
            ),
          );
        }
    );
  }
}

