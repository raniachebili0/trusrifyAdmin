import 'dart:convert';

import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String _jwtToken = '';

  String get jwtToken => _jwtToken;

  set jwtToken(String token) {
    _jwtToken = token;
    notifyListeners();
  }

  // Add a method to set the JWT token
  void setToken(String token) {
    Map<String, dynamic> tokenMap = json.decode(token);
    jwtToken = tokenMap['token'];
    notifyListeners();
  }
}