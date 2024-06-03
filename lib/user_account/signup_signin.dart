import 'package:flutter/material.dart';
import 'package:project1/user_account/auth_page.dart';
import 'package:project1/user_account/emp_sign_up_form.dart';
import 'package:project1/user_account/rgister.dart';
import 'package:project1/user_account/seeker_sign_up_form.dart';

class Sign_up_in extends StatefulWidget {
  final VoidCallback onclickedSignUp;
  const Sign_up_in({Key? key, required this.onclickedSignUp}) : super(key: key);

  @override
  State<Sign_up_in> createState() => _Sign_up_inState();
}

class _Sign_up_inState extends State<Sign_up_in> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                button1 == true ? JobSeekerSignUPForm() : EmpSignUpForm(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Alrady have an account'),
                    TextButton(
                        onPressed: () {
                          // widget.onclickedSignUp();
                          Navigator.pushNamed(context, AuthPage.routName,
                              arguments: AuthPage(isLogin: true));
                        },
                        child: const Text('Sing In')),
                  ],
                ),
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('back'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
