import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:intl/intl.dart';
import 'package:project1/Employers/bridgeTOemp_home_page.dart';
import 'package:project1/Employers/home_page/tabs_screen.dart';
import 'package:project1/Employers/models/jobs_model.dart';
import './compLogo_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:io';
import '../Employers_account/empUtils.dart';

class EmployerRegistrationForm extends StatefulWidget {
  static const routeName = '/EmployerRegistrationForm';
  const EmployerRegistrationForm({Key? key}) : super(key: key);

  @override
  State<EmployerRegistrationForm> createState() =>
      _EmployerRegistrationFormState();
}

class _EmployerRegistrationFormState extends State<EmployerRegistrationForm> {
  File? _image;
  void _onImageSelected(File image) {
    setState(() {
      _image = image;
      //  companyLogo = url;
    });
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

  void printImagePath() {
    print('your image path is : ${_image}');
  }

  Future<void> saveEmployerInfo(Company companyInfo) async {
    try {
      if (currentUser == null) {
        throw Exception('currentUser is null');
      }

      final empDocRef =
          FirebaseFirestore.instance.collection('employer').doc(currentUser);
      final empProfileRef =
          empDocRef.collection('company profile').doc('profile');
      setState(() {
        _companyId = empDocRef.id;
      });

      final json = companyInfo.toJson();

      print('Saving company info: ${json}');
      await empProfileRef.set(json);
      print('Company info saved successfully.');
    } on FirebaseException catch (e) {
      print('Error saving company info: ${e.message}');
      throw Exception('Error saving company info: ${e.message}');
    } catch (e) {
      print('Error saving company info: $e');
      throw Exception('Error saving company info: $e');
    }
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

  final _formKey = GlobalKey<FormState>();
  String _companyId = '';
  String contactPerson = '';
  String _streetAddress = '';
  String _city = '';
  String _state = '';
  String _country = '';

  String companyName = '';
  String phoneNumber = '';
  String email = '';
  String companyWebsite = '';
  String comapnyDesription = '';
  String _IndustryTypeselected = '';
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
    // TODO: implement initState
    super.initState();
    getUserUid();
  }

  @override
  Widget build(BuildContext context) {
    // printImagePath();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Company Information',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    child: TextFormField(
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
                                BorderSide(color: Colors.blue, width: 2)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
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
                                BorderSide(color: Colors.blue, width: 2)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the company name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (value != null) companyName = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    child: TextFormField(
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
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2)),
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
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2)),
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
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2)),
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
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a country';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (value != null) _country = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 10.0),
                    child: TextFormField(
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
                                BorderSide(color: Colors.blue, width: 2)),
                      ),
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter your phone number';
                        } else if (value.length < 10)
                          return 'Please enter your phone number';
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
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2)),
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
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2)),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your company detail.';
                        } else if (value.toString().split(' ').length < 50) {
                          return 'Please enter at least 50 words.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        if (newValue != null) comapnyDesription = newValue;
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Industry Type:',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
                      // value: _IndustryTypeselected,
                      items: industryType.map((item) {
                        return DropdownMenuItem(
                          child: Text(item),
                          value: item,
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _IndustryTypeselected = value.toString();
                        });
                      },
                      onSaved: (newValue) {
                        if (newValue != null)
                          _IndustryTypeselected = newValue.toString();
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Company size:',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
                      value: companySzeSelected,
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
                      },
                      onSaved: (newValue) {
                        if (newValue != null)
                          companySzeSelected = newValue.toString();
                      },
                    ),
                  ),
                  // CompanyLogoPicker(onImageSelected: _onImageSelected),
                  Text(
                    'Profile Picture:',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  CompanyLogoPicker(onImageSelected: _onImageSelected),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 3 / 4,
                        // child: ElevatedButton.icon(
                        //     style: ElevatedButton.styleFrom(
                        //         shape: RoundedRectangleBorder(
                        //             side: BorderSide.none,
                        //             borderRadius: BorderRadius.circular(15)),
                        //         minimumSize: Size.fromHeight(50)),
                        //     onPressed: () async {
                        //       if (_formKey.currentState!.validate()) {
                        //         _formKey.currentState?.save();
                        //         if (currentUser == null) {
                        //           print('Error: currentUser is null');
                        //           ScaffoldMessenger.of(context).showSnackBar(
                        //             SnackBar(
                        //               content:
                        //                   Text('Error: No user signed in.'),
                        //               backgroundColor: Colors.red,
                        //             ),
                        //           );
                        //           return;
                        //         }
                        //         await _uploadFile();
                        //         final companyInfo = Company(
                        //             companyId: _companyId,
                        //             name: companyName,
                        //             address: _streetAddress,
                        //             city: _city,
                        //             state: _state,
                        //             country: _country,
                        //             phone: phoneNumber,
                        //             email: email,
                        //             website: companyWebsite,
                        //             description: comapnyDesription,
                        //             industry: _IndustryTypeselected,
                        //             companySize: companySzeSelected,
                        //             logoUrl: companyLogo as String);
                        //         print('company info is ${companyInfo}');
                        //         try {
                        //           await saveEmployerInfo(companyInfo);

                        //           // EmpUtils.showSnackBar(
                        //           //     'sucessfully saved', Colors.green);
                        //           ScaffoldMessenger.of(context).showSnackBar(
                        //             const SnackBar(
                        //               content: Text('Successfully saved'),
                        //               backgroundColor: Colors.green,
                        //             ),
                        //           );
                        //           Navigator.pushNamed(
                        //               context, TabsScreen.routeName,
                        //               arguments: companyInfo);
                        //         } catch (e) {
                        //           print('Error during saving: $e');
                        //           ScaffoldMessenger.of(context).showSnackBar(
                        //             const SnackBar(
                        //               content: Text(
                        //                   'Error saving information. Please try again.'),
                        //               backgroundColor: Colors.red,
                        //             ),
                        //           );
                        //         }
                        //       }
                        //     },
                        //     icon: const Icon(Icons.arrow_forward),
                        //     label: const Text('Save ')),

                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide.none,
                                  borderRadius: BorderRadius.circular(15)),
                              minimumSize: Size.fromHeight(50)),
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
                              await _uploadFile();
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
                                  industry: _IndustryTypeselected,
                                  companySize: companySzeSelected,
                                  logoUrl: companyLogo as String);
                              try {
                                await saveEmployerInfo(companyInfo);
                                print('Successfully saved company info.');

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Successfully saved'),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                Navigator.pushNamed(
                                    context, TabsScreen.routeName,
                                    arguments: companyInfo);
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
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
