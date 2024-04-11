import 'package:flutter/material.dart';
import 'package:project1/user_account/emp_sign_up_form.dart';
import 'package:project1/user_account/seeker_sign_up_form.dart';

class Sign_up_in extends StatefulWidget {
  static const routeName = '/signupin';
  const Sign_up_in({super.key});

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
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2 - 20,
              decoration: BoxDecoration(
                  color: button2 ? Colors.blue : Colors.white,
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(15.0),
                      topRight: Radius.circular(15.0))),
              child: TextButton(
                  onPressed: () => button1Clicked(),
                  child: Text(
                    'Job Seeker',
                    style:
                        TextStyle(color: button2 ? Colors.white : Colors.blue),
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2 - 20,
              decoration: BoxDecoration(
                  color: button2 ? Colors.blue : Colors.white,
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(15.0),
                      topRight: Radius.circular(15.0))),
              child: TextButton(
                  onPressed: () => button2Clicked(),
                  child: Text(
                    'Company',
                    style:
                        TextStyle(color: button2 ? Colors.white : Colors.blue),
                  )),
            ),
          ],
        ),
        button1 == true ? JobSeekerSignUPForm() : EmpSignUpForm(),
      ],
    );
  }
}
