import 'package:flutter/material.dart';

class SliverDome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: GestureDetector(
                child: Icon(Icons.arrow_back),
                onTap: () => print('ppp'),
              ),
              automaticallyImplyLeading: true,
//              title: Text('SliverAppBar'),
              centerTitle: true,
              actions: <Widget>[Icon(Icons.archive)],
              elevation: 4,
              forceElevated: true,
              backgroundColor: Colors.green,
              brightness: Brightness.dark,
              iconTheme: IconThemeData(
                color: Colors.red,
                size: 30,
                opacity: 1,
              ),
              textTheme: TextTheme(),
              primary: false,
              titleSpacing: 30,
              expandedHeight: 200,
              floating: true,
              pinned: true,
              snap: false,
              flexibleSpace: FlexibleSpaceBar(
                title: Text("内容随国内滚动条改变"),
                centerTitle: true,
                collapseMode: CollapseMode.pin,
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 150,
              delegate: SliverChildBuilderDelegate((context, index) => ListTile(
                title: Text("list item $index"),
              )),
            )
          ],
        ),
      ),
    );
  }
}
