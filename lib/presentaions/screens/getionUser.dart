import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../widges/Card.dart';

class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  List<dynamic> _users = [];
  List<dynamic> _filteredUsers = [];
  TextEditingController _searchController = TextEditingController();

  // Pagination variables
  int _currentPage = 1;
  int _itemsPerPage = 10;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterUsers);
    fetchUsers();
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterUsers);
    _searchController.dispose();
    super.dispose();
  }

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
        List<dynamic> users = json.decode(response.body);

        // Filter out users whose email ends with 'Trustify@contact.tn'
        List<dynamic> filteredUsers = users.where((user) {
          if (user['email'] is String) {
            return !user['email'].endsWith('Trustify@contact.tn');
          }
          return true;
        }).toList();

        setState(() {
          _users = users;
          _filteredUsers = filteredUsers; // Only show filtered users
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


  void _filterUsers() {
    setState(() {
      _filteredUsers = _users
          .where((user) =>
      (user['email'] != null &&
          user['email']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase())) ||
          (user['Companyname'] != null &&
              user['Companyname']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase())))
          .toList();

      // Reset pagination when filtering
      _currentPage = 1;
    });
  }

  List<dynamic> _getPaginatedUsers() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _filteredUsers.sublist(
        startIndex, endIndex > _filteredUsers.length ? _filteredUsers.length : endIndex);
  }

  void _deleteUser(String userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      final response = await http.delete(
        Uri.parse('http://localhost:3000/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User deleted successfully.')),
        );
        fetchUsers();
      } else {
        throw Exception('Failed to delete user: ${response.statusCode}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user: $error')),
      );
    }
  }

  void _confirmDelete(BuildContext context, String userId, String userEmail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete $userEmail?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteUser(userId);
              },
            ),
          ],
        );
      },
    );
  }



  void _showEditUserDialog(String userId, String email, String companyName, String registrationNumb) {
    TextEditingController emailController = TextEditingController(text: email);
    TextEditingController companyNameController = TextEditingController(text: companyName);
    TextEditingController registrationController = TextEditingController(text: registrationNumb);

    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Email is required';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: companyNameController,
                    decoration: InputDecoration(labelText: 'Company Name'),
                  ),
                  TextFormField(
                    controller: registrationController,
                    decoration: InputDecoration(labelText: 'Registration Number'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _updateUser(
                    userId,
                    emailController.text,
                    companyNameController.text,
                    registrationController.text,
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUser(String userId, String email, String companyName, String registrationNumb) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('accessToken');

      final response = await http.patch(
        Uri.parse('http://localhost:3000/users/$userId/update'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'email': email,
          'Companyname': companyName,
          'registrationNumb': registrationNumb,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User updated successfully!')),
        );
        fetchUsers();
      } else {
        throw Exception('Failed to update user');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating user: $error')),
      );
    }
  }


  void _showAddUserDialog() {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController companyNameController = TextEditingController();
    TextEditingController registrationNumbController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New User'),
          content: SingleChildScrollView(
            child: CustomCard(
              customHeight: 500.h,
              customWidth: 500.w,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          // Email regex validation
                          String emailPattern =
                              r'^[^@]+@[^@]+\.[^@]+';
                          if (!RegExp(emailPattern).hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: companyNameController,
                        decoration: InputDecoration(labelText: 'Company Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Company Name is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: registrationNumbController,
                        decoration: InputDecoration(labelText: 'Registration Number'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.length != 13) {
                            return 'Registration Number must be exactly 13 characters';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() == true) {
                  _addUser(
                    emailController.text,
                    passwordController.text,
                    companyNameController.text,
                    registrationNumbController.text,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }


  Future<void> _addUser(
      String email, String password, String companyName, String registrationNumb) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('accessToken');

      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }

      final response = await http.post(
        Uri.parse('http://localhost:3000/auth/signup'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'email': email,
          'password': password,
          'Companyname': companyName,
          'registrationNumb': registrationNumb,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User added successfully!')),
        );
        fetchUsers(); // Refresh the user list
      } else {
        throw Exception('Failed to add user: ${response.statusCode}');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding user: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: CustomCard(
        customHeight: 700,
        customWidth: 1000,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search Users by Email or Company Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _showAddUserDialog,
                    icon: Icon(Icons.add),
                    label: Text('Add User'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _filteredUsers.isEmpty
                  ? Center(child: Text('No users found.'))
                  : ListView.builder(
                itemCount: _getPaginatedUsers().length,
                itemBuilder: (context, index) {
                  final user = _getPaginatedUsers()[index];
                  final email = user['email'] ?? 'No Email';
                  final userId = user['_id'] ?? '';
                  final companyName =
                      user['Companyname'] ?? 'No Company Name';
                  final registrationNumb =
                      user['registrationNumb'] ?? 'No registration Number';




                  return ListTile(
                    title: Text(email),
                    subtitle: Row(
                      children: [
                        Text("Company name : $companyName"),
                        SizedBox(width: 10,),
                        Text("Registration Number : $registrationNumb"),
                      ],
                    ),
                    leading: CircleAvatar(
                      child: Text(email.isNotEmpty ? email[0] : '?'),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.credit_card),
                          onPressed: () async {
                            try {
                              // Récupérer les informations de la carte
                              Map<String, dynamic> cardDetails = await fetchUserCard(userId);
                               print(cardDetails);
                              // Afficher les informations dans une boîte de dialogue
                              showCardDetails(context, cardDetails);
                            } catch (e) {
                              // Gérer les erreurs
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: ${e.toString()}'),
                                ),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditUserDialog(userId, email, companyName, registrationNumb);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _confirmDelete(context, userId, email);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _currentPage > 1
                      ? () {
                    setState(() {
                      _currentPage--;
                    });
                  }
                      : null,
                  child: Text('Previous'),
                ),
                SizedBox(width: 16),
                Text('Page $_currentPage of ${(_filteredUsers.length / _itemsPerPage).ceil()}'),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _currentPage * _itemsPerPage < _filteredUsers.length
                      ? () {
                    setState(() {
                      _currentPage++;
                    });
                  }
                      : null,
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchUserCard(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('accessToken');
    final response = await http.get(
      Uri.parse('http://localhost:3000/card/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },// Remplacez par votre endpoint
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Décoder le JSON en Map
    } else {
      throw Exception('Failed to load card details');
    }
  }




  void showCardDetails(BuildContext context, Map<String, dynamic> cardDetails) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Transparent background
          child: Container(
            width: 350, // Card width
            height: 200, // Card height
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)], // Purple Gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                // Light circles (top-right and bottom-left shapes)
                Positioned(
                  top: -30,
                  right: -30,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  left: -30,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Card details content
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Card Balance
                      Text(
                        'Type : ${cardDetails['type']}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' CVC : ${cardDetails['cvc']}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Balance : ${cardDetails['balance']} DT',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Card Number and Expiry
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${cardDetails['number']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            '${cardDetails['expiry']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),


                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }





}
