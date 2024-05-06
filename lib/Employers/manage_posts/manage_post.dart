import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/Employers/Employers_account/empUtils.dart';
import 'package:project1/Employers/manage_posts/edit_posts.dart';

import '../home_page/job_post_form.dart';
import '../models/jobs_model.dart';

class Manage_posts extends StatefulWidget {
  static const routeName = 'Manage_posts';
  @override
  _Manage_postsState createState() => _Manage_postsState();
}

class _Manage_postsState extends State<Manage_posts> {
  String? currentUser;
  Future<void> getUserUid() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        setState(() {
          currentUser = user.uid;
          jobPostingsStream = FirebaseFirestore.instance
              .collection('employer')
              .doc(currentUser)
              .collection('job posting')
              .snapshots();
        });
      }
    } catch (e) {
      print('Error getting current user UID: $e');
    }
  }

  void deleteJob(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              Row(
                children: [
                  Text('Are you sure to delete this job '),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.warning,
                        color: Colors.red,
                      ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        try {
                          FirebaseFirestore.instance
                              .collection('employers-job-postings')
                              .doc('post-id')
                              .collection('job posting')
                              .doc(id)
                              .delete();
                          FirebaseFirestore.instance
                              .collection('employer')
                              .doc(currentUser)
                              .collection('job posting')
                              .doc(id)
                              .delete();
                          Navigator.of(context).pop();
                          EmpUtils.showSnackBar(
                              'Job deleted sucessfuly', Colors.green);
                        } on FirebaseException catch (e) {
                          EmpUtils.showSnackBar(e.message, Colors.red);
                        }
                      },
                      child: Text('Delete')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel')),
                ],
              ),
            ],
          );
        });
  }

  Stream<QuerySnapshot>? jobPostingsStream;
  @override
  void initState() {
    super.initState();

    getUserUid();
    // jobPostingsStream = FirebaseFirestore.instance
    //     .collection('employer')
    //     .doc(currentUser)
    //     .collection('job posting')
    //     .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Employer Dashboard'),
        backgroundColor: Colors.blue[900],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: jobPostingsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());

            default:
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      final DocumentSnapshot jobPosting =
                          snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        child: Card(
                          //  color: Color.fromARGB(255, 252, 234, 240),
                          color: const Color.fromARGB(255, 247, 244, 244),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: SizedBox(
                            height: 100,
                            child: ListTile(
                              dense: false,
                              leading: CircleAvatar(
                                foregroundImage: NetworkImage(jobPosting[
                                        'company']['logoUrl'] ??
                                    'https://www.bing.com/images/search?view=detailV2&ccid=q182Q4Zy&id=D8C88B9D55DB76A095EADD6BDE4D4DF28EFD9B65&thid=OIP.q182Q4ZyCS-WUHuYGfac4QHaDt&mediaurl=https%3a%2f%2fhitechengineeringindia.com%2fimg%2fheader-img%2fprofile.jpg&cdnurl=https%3a%2f%2fth.bing.com%2fth%2fid%2fR.ab5f36438672092f96507b9819f69ce1%3frik%3dZZv9jvJNTd5r3Q%26pid%3dImgRaw%26r%3d0&exph=834&expw=1666&q=image+for+company+profile+picture&simid=608015538228691274&FORM=IRPRST&ck=97AE052C55DA4BCF742295A439E9F6CE&selectedIndex=22'),

                                // :child: Icon(Icons.person),
                              ),
                              title: Text(
                                jobPosting['title'],
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              subtitle: Column(
                                children: [
                                  Chip(label: Text(jobPosting['job category'])),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(jobPosting['employment type']),
                                ],
                              ),
                              trailing: Container(
                                width: MediaQuery.of(context).size.width -
                                    (MediaQuery.of(context).size.width - 98),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          EditJobPostingForm.routName,
                                          arguments: jobPosting,
                                        );
                                      },
                                      icon: Icon(Icons.edit,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        deleteJob(jobPosting.id);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    })),
              );
          }
        },
      ),
    );
  }
}
