import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project1/user_account/utils.dart';
import 'package:project1/user_account/verify_email.dart';
import 'package:project1/job_seeker_home_page/jobSeekerHome.dart';

class JobSeekerLoginForm extends StatefulWidget {
  const JobSeekerLoginForm({
    super.key,
  });

  @override
  State<JobSeekerLoginForm> createState() => _JobSeekerLoginFormState();
}

class _JobSeekerLoginFormState extends State<JobSeekerLoginForm> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        await checkUserRole(user.uid);
        if (isJobSeeker) {
          Navigator.pushNamed(context, home.routeName);
        } else {
          Utils.showSnackBar('Job seeker not found', Colors.red);
          FirebaseAuth.instance.signOut();
        }
      }
    });
  }

  bool isJobSeeker = false;
  Future<void> checkUserRole(String uid) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('job-seeker')
        .doc(user.uid)
        .get();
    if (userData.exists) {
      String role = userData.get('role');
      setState(() {
        isJobSeeker = role == 'jobseeker';
      });
    }
    //return isJobSeeker;
  }

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController1 = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController1.dispose();
    super.dispose();
  }

  bool _showProgressIndicator = false;
  Future signIn() async {
    setState(() {
      _showProgressIndicator = true;
    });
    Visibility(
      visible: _showProgressIndicator,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) => Center(
    //           child: CircularProgressIndicator(),
    //         ));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController1.text.trim());
      // await checkUserRole();
      // if (isJobSeeker) {
      //   Navigator.pushNamed(context, home.routeName);
      //   //  Navigator.of(context).pop();
      //   // Utils.showSnackBar('Job seeker not found', Colors.red);
      //   // FirebaseAuth.instance.signOut();
      // } else {
      //   Utils.showSnackBar('Job seeker not found', Colors.red);
      //   FirebaseAuth.instance.signOut();
      //   //  Navigator.of(context).pop();
      // }
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message, Colors.red);
      print(e.message);
    }
    setState(() {
      _showProgressIndicator = false;
    });
    // if (mounted) {
    //   Navigator.of(context).pop();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 252, 234, 240),
                  label: Text('Email'),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 252, 234, 240)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email'
                        : null,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: passwordController1,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 252, 234, 240),
                  label: const Text('password'),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 252, 234, 240)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Enter at least 6 characters'
                    : null,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      minimumSize: Size.fromHeight(
                          MediaQuery.of(context).size.height - 670)),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState?.save();
                      signIn();
                    }
                  },
                  icon: const Icon(
                    Icons.person_add,
                    size: 30.0,
                  ),
                  label: const Text('Login')),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ));
  }
}
