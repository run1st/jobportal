import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project1/job_seeker_home_page/jobSeekerHome.dart';
import 'package:project1/user_account/utils.dart';
import 'package:provider/provider.dart';
import '../jobSeekerModel/job_seeker_profile_model.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Employers/emp_profile/compLogo_Picker.dart';
import './education.dart';
import './experience.dart';
import './personal_info.dart';
import 'package:uuid/uuid.dart';

class SkillSet extends StatefulWidget {
  //const SkillSet({Key? key}) : super(key: key);
  static const routeName = '/SkillSet';

  @override
  State<SkillSet> createState() => _SkillSetState();
}

class _SkillSetState extends State<SkillSet> {
  String? selectedSalaryRange;

  List<String> salaryExpectation = [
    '1,000 - 5,000'
        '5,000 - 10,000',
    '10,000 - 20,000',
    '20,000 - 30,000',
    '30,000 - 40,000',
    '40,000 - 50,000',
    '50,000 - 60,000',
    '60,000 - 70,000',
    '70,000 - 80,000',
    '80,000 - 90,000',
    '90,000 - 100,000',
    '100,000 - 110,000',
    '110,000 - 120,000',
    'Above 120,000',
  ];
  List experienceLevel = [
    'Fresh',
    '2 years',
    '3 years',
    '5 years',
    '10 years',
    '> 10 years'
  ];
  List<String> jobTitles = [
    'Accountant',
    'Architect',
    'Business Analyst',
    'Business Development Manager',
    'Civil Engineer',
    'Content Writer',
    'Data Analyst',
    'Data Scientist',
    'Database Administrator',
    'DevOps Engineer',
    'Electrical Engineer',
    'Flutter Developer',
    'Full Stack Developer',
    'Game Developer',
    'Graphic Designer',
    'Human Resources Manager',
    'IT Project Coordinator',
    'Lawyer',
    'Marketing Manager',
    'Mechanical Engineer',
    'Network Engineer',
    'Nurse',
    'Pharmacist',
    'Product Manager',
    'Project Manager',
    'Software Engineer',
    'Software Tester',
    'Solution Architect',
    'System Administrator',
    'Teacher',
    'Doctor'
        'UI/UX Designer',
    'Web Developer' 'other'
  ];

  var experienceLevelChoosed;
  var salaryLevelChoosed;
  String? _jobPreference;
  String? uid;
  File? _image;
  String? _imageUrl;
  List<String> personalSkill = [];
  List<String> proffesionalSkill = [];
  List<String> languageSkill = [];
  List<String> achivSkill = [];
  String about = '';
  final _formKey = GlobalKey<FormState>();
  final profSkillController = TextEditingController();
  final persSkillController = TextEditingController();
  final langSkillController = TextEditingController();
  final achivSkillController = TextEditingController();
  String profileId = '';
  void _onImageSelected(File image) {
    setState(() {
      _image = image;
      //  _imageUrl = Url;
    });
  }

  void _addProffSkill(String skill) {
    if (!proffesionalSkill.contains(skill)) {
      setState(() {
        proffesionalSkill.add(skill);
      });
    }
  }

  void _removeproffSkill(String skill) {
    setState(() {
      proffesionalSkill.remove(skill);
    });
  }

  void _addPersonalSkill(String skill) {
    if (!personalSkill.contains(skill)) {
      setState(() {
        personalSkill.add(skill);
      });
    }
  }

  void _removePersonalSkill(String skill) {
    setState(() {
      personalSkill.remove(skill);
    });
  }

  void _addLanguageSkill(String skill) {
    if (!languageSkill.contains(skill)) {
      setState(() {
        languageSkill.add(skill);
      });
    }
  }

  // void addLanguageSkill(List skills, Function addSkill) {}
  void _removeLanguageSkill(String skill) {
    setState(() {
      languageSkill.remove(skill);
    });
  }

  void _addAchivSkill(String skill) {
    if (!achivSkill.contains(skill)) {
      setState(() {
        achivSkill.add(skill);
      });
    }
  }

  //void addAchivSkill(List skills, Function addSkill) {}
  void _removeAchivSkill(String skill) {
    setState(() {
      achivSkill.remove(skill);
    });
  }

  User? user = FirebaseAuth.instance.currentUser;
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

  final user_reference = FirebaseFirestore.instance.collection('job-seeker');
  Future saveSkillInfo(Skill job_seeker_skill) async {
    try {
      final personalInfoDocRef = user_reference.doc(currentUser);
      final json = job_seeker_skill.toJson();
      await personalInfoDocRef
          .collection('jobseeker-profile')
          .doc('profile')
          .set({'skills': json}, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      print('Error saving skills: ${e.message}');
      Utils.showSnackBar(context, e.message, Colors.red);
      rethrow;
    } catch (e) {
      print('Error saving skills info: $e');
    }
  }

  Future saveOtherInfo(Other other_info) async {
    try {
      final personalInfoDocRef = user_reference.doc(currentUser);
      final json = other_info.toJson();
      await personalInfoDocRef
          .collection('jobseeker-profile')
          .doc('profile')
          .set({'other-data': json}, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      print('Error in saving your data: ${e.message}');
      Utils.showSnackBar(context, e.message, Colors.red);
      rethrow;
    } catch (e) {
      print('Error saving other data: $e');
    }
  }

  String? _uploadedFileURL;

  Future<void> _uploadFile() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference reference =
        storage.ref().child('images/jobSeekers/$fileName');
    final UploadTask uploadTask = reference.putFile(_image!);
    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = (await downloadUrl.ref.getDownloadURL());
    setState(() {
      _uploadedFileURL = url;
      _imageUrl = _uploadedFileURL;
    });
    print(_imageUrl);
  }

  void createProfileId() {
    var uuid = Uuid();
    profileId = uuid.v4();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
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
        title: Text('Skills *'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Text(
                  'Share your skills with us',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.blue),
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  // padding: EdgeInsets.only(
                  //     left: 60.0, right: 10.0, top: 10.0, bottom: 10.0),
                  width: MediaQuery.of(context).size.width * 4 / 5,
                  child: TextFormField(
                    // onSubmitted: _addProffSkill,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Add professional skill';
                      } else {
                        return null;
                      }
                    },
                    controller: profSkillController,
                    decoration: InputDecoration(
                      label: Text(' Professional skills'),
                      suffixIcon: IconButton(
                          onPressed: () {
                            if (profSkillController.text.isNotEmpty) {
                              _addProffSkill(profSkillController.text);
                              profSkillController.clear();
                            }
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.pink,
                          )),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    ...proffesionalSkill.map(
                      (skill) => Chip(
                        label: Text(skill),
                        onDeleted: () => _removeproffSkill(skill),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  // padding: EdgeInsets.only(
                  //     left: 60.0, right: 10.0, top: 10.0, bottom: 10.0),
                  width: MediaQuery.of(context).size.width * 4 / 5,
                  child: TextFormField(
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Add professional skill';
                      } else {
                        return null;
                      }
                    },
                    // onChanged: _addPersonalSkill,
                    controller: persSkillController,
                    decoration: InputDecoration(
                      label: Text(' personal skills'),
                      suffixIcon: IconButton(
                          onPressed: () {
                            if (profSkillController.text.isNotEmpty) {
                              _addPersonalSkill(persSkillController.text);
                              persSkillController.clear();
                            }
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.pink,
                          )),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    ...personalSkill.map(
                      (skill) => Chip(
                        label: Text(skill),
                        onDeleted: () => _removePersonalSkill(skill),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  // padding: EdgeInsets.only(
                  //     left: 60.0, right: 10.0, top: 10.0, bottom: 10.0),
                  width: MediaQuery.of(context).size.width * 4 / 5,
                  child: TextFormField(
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Add professional skill';
                      } else {
                        return null;
                      }
                    },
                    //onChanged: _addLanguageSkill,
                    controller: langSkillController,
                    decoration: InputDecoration(
                      label: Text(' Language skills'),
                      suffixIcon: IconButton(
                          onPressed: () {
                            if (profSkillController.text.isNotEmpty) {
                              _addLanguageSkill(langSkillController.text);
                              langSkillController.clear();
                            }
                          },
                          icon: Icon(
                            Icons.add,
                            color: Colors.pink,
                          )),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    ...languageSkill.map(
                      (skill) => Chip(
                        label: Text(skill),
                        onDeleted: () => _removeLanguageSkill(skill),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text('Tell us about yourself *'),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width * 4 / 5,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: TextFormField(
                      onSaved: (newValue) {
                        if (newValue != null) about = newValue;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Say something about yourself.';
                        } else if (value.toString().split(' ').length < 50) {
                          return 'Please enter at least 50 words.';
                        } else {
                          return null;
                        }
                      },
                      maxLines: 10,
                      decoration: InputDecoration(
                        labelText: 'summary',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Text('Preferred job '),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      // labelStyle: TextStyle(color: Colors.white),
                      // filled: true,
                      // fillColor: Colors.lightBlue,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      // filled: true,
                      // fillColor: Colors.blue,
                      hintText: 'Select an option',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    validator: ((value) {
                      if (value == null) {
                        return 'please select an option';
                      } else {
                        return null;
                      }
                    }),
                    value: _jobPreference,
                    items: jobTitles.map((item) {
                      return DropdownMenuItem(
                        child: Text(item),
                        value: item,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _jobPreference = value.toString();
                      });
                    }),
              ),
              SizedBox(height: 16.0),
              Text('Salary Expectation'),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      // filled: true,
                      // fillColor: Colors.blue,
                      hintText: 'Select an option',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    validator: ((value) {
                      if (value == null) {
                        return 'please select an option';
                      } else {
                        return null;
                      }
                    }),
                    value: selectedSalaryRange,
                    items: salaryExpectation.map((item) {
                      return DropdownMenuItem(
                        child: Text(item),
                        value: item,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSalaryRange = value.toString();
                      });
                    }),
              ),
              Text('Your level of Experience'),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      // filled: true,
                      // fillColor: Colors.blue,
                      hintText: 'Select an option',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    validator: ((value) {
                      if (value == null) {
                        return 'please select an option';
                      } else {
                        return null;
                      }
                    }),
                    value: experienceLevelChoosed,
                    items: experienceLevel.map((item) {
                      return DropdownMenuItem(
                        child: Text(item),
                        value: item,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        experienceLevelChoosed = value.toString();
                      });
                    }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text('Add your profile image'),
              ),
              // imageProfile(context),
              CompanyLogoPicker(onImageSelected: _onImageSelected),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 45,
                width: MediaQuery.of(context).size.width - 100,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();
                      final skill_Set = Skill(
                          languageSkills: languageSkill,
                          personalSkills: personalSkill,
                          professionalSkills: proffesionalSkill);
                      //  _uploadFile(); //uploades image to firebase storage
                      final other_info = Other(
                          aboutMe: about,
                          imageUrl: _imageUrl,
                          preferredJob: _jobPreference,
                          SalaryExpectation: salaryLevelChoosed,
                          levelOfExperience: experienceLevelChoosed);
                      try {
                        await saveSkillInfo(skill_Set);
                        await _uploadFile();

                        await saveOtherInfo(other_info);
                        // user_reference
                        //     .doc(currentUser)
                        //     .collection('profile')
                        //     .doc('About')
                        //     .set({'summary': about});

                        // uploadImage();
                        // addImageToFirestore();
                        // uploadFile();

                        Utils.showSnackBar(
                            context, 'Profile successfuly saved', Colors.green);
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamed(
                          home.routeName,
                        );
                      } catch (e) {
                        print('Error during saving: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Error saving information. Please try again.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  // icon: Icon(Icons.navigate_next),
                  style: ElevatedButton.styleFrom(
                    // minimumSize: Size.fromHeight(50),
                    // maximumSize: Size.fromWidth(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    // primary: Colors.blue[900],
                    padding: EdgeInsets.all(10.0),
                    elevation: 10.0,
                  ),
                  //ElevatedButton.styleFrom(minimumSize: Size.fromWidth(50)),
                  child: Text('Finish'),
                ),
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
