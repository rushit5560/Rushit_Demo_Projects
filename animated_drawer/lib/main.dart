import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'drawer_widget.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  double? xOffset;
  double? yOffset;
  double? scaleFactor;
  bool? isDrawerOpen;

  @override
  void initState() {
    super.initState();

    closeDrawer();
  }

  void openDrawer() => setState(() {
    xOffset = Get.width * 0.50;
    yOffset = Get.height * 0.20;
    scaleFactor = 0.6;
    isDrawerOpen = true;
  });

  void closeDrawer() => setState(() {
    xOffset = 0;
    yOffset = 0;
    scaleFactor = 1;
    isDrawerOpen = false;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: Stack(
        children: [
          buildDrawer(),
          buildPage(),
        ],
      ),
    );
  }

  Widget buildDrawer() =>  SafeArea(child: DrawerWidget());

  Widget buildPage() {

    return WillPopScope(
      onWillPop: () async {
        if(isDrawerOpen!){
          closeDrawer();
          return false;
        }
        else {
          return true;
        }
      },
      child: GestureDetector(
        onTap: closeDrawer,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          transform: Matrix4.translationValues(xOffset!, yOffset!, 0)..scale(scaleFactor),
            child: AbsorbPointer(
              absorbing: isDrawerOpen!,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isDrawerOpen! ? 20 : 0),
                    child: HomePage(openDrawer: openDrawer),
                ),
            ),
        ),
      ),
    );
  }
}

