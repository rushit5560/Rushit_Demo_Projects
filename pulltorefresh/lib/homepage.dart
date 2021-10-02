import 'dart:math';

import 'package:flutter/material.dart';

import 'refreshwidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> data = [];
  // late final GlobalKey<RefreshIndicatorState> keyRefresh;

  @override
  void initState() {
    super.initState();

    loadList();
  }

  Future loadList() async {
    // keyRefresh.currentState?.show();
    await Future.delayed(Duration(milliseconds: 2000));
    final random = Random();
    final data = List.generate(100, (_) => random.nextInt(100));

    setState(() {
      this.data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pull To Refresh'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: loadList, icon: Icon(Icons.refresh_rounded,),),
        ],
      ),
      body: buildList(),
    );
  }

  Widget buildList() => data.isEmpty
      ? Center(child: CircularProgressIndicator())
      : RefreshWidget(
        // keyRefresh: keyRefresh,
        onRefresh: loadList,
        child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          padding: EdgeInsets.all(16),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final number = data[index];
            return buildItem(number);
          },
        ),
      );

  Widget buildItem(int number) => ListTile(
        title: Center(
          child: Text(
            '$number',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      );
}
