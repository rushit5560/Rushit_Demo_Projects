import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  final VoidCallback? openDrawer;
  const HomePage({Key? key, this.openDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: IconButton(
          onPressed: openDrawer,
          icon: Icon(Icons.menu_rounded),
        ),
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Home Page'),
      ),
    );
  }
}
