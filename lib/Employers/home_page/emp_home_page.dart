//import 'dart:html';

import 'package:project1/Employers/manage_posts/manage_post.dart';
import 'package:project1/Employers/models/jobs_model.dart';

import '../emp_profile/emp_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import 'job_post_form.dart';

class EmpHomePage extends StatefulWidget {
  static const routeName = '/EmpHomePage';
  @override
  State<EmpHomePage> createState() => _EmpHomePageState();
}

class _EmpHomePageState extends State<EmpHomePage> {
  @override
  Widget build(BuildContext context) {
    final company_Object = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/post.jpeg', width: 350.0),
            Text(
              'Welcome Employer',
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Connect with the most qualified talent',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                    color: Colors.black54),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Access to the largest talent pool',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                    color: Colors.black54),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Post Jobs & Find Candidates',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                    color: Colors.black54),
              ),
            ),
            SizedBox(
              height: 35.0,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, JobPostingForm.routName,
                    arguments: company_Object);
              },
              child: Text('Post a new Job'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Manage_posts.routeName);
              },
              child: Text('Manage Job'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
