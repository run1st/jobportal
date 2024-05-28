import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:intl/intl.dart';
// import 'package:project1/Employers/bridgeTOemp_home_page.dart';
import 'package:project1/Employers/home_page/tabs_screen.dart';
import 'package:project1/Employers/models/jobs_model.dart';
import './compLogo_picker.dart';

import 'package:flutter/material.dart';

import 'dart:io';
import '../Employers_account/empUtils.dart';

class EditEmployerProfile extends StatefulWidget {
  static const routeName = '/EditEmployerProfile';
  const EditEmployerProfile({Key? key}) : super(key: key);

  @override
  State<EditEmployerProfile> createState() => _EditEmployerProfileState();
}

class _EditEmployerProfileState extends State<EditEmployerProfile> {
  File? _image;
  void _onImageSelected(File image) {
    setState(() {
      _image = image;
      //  companyLogo = url;
    });
  }

  String? currentUser;
  Future<String> getCurrentUserUid() async {
    User? user = await FirebaseAuth.instance.currentUser;

    if (user != null) {
      print('Curent user id ${user}');
      return user.uid;
    } else {
      return '';
    }
  }

  void printImagePath() {
    print('your image path is : ${_image}');
  }

  Future saveEmployerInfo(Company companyInfonfo) async {
    final empDocumentReference =
        FirebaseFirestore.instance.collection('employer').doc(currentUser);
    final empPrifileReference =
        empDocumentReference.collection('company profile').doc('profile');
    _companyId = empDocumentReference.id;
    final json = companyInfonfo.toJson();
    await empPrifileReference
        // .collection('Employer profile')
        // .doc('personal_info')
        .set(json);
  }

  String? _uploadedFileURL;

  Future<void> _uploadFile() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference reference =
        storage.ref().child('images/Employers/$fileName');
    final UploadTask uploadTask = reference.putFile(_image!);
    final TaskSnapshot downloadUrl = (await uploadTask);
    final String url = (await downloadUrl.ref.getDownloadURL());
    setState(() {
      _uploadedFileURL = url;
      companyLogo = url;
    });
    print('the company logo url is : ${companyLogo}');
  }

  final contactPersonConteroller = TextEditingController();
  final companyNameController = TextEditingController();
  final streetAdressConteroller = TextEditingController();
  final cityController = TextEditingController();
  final regionController = TextEditingController();
  final countryController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final descreptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _companyId = '';
  String contactPerson = '';
  String _streetAddress = '';
  String _city = '';
  String _state = '';
  String _country = '';
  // String _zipCode = '';
  String companyName = '';
  String phoneNumber = '';
  String email = '';
  String companyWebsite = '';
  String comapnyDesription = '';
  String _industryTypeselected = 'Education';
  String companySzeSelected = 'Self-Employed';
  String? companyLogo;

  List<String> industryType = [
    'Agriculture',
    'Automotive',
    'Banking and Finance',
    'Construction',
    'Education',
    'Energy',
    'Healthcare',
    'Tourism',
    'Information Technology',
    'Manufacturing',
    'Media and Entertainment',
    'NGO'
  ];
  List<String> companySize = [
    'Self-Employed',
    'Small Business',
    'Small-Medium Business',
    'Medium Business',
    'Medium-Large Business',
    'Large Business',
    'Enterprise'
  ];
  @override
  void initState() {
    super.initState();

    getCurrentUserUid();
  }

  Future<bool> _onWillPop() async {
    //await SystemNavigator.pop();
    Navigator.pushNamed(
      context,
      TabsScreen.routeName,
    );
    return false;
  }

  Map<String, dynamic>? profileData;
  @override
  Widget build(BuildContext context) {
    // currentUser = getCurrentUserUid();
    // printImagePath();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('employer')
                  .doc(currentUser)
                  .collection('company profile')
                  .doc('profile')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Text('No data available');
                  } else {
                    profileData = snapshot.data!.data() as Map<String, dynamic>;
                    setState(() {
                      //   String _companyId = profileData?['companyId'] ?? '';
                      contactPerson = '';
                      _streetAddress = profileData?['address'] ?? 'Adess';
                      _city = profileData?['city'] ?? 'city';
                      _state = profileData?['state'] ?? 'state';
                      _country = profileData?['country'] ?? 'country';
                      // _zipCode = '';
                      companyName = profileData?['name'] ?? 'name';
                      phoneNumber = profileData?['phone'] ?? 'phone';
                      email = profileData?['email'] ?? 'name';
                      companyWebsite = profileData?['website'] ?? 'website';
                      comapnyDesription =
                          profileData?['description'] ?? 'description';
                      _industryTypeselected =
                          profileData?['industry'] ?? 'Education';
                      companySzeSelected =
                          profileData?['company-size'] ?? 'Small Business';
                      companyLogo;
                    });
                  }
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                Text(
                                  'Update Company ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.black45,
                                  ),
                                ),
                                Text(
                                  'Information',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            child: TextFormField(
                              controller: contactPersonConteroller
                                ..text = profileData?['email'] ?? 'name',
                              decoration: InputDecoration(
                                labelText: 'contact person Name',
                                labelStyle: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                filled: true,
                                fillColor: Colors.blue[50],
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please enter contact person name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) contactPerson = value;
                              },
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            child: TextFormField(
                              controller: companyNameController
                                ..text = profileData?['name'] ?? 'name',
                              decoration: InputDecoration(
                                labelText: 'company Name',
                                labelStyle: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                filled: true,
                                fillColor: Colors.blue[50],
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please enter the company name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) companyName = value;
                              },
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            child: TextFormField(
                              controller: streetAdressConteroller
                                ..text = _streetAddress,
                              decoration: InputDecoration(
                                labelText: 'Street Address',
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w700,
                                ),
                                filled: true,
                                fillColor: Colors.blue[50],
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a street address';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) _streetAddress = value;
                              },
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            child: TextFormField(
                              controller: cityController..text = _city,
                              decoration: InputDecoration(
                                labelText: 'City',
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w700,
                                ),
                                filled: true,
                                fillColor: Colors.blue[50],
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a city';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) _city = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            child: TextFormField(
                              controller: regionController..text = _state,
                              decoration: InputDecoration(
                                labelText: 'State/Region',
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w700,
                                ),
                                filled: true,
                                fillColor: Colors.blue[50],
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a state';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) _state = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            child: TextFormField(
                              controller: countryController..text = _country,
                              decoration: InputDecoration(
                                labelText: 'Country',
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w700,
                                ),
                                filled: true,
                                fillColor: Colors.blue[50],
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a state';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                if (value != null) _state = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            child: TextFormField(
                              controller: phoneController..text = phoneNumber,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'phone number',
                                labelStyle: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                filled: true,
                                fillColor: Colors.blue[50],
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
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
                              onSaved: (newValue) {
                                if (newValue != null) phoneNumber = newValue;
                              },
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            child: TextFormField(
                              controller: emailController
                                ..text = profileData?['email'] ?? 'name',
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter your email address',
                                prefixIcon: Icon(Icons.email),
                                filled: true,
                                fillColor: Colors.blue[50],
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
                                ),
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
                              onSaved: (newValue) {
                                if (newValue != null) email = newValue;
                              },
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            child: TextFormField(
                              controller: websiteController
                                ..text = companyWebsite,
                              decoration: InputDecoration(
                                labelText: 'Company Website',
                                hintText: 'www.example.com',
                                prefixIcon: Icon(Icons.language),

                                /// border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.blue[50],
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2)),
                                errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 2),
                                ),
                              ),
                              keyboardType: TextInputType.url,
                              // validator: (value) {
                              //   if (value == null) {
                              //     return 'Please enter company website';
                              //   } else if (!Uri.parse(value).isAbsolute) {
                              //     return 'Please enter a valid website';
                              //   }
                              //   return null;
                              // },
                              onSaved: (newValue) {
                                if (newValue != null) companyWebsite = newValue;
                              },
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            child: TextFormField(
                              controller: descreptionController
                                ..text = comapnyDesription,
                              maxLines: 5,
                              decoration: InputDecoration(
                                labelText: 'Company Description',
                                filled: true,
                                fillColor: Colors.blue[50],
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 2.0,
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
                              onSaved: (newValue) {
                                if (newValue != null)
                                  comapnyDesription = newValue;
                              },
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Industry Type:',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  filled: true,
                                  fillColor: Colors.blue[50],
                                  hintText: 'Select an option',
                                  // hintStyle: TextStyle(color: Colors.white),
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
                                value: _industryTypeselected,
                                items: industryType.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(item),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _industryTypeselected = value.toString();
                                  });
                                }),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Company size:',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            child: DropdownButtonFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  filled: true,
                                  fillColor: Colors.blue[50],
                                  hintText: 'Select an option',
                                  // hintStyle: TextStyle(color: Colors.white),
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
                                value: companySzeSelected,
                                //  profileData?['company-size'] ??
                                //     'Small Business',
                                items: companySize.map((item) {
                                  return DropdownMenuItem(
                                    child: Text(item),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    companySzeSelected = value.toString();
                                  });
                                }),
                          ),
                          // CompanyLogoPicker(onImageSelected: _onImageSelected),
                          const Text(
                            'Profile Picture:',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          CompanyLogoPicker(onImageSelected: _onImageSelected),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size.fromHeight(50)),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState?.save();
                                        _uploadFile();
                                        final companyInfo = Company(
                                            companyId: _companyId,
                                            name: companyName,
                                            address: _streetAddress,
                                            city: _city,
                                            state: _state,
                                            country: _country,
                                            phone: phoneNumber,
                                            email: email,
                                            website: companyWebsite,
                                            description: comapnyDesription,
                                            industry: _industryTypeselected,
                                            companySize: companySzeSelected,
                                            logoUrl: companyLogo as String);
                                        try {
                                          saveEmployerInfo(companyInfo);

                                          EmpUtils.showSnackBar(
                                              'sucessfully saved',
                                              Colors.green);
                                          Navigator.pushNamed(
                                              context, TabsScreen.routeName,
                                              arguments: companyInfo);
                                        } on FirebaseException catch (e) {
                                          EmpUtils.showSnackBar(
                                              e.message, Colors.red);
                                        }
                                        // Navigator.pushNamed(
                                        //   context,
                                        //   TabsScreen.routeName,
                                        // );
                                      }
                                    },
                                    icon: Icon(Icons.arrow_forward),
                                    label: Text('Update')),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      )),
                );
              }),
        ),
      ),
    );
  }
}
