import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1/profile/datepicker.dart';

import '../Employers_account/empUtils.dart';
import '../models/jobs_model.dart';
//import 'package:flutter_tags/flutter_tags.dart';
import 'package:uuid/uuid.dart';

class JobPostingForm extends StatefulWidget {
  static const routName = '/jobPostingForm';
  @override
  _JobPostingFormState createState() => _JobPostingFormState();
}

class _JobPostingFormState extends State<JobPostingForm> {
  final _formKey = GlobalKey<FormState>();
  final requirementController = TextEditingController();
  void _addRequirement(String skill) {
    if (!requirement.contains(skill)) {
      setState(() {
        requirement.add(skill);
      });
    }
  }

  void _removeRequirement(String skill) {
    setState(() {
      requirement.remove(skill);
    });
  }

  //List jobCategory = ['Technology', 'Agriculture', 'blabal'];
  // job_categories.dart

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
  List educationLevel = ['bachelor', 'MSC', 'PHD'];
  String jobCategorySelected = '';
  String jobDescreption = '';
  String employmentTypeSelected = '';
  String experienceLevelSelected = '';
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
  String? selectedSalaryRange;

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

  void createJobId() {
    var uuid = Uuid();
    setState(() {
      jobId = uuid.v5(Uuid.NAMESPACE_DNS, jobTitle);
    });
  }

  Future saveJobPost(JobPost jobData) async {
    final jobDocumentReference = FirebaseFirestore.instance
        .collection('employers-job-postings')
        .doc('post-id')
        .collection('job posting')
        .doc(jobId);
    final companyJobPostRef = FirebaseFirestore.instance
        .collection('employer')
        .doc(currentUser)
        .collection('job posting')
        .doc(jobId);
    final json = jobData.toJson();
    await companyJobPostRef.set(json);
    await jobDocumentReference.set(json);
  }

  Company? companyProfile;
  Future<void> fetchAndSaveCompanyData() async {
    try {
      print('Fetching company data for user: $currentUser');
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
          setState(() {
            companyProfile = Company.fromJson(data);
          });
          print(
              'Company data fetched and saved to global variable: ${companyProfile!.toJson()}');
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

  // final company_data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserUid();
  }

  @override
  Widget build(BuildContext context) {
    // createJobId();

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
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('Job Category'),
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
                        return 'please select an option';
                      } else
                        return null;
                    },
                    items: jobCategory
                        .map((item) => DropdownMenuItem(
                              child: Text(item),
                              value: item,
                            ))
                        .toList(),
                    value: jobCategory[0],
                    onChanged: (value) {
                      setState(() {
                        jobCategorySelected = value.toString();
                      });
                    }),
                SizedBox(height: 16),
                Text('Job Descreption'),
                TextFormField(
                  onSaved: (newValue) {
                    if (newValue != null) {
                      jobDescreption = newValue;
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Discribe your company.';
                    } else if (value.toString().split(' ').length < 50) {
                      return 'Please enter at least 50 words.';
                    } else {
                      return null;
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
                          if (!requirementController.text.isEmpty) {
                            _addRequirement(requirementController.text);
                            requirementController.clear();
                          }
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
                  validator: (value) {
                    if (requirement.isEmpty) {
                      return 'Please enter a requirement';
                    }
                    return null;
                  },
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
                SizedBox(height: 16),
                Text('Salary Range'),
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
                    value: employmentType[0],
                    onChanged: (value) {
                      setState(() {
                        employmentTypeSelected = value.toString();
                      });
                    }),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
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
                      } else {
                        return null;
                      }
                    },
                    items: experienceLevel
                        .map((item) => DropdownMenuItem(
                              child: Text(item),
                              value: item,
                            ))
                        .toList(),
                    value: experienceLevel[0],
                    onChanged: (value) {
                      setState(() {
                        experienceLevelSelected = value.toString();
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
                      } else {
                        return null;
                      }
                    },
                    items: educationLevel
                        .map((item) => DropdownMenuItem(
                              child: Text(item),
                              value: item,
                            ))
                        .toList(),
                    value: educationLevel[0],
                    onChanged: (value) {
                      setState(() {
                        educatonLelSeleceted = value.toString();
                      });
                    }),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: DateFormField(
                    label: 'Deadline',
                    initialDate: DateTime.now(),
                    onDateSelected: (date) {
                      setState(() {
                        deadLine = date;
                        stringDeadline = saveDateAsString(deadLine);
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState?.save();
                            createJobId();
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
                            stringPostedTime = saveDateAsString(postedTime);

                            try {
                              await fetchAndSaveCompanyData();

                              final jobPost = JobPost(
                                  timePosted: stringPostedTime,
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
                                  deadline: stringDeadline,
                                  company: companyProfile?.toJson());
                              await saveJobPost(jobPost);
                              // EmpUtils.showSnackBar(
                              //     'sucessfully posted', Colors.green);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Successfully saved'),
                                  backgroundColor: Colors.green,
                                ),
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
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Post'),
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
