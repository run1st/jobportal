import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project1/user_account/utils.dart';
import 'package:project1/user_account/verify_email.dart';

class JobSeekerSignUPForm extends StatefulWidget {
  static const routeName = 'JobSeekerSignUPForm';
  const JobSeekerSignUPForm({super.key});

  @override
  State<JobSeekerSignUPForm> createState() => _JobSeekerSignUPFormState();
}

class _JobSeekerSignUPFormState extends State<JobSeekerSignUPForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController1 = TextEditingController();
  final passwordController2 = TextEditingController();
  bool _isSigningUp = false;
  // Future signUp() async {
  //   final isValid = formKey.currentState!.validate();
  //   if (!isValid) return;
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context) => Center(
  //             child: CircularProgressIndicator(),
  //           ));
  //   try {
  //     await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(
  //             email: emailController.text.trim(),
  //             password: passwordController1.text.trim())
  //         .then((result) {
  //       FirebaseFirestore.instance
  //           .collection('job-seeker')
  //           .doc(result.user!.uid)
  //           .set({
  //         'email': emailController.text,
  //         'role': 'jobseeker', // or 'jobseeker'
  //       });
  //     });
  //     Navigator.of(context).pop();
  //     // const VerifyEmail();
  //     Navigator.pushNamed(context, VerifyEmail.routeName);
  //   } on FirebaseAuthException catch (e) {
  //     print(e);
  //     Utils.showSnackBar(e.message, Colors.red);
  //   }
  //   // Navigator.of(context).pop();
  // }
  Future<void> signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    setState(() {
      _isSigningUp = true; // Set flag to true when signing up
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController1.text.trim(),
      );

      // Create user document in Firestore
      await FirebaseFirestore.instance
          .collection('job-seeker')
          .doc(userCredential.user!.uid)
          .set({
        'email': emailController.text,
        'role': 'jobseeker', // Set user role
      });
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException
      print('FirebaseAuthException: ${e.code}');
      // Show error message using SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'An error occurred.'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      // Handle other errors
      print('Error: $e');
      // Show generic error message using SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSigningUp = false; // Reset flag after sign-up completes
      });
      // Navigate to VerifyEmail screen
      Navigator.pushNamed(context, VerifyEmail.routeName);
    }
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
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: passwordController1,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 252, 234, 240),
                  label: Text('password'),
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
                validator: (value) => value != null && value.length < 6
                    ? 'Enter at least 6 characters'
                    : null,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                  controller: passwordController2,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 252, 234, 240),
                    label: Text('Verify password'),
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
                  validator: (value) {
                    value != null && value.length < 6
                        ? 'Enter at least 6 characters'
                        : null;
                    if (passwordController2.text != passwordController1.text) {
                      return 'Password is not match';
                    }
                  }),
              SizedBox(
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
                    //signUp();
                    _isSigningUp ? null : signUp();
                  }
                },
                icon: Icon(
                  Icons.person_add,
                  size: 30.0,
                ),
                label: _isSigningUp
                    ? CircularProgressIndicator(
                        color: Colors.amber,
                      ) // Show progress indicator
                    : Text('Sign Up'),
                // const SizedBox(
                //   height: 24,
              ),
            ],
          ),
        ));
  }
}
