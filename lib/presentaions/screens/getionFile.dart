import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../widges/Card.dart';

class FileManagementPage extends StatefulWidget {
  @override
  _FileManagementPageState createState() => _FileManagementPageState();
}

class _FileManagementPageState extends State<FileManagementPage> {
  List<dynamic> files = [];
  List<dynamic> filteredFiles = [];
  bool isLoading = true;

  String selectedFilter = 'All'; // Initial filter value

  // Fetch files
  Future<void> fetchFiles() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      final response = await http.get(
        Uri.parse('http://localhost:3000/document/getallDoc'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      // Log the response body
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          files = json.decode(response.body);
          filteredFiles = files; // Initially, show all files
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load files. Status: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar(context, 'Error fetching files: $error');
    }
  }

  // Helper function to show SnackBar
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Filter function to update the displayed files based on selected filter
  void _filterFiles() {
    setState(() {
      if (selectedFilter == 'All') {
        filteredFiles = files;
      } else {
        filteredFiles = files.where((file) {
          String fileName = file['fileName'] ?? '';
          return fileName.endsWith(selectedFilter);
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFiles();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      customWidth: 1000,
      customHeight: 1000,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Dropdown menu for filtering files
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: selectedFilter,
              onChanged: (String? newValue) {
                setState(() {
                  selectedFilter = newValue!;
                });
                _filterFiles(); // Apply filter when dropdown value changes
              },
              items: <String>['All', '.pdf', '.png', '.jpg', '.docx']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),

          // Show loading indicator while fetching files
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else if (filteredFiles.isEmpty)
            Center(child: Text('No files found with the selected extension.'))
          else
            Expanded(
              child: ListView.builder(
                itemCount: filteredFiles.length,
                itemBuilder: (context, index) {
                  final file = filteredFiles[index];
                  final fileName = file['fileName'] ?? 'No File Name';
                  final totalAmount = file['totalAmount'] ?? 'No Total Amount';
                  final accontenumber = file['Accontenumber'] ?? 'No Account Number';
                  return ListTile(
                    title: Text(fileName),
                    subtitle: Text('Amount: $totalAmount\nAccount: $accontenumber'),
                    trailing: Icon(Icons.file_copy),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
