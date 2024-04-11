import 'package:flutter/material.dart';
import 'package:project1/Employers/Employers_account/emp_register.dart';
import 'package:project1/user_account/rgister.dart';
import 'user_account/auth_page.dart';
import 'Employers/Employers_account/emp_auth_page.dart';

enum UserType {
  jobSeeker,
  recruiter,
}

class loginOption extends StatefulWidget {
  static const routeName = '/loginOption';
  @override
  _loginOptionState createState() => _loginOptionState();
}

class _loginOptionState extends State<loginOption> {
  UserType _userType = UserType.jobSeeker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title:const Text('Login Page'),
      // ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            IconButton(
                alignment: Alignment.topLeft,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new_sharp)),
            const SizedBox(
              height: 50,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [],
              ),
              child: Container(
                width: MediaQuery.of(context).size.width - 100,
                height: MediaQuery.of(context).size.height - 450,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("assets/images/login2.jpg"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Select your user type:',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: UserType.jobSeeker,
                        groupValue: _userType,
                        onChanged: (value) {
                          setState(() {
                            _userType = value as UserType;
                          });
                        },
                      ),
                      const Text('Job Seeker'),
                      const SizedBox(width: 30.0),
                      Radio(
                        value: UserType.recruiter,
                        groupValue: _userType,
                        onChanged: (value) {
                          setState(() {
                            _userType = value as UserType;
                          });
                        },
                      ),
                      const Text('Recruiter'),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_userType == UserType.jobSeeker) {
                        Navigator.pushNamed(context, AuthPage.routName);
                      } else {
                        Navigator.pushNamed(context, EmpAuthPage.routName);
                      }
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
