import 'package:flutter/material.dart';

class LayoutDome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('drawer组件dome'),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'ppp',
          onPressed: (){
            print('ppp');
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: AssetImage('images/2.jpg'),
                          radius: 35.0,
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("TOM"),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text('get UP', style: TextStyle(
                                  color: Colors.red
                                ),),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                curve: Curves.easeIn,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/bg.jpg'),
                    fit: BoxFit.fill
                  )
                ),
              ),
              ListTile(
                leading: Icon(Icons.print),
                title: Text("北京"),
              ),
              ListTile(
                leading: Icon(Icons.directions_run),
                title: Text("跑路"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
