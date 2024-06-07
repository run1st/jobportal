import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project1/Employers/Employers_account/empUtils.dart';
import 'package:project1/Employers/Employers_account/emp_forgote_account.dart';
import 'package:project1/Employers/Employers_account/emp_verify.dart';
import 'package:project1/Employers/home_page/emp_home_page.dart';
import 'package:project1/Employers/home_page/tabs_screen.dart';

class EmpLoginForm extends StatefulWidget {
  const EmpLoginForm({super.key});

  @override
  State<EmpLoginForm> createState() => _EmpLoginFormState();
}

class _EmpLoginFormState extends State<EmpLoginForm> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController1 = TextEditingController();
  final passwordController2 = TextEditingController();
  void initState() {
    super.initState();
  }

  bool isEmployer = false;
  Future<void> checkUserRole(String uid) async {
    // User? user = FirebaseAuth.instance.currentUser;
    // if (user == null) {
    //   return;
    // }
    DocumentSnapshot userData =
        await FirebaseFirestore.instance.collection('employer').doc(uid).get();
    if (userData.exists) {
      String role = userData.get('role');
      setState(() {
        isEmployer = role == 'employer';
      });
    }

    //return isJobSeeker;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController1.dispose();
    super.dispose();
  }

  bool _showProgressIndicator = false;
  bool _isObscured = true;
  Future<void> signIn() async {
    setState(() {
      _showProgressIndicator = true; // Show progress indicator
    });

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController1.text.trim());

      // Check if sign-in was successful
      if (userCredential.user != null) {
        // Authentication successful, check user role
        await checkUserRole(userCredential.user!.uid);
        if (isEmployer) {
          Navigator.of(context)
              .pushNamed(TabsScreen.routeName); //Navigate to Employer main page
        } else {
          FirebaseAuth.instance.signOut();
          //   EmpUtils.showSnackBar('Employer not found', Colors.red);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Center(
            child: Text('Employer not found'),
          )));
          print('Employer not found');
        }
      } else {
        // Authentication failed (user is null)
        EmpUtils.showSnackBar('Sign-in failed', Colors.red);
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException errors
      EmpUtils.showSnackBar('Sign-in failed: ${e.message}', Colors.red);
      print('FirebaseAuthException: ${e.message}');
    } catch (e) {
      // Handle other errors
      EmpUtils.showSnackBar('Sign-in failed: $e', Colors.red);
      print('Error: $e');
    } finally {
      setState(() {
        _showProgressIndicator = false;
      });
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
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordController1,
              keyboardType: TextInputType.visiblePassword,
              obscureText: _isObscured,
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
                suffixIcon: IconButton(
                  icon: Icon(
                      _isObscured ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
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
              icon: Icon(Icons.login_sharp),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                minimumSize: Size.fromHeight(70),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState?.save();
                  //  signUp();
                  signIn();
                }
              },
              label: _showProgressIndicator
                  ? CircularProgressIndicator(
                      color: Colors.amber,
                    ) // Show progress indicator
                  : Text('Sign In'),
            ),
            const SizedBox(
              height: 24,
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
                child: Text(
                  'forgote password',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Color.fromARGB(255, 255, 7, 172)),
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ForgotePassword()))),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
