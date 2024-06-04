import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/Employers/Employers_account/empUtils.dart';
import 'package:project1/profile/job_seeker_view_profile.dart';

enum SortBy { Relevance, Experience, ApplicationDate }

enum ViewMode { Grid, List }

// class ApplicantPage extends StatefulWidget {
//   static const routeName = '/ApplicantPage';

class ApplicantPage extends StatelessWidget {
  static const routeName = '/ApplicantPage';
  void addToShortlist(String jobId, String applicantId) {
    final candidatesReference = FirebaseFirestore.instance
        .collection('employers-job-postings')
        .doc('post-id')
        .collection('job posting')
        .doc(jobId)
        .collection('candidates');
  }

  Future saveJobPost(String job_id, String applierId) async {
    final job_document_ref = FirebaseFirestore.instance
        .collection('employers-job-postings')
        .doc('post-id')
        .collection('job posting')
        .doc(job_id)
        .collection('Applicants')
        .doc(applierId);
  }

  Future<void> ChooseCandidate(String job_id, String applierId) async {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('job-seeker')
            .doc(applierId)
            .collection('jobseeker-profile')
            .doc('profile')
            .get();
    final DocumentReference candidate_Collection_Reference =
        await FirebaseFirestore.instance
            .collection('employers-job-postings')
            .doc('post-id')
            .collection('job posting')
            .doc(job_id)
            .collection("candidates")
            .doc(applierId);
    candidate_Collection_Reference.set(documentSnapshot.data());
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as List;
    final applicant_id = arguments[0];
    final jobId = arguments[1];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Applicant Profile'),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.expand(
                  height: (MediaQuery.of(context).size.height) - 300,
                  width: MediaQuery.of(context).size.width),
              child: ProfilePageView(
                id: applicant_id,
              ),
            ),
            Column(
              children: [
                const Card(
                    // child: Column(
                    //   children: [
                    //     ListTile(
                    //       leading: const Icon(Icons.email),
                    //       title: const Text('Send Email'),
                    //       onTap: () {
                    //         showModalBottomSheet(
                    //           context: context,
                    //           builder: (BuildContext context) {
                    //             return Container(
                    //               height: 300,
                    //               // Your content for the bottom sheet
                    //               child: const Text('Email'),
                    //             );
                    //           },
                    //         );
                    //       },
                    //     ),
                    //     const Divider(),
                    //     ListTile(
                    //       leading: const Icon(Icons.message),
                    //       title: const Text('Send Message'),
                    //       onTap: () {
                    //         showModalBottomSheet(
                    //           context: context,
                    //           isScrollControlled:
                    //               true, // Allow the bottom sheet to take up full screen height
                    //           builder: (BuildContext context) {
                    //             return Container(
                    //               padding: const EdgeInsets.all(16.0),
                    //               child: Column(
                    //                 mainAxisSize: MainAxisSize.min,
                    //                 children: [
                    //                   const Text(
                    //                     'Compose Message',
                    //                     style: TextStyle(
                    //                       fontSize: 20,
                    //                       fontWeight: FontWeight.bold,
                    //                     ),
                    //                   ),
                    //                   const SizedBox(height: 16),
                    //                   const TextField(
                    //                     maxLines: null,
                    //                     keyboardType: TextInputType.multiline,
                    //                     decoration: InputDecoration(
                    //                       border: OutlineInputBorder(),
                    //                       hintText: 'Enter your message...',
                    //                     ),
                    //                   ),
                    //                   const SizedBox(height: 16),
                    //                   ElevatedButton(
                    //                     child: const Text('Send'),
                    //                     onPressed: () {
                    //                       Navigator.pop(
                    //                           context); // Close the bottom sheet
                    //                     },
                    //                   ),
                    //                 ],
                    //               ),
                    //             );
                    //           },
                    //         );
                    //       },
                    //     ),
                    //   ],
                    // ),
                    ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Wrap(
                        runAlignment: WrapAlignment.center,
                        spacing: 5,
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        children: [
                          Text(
                            'Interseted in the applicant profile ?',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w900),
                          ),
                          Text(
                            'select as candidate and further contact ',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                // Code to Shortlist the applicant
                                try {
                                  await ChooseCandidate(jobId, applicant_id);
                                  EmpUtils.showSnackBar(
                                      'saved Successfully', Colors.green);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: const Text(
                                      'Applicant Shortlistes Successfuly !',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    backgroundColor: Colors.blueAccent,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.all(10),
                                  ));
                                } catch (e) {
                                  EmpUtils.showSnackBar(
                                      e.toString(), Colors.green);
                                }
                                //   ChooseCandidate(jobId, applicant_id);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                              ),
                              child: Text('Shortlist'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
