import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/Employers/Employers_account/empUtils.dart';
import 'package:project1/Employers/home_page/messages.dart';
import 'package:project1/Employers/home_page/send_email_screen.dart';
import 'package:project1/profile/job_seeker_view_profile.dart';

enum SortBy { Relevance, Experience, ApplicationDate }

enum ViewMode { Grid, List }

// class candidateProfile extends StatefulWidget {
//   static const routeName = '/candidateProfile';

class candidateProfile extends StatelessWidget {
  static const routeName = '/candidateProfile';
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

  Future<void> deleteCandidate(String jobId, String applierId) async {
    try {
      DocumentReference candidateCollectionReference =
          FirebaseFirestore.instance
              .collection('employers-job-postings')
              .doc('post-id') // Replace 'post-id' with the actual post id
              .collection('job posting')
              .doc(jobId)
              .collection("candidates")
              .doc(applierId);

      await candidateCollectionReference.delete();
      print('Candidate deleted successfully');
    } catch (e) {
      print('Error deleting candidate: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as List;
    final applicant_id = arguments[0];
    final jobId = arguments[1];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Candidates Profile'),
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
                  height: (MediaQuery.of(context).size.height) - 350,
                  width: MediaQuery.of(context).size.width),
              child: ProfilePageView(
                id: applicant_id,
              ),
            ),
            Column(
              children: [
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('Send Email'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SendEmailScreen(
                                    jobApplierId: applicant_id)),
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.message),
                        title: const Text('Send Message'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ComposeMessageScreen(
                                    jobApplierId: applicant_id)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text('NOT INTERESTED ?'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await deleteCandidate(jobId, applicant_id);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text(
                                'Candidate Deleted Successfuly !',
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
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          child: const Text('Reject'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Expanded(
                      //   child: ElevatedButton(
                      //     onPressed: () {},
                      //     style: ElevatedButton.styleFrom(
                      //       primary: Colors.blue,
                      //     ),
                      //     child: const Text('Schedule Interview'),
                      //   ),
                      // ),
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
