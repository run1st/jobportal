import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project1/Employers/Employers_account/emp_forgote_account.dart';
import 'package:project1/main.dart';
import 'package:project1/user_account/auth_page.dart';
import 'package:project1/user_account/emp_login_form.dart';
import 'package:project1/user_account/emp_sign_up_form.dart';
import 'package:project1/user_account/job_seeker_login_form.dart';
import 'package:project1/user_account/rgister.dart';
import 'package:project1/user_account/seeker_sign_up_form.dart';

class LoginPage extends StatefulWidget {
  static const routeName = 'LoginPage';
  final VoidCallback onclickedSignIn;

  const LoginPage({super.key, required this.onclickedSignIn});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool button1 = true;
  bool button2 = false;

  void button1Clicked() {
    setState(() {
      button1 = true;
      button2 = false;
    });
  }

  void button2Clicked() {
    setState(() {
      button1 = false;
      button2 = true;
    });
  }

  Future<bool> _onWillPop() async {
    //await SystemNavigator.pop();
    Navigator.pushNamed(context, MyHomePage.routeName);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                Text(
                  'Hulu',
                  style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'Montserrat',
                      fontSize: 34,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () => button1Clicked(),
                        child: Text(
                          'Job Seeker',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: button2 ? Colors.black : Colors.blue,
                          ),
                        )),
                    TextButton(
                        onPressed: () => button2Clicked(),
                        child: Text(
                          'Company',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: button2 ? Colors.blue : Colors.black,
                          ),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Divider(
                      color: button2 ? Colors.black : Colors.blue,
                      thickness: 3,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 50,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: 1,
                      color: button2 ? Colors.black : Colors.blue,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 50,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      height: 1,
                      color: button2 ? Colors.blue : Colors.black,
                    ),
                  ],
                ),
                button1 == true ? JobSeekerLoginForm() : EmpLoginForm(),
                // RichText(
                //     text: TextSpan(
                //         style: TextStyle(color: Colors.black),
                //         text: 'No accont ?  ',
                //         children: [
                //       TextSpan(
                //           recognizer: TapGestureRecognizer()
                //          //   ..onTap = widget.onclickedSignIn,
                //            ..onTap =
                //           text: 'Sign up',
                //           style: TextStyle(
                //               color: Colors.blue,
                //               decoration: TextDecoration.underline))
                //     ])),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No Account'),
                    TextButton(
                        onPressed: (() {
                          Navigator.pushNamed(context, AuthPage.routName,
                              arguments: AuthPage(isLogin: false));
                        }),
                        child: Text('Sign Up'))
                  ],
                )
                // ElevatedButton(
                //     onPressed: () => Navigator.of(context).pop(),
                //     child: Text('back'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
