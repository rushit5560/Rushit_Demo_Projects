import 'package:flutter/material.dart';

import 'model/food.dart';
import 'model/foods.dart';
import 'shimmer_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Food> foods = [];

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future loadData() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(seconds: 3));
    foods = List.of(allFoods);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shimmer Effect'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              loadData();
            },
            icon: Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: isLoading ? 5 : foods.length,
        itemBuilder: (context, index) {
          if (isLoading) {
            return buildCustomShimmer();
          } else {
            final food = foods[index];
            return buildFood(food);
          }
        },
      ),
    );
  }

  Widget buildFood(Food food) => ListTile(
        leading: CircleAvatar(
          radius: 32,
          backgroundImage: NetworkImage(food.imgUrl),
        ),
        title: Text(
          food.title,
          style: TextStyle(fontSize: 16),
        ),
        subtitle: Text(
          food.description,
          style: TextStyle(fontSize: 14),
          maxLines: 1,
        ),
      );

  Widget buildCustomShimmer() => ListTile(
        leading: ShimmerWidget.circular(
          width: 64,
          height: 64,
          /*shapeBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),*/
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: ShimmerWidget.rectangle(
              width: MediaQuery.of(context).size.width * 0.3, height: 16),
        ),
        subtitle: ShimmerWidget.rectangle(height: 14),
      );
}
