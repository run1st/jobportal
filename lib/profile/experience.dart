import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project1/profile/progress_indicator.dart';
import 'package:provider/provider.dart';
import './skills.dart';
//import 'package:date_field/date_field.dart';
import '../jobSeekerModel/job_seeker_profile_model.dart';
import './datepicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../user_account/utils.dart';

class Experience extends StatefulWidget {
  const Experience({Key? key}) : super(key: key);
  static const routeName = '/Experience';

  @override
  State<Experience> createState() => _ExperienceState();
}

class _ExperienceState extends State<Experience> {
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

  Future saveExperienceInfo(ExperienceModel experienceInfo) async {
    try {
      final personal_info_doc_ref =
          FirebaseFirestore.instance.collection('job-seeker').doc(currentUser);
      final json = experienceInfo.toJson();
      await personal_info_doc_ref
          .collection('jobseeker-profile')
          .doc('profile')
          .set({
        'experiences': {'experience': json}
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      print('Error saving personal info: ${e.message}');
      Utils.showSnackBar(context, e.message, Colors.red);
      rethrow;
    } catch (e) {
      print('Error saving personal info: $e');
      rethrow;
    }
  }

  final _formKey = GlobalKey<FormState>();
  final jobTitleController = TextEditingController();
  final companyController = TextEditingController();
  final cityController = TextEditingController();
  final regionController = TextEditingController();
  late DateTime startDateController;
  late DateTime endDateController;
  String jobTitle = '';
  String company = '';
  String region = '';
  String city = '';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  void startDateSelected(DateTime selectedDate) {
    startDate = selectedDate;
  }

  void endDateSelected(DateTime selectedDate) {
    endDate = selectedDate;
  }

  List State = ['Amhara', 'AA', 'Hareri', 'Somali', 'Hawassa'];
  var stateSelected;
  //List towns = ['Ethiopia', 'america', 'england', 'Germany'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserUid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Experience'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CircularProgress(value: 0.5),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      ' Prior work experience',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.blue),
                    ),
                    Text(' job title'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: TextFormField(
                        controller: jobTitleController,
                        decoration: InputDecoration(
                          labelText: 'job title',
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
                            borderSide: BorderSide(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter the job title';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null) jobTitle = value;
                        },
                      ),
                    ),
                    Text('Company Name'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: TextFormField(
                        controller: companyController,
                        decoration: InputDecoration(
                          labelText: 'company name',
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
                            borderSide: BorderSide(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter Your company name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null) company = value;
                        },
                      ),
                    ),
                    const Text('Region'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: TextFormField(
                        controller: regionController,
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
                            borderSide: BorderSide(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter Your region name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null) region = value;
                        },
                      ),
                    ),
                    Text('City'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: TextFormField(
                        controller: cityController,
                        decoration: InputDecoration(
                          labelText: 'city',
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
                            borderSide: BorderSide(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter Your city name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value != null) city = value;
                        },
                      ),
                    ),
                    Text('Date'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: DateFormField(
                        label: 'Start Date',
                        initialDate: DateTime.now(),
                        onDateSelected: (date) {
                          startDate = date;
                          // do something with the selected date
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: DateFormField(
                        label: 'End Date',
                        initialDate: DateTime.now(),
                        onDateSelected: (date) {
                          endDate = date;
                          // do something with the selected date
                        },
                      ),
                    ),
                    //  Text('projects worked on'),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();

                          final experienceInfo = ExperienceModel(
                              title: jobTitle,
                              company: company,
                              startDate: startDate,
                              endDate: endDate,
                              city: city,
                              region: region);
                          print(experienceInfo.city);
                          print(experienceInfo.company);
                          print(experienceInfo.region);
                          print(experienceInfo.startDate);

                          try {
                            await saveExperienceInfo(experienceInfo);
                            Utils.showSnackBar(
                                context, 'sucessfully saved', Colors.green);
                            Navigator.of(context).pop();
                          } catch (e) {
                            Utils.showSnackBar(
                                context, e.toString(), Colors.red);
                          }
                        }

                        // Navigator.pushNamed(context, SkillSet.routeName);
                      },
                      icon: Icon(Icons.forward),
                      label: Text('Save and Continue'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        // primary: Colors.blue[900],
                        padding: EdgeInsets.all(10.0),
                        elevation: 10.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
