import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trastify_back_office/presentaions/screens/getionAdmin.dart';
import '../utils/colors.dart';
import 'dashboard.dart';
import 'getionFile.dart';
import 'getionUser.dart';
import 'loginScreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Selected index for navigation
  int _selectedIndex = 0;

  // List of Pages
  static List<Widget> _pages = <Widget>[
    DashboardPage(),
    UserManagementPage(),
    FileManagementPage(),
    AdminManagementPage(),
  ];

  // Method to handle navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
       backgroundColor: const Color(0xFFF5F6FA),
        title: Text(
          "Trastify Admin",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Color(0xFF4318FF),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Color(0xFF4318FF)),
            onPressed: () {
              // Add notifications functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Color(0xFF4318FF)),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
              // Add logout functionality
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Fixed Drawer
          Container(
            width: 300.w,  // Drawer width
            child: Drawer(
              child: Container(
                color: Colors.white,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      child: Text(
                        'Admin Panel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),

                    ListTile(
                      title: Row(
                        children: [
                          Image(
                            image:
                            AssetImage('assets/dashboard.png'),
                            width: 40.w,
                            height: 40.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text('Dashboard',style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 22.sp,
                            ),),
                          ),
                        ],
                      ),
                      onTap: () {
                        _onItemTapped(0); // Change page to User Management
                      },
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Image(
                            image:
                            AssetImage('assets/user.png'),
                            width: 40.w,
                            height: 40.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text('Users Management',style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 22.sp,
                            ),),
                          ),
                        ],
                      ),
                      onTap: () {
                        _onItemTapped(1); // Change page to Dashboard
                      },
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Image(
                            image:
                            AssetImage('assets/user.png'),
                            width: 40.w,
                            height: 40.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text('Admin managment',style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 22.sp,
                            ),),
                          ),
                        ],
                      ),
                      onTap: () {
                        _onItemTapped(3); // Change page to User Management
                      },
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Image(
                            image:
                            AssetImage('assets/document.png'),
                            width: 40.w,
                            height: 40.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text('Files Management',style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 22.sp,
                            ),),
                          ),
                        ],
                      ),
                      onTap: () {
                        _onItemTapped(2); // Change page to Card Management
                      },
                    ),

                  ],
                ),
              ),
            ),
          ),
          // Main content area
          Expanded(
            child: SingleChildScrollView(
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
