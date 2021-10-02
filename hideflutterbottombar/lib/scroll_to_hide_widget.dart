import 'package:flutter/material.dart';

class ScrollToHideWidget extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final Duration duration;

  const ScrollToHideWidget(
      {Key? key,
      required this.child,
      required this.controller,
      this.duration = const Duration(milliseconds: 300)})
      : super(key: key);

  @override
  _ScrollToHideWidgetState createState() => _ScrollToHideWidgetState();
}

class _ScrollToHideWidgetState extends State<ScrollToHideWidget> {
  bool isVisible = true;

  @override
  void initState() {
    widget.controller.addListener(listen);
    super.initState();

  }

  @override
  void dispose() {
    widget.controller.removeListener(listen);
    super.dispose();
  }
  void listen() {
    // -> One Method
    /*final direction = widget.controller.position.userScrollDirection;
    if(direction == ScrollDirection.forward){
      show();
    }
    else if(direction == ScrollDirection.reverse){
      hide();
    }*/

    // -> TwoMethod
    if(widget.controller.position.pixels >= 200){
      hide();
    } else {
      show();
    }
  }

  void show() {
    if(!isVisible) setState(() {
      isVisible = true;
    });
  }

  void hide() {
    if(isVisible) setState(() {
      isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: widget.duration,
    height: isVisible ? kBottomNavigationBarHeight : 0,
    child: Wrap(children: [widget.child],),
  );
}
