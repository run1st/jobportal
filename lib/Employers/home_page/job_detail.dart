import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1/user_account/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobDetail extends StatefulWidget {
  final int index;
  final DocumentSnapshot<Object?> job;

  JobDetail({Key? key, required this.index, required this.job})
      : super(key: key);

  @override
  State<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  bool favorite = false;
  bool isJobApplied = false;
  String? currentUser;

  @override
  void initState() {
    super.initState();
    getUserUid();
  }

  Future<void> getUserUid() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        currentUser = user.uid;
        await _loadFavState(widget.job);
        await _loadApplicationState(widget.job);
      }
    } catch (e) {
      print('Error getting current user UID: $e');
    }
  }

  Future<void> _loadFavState(DocumentSnapshot<Object?> job) async {
    final state =
        await StatePersistence.getFavState("favorite_${job['job id']}");
    setState(() {
      favorite = state ?? false;
    });
  }

  Future<void> _loadApplicationState(DocumentSnapshot<Object?> job) async {
    final state = await StatePersistence.getApplicationState(
        "application_${job['job id']}");
    setState(() {
      isJobApplied = state ?? false;
    });
  }

  Future<void> _saveFavState(DocumentSnapshot<Object?> job, bool value) async {
    await StatePersistence.favState("favorite_${job['job id']}", value);
  }

  Future<void> _saveApplicationState(
      DocumentSnapshot<Object?> job, bool value) async {
    await StatePersistence.saveApplicationState(
        "application_${job['job id']}", value);
  }

  void favoriteClicked(DocumentSnapshot<Object?> job) async {
    setState(() {
      favorite = !favorite;
    });
    if (favorite) {
      await addToFavorites(job);
    } else {
      await removeFromFavorites(job);
    }
    await _saveFavState(job, favorite);
  }

  Future<void> addToFavorites(DocumentSnapshot<Object?> doc) async {
    final DocumentReference favoritesCollection = FirebaseFirestore.instance
        .collection('job-seeker')
        .doc(currentUser)
        .collection('favorite-jobs')
        .doc(doc['job id']);
    await favoritesCollection.set(doc.data());
  }

  Future<void> removeFromFavorites(DocumentSnapshot<Object?> doc) async {
    final DocumentReference favoritesCollection = FirebaseFirestore.instance
        .collection('job-seeker')
        .doc(currentUser)
        .collection('favorite-jobs')
        .doc(doc['job id']);
    await favoritesCollection.delete();
  }

  void _handleApplyButtonTap(DocumentSnapshot<Object?> doc) async {
    if (currentUser != null) {
      if (!isJobApplied) {
        await saveApplication(doc);
      } else {
        showAlertDialog('Oops!', 'You already applied.');
      }
    } else {
      showAlertDialog('Notice', 'Please log in to apply.');
    }
  }

  Future<void> saveApplication(DocumentSnapshot<Object?> doc) async {
    final DocumentReference applicationDocumentReference = FirebaseFirestore
        .instance
        .collection('job-seeker')
        .doc(currentUser)
        .collection('jobs-applied')
        .doc(doc['job id']);
    try {
      await applicationDocumentReference.set(doc.data());
      await _saveApplicationState(widget.job, true);
      setState(() {
        isJobApplied = true;
      });
      await getData(doc);
      showAlertDialog('Application Submitted',
          'Your application has been submitted successfully.');
    } catch (e) {
      Utils.showSnackBar(context, e.toString(), Colors.red);
    }
  }

  String randomText =
      '   Porttitor eget dolor morbi non arcu risus. Eget arcu dictum varius duis at consectetur lorem. Velit sed ullamcorper morbi tincidunt ornare massa. At volutpat diam ut venenatis tellus. Tortor at auctor urna nunc id cursus metus aliquam eleifend. Amet commodo nulla facilisi nullam vehicula ipsum a. Vitae nunc sed velit dignissim sodales ut eu. Facilisis leo vel fringilla est ullamcorper. Faucibus scelerisque eleifend donec pretium vulputate sapien nec sagittis. Tempus egestas sed sed risus pretium quam vulputate dignissim suspendisse. Arcu non odio euismod lacinia at quis risus. Ante metus dictum at tempor commodo ullamcorper a lacus vestibulum. Ut placerat orci nulla pellentesque dignissim. Sed nisi lacus sed viverra tellus in. Posuere morbi leo urna molestie at elementum eu. Nibh sit amet commodo nulla facilisi nullam vehicula ipsum a. Non nisi est sit amet facilisis magna etiam tempor orci. Posuere sollicitudin aliquam ultrices sagittis orci a scelerisque purus semper. Mauris in aliquam sem fringilla ut morbi. Vitae nunc sed velit dignissim sodales ut eu. Dignissim diam quis enim lobortis scelerisque fermentum dui faucibus. Urna molestie at elementum eu facilisis sed odio morbi quis. Odio ut sem nulla pharetra diam. Nam libero justo laoreet sit amet. Mauris in aliquam sem fringilla ut morbi. Massa tincidunt nunc pulvinar sapien et. A lacus vestibulum sed arcu non odio euismod lacinia. Maecenas volutpat blandit aliquam etiam. Nunc sed id semper risus. Vel pharetra vel turpis nunc eget lorem dolor. Tellus rutrum tellus pellentesque eu tincidunt. Cum sociis natoque penatibus et. Sapien nec sagittis aliquam malesuada bibendum. Nulla posuere sollicitudin aliquam ultrices sagittis orci a. Massa vitae tortor condimentum lacinia quis. Odio tempor orci dapibus ultrices in iaculis nunc. Eu augue ut lectus arcu bibendum. Eu consequat ac felis donec et odio. Auctor neque vitae tempus quam pellentesque nec nam. Venenatis lectus magna fringilla urna porttitor rhoncus dolor purus. Lorem ipsum dolor sit amet consectetur adipiscing. Justo eget magna fermentum iaculis eu non diam phasellus vestibulum. Egestas integer eget aliquet nibh. Est ullamcorper eget nulla facilisi etiam dignissim. Feugiat in ante metus dictum.';

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown date';
    DateTime dateTime = timestamp.toDate();
    return '${DateFormat.yMMMd().format(dateTime)} at ${DateFormat.jm().format(dateTime)}';
  }

  Future<void> getData(DocumentSnapshot<Object?> doc) async {
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('job-seeker')
            .doc(currentUser)
            .collection('jobseeker-profile')
            .doc('profile')
            .get();
    final DocumentReference applicantCollectionReference = FirebaseFirestore
        .instance
        .collection('employers-job-postings')
        .doc('post-id')
        .collection('job posting')
        .doc(doc['job id'])
        .collection("Applicants")
        .doc(currentUser);
    await applicantCollectionReference.set(documentSnapshot.data());
  }

  void showAlertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.location_city),
            Text(widget.job.get('location') ?? 'Ethiopia Addis Ababa'),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('posted time'),
            Text(formatTimestamp(widget.job.get('posted time')) ??
                '7 Hours ago'),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Job type',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Salary',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(widget.job.get('employment type') ?? 'Full Time'),
            Text('${widget.job.get('salary') ?? '1000 ETB'}  ')
          ],
        ),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text('${widget.job.get('description') ?? randomText}'),
        ),
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2 - 20,
              decoration: BoxDecoration(
                color: isJobApplied ? Colors.grey : Colors.blue,
                border: !isJobApplied
                    ? Border.all(
                        color: Colors.blue,
                        width: 2,
                      )
                    : Border.all(width: 0),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextButton(
                onPressed: () {
                  _handleApplyButtonTap(widget.job);
                },
                child: !isJobApplied
                    ? Text('Apply', style: TextStyle(color: Colors.white))
                    : Text('Applied', style: TextStyle(color: Colors.white)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextButton.icon(
                icon: Icon(favorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  favoriteClicked(widget.job);
                },
                label: Text(''),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class StatePersistence {
  static Future<bool> favState(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(key, value);
  }

  static Future<bool> saveApplicationState(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(key, value);
  }

  static Future<bool?> getFavState(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<bool?> getApplicationState(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }
}
