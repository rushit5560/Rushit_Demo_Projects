import 'package:flutter/material.dart';

import 'scroll_to_hide_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: ListView.builder(
          controller: scrollController,
          itemCount: 100,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Index Number ${index + 1}'),
              onTap: () {},
            );
          },
        ),
      ),

      bottomNavigationBar: ScrollToHideWidget(
        controller: scrollController,

        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.child_friendly),
              label: 'Child',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
          ],
        ),
      ),
    );
  }
}
