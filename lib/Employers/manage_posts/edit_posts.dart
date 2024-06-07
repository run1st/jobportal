import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1/profile/datepicker.dart';

import '../Employers_account/empUtils.dart';
import '../models/jobs_model.dart';
//import 'package:flutter_tags/flutter_tags.dart';
import 'package:uuid/uuid.dart';

class EditJobPostingForm extends StatefulWidget {
  static const routName = '/EditjobPostingForm';
  @override
  _EditJobPostingFormState createState() => _EditJobPostingFormState();
}

class _EditJobPostingFormState extends State<EditJobPostingForm> {
  final _formKey = GlobalKey<FormState>();
  final requirementController = TextEditingController();

  final jobTitleController = TextEditingController();
  final categoryController = TextEditingController();
  final descreptionController = TextEditingController();
  final salaryController = TextEditingController();
  final empTypeConroller = TextEditingController();
  final locationController = TextEditingController();
  final experienceController = TextEditingController();
  final educationController = TextEditingController();
  final deadlineConroller = TextEditingController();

  void _addRequirement(String skill) {
    if (!requirement.contains(skill)) {
      setState(() {
        requirement.add(skill);
      });
    }
  }

  void _removeRequirement(String skill) {
    if (requirement.contains(skill)) {
      setState(() {
        requirement.remove(skill);
      });
    }
  }

  List<String> jobCategory = [
    'Accounting & Finance',
    'Agriculture',
    'Administrative & Office Support',
    'Advertising & Marketing',
    'Arts & Entertainment',
    'Construction & Maintenance',
    'Customer Service',
    'Education & Training',
    'Engineering',
    'Healthcare & Medical',
    'Hospitality & Tourism',
    'Human Resources',
    'Technology',
    'Legal',
    'Manufacturing & Production',
    'Media & Communication',
    'Non-Profit & Volunteer',
    'Real Estate',
    'Retail & Sales',
    'Science & Research',
    'Transportation & Logistics',
    'Other'
  ];
  List employmentType = ['Partime', 'Full time', 'Remote', 'Onsite'];
  List experienceLevel = [
    'Fresh',
    '2 years',
    '3 years',
    '5 years',
    '10 years',
    '> 10 years'
  ];
  List<String> salaryExpectation = [
    '1,000 - 5,000',
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
  List educationLevel = ['bachelor', 'MSC', 'PHD'];
  String jobCategorySelected = 'Technology';
  String jobDescreption = '';
  String employmentTypeSelected = 'Full time';
  String experienceLevelSelected = 'Fresh';
  String educatonLelSeleceted = '';

  String salary = '';
  String jobTitle = '';
  String jobLocation = '';
  List requirement = [];
  String jobId = '';

  DateTime deadLine = DateTime.now();
  DateTime postedTime = DateTime.now();
  String stringDeadline = '';
  String stringPostedTime = '';

  String? selectedSalaryRange = '1,000 - 5,000';
  var companyData;
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2026),
  //   );

  //   if (picked != null && picked != _selectedDate) {
  //     setState(() {
  //       _selectedDate = picked;
  //     });
  //   }
  // }

  String saveDateAsString(DateTime selectedDate) {
    if (selectedDate == null) return "";

    final formatter = DateFormat('yyyy-MM-dd');

    // Convert DateTime object to String
    final formattedDate = formatter.format(selectedDate);
    return formattedDate;
  }

  String? currentUser;

  Future<void> getUserUid() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          currentUser = user.uid;
        });
        await fetchAndSaveCompanyData();
      } else {
        print('No user is signed in.');
      }
    } catch (e) {
      print('Error getting current user UID: $e');
    }
  }

  Map<String, dynamic>? companyProfile;
  Future<void> fetchAndSaveCompanyData() async {
    try {
      if (currentUser == null) {
        throw Exception('Error: currentUser is null');
      }

      final empDocRef =
          FirebaseFirestore.instance.collection('employer').doc(currentUser);
      final empProfileRef =
          empDocRef.collection('company profile').doc('profile');

      final docSnapshot = await empProfileRef.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          companyProfile = data;
          print(
              'Company data fetched and saved to global variable: ${companyProfile}');
        } else {
          print('Error: No data found in the document.');
        }
      } else {
        print('Error: Document does not exist.');
      }
    } on FirebaseException catch (e) {
      print('Error fetching company data: ${e.message}');
    } catch (e) {
      print('Error: $e');
    }
  }

  JobPost? previousJobPos;
  Future<void> fetchPreviousJobPos() async {
    try {
      if (currentUser == null) {
        throw Exception('Error: currentUser is null');
      }

      final empDocRef =
          FirebaseFirestore.instance.collection('employer').doc(currentUser);
      final empProfileRef =
          empDocRef.collection('company profile').doc('profile');

      final docSnapshot = await empProfileRef.get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          companyProfile = (data);
          print(
              'Company data fetched and saved to global variable: ${companyProfile}');
        } else {
          print('Error: No data found in the document.');
        }
      } else {
        print('Error: Document does not exist.');
      }
    } on FirebaseException catch (e) {
      print('Error fetching company data: ${e.message}');
    } catch (e) {
      print('Error: $e');
    }
  }

  void createJobId() {
    var uuid = Uuid();
    jobId = uuid.v5(Uuid.NAMESPACE_DNS, jobTitle);
  }

  Future saveJobPost(JobPost jobData) async {
    final job_document_ref = FirebaseFirestore.instance
        .collection('employers-job-postings')
        .doc('post-id')
        .collection('job posting')
        .doc(jobId);
    final company_job_post_ref = FirebaseFirestore.instance
        .collection('employer')
        .doc(currentUser)
        .collection('job posting')
        .doc(jobId);
    final json = jobData.toJson();
    await company_job_post_ref.set(json);
    await job_document_ref.set(json);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
    getUserUid();
  }

  @override
  Widget build(BuildContext context) {
    //print('this is the initial value of location ${locationController.text}');
    //createJobId();
    final postedJob =
        ModalRoute.of(context)?.settings.arguments as DocumentSnapshot;
    setState(() {
      jobCategorySelected = postedJob['job category'];
      employmentTypeSelected = postedJob['employment type'];
      experienceLevelSelected = postedJob['experience level'];
      educatonLelSeleceted = postedJob['education level'];
    });
    List<dynamic> job_requirement =
        (postedJob['requirements'] as List<dynamic>);
    for (int i = 0; i < job_requirement.length; i++) {
      setState(() {
        requirement.add(job_requirement[i]);
      });
    }
    // print('company data is :${globalData}');
    //getData();
    return Scaffold(
      appBar: AppBar(
        title: Text('Post a Job'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Job Title'),
                TextFormField(
                  controller: jobTitleController
                    ..text = '${postedJob['title'] ?? 'title'}',
                  // initialValue: postedJob['title'] ?? 'title',
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Job Title',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a job title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) {
                      jobTitle = value;
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                Text('Job Category'),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.blue[100],
                    hintText: 'Select an option',
                    hintStyle: const TextStyle(color: Colors.white),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an option';
                    }
                    return null;
                  },
                  items: jobCategory
                      .map((item) => DropdownMenuItem(
                            child: Text(item),
                            value: item,
                          ))
                      .toList(),
                  value: jobCategorySelected,
                  onChanged: (value) {
                    setState(() {
                      jobCategorySelected = value.toString();
                    });
                  },
                ),
                SizedBox(height: 16),
                Text('Job Descreption'),
                TextFormField(
                  controller: descreptionController
                    ..text = '${postedJob['description'] ?? 'desciption'}',
                  // initialValue: postedJob['description'] ?? 'desciption',
                  onSaved: (newValue) {
                    if (newValue != null) {
                      jobDescreption = newValue;
                    }
                  },
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Job Descreption',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  // onSubmitted: _addProffSkill,
                  controller: requirementController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          _addRequirement(requirementController.text);
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.pink,
                        )),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Requirement',
                  ),
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return 'Please enter a requirement';
                  //   }
                  //   return null;
                  // },
                  // onSaved: (value) {
                  //   if (value != null) requirement = value;
                  // },
                ),
                SizedBox(
                  height: 10,
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: [
                    ...requirement.map(
                      (skill) => Chip(
                        label: Text(skill),
                        onDeleted: () => _removeRequirement(skill),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Salary Range'),
                DropdownButtonFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue[100],
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
                SizedBox(height: 16),
                Text('Employment Type'),
                SizedBox(height: 16),
                DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.blue[100],
                      hintText: 'Select an option',
                      hintStyle: TextStyle(color: Colors.white),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'please select an option';
                      } else {
                        return null;
                      }
                    },
                    items: employmentType
                        .map((item) => DropdownMenuItem(
                              child: Text(item),
                              value: item,
                            ))
                        .toList(),
                    value: postedJob['employment type'] ?? 'Full time',
                    onChanged: (value) {
                      setState(() {
                        employmentTypeSelected = value.toString();
                      });
                    }),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: locationController
                    ..text = '${postedJob['location']}',
                  //   initialValue: postedJob['location'],
                  decoration: InputDecoration(
                    labelText: 'Location',
                    labelStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1.5,
                      ),
                    ),
                    errorStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a location';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) {
                      jobLocation = value;
                    }
                    //else {
                    //   jobLocation = locationController.text;
                    // }
                  },
                ),
                SizedBox(height: 16),
                Text('Experience Level'),
                DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.blue[100],
                      hintText: 'Select an option',
                      hintStyle: TextStyle(color: Colors.white),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'please select an option';
                      } else
                        return null;
                    },
                    items: experienceLevel
                        .map((item) => DropdownMenuItem(
                              child: Text(item),
                              value: item,
                            ))
                        .toList(),
                    value: postedJob['experience level'] ?? 'Fresh',
                    onChanged: (value) {
                      setState(() {
                        value != null
                            ? experienceLevelSelected = value.toString()
                            : postedJob['experience level'];
                      });
                    }),
                SizedBox(
                  height: 16,
                ),
                SizedBox(height: 16),
                Text('Education Level'),
                DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.blue[100],
                      hintText: 'Select an option',
                      hintStyle: TextStyle(color: Colors.white),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'please select an option';
                      } else
                        return null;
                    },
                    items: educationLevel
                        .map((item) => DropdownMenuItem(
                              child: Text(item),
                              value: item,
                            ))
                        .toList(),
                    value: postedJob['education level'] ?? 'bachelor',
                    onChanged: (value) {
                      setState(() {
                        value != null
                            ? educatonLelSeleceted = value.toString()
                            : postedJob['education level'];
                      });
                    }),
                const Text('Application Deadline'),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: DateFormField(
                    label: 'Deadline',
                    initialDate: DateTime.now(),
                    onDateSelected: (date) {
                      deadLine = date;
                      stringDeadline = saveDateAsString(deadLine);
                    },
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width - 100,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();
                          // getDataFromFirestore();
                          stringPostedTime = saveDateAsString(postedTime);
                          final job_post = JobPost(
                              timePosted: postedTime,
                              JobId: jobId,
                              title: jobTitle,
                              category: jobCategorySelected,
                              description: jobDescreption,
                              requirements: requirement,
                              salary: selectedSalaryRange,
                              employmentType: employmentTypeSelected,
                              location: jobLocation,
                              experienceLevel: experienceLevelSelected,
                              educationLevel: educatonLelSeleceted,
                              deadline: deadLine,
                              company: companyProfile);
                          try {
                            // getData();

                            saveJobPost(job_post);
                            EmpUtils.showSnackBar(
                                'sucessfully posted', Colors.green);
                          } on FirebaseException catch (e) {
                            EmpUtils.showSnackBar(e.message, Colors.red);
                          }
                        }
                      },
                      child: Text('Update Post'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
