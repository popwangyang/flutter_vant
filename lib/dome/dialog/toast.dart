import 'package:flutter/material.dart';

class ShowToast{

  static OverlayState overlayState;

  static OverlayEntry overlayEntry;

  static bool isLong = false;

  static init({
    @required BuildContext context,
    @required WidgetBuilder builder,
  }){
    ShowToast.clear();
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        builder: (context) => builder(context)
    );
    overlayState.insert(overlayEntry);
  }

  static void clear(){
    if(overlayEntry != null){
      overlayEntry.remove();
      overlayEntry = null;
    }
  }
}

enum ToastType {
  loading,
  message,

}

enum Position {
  top,
  center,
  bottom
}



class ToastBox extends StatelessWidget {
  ToastBox({
    Key key,
    this.message,
    this.type,
    this.position,
    this.icon,
    this.animationTime
  }):super(key: key);
  final String message;
  final ToastType type;
  final Position position;
  final IconData icon;
  final int animationTime;


  @override
  Widget build(BuildContext context) {
    Alignment alignment;
    switch(position){
      case Position.top:
        alignment = Alignment(0, -1);
        break;
      case Position.center:
        alignment = Alignment(0, 0);
        break;
      case Position.bottom:
        alignment = Alignment(0, 1);
        break;
    }
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 120, horizontal: 0),
        alignment: alignment,
        child: BoxFadeTransition(
          duration: Duration(milliseconds: animationTime),
          child: (){
            if(type == ToastType.message){
              return messageBox();
            }else{
              return content();
            }
          }()
        ),
      ),
    );
  }




  Widget content(){
    return Container(
      padding: EdgeInsets.all(10),
      width: 150,
      height: 150,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 100,
            height: 80,
            child: Center(
              child: (){
                if(icon == null){
                  return loading();
                }else{
                  return iconWidget(icon);
                }
              }(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(message, style: TextStyle(
                fontSize: 16.0,
                color: Colors.white
            ),),
          )

        ],
      ),
      decoration: ShapeDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.6),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)
          )
      ),
    );
  }

  Widget iconWidget(IconData iconData){
    return Icon(iconData, size: 50, color: Colors.white,);
  }

  Widget messageBox(){
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
        child: Text(message, style: TextStyle(
            fontSize: 16.0,
            color: Colors.white
        ),),
      ),
      decoration: ShapeDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.6),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)
          )
      ),
    );
  }

  Widget loading(){
    return SizedBox(
      width: 30,
      height: 30,
      child: CircularProgressIndicator(
        strokeWidth: 3.0,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

}

class Toast{

  Toast(
      BuildContext context,
      {
        @required String message,
        bool forbidClick = false,
        int duration = 2000,
        int animationTime = 200,
        Position position = Position.center,
        IconData iconData,
        ToastType type = ToastType.message
      }){
    ShowToast.init(context: context, builder: (context) {
      return ToastBox(
        message: message,
        position: position,
        type: type,
        animationTime: animationTime,
        icon: iconData,
      );
    });
    if(duration != 0){
      Future.delayed(Duration(milliseconds: duration)).then((val) {
        ShowToast.clear();
      });
    }
  }

  static void fail (
       BuildContext context,
      {
        @required String message,
        bool forbidClick = false,
        Position position = Position.center,
        int duration = 2000,
        int animationTime = 200,
      }){

      Toast(
          context,
          message: message,
          forbidClick : forbidClick,
          position: position,
          duration: duration,
          animationTime: animationTime,
          iconData: Icons.error_outline
      );
  }


  static void success (
      BuildContext context,
      {
        @required String message,
        bool forbidClick = false,
        Position position = Position.center,
        int duration = 2000,
        int animationTime = 200,
      }){

    Toast(
        context,
        message: message,
        forbidClick : forbidClick,
        position: position,
        duration: duration,
        animationTime: animationTime,
        iconData: Icons.done
    );
  }

  static void loading(
      BuildContext context,
      {
        @required String message,
        bool forbidClick = false,
        Position position = Position.center,
        int duration = 2000,
        int animationTime = 200,
      }){

    Toast(
        context,
        message: message,
        forbidClick : forbidClick,
        position: position,
        duration: duration,
        animationTime: animationTime,
        type: ToastType.loading
    );

  }
}


// 动画
class BoxFadeTransition extends StatefulWidget {
  BoxFadeTransition({
    Key key,
    @required this.duration,
    @required this.child,
  }):super(key: key);

  final Widget child;
  final Duration duration;

  @override
  _BoxFadeTransitionState createState() => _BoxFadeTransitionState();
}

class _BoxFadeTransitionState extends State<BoxFadeTransition> with
    SingleTickerProviderStateMixin{
  AnimationController _animationController;
  Animation _animation;


  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      child: widget.child,
      opacity: _animation,
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}