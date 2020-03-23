import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef CheckBoxCallback =  void Function(bool val);
typedef StlBuilder = Widget Function();

enum CheckShape{
  square,
  circular,
}

class CheckBox extends StatelessWidget {

  CheckBox({
    this.value = false,
    this.shape = CheckShape.circular,
    this.disabled = false,
    this.color = Colors.blue,
    this.size = 16.0,
    this.iconData = Icons.done,
    this.label,
    this.labelDisabled = false,
    this.onChange,
    this.selectedBuilder,
    this.unselectedBuilder,
  }):assert(selectedBuilder != null && unselectedBuilder != null || selectedBuilder == null && unselectedBuilder == null);

  final bool value;
  final String label;
  final CheckShape shape;
  final bool disabled;
  final bool labelDisabled;
  final Color color;
  final double size;
  final IconData iconData;
  final CheckBoxCallback onChange;
  final StlBuilder selectedBuilder;
  final StlBuilder unselectedBuilder;



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(!disabled){
          onChange(value);
        }
      },
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            (){
              if(unselectedBuilder!=null){
                return customBox();
              }else{
                return selectedBox();
              }
            }(),
            GestureDetector(
              child: labelText(),
              onTap: (){
                if(!disabled && !labelDisabled){
                  onChange(value);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  // 选中显示状态
  Widget selectedBox(){
    CheckBoxStyle checkBoxStyle = CheckBoxStyle(
        selected: value,
        shape: shape,
        disabled: disabled,
        color: color,
        size: size,
        iconData: iconData,
    );
    return Container(
      padding: EdgeInsets.all(2.0),
      decoration: checkBoxStyle.checkDecorationBackground,
      child: Center(
        child: Opacity(
          opacity: checkBoxStyle.opacity,
          child: checkBoxStyle.icon,
        ),
      ),
    );
  }

  // 只定义图标
  Widget customBox(){
    return Container(
      constraints: BoxConstraints(
        maxWidth: size+2,
        maxHeight: size+2
      ),
      child: (){
        if(value){
          return selectedBuilder();
        }else{
          return unselectedBuilder();
        }
      }(),
    );
  }


  // label文子部分
  Widget labelText(){
    if(label == null){
      return Container();
    }else{
      return Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Text(label, style: TextStyle(
          color: disabled ? Color(0xffc8c9cc):Colors.black
        ),),
      );
    }
  }
}

class CheckBoxStyle{

  CheckBoxStyle({
    this.selected,
    this.disabled,
    this.color,
    this.size,
    this.iconData,
    this.shape,
  }){
    init();
  }

  final bool selected;
  final bool disabled;
  final Color color;
  final double size;
  final IconData iconData;
  final CheckShape shape;

  BoxDecoration checkDecorationBackground;
  BoxDecoration checkDecorationForeground;
  double opacity;
  Icon icon;

  void init(){
    Color _background;
    Color _iconColor;
    Color _borderColor;
    if(disabled){
      _borderColor = Color(0xffc8c9cc);
      if(selected){
        _background = Color(0xffebedf0);
        _iconColor = Color(0xffc8c9cc);
      }else{
        _background = Color(0xffebedf0);
        _iconColor = Color(0xffebedf0);
      }
    }else{
      if(selected){
        _background = color;
        _iconColor = Colors.white;
        _borderColor = color;
      }else{
        _background = Colors.white;
        _iconColor = Colors.white;
        _borderColor = Color(0xffc8c9cc);
      }
    }
    checkDecorationBackground = BoxDecoration(
      color: _background,
      borderRadius: BorderRadius.all(
          Radius.circular(
              shape == CheckShape.circular ? 999 : 0.0
          )
      ),
      border: Border.all(color: _borderColor,width: 1.0)
    );
    opacity = selected ? 1.0 : 0.0;
    icon = Icon(
      iconData,
      size: size,
      color: _iconColor,
    );
  }
}
