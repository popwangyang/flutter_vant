import 'package:flutter/material.dart';

class Foo extends StatelessWidget {

  final List<ItemIcon> tabs = <ItemIcon>[
    ItemIcon('汽车', Icons.directions_bus),
    ItemIcon('火车', Icons.train),
    ItemIcon('飞机', Icons.airplanemode_active),
    ItemIcon('轮船', Icons.directions_boat),
    ItemIcon('骑行', Icons.directions_bike),
    ItemIcon('徒步', Icons.directions_run),
    ItemIcon('汽车', Icons.directions_bus),
    ItemIcon('火车', Icons.train),
    ItemIcon('飞机', Icons.airplanemode_active),
    ItemIcon('轮船', Icons.directions_boat),
    ItemIcon('骑行', Icons.directions_bike),
    ItemIcon('徒步', Icons.directions_run)
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            appBar: AppBar(
              title: Text("tabbar展示"),
              bottom: TabBar(
                  isScrollable: true,
                  tabs: tabs.map((ItemIcon item) {
                    return Tab(
                      icon: Icon(item.icon),
                      text: item.title
                    );
                  }).toList()
              ),
            ),
            body: TabBarView(
              children: tabs.map((ItemIcon item) {
                return SelectedView1(item: item);
              }).toList(),
            ),
          )
      ),
    );
  }
}

class ItemIcon{
  ItemIcon(this.title, this.icon);
  final String title;
  final IconData icon;
}

class SelectedView extends StatelessWidget {

  SelectedView({Key key, this.item}) : super(key: key);
  final ItemIcon item;


  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(item.icon),
              Text(item.title)
            ],
          ),
        ),
      ),
    );
  }
}

class SelectedView1 extends StatefulWidget {

  SelectedView1({Key key, this.item}):super(key: key);

  final ItemIcon item;

  @override
  _SelectedView1State createState() => _SelectedView1State();
}

class _SelectedView1State extends State<SelectedView1> with AutomaticKeepAliveClientMixin {


  int num;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(widget.item.icon, size: 90, color: Colors.red,),
              Text(widget.item.title)
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    num =0;
    num++;
    print("num的数字为$num");
  }
}


