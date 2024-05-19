//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1/profile/progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './education.dart';
import '../jobSeekerModel/job_seeker_profile_model.dart';
import '../jobSeekerModel/job_seeker_profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../user_account/utils.dart';

class personal_info extends StatefulWidget {
  static const routeName = '/personal_info';
  const personal_info({Key? key}) : super(key: key);

  @override
  State<personal_info> createState() => _personal_infoState();
}

class _personal_infoState extends State<personal_info> {
  final _formKey = GlobalKey<FormState>();
  final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");

  bool validateEmail(String email) {
    return emailRegex.matchAsPrefix(email) != null;
  }

  String? currentUser;

  Future<void> getUserUid() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          currentUser = user.uid;
        });
      } else {
        print('No user is signed in.');
      }
    } catch (e) {
      print('Error getting current user UID: $e');
    }
  }

  Future<void> savePersonalInfo(PersonalInfo personalInfo) async {
    try {
      final personalInfoDocRef =
          FirebaseFirestore.instance.collection('job-seeker').doc(currentUser);

      personalInfo.id = personalInfoDocRef.id;
      final json = personalInfo.toJson();

      await personalInfoDocRef
          .collection('jobseeker-profile')
          .doc('profile')
          .set({'personal-info': json});
      print('Personal info saved successfully');
    } on FirebaseException catch (e) {
      print('Error saving personal info: ${e.message}');
      Utils.showSnackBar(context, e.message, Colors.red);
      rethrow;
    } catch (e) {
      print('Error saving personal info: $e');
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    getUserUid();
  }

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final regionController = TextEditingController();
  final cityController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  DateTime? birthDate;
  bool isDateSelected = false;
  bool isCountrySelected = false;
  bool isCitySelected = false;
  bool isRegionSelected = false;
  bool progressComplete = false;
  List<String> gender = ['Male', 'Female'];
  String firstName = '';
  String lastName = '';
  String email = '';
  String countryName = '';
  String cityName = '';
  String phoneNumber = '';
  String countryChoosed = '';
  String genderChoosed = '';
  String regionChoosed = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Information'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CircularProgressIndicator(value: progressComplete ? 0.25 : 0),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Text(
                'PERSONAL INFORMATION',
                style: TextStyle(
                    fontSize: 30, fontFamily: 'Anton', color: Colors.blue),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(child: Text('First Name *')),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: TextFormField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            labelText: 'First name',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 218, 214, 214),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            firstName = value!;
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: TextFormField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Last name',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 218, 214, 214),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            lastName = value!;
                          },
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Center(
                        child: Text(
                          'Gender:',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              filled: true,
                              fillColor: Color.fromARGB(255, 161, 200, 231),
                              hintText: 'Select an option',
                              hintStyle: TextStyle(color: Colors.white),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select an option';
                              }
                              return null;
                            },
                            items: gender.map((item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                genderChoosed = value!;
                              });
                            }),
                      ),
                      SizedBox(height: 16.0),
                      Center(child: Text('Country *')),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Country',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 218, 214, 214),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your country name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            countryName = value!;
                          },
                        ),
                      ),
                      Center(child: Text('Region *')),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Region',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 218, 214, 214),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your region';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            regionChoosed = value!;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Center(child: Text('City (Home Town) *')),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'City name',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 218, 214, 214),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your city name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            cityName = value!;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Center(child: Text('Contact information *')),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email address',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!validateEmail(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            email = value!;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText: '09xxxxxxxx',
                            labelStyle: TextStyle(
                              color: Color.fromARGB(255, 218, 214, 214),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          style: TextStyle(
                            color: Color.fromARGB(255, 218, 214, 214),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            } else if (value.length < 10) {
                              return 'Please enter a valid phone number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            phoneNumber = value!;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: MediaQuery.of(context).size.width - 150,
                        height: MediaQuery.of(context).size.height - 700,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState?.save();

                              if (currentUser == null) {
                                print('Error: currentUser is null');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: No user signed in.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              final personalInfo = PersonalInfo(
                                firstName: firstName,
                                lastName: lastName,
                                gender: genderChoosed,
                                city: cityName,
                                region: regionChoosed,
                                email: email,
                                phoneNumber: phoneNumber,
                              );

                              try {
                                await savePersonalInfo(personalInfo);
                                print(
                                    'PERSONAL INFO IS ${personalInfo.toJson()}');

                                // Show success message using ScaffoldMessenger
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Successfully saved'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pop(context);
                              } catch (e) {
                                print('Error during saving: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Error saving information. Please try again.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            'SAVE & CONTINUE',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            padding: EdgeInsets.all(10.0),
                            elevation: 10.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
