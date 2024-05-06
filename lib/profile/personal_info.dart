//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1/profile/progress_indicator.dart';
import './education.dart';
import '../jobSeekerModel/job_seeker_profile_model.dart';
import '../jobSeekerModel/job_seeker_profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../user_account/utils.dart';

class personal_info extends StatefulWidget {
  const personal_info({Key? key}) : super(key: key);
  static const routeName = '/personal_info';
  @override
  State<personal_info> createState() => _personal_infoState();
}

class _personal_infoState extends State<personal_info> {
  final _formKey = GlobalKey<FormState>();
  String? currentUser;
  Future<void> getUserUid() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          currentUser = user.uid;
        });
      }
    } catch (e) {
      print('Error getting current user UID: $e');
    }
  }

  Future savePesonalInfo(PersonalInfo personalinfo) async {
    final personal_info_doc_ref =
        FirebaseFirestore.instance.collection('job-seeker').doc(currentUser);
    personalinfo.id = personal_info_doc_ref.id;
    final json = personalinfo.toJson();
    await personal_info_doc_ref
        .collection('jobseeker-profile')
        .doc('profile')
        .set({'personal-info': json});
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
  //final cityController = TextEditingController();
  DateTime? birthDate;
  bool isDateSelected = false;
  bool isCountrySelected = false;
  bool isCitySelected = false;
  bool isRegionSelected = false;
  //List countries = ['Ethiopia', 'america', 'england', 'Germany'];
  //List regions = ['amhara', 'oromia', 'south', 'somali'];
  //List towns = ['Ethiopia', 'america', 'england', 'Germany'];
  List gender = [
    'Male',
    'Female',
  ];
  String firstName = '';
  String LastName = '';
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
        title: Text('personal information'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CircularProgress(value: 0.25),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                  // border: Border.all(
                  //     color: Colors.blue, style: BorderStyle.solid)
                  // color: Color.fromARGB(255, 39, 176, 39),
                  ),
              child: Text(
                'PERSONAL INFORMATION',
                style: TextStyle(
                    fontSize: 30,
                    // fontWeight: FontWeight.bold,
                    fontFamily: 'Anton',
                    //  color: Colors.black38
                    color: Colors.blue),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Form(
                  key: _formKey,
                  child: Expanded(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                color: Colors.grey[800],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter Your name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null) {
                                firstName = value;
                              }
                            },
                          ),
                        ),

                        SizedBox(height: 16.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: 'Last name',
                              labelStyle: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null) {
                                LastName = value;
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Gender:',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: DropdownButtonFormField(
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
                              validator: ((value) {
                                if (value == null) {
                                  return 'please select an option';
                                } else {
                                  return value.toString();
                                }
                              }),
                              // value: genderChoosed,
                              items: gender.map((item) {
                                return DropdownMenuItem(
                                  child: Text(item),
                                  value: item,
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  genderChoosed = value.toString();
                                });
                              }),
                        ),
                        SizedBox(height: 16.0),

                        Center(child: Text('Country *')),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: TextFormField(
                            // controller: firstNameController,
                            decoration: InputDecoration(
                              labelText: 'Country',
                              labelStyle: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter Your Country name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null) {
                                countryName = value;
                              }
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
                                color: Colors.grey[800],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter your Region';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null) {
                                regionChoosed = value;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Center(child: Text('City(Home Town) *')),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'city name',
                              labelStyle: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter your city name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null) {
                                cityName = value;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Center(child: Text('Contact information *')),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email address',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              email = value.toString();
                            },
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'phone number',
                              labelStyle: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              //Do something when the value changes
                              phoneNumber = value.toString();
                            },
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        //  ElevatedButton(onPressed: () {}, child: Text('Save')),\

                        Container(
                          width: MediaQuery.of(context).size.width - 100,
                          height: MediaQuery.of(context).size.height - 700,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState?.save();
                                try {
                                  final personal_info = PersonalInfo(
                                      firstName: firstName,
                                      lastName: LastName,
                                      gender: genderChoosed,
                                      city: cityName,
                                      region: regionChoosed,
                                      email: email,
                                      phoneNumber: phoneNumber);
                                  PersonalInfoProvider provider =
                                      PersonalInfoProvider();
                                  provider.personalInfo = personal_info;
                                  //savePesonalInfo(personal_info);
                                  Utils.showSnackBar(
                                      'sucessfully saved', Colors.green);
                                } on FirebaseException catch (e) {
                                  Utils.showSnackBar(e.message, Colors.red);
                                }
                              }

                              Navigator.pushNamed(
                                  context, EducationForm.routeName);
                            },
                            // style: ButtonStyle(),
                            // icon: Icon(Icons.forward),
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
                              // primary: Colors.blue[900],
                              padding: EdgeInsets.all(10.0),
                              elevation: 10.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
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
