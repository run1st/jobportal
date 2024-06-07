import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project1/jobSeekerModel/job_seeker_profile_model.dart';
import 'package:project1/user_account/utils.dart';

class ExperienceBottomSheet extends StatefulWidget {
  final String? currentUser;

  const ExperienceBottomSheet({Key? key, required this.currentUser})
      : super(key: key);

  @override
  _ExperienceBottomSheetState createState() => _ExperienceBottomSheetState();
}

class _ExperienceBottomSheetState extends State<ExperienceBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _regionController = TextEditingController();
  final _cityController = TextEditingController();
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

  Future<void> _saveExperience() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ExperienceModel newExperience = ExperienceModel(
        title: _titleController.text,
        company: _companyController.text,
        startDate: _startDate,
        endDate: _endDate,
        region: _regionController.text,
        city: _cityController.text,
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
      Utils.showSnackBar(
          context, "Experience information saved successfully!", Colors.green);
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
              'Add Experience Information',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Job Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your job title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _companyController,
              decoration: InputDecoration(labelText: 'Company'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your company';
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
            TextFormField(
              controller: _regionController,
              decoration: InputDecoration(labelText: 'Region'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your region';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'City'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your city';
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _saveExperience,
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
