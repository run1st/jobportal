import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1/jobSeekerModel/job_seeker_profile_model.dart';
import 'package:project1/user_account/utils.dart';

class UpdateAboutMeDialog extends StatefulWidget {
  @override
  _UpdateAboutMeDialogState createState() => _UpdateAboutMeDialogState();
}

class _UpdateAboutMeDialogState extends State<UpdateAboutMeDialog> {
  String getCurrentUserUid() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  void updateField(String aboutMe) async {
    try {
      await FirebaseFirestore.instance
          .collection('job-seeker')
          .doc(getCurrentUserUid())
          .collection('jobseeker-profile')
          .doc('profile')
          .update({'other-data.about me': '${aboutMe}'});
      print('Field updated successfully.');
    } catch (e) {
      print('Error updating field: $e');
    }
  }

  final TextEditingController aboutMeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update About Me'),
      content: TextFormField(
        controller: aboutMeController,
        maxLines: 10,
        decoration: InputDecoration(
          labelText: 'About Me',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () {
            String updatedAboutMe = aboutMeController.text;
            try {
              updateField(updatedAboutMe);
              Utils.showSnackBar(context, 'Sucessfuly Updated', Colors.green);
            } catch (e) {
              Utils.showSnackBar(context, e.toString(), Colors.red);
            }

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class UpdateSkillsDialog extends StatefulWidget {
  final String skill_Type;
  const UpdateSkillsDialog({Key? key, required this.skill_Type})
      : super(key: key);
  @override
  _UpdateSkillsDialogState createState() => _UpdateSkillsDialogState();
}

class _UpdateSkillsDialogState extends State<UpdateSkillsDialog> {
  String getCurrentUserUid() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  void updateField(String skillType, String skillAdded) async {
    try {
      await FirebaseFirestore.instance
          .collection('job-seeker')
          .doc(getCurrentUserUid())
          .collection('jobseeker-profile')
          .doc('profile')
          .update({
        'skills.${skillType}': FieldValue.arrayUnion([skillAdded])
      });
      print('Field updated successfully.');
    } catch (e) {
      print('Error updating field: $e');
    }
  }

  final TextEditingController aboutMeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add more skills'),
      content: TextFormField(
        controller: aboutMeController,
        decoration: InputDecoration(
          labelText: 'Professional Skill',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('ADD'),
          onPressed: () {
            String skillAdded = aboutMeController.text;
            try {
              updateField(widget.skill_Type, skillAdded);
              Utils.showSnackBar(context, 'Sucessfuly Updated', Colors.green);
            } catch (e) {
              Utils.showSnackBar(context, e.toString(), Colors.red);
            }

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class UpdateExperienceDialog extends StatefulWidget {
  final Map<String, dynamic>? Experience;
  UpdateExperienceDialog({
    Key? key,
    required this.Experience,
  }) : super(key: key);
  @override
  _UpdateExperienceDialogState createState() => _UpdateExperienceDialogState();
}

class _UpdateExperienceDialogState extends State<UpdateExperienceDialog> {
  String getCurrentUserUid() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  void updateField(String experienceAdded) async {
    try {
      await FirebaseFirestore.instance
          .collection('job-seeker')
          .doc(getCurrentUserUid())
          .collection('jobseeker-profile')
          .doc('profile')
          .set({
        'experiences.${DateTime.now().millisecondsSinceEpoch.toString()}':
            '${experienceAdded}'
      });
      print('Field updated successfully.');
    } catch (e) {
      print('Error updating field: $e');
    }
  }

  final TextEditingController aboutMeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add experience'),
      content: Container(
        height: MediaQuery.of(context).size.height / 3,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: aboutMeController
                  ..text = widget.Experience?['job title'],
                decoration: InputDecoration(
                  labelText: 'Job title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: aboutMeController,
                decoration: InputDecoration(
                  labelText: 'company name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: aboutMeController,
                decoration: InputDecoration(
                  labelText: 'Region',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: aboutMeController,
                decoration: InputDecoration(
                  labelText: 'city',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: aboutMeController,
                decoration: InputDecoration(
                  labelText: 'Start date',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: aboutMeController,
                decoration: InputDecoration(
                  labelText: 'End date',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Save'),
          onPressed: () {
            String updatedAboutMe = aboutMeController.text;
            try {
              updateField(updatedAboutMe);
              Utils.showSnackBar(context, 'Sucessfuly Updated', Colors.green);
            } catch (e) {
              Utils.showSnackBar(context, e.toString(), Colors.red);
            }

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class EducationBottomSheet extends StatefulWidget {
  final String? currentUser;

  const EducationBottomSheet({Key? key, required this.currentUser})
      : super(key: key);

  @override
  _EducationBottomSheetState createState() => _EducationBottomSheetState();
}

class _EducationBottomSheetState extends State<EducationBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _gpaController = TextEditingController();
  final _levelOfEducationController = TextEditingController();
  final _institutionController = TextEditingController();
  final _fieldOfStudyController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isStart ? _startDate ?? DateTime.now() : _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != (isStart ? _startDate : _endDate))
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
  }

  Future<void> saveEducationInfo(Education educationInfo) async {
    try {
      final personalInfoDoc = FirebaseFirestore.instance
          .collection('job-seeker')
          .doc(widget.currentUser);
      final json = educationInfo.toJson();
      await personalInfoDoc
          .collection('jobseeker-profile')
          .doc('profile')
          .set({'education': json}, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      print('Error saving education info: ${e.message}');
      Utils.showSnackBar(context, e.message, Colors.red);
      rethrow;
    } catch (e) {
      print('Error saving education info: $e');
      rethrow;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Education educationInfo = Education(
        GPA: _gpaController.text,
        levelOfEducation: _levelOfEducationController.text,
        institution: _institutionController.text,
        fieldOfStudy: _fieldOfStudyController.text,
        startDate: _startDate,
        endDate: _endDate,
      );

      saveEducationInfo(educationInfo).then((_) {
        Navigator.pop(context);
        Utils.showSnackBar(
            context, "Education information saved successfully!", Colors.green);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Education Information',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _gpaController,
              decoration: InputDecoration(labelText: 'GPA'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your GPA';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _levelOfEducationController,
              decoration: InputDecoration(labelText: 'Level of Education'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your level of education';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _institutionController,
              decoration: InputDecoration(labelText: 'Institution'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your institution';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _fieldOfStudyController,
              decoration: InputDecoration(labelText: 'Field of Study'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your field of study';
                }
                return null;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(context, true),
                    child: InputDecorator(
                      decoration: InputDecoration(labelText: 'Start Date'),
                      child: Text(
                        _startDate != null
                            ? DateFormat.yMMMd().format(_startDate!)
                            : 'Select start date',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(context, false),
                    child: InputDecorator(
                      decoration: InputDecoration(labelText: 'End Date'),
                      child: Text(
                        _endDate != null
                            ? DateFormat.yMMMd().format(_endDate!)
                            : 'Select end date',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
