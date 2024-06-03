import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project1/jobSeekerModel/job_seeker_profile_model.dart';

class ExperienceFormDialog extends StatefulWidget {
  final String currentUser;

  const ExperienceFormDialog({Key? key, required this.currentUser})
      : super(key: key);

  @override
  _ExperienceFormDialogState createState() => _ExperienceFormDialogState();
}

class _ExperienceFormDialogState extends State<ExperienceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  String? title;
  String? company;
  DateTime? startDate;
  DateTime? endDate;
  String? region;
  String? city;

  Future<void> _saveExperience() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ExperienceModel newExperience = ExperienceModel(
        title: title,
        company: company,
        startDate: startDate,
        endDate: endDate,
        region: region,
        city: city,
      );

      final personalInfoDocRef = FirebaseFirestore.instance
          .collection('job-seeker')
          .doc(widget.currentUser);

      // Fetch the current profile document
      DocumentSnapshot profileSnapshot = await personalInfoDocRef
          .collection('jobseeker-profile')
          .doc('profile')
          .get();

      Map<String, dynamic>? currentProfileData =
          profileSnapshot.data() as Map<String, dynamic>?;

      if (currentProfileData == null) {
        currentProfileData = {};
      }

      // Check if experiences map exists, if not create it
      if (currentProfileData['experiences'] == null) {
        currentProfileData['experiences'] = {};
      }

      // Generate a unique key for the new experience
      String newExperienceKey =
          'experience${currentProfileData['experiences'].length + 1}';

      // Add the new experience to the experiences map
      currentProfileData['experiences'][newExperienceKey] =
          newExperience.toJson();

      // Save the updated profile data back to Firestore
      await personalInfoDocRef
          .collection('jobseeker-profile')
          .doc('profile')
          .set(currentProfileData);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Experience'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: ListBody(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Job Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a job title';
                  }
                  return null;
                },
                onSaved: (value) {
                  title = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Company'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a company';
                  }
                  return null;
                },
                onSaved: (value) {
                  company = value;
                },
              ),
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Start Date (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a start date';
                  }
                  if (DateTime.tryParse(value) == null) {
                    return 'Please enter a valid date';
                  }
                  return null;
                },
                onSaved: (value) {
                  startDate = DateTime.tryParse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'End Date (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an end date';
                  }
                  if (DateTime.tryParse(value) == null) {
                    return 'Please enter a valid date';
                  }
                  return null;
                },
                onSaved: (value) {
                  endDate = DateTime.tryParse(value!);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Region'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a region';
                  }
                  return null;
                },
                onSaved: (value) {
                  region = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a city';
                  }
                  return null;
                },
                onSaved: (value) {
                  city = value;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Add'),
          onPressed: _saveExperience,
        ),
      ],
    );
  }
}
