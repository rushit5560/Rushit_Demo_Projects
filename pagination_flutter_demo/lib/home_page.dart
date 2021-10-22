import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pagination_flutter_demo/model/passenger_data.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentPage = 1;
  List<Datum> passengers = [];
  // initialRefresh is True so Automatically Load the Data. No need to use initState.
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  late int totalPages;

  Future<bool> getPassengerData({bool isRefresh = false}) async {

    if(isRefresh){
      currentPage = 1;
    } else {
      if(currentPage >= totalPages){
        refreshController.loadNoData();
        return false;
      }
    }

    final Uri uri = Uri.parse('https://api.instantwebtools.net/v1/passenger?page=$currentPage&size=10');
    final response = await http.get(uri);

    if(response.statusCode == 200){
      final result = passengersDataFromJson(response.body);

      if(isRefresh){
        passengers = result.data;
      } else {
        passengers.addAll(result.data);
      }

      currentPage++;
      totalPages = result.totalPages;
      print('Response : ${response.body}');
      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getPassengerData();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagination List'),
        centerTitle: true,
      ),

      body: SmartRefresher(
        controller: refreshController,
        // onRefresh For Pull To Refresh
        onRefresh: () async {
          final result = await getPassengerData(isRefresh: true);
          if(result){
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        // onLoading For Pagination
        enablePullUp: true, // By Default it's False
        onLoading: () async {
          final result = await getPassengerData();
          if(result){
            refreshController.loadComplete();
          } else {
            refreshController.loadFailed();
          }
        },

        child: ListView.builder(
          itemCount: passengers.length,
          itemBuilder: (context, index){
            final passenger = passengers[index];
            return ListTile(
              title: Text(passenger.name),
              subtitle: Text(passenger.airline[0].country),
              trailing: Text(passenger.airline[0].name),
            );
          },
        ),
      ),
    );
  }
}
