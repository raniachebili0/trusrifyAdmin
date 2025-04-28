import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trastify_back_office/presentaions/screens/charts/ColumnChartPage.dart';
import 'package:trastify_back_office/presentaions/screens/charts/DoughnutChartPage.dart';
import 'package:trastify_back_office/presentaions/screens/charts/LineChartPage.dart';
import 'package:trastify_back_office/presentaions/screens/charts/PieChartPage.dart';
import 'package:http/http.dart' as http;
import 'package:trastify_back_office/presentaions/widges/Card.dart';



class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<dynamic> _users = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  // Fetch users from the backend
  Future<void> fetchUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      final response = await http.get(
        Uri.parse('http://localhost:3000/users/list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _users = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching users: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    int userCount = _users.length;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              CustomCard(
                customcoler: LinearGradient(colors: [Color(0xFF4318FF), Color(
                    0xFF6AD2FF)], begin: Alignment.topLeft,
                  end: Alignment.bottomRight,),
                customWidth: 290.w,
                customHeight: 200.h,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image(
                            image:
                            AssetImage('assets/users.png'),
                            width: 70.w,
                            height: 70.h,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text("Members" , style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),),
                          Text(
                            _isLoading ? "Loading..." : "$userCount",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              CustomCard(
                customWidth: 290.w,
                customHeight: 200.h,
                child:  Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image(
                            image:
                            AssetImage('assets/money.png'),
                            width: 70.w,
                            height: 70.h,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text("Benefits" , style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF4318FF),
                          ),),
                          Text("4520 DT" ,  style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color:Color(
                                0xFF6AD2FF),
                          ),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              CustomCard(
                customWidth: 290.w,
                customHeight: 200.h,
                customcoler: LinearGradient(
                  colors: [Color(0xFF4318FF), Color(0xFF6AD2FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image(
                        image:
                        AssetImage('assets/cloud.png'),
                        width: 70.w,
                        height: 70.h,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text("Cloud storage" , style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),),
                      Text("26 GO" ,  style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              CustomCard(
                customWidth: 290.w,
                customHeight: 200.h,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image(
                            image:
                            AssetImage('assets/ai.png'),
                            width: 70.w,
                            height: 70.h,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text("Correct detection" , style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF4318FF),
                          ),),
                          Text("76%" ,  style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(
                                0xFF6AD2FF),
                          ),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25.h,
          ),
          Row(
            children: [
              CustomCard(
                customHeight: 400.h,
                customWidth: 800.w,
                child:SizedBox(
                  height: 390.h,
                    width: 790.w,
                    child: LineChartPage()),
              ),
              SizedBox(
                width: 25.w,
              ),
              CustomCard(
                customWidth: 400.w,
                customHeight: 400.h,
                child:  Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: PieChartPage(),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25.h,
          ),
          Row(
            children: [

              CustomCard(
                customHeight: 500.h,
                customWidth: 800.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 450.h,
                      width: 790.w,
                      child: Center(child: ColumnChartPage()),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 25.w,
              ),
              CustomCard(
                customWidth: 400.w,
                customHeight: 500.h,
                child: Column(
                  children: [
                    SizedBox(
                      height: 490.h,
                      width: 380.w,
                      child:DoughnutChartPage(),
                    ),
                  ],
                ),
              ),
            ],
          )

        ],
      ),
    );
  }
}


