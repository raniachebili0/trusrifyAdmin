import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double customHeight;
  final double customWidth;
  final LinearGradient customcoler;




  const CustomCard({
    Key? key,
    required this.child,
    this.customHeight =0,
    this.customWidth =0,
    this.customcoler = const LinearGradient(colors: [Color(0xFFFFFFFF), Color(
        0xFFFFFFFF)]),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height:customHeight,
      width:customWidth ,
      decoration: BoxDecoration(
      gradient: customcoler, // Background color
      borderRadius: BorderRadius.circular(16.0), // Rounded corners
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1), // Shadow color
          spreadRadius: 2, // Spread radius
          blurRadius: 30, // Blur radius
          offset: const Offset(3, 3), // Shadow position
        ),
      ],
    ),
      child: child,
    );
  }
}
