import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';


import '../utils/JWT.dart';
import '../widges/button.dart';
import '../widges/textField.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPassVisible = true;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor:   Color(0xD000B1D0),
        body:
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 100,vertical: 50),
            height: 700.h,
            width: 800.w,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg.jpeg'), // Path to your image
                  fit: BoxFit.cover, // Adjust the fit of the image
                ),
                //color: Color(0xFFF5F5F5),
                //   gradient:  LinearGradient(
                //     begin: Alignment.topLeft,
                //     end: Alignment.bottomRight,
                //     colors: <Color>[
                //       Color(0xFF2356D3),
                //       Color(0xFF4882F3),
                //       Color(0xFF47D5D5),
                //     ],
                //     stops: <double>[0, 0.5,1],
                //   ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    //spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 4),
                    // spreadRadius: 0,
                  ),
                ],
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.black87,
                    width: 0.2)
            ),
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Image(
                    image:
                    AssetImage('assets/logo.png'),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade400, spreadRadius: 0, blurRadius: 5),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 60,
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: _emailController,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(
                        CupertinoIcons.mail_solid,
                        color: Color(0xFFC69C6D),
                      ),
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an email';
                      }
                      else if ( !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter an correct email';
                      }
                      else{
                        return null;
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade400, spreadRadius: 0, blurRadius: 5),
                    ],
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 60,
                  alignment: Alignment.center,
                  child: TextFormField(
                    controller: _passwordController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(
                        CupertinoIcons.lock_fill,
                        color: Color(0xFFC69C6D),
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPassVisible = !_isPassVisible;
                            });
                          },
                          icon: _isPassVisible
                              ? const Icon(
                            CupertinoIcons.eye,
                            color: Color(0xFFC69C6D),
                          )
                              : const Icon(
                            CupertinoIcons.eye_slash,
                            color: Color(0xFFC69C6D),
                          )),
                      border: InputBorder.none,
                    ),
                    obscureText: _isPassVisible,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height:5),
                SizedBox(
                  width: double.maxFinite,
                  height:58,
                  child: ElevatedButton(
                    onPressed: () async{
                      buttonAction();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle:const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ) ,
                      // backgroundColor: const Color(0xFF014886),
                      shadowColor: const Color(0xFF8D9AAE),
                    ),
                    child: const Text('Log in'),
                  ),
                ),


              ],
            ),
          ),
        )

    );
  }
  Authenticate(String mail, String mdp) async {
    String url = "http://localhost:3000/auth/login";
    try {
      var response = await http.Client().post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "email": mail,
          "password": mdp,
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // Treat both 200 and 201 as success
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = json.decode(response.body);

        // Check if 'tokens' exist in the response
        if (jsonResponse.containsKey('tokens')) {
          // Extract tokens and store them
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('accessToken', jsonResponse['tokens']['accessToken']);
          prefs.setString('refreshToken', jsonResponse['tokens']['refreshToken']);
          prefs.setString('userId', jsonResponse['tokens']['userId']);

          // Navigate to the HomePage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          print("Error: Tokens missing in the response.");
        }
      } else {
        // Handle errors for other status codes
        Map<String, dynamic> responseMap = json.decode(response.body);
        String errorMsg = responseMap['message'] ?? 'Unknown error occurred';
        print('Error: $errorMsg');
      }
    } catch (e) {
      print('Error during request: $e');
    }
  }





  // button function
  void buttonAction() async {

    try {
      Authenticate(_emailController.text,_passwordController.text);
      print(_emailController.text+_passwordController.text);
    } catch (e) {
      print('Error: $e');
    }
  }

}
