import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                padding: EdgeInsets.only(top: 15),
                width: Get.width * 0.5,
                child: Column(
                  children: [
                    Container(
                      height: 90, width: 90,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white,width: 3),
                          image: DecorationImage(
                              image: AssetImage('images/profile.png')
                          )
                      ),
                    ),
                    SizedBox(height: 5),

                    Text(
                      'Jenny Doe',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    SizedBox(height: 5),
                    Text(
                      'jenny@gmail.com',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  print('Home');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Home',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              Divider(color: Colors.white,indent: 8, endIndent: Get.width * 0.55),
              GestureDetector(
                onTap: () {
                  print('Notification');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Notification',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              Divider(color: Colors.white,indent: 8, endIndent: Get.width * 0.55),
              GestureDetector(
                onTap: () {
                  print('Collections');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Collections',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              Divider(color: Colors.white,indent: 8, endIndent: Get.width * 0.55),
              GestureDetector(
                onTap: () {
                  print('My Order');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'My Order',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              Divider(color: Colors.white,indent: 8, endIndent: Get.width * 0.55),
              GestureDetector(
                onTap: () {
                  print('Profile');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              Divider(color: Colors.white,indent: 8, endIndent: Get.width * 0.55),
              GestureDetector(
                onTap: () {
                  print('Contact Us');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Contact Us',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              Divider(color: Colors.white,indent: 8, endIndent: Get.width * 0.55),
              GestureDetector(
                onTap: () {
                  print('Settings');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),

        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(color: Colors.white,indent: 8, endIndent: Get.width * 0.55),
              GestureDetector(
                onTap: () {
                  print('Logout');
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20,right: 8, left: 8, top: 8),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }

}
