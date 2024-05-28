import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1/Employers/models/jobs_model.dart';
import 'package:project1/job_seeker_home_page/favorites.dart';
import 'package:project1/job_seeker_home_page/filter.dart';
import 'package:project1/job_seeker_home_page/image_card.dart';

import '../Employers/home_page/detail_page.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math';

class JobsList extends StatefulWidget {
  @override
  State<JobsList> createState() => _JobsListState();
}

class _JobsListState extends State<JobsList> {
  Map<String, dynamic>? otherData;
  Map<String, dynamic>? personalInfo;
  Map<String, dynamic>? skills;
  Map<String, dynamic>? education;
  DocumentSnapshot? profileData;
  DocumentSnapshot<Object?>? profileSnapshot;
  QuerySnapshot<Object?>? jobPostings;
  List<DocumentSnapshot<Object?>> filtered_Jobs = [];
  List<DocumentSnapshot<Object?>> postedJobs = [];
  List filteredJobsByCategory = [];
  bool dropDownSelected = false;
  var selectedValue;
  List recommendedJobs = [];
  bool selectRecommended = false;
  String selectedCategory = 'All';
  List<String> categories = [
    'All',
    'Region',
    'City',
    'Employment type',
    'Education level',
  ];

  bool seleceByCategory = false;
  var category;
  bool isJobTitleMatched = false;
  String searchQuery = '';
  final searchController = TextEditingController();
  // a job searching function ********************************************
  void searchJobs(String query) {
    filtered_Jobs = postedJobs.where((job) {
      String jobTitle = job['title'].toLowerCase() as String;
      final input = query.toLowerCase();
      return jobTitle.contains(input);
    }).toList();
    setState(() {
      postedJobs = filtered_Jobs;
      isJobTitleMatched = true;
    });
    // }
  }

//a dropdown filter to show the options to be filtered
  void showFilterOption(BuildContext context) {
    DropdownButton<String>(
      value: selectedCategory,
      onChanged: (newValue) {
        setState(() {
          selectedCategory = newValue!;
        });
      },
      items: categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  final List<String> jobCategory = [
    'Accounting & Finance',
    'Agriculture',
    'Administrative & Office Support',
    'Advertising & Marketing',
    'Arts & Entertainment',
    'Construction & Maintenance',
    'Customer Service',
    'Education & Training',
    'Engineering',
    'Healthcare & Medical',
    'Hospitality & Tourism',
    'Human Resources',
    'Technology',
    'Legal',
    'Manufacturing & Production',
    'Media & Communication',
    'Non-Profit & Volunteer',
    'Real Estate',
    'Retail & Sales',
    'Science & Research',
    'Transportation & Logistics',
    "Engineering",
    'Other'
  ];
  final List<String> Regions = [
    'Amhara',
    'Oromia',
    'South nations',
    'Afar',
    'Harari',
    'Benishangul gumuz',
    'Gambela',
    'Tigray',
    'Somalia',
    'Sidamo'
  ];

  final List<String> educationLevel = ['Bachelor', 'MSC', 'PHD'];
  final List<String> employmentType = [
    'Full time',
    'Partime',
    'remote',
    'Onsite'
  ];
  List companyName = [];
  final List<String> cities = [
    'Bahirdar',
    'Gonder',
    'Addis Ababa',
    'Mekele',
    'Dere Dawa',
    'Hawasa',
    'Dessie',
    'jigjiga',
    'Jimma',
    'shashemene'
  ];

  String getCurrentUserUid() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  File? image;
  void filterByCategory(String category) {
    final postedJobs = FirebaseFirestore.instance
        .collection('employers-job-postings')
        .doc('post-id')
        .collection('job posting')
        .snapshots();
    postedJobs.map((snapshot) {
      snapshot.docs.map((job) {
        if (category == job['job category']) {
          filteredJobsByCategory.add(job);
        }
      });
    });
    //.data!.docs.map((DocumentSnapshot document)
    print('this is the list of jobs filtered ${filteredJobsByCategory}');
  }

  bool isFilterVisible = false;

  // a method used to make the filtering dropdown button visible *********************
  void toggleFilterVisibility() {
    setState(() {
      isFilterVisible = !isFilterVisible;
    });
  }

  List<QueryDocumentSnapshot> filteredJobs = [];

  void updateSelectedValue(String value, bool abc) {
    setState(() {
      selectedValue = value;
    });
  }

  void openAlertDialog(List selectedItem, IconData? icon) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OverlayScreen(
          icon: icon,
          callback: updateSelectedValue,
          items: selectedItem,
        );
      },
    );
  }

  DateTime parseDate(String date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.parse(date);
  }

//12 Jun 2023
  String getPostedTime(String postedDate) {
    final now = DateTime.now();

    DateTime parsedDate = parseDate(postedDate);
    final difference = now.difference(parsedDate);
    print(parsedDate);
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  List<Color> colorsList = [
    const Color.fromRGBO(179, 229, 252, 1.0),
    const Color.fromARGB(206, 243, 208, 231),
    const Color.fromARGB(206, 241, 214, 205),
    const Color.fromRGBO(200, 230, 201, 1.0),
    const Color.fromRGBO(255, 249, 196, 1.0),
    const Color.fromRGBO(248, 187, 208, 1.0),
    const Color.fromRGBO(225, 190, 231, 1.0)
  ];

  Color colorMaker() {
    final int colorIndex = Random().nextInt(6);
    return colorsList[colorIndex];
  }

  @override
  Widget build(BuildContext context) {
    print('selected value is :${selectedValue}');
    print('selected category value is :${selectedCategory}');
    //  image = ModalRoute.of(context)?.settings.arguments as File?;
    //  print(image?.path);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),

            //Search Bar ***********************************************************

            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Icon(
                      Icons.search,
                      color: Colors.grey[400],
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        //  searchJobs(value);
                        setState(() {
                          searchQuery = value;

                          isJobTitleMatched = true;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search by Title,category,location",
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.deepPurpleAccent,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          isJobTitleMatched = false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),

            //End of search bar *******************************************************

            const SizedBox(
              height: 20,
            ),
// The job category griedview*****************************************************
            Card(
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              //  elevation: 5.0,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  height: 120,
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: jobCategory.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            seleceByCategory = true;
                            category = jobCategory[index];
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // gradient: LinearGradient(
                            //   begin: Alignment.topLeft,
                            //   end: Alignment.bottomRight,
                            //   colors: [
                            //     Color.fromRGBO(
                            //         51, 224, 255, 1.0), // Start color
                            //     Color.fromRGBO(55, 0, 255, 1.0), // End color
                            //   ],
                            // ),
                            color: colorMaker(),
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              // BoxShadow(
                              //   color: Colors.grey.withOpacity(0.5),
                              //   spreadRadius: 2,
                              //   blurRadius: 5,
                              //   offset: Offset(0, 2),
                              // ),
                            ],
                          ),
                          child: Text(
                            jobCategory[index],
                            style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1.0),
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // End of job category gridview********************************************

// A row that contains see all button, filter icon and recommended button ****************************
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            isJobTitleMatched = false;
                            seleceByCategory = false;
                            selectRecommended = false;
                          });
                        },
                        child: Text('See all')),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.filter_list),
                          onPressed: toggleFilterVisibility,
                        ),
                        Visibility(
                          visible: isFilterVisible,
                          child: DropdownButton<String>(
                            value: selectedCategory,
                            onChanged: (newValue) {
                              setState(() {
                                selectedCategory = newValue!;
                                dropDownSelected = true;
                              });
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => OverlayScreen()),
                              // );

                              switch ('${selectedCategory}') {
                                case 'All':
                                  return null;
                                case 'Region':
                                  return openAlertDialog(Regions, Icons.public);
                                case 'City':
                                  return openAlertDialog(
                                      cities, Icons.location_city);
                                case 'Education level':
                                  return openAlertDialog(
                                      educationLevel, Icons.school);
                                case 'Employment type':
                                  return openAlertDialog(
                                      employmentType, Icons.work);
                                // case 'Company name':
                                //   return openAlertDialog(
                                //       companyName, Icons.business);

                                default:
                                  return null;
                              }
                            },
                            items: categories
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(
                        onPressed: () {
                          // final profile = FirebaseFirestore.instance
                          //     .collection('job-seeker')
                          //     .doc(getCurrentUserUid())
                          //     .collection('jobseeker-profile')
                          //     .doc('profile')
                          //     .snapshots();
                          setState(() {
                            selectRecommended = true;
                            postedJobs = [];
                          });
                        },
                        child: Text('Recommended')),
                  ),
                ],
              ),
            ),

            //End of filtering row ***************************************

            StreamBuilder<List<dynamic>>(
              stream: CombineLatestStream.list([
                FirebaseFirestore.instance
                    .collection('job-seeker')
                    .doc(getCurrentUserUid())
                    .collection('jobseeker-profile')
                    .doc('profile')
                    .snapshots(),
                FirebaseFirestore.instance
                    .collection('employers-job-postings')
                    .doc('post-id')
                    .collection('job posting')
                    .snapshots(),
              ]),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Text('Loading...');
                } else if (snapshot.data?[0] == null &&
                    snapshot.data?[1] == null) {
                  return Center(child: const Text('No data available'));
                } else if (snapshot.data?[1] == null) {
                  return Center(child: const Text('No job postings available'));
                } else if (snapshot.data?[0] != null) {
                  // return const Text('No job postings available');
                  profileSnapshot =
                      snapshot.data?[0] as DocumentSnapshot<Object?>?;
                }
                if (profileSnapshot != null) {
                  profileData = snapshot.data?[0];
                  personalInfo = snapshot.data?[0]?.data()?['personal-info']
                      as Map<String, dynamic>?;
                  // print('personal info is ${personalInfo}');
                  skills = snapshot.data?[0]?.data()?['skills']
                      as Map<String, dynamic>?;
                  education = snapshot.data?[0]?.data()?['education']
                      as Map<String, dynamic>?;
                  otherData = snapshot.data?[0].data()?['other-data']
                      as Map<String, dynamic>?;
                }

                QuerySnapshot jobPostings = snapshot.data?[1];
                if (jobPostings != null && jobPostings.docs.isNotEmpty) {
                  // Access the job postings documents
                  postedJobs = jobPostings.docs.toList();
                }
                if (jobPostings != null &&
                    jobPostings.docs.isNotEmpty &&
                    seleceByCategory == true) {
                  List<QueryDocumentSnapshot> AllpostedJobs =
                      jobPostings.docs.toList();
                  //  print(AllpostedJobs.first.data());
                  // QuerySnapshot querySnapshot = snapshot.data!;
                  postedJobs = AllpostedJobs.where((doc) {
                    // Filter the jobs by category
                    return doc['job category'] == category;
                  }).toList();
                }
                //search field operation
                if (searchQuery.isNotEmpty) {
                  // QuerySnapshot querySnapshot = snapshot.data!;

                  //  List<DocumentSnapshot> allJobs = querySnapshot.docs.toList();
                  List<QueryDocumentSnapshot> AllpostedJobs =
                      jobPostings.docs.toList();
                  postedJobs = AllpostedJobs.where((doc) {
                    String title = doc['title'].toString().toLowerCase();
                    String location = doc['location'].toString().toLowerCase();
                    String category =
                        doc['job category'].toString().toLowerCase();

                    String lowercaseQuery = searchQuery.toLowerCase();
                    return title.contains(lowercaseQuery) ||
                        location.contains(lowercaseQuery) ||
                        category.contains(lowercaseQuery);
                  }).toList();
                  // }
                }
                // List<QueryDocumentSnapshot> postedJobs = jobPostingsSnapshot.docs;
                //     List<QueryDocumentSnapshot> recommendedJobs = [];

                if (selectRecommended &&
                    snapshot.data != null &&
                    snapshot.data!.isNotEmpty) {
                  List<QueryDocumentSnapshot> AllpostedJobs =
                      jobPostings.docs.toList();
                  if (profileSnapshot != null) {
                    postedJobs = AllpostedJobs.where((doc) {
                      String jobTitle =
                          doc['title'].toString().toLowerCase().trim();
                      String location =
                          doc['location'].toString().toLowerCase().trim();
                      String educationLevel =
                          doc['education level'].toString().toLowerCase();

                      String experienceLevel =
                          doc['experience level'].toString().toLowerCase();
                      // print(
                      //     'education level required is: ${otherData?['Experience level'].toString().toLowerCase()}');
                      print('education level required is: ${experienceLevel}');
                      print('education level required is: ${jobTitle}');
                      print(
                          'education level required is: ${otherData?['preferred job'].toString().toLowerCase()}');
                      String salary = doc['salary'].toString().toLowerCase();
                      //  String category =
                      //     doc['job category'].toString().toLowerCase().trim();

                      print(
                          'boolian value is : ${jobTitle == otherData?['preferred job'].toString().toLowerCase() && experienceLevel == otherData?['Experience level'].toString().toLowerCase()}');
                      bool isMatching = (jobTitle ==
                              otherData?['preferred job']
                                  ?.toString()
                                  .toLowerCase()) &&
                          (experienceLevel ==
                              otherData?['experience level']
                                  ?.toString()
                                  .toLowerCase());

                      print('boolean value is: $isMatching');
                      String lowercaseQuery = searchQuery.toLowerCase();

                      return jobTitle ==
                                  otherData?['preferred job']
                                      .toString()
                                      .toLowerCase()
                                      .replaceAll(' ', '') &&
                              location ==
                                  personalInfo?['city']
                                      .toString()
                                      .toLowerCase()
                                      .replaceAll(' ', '') ||
                          jobTitle ==
                                  otherData?['preferred job']
                                      .toString()
                                      .toLowerCase() &&
                              educationLevel ==
                                  education?['levelOfEducation'] ||
                          jobTitle ==
                                  otherData?['preferred job']
                                      .toString()
                                      .toLowerCase() &&
                              experienceLevel ==
                                  otherData?['Experience level'] ||
                          //if all are matched
                          jobTitle == otherData?['preferred job'] &&
                              salary == otherData?['Expected salary'] ||
                          jobTitle == otherData?['preferred job'] &&
                              location == personalInfo?['city'] &&
                              educationLevel ==
                                  education?['levelOfEducation'] &&
                              experienceLevel ==
                                  otherData?['Experience level'] &&
                              salary == otherData?['Expected salary'];
                    }).toList();
                  } else {
                    postedJobs = [];
                  }
                }
                print('this is posted jobs data : ${postedJobs}');
                print(
                    'this is profile snapshot data : ${profileSnapshot?.data()}');
                if (selectedCategory == 'City') {
                  List<QueryDocumentSnapshot> AllpostedJobs =
                      jobPostings.docs.toList();
                }
                // if (dropDownSelected) {
                //  if (selectedCategory == 'All') {}
                if (selectedCategory == 'City') {
                  // QuerySnapshot querySnapshot = snapshot.data!;
                  // List<DocumentSnapshot> allJobs = querySnapshot.docs.toList();
                  List<QueryDocumentSnapshot> AllpostedJobs =
                      jobPostings.docs.toList();
                  postedJobs = AllpostedJobs.where((doc) {
                    String city = doc['location']
                        .toString()
                        .toLowerCase()
                        .replaceAll(' ', '');
                    print('city :${city}');
                    // String lowercaseQuery = selectedCategory.toLowerCase();
                    return city ==
                        selectedValue
                            .toString()
                            .toLowerCase()
                            .replaceAll(' ', '');
                  }).toList();
                }

                if (selectedCategory == 'Employment type') {
                  // QuerySnapshot querySnapshot = snapshot.data!;
                  // List<DocumentSnapshot> allJobs = querySnapshot.docs.toList();
                  List<QueryDocumentSnapshot> AllpostedJobs =
                      jobPostings.docs.toList();
                  postedJobs = AllpostedJobs.where((doc) {
                    String emplyment_type =
                        doc['employment type'].toString().toLowerCase();

                    //  String lowercaseQuery = selectedCategory.toLowerCase();
                    return emplyment_type == selectedValue.toLowerCase();
                  }).toList();
                }
                if (selectedCategory == 'Education level') {
                  // QuerySnapshot querySnapshot = snapshot.data!;
                  // List<DocumentSnapshot> allJobs = querySnapshot.docs.toList();
                  List<QueryDocumentSnapshot> AllpostedJobs =
                      jobPostings.docs.toList();
                  postedJobs = AllpostedJobs.where((doc) {
                    String education_level =
                        doc['education level'].toString().toLowerCase();

                    return education_level == selectedValue.toLowerCase();
                  }).toList();
                }

                if (selectedCategory == 'Company name') {
                  // QuerySnapshot querySnapshot = snapshot.data!;
                  // List<DocumentSnapshot> allJobs = querySnapshot.docs.toList();
                  List<QueryDocumentSnapshot> AllpostedJobs =
                      jobPostings.docs.toList();
                  postedJobs = AllpostedJobs.where((doc) {
                    String company_name =
                        doc['company']['name'].toString().toLowerCase();

                    return company_name == selectedValue.toLowerCase();
                  }).toList();
                }

                if (selectRecommended && postedJobs.isEmpty) {
                  return const SafeArea(
                    child: Center(
                      child: ImageCard(
                          imagePath: 'assets/images/empty.png',
                          imageCaption: 'Nothing Recommended'),
                    ),
                  );
                } else
                  return SafeArea(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - 400,
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          itemCount: postedJobs.length,
                          itemBuilder: (BuildContext context, int index) {
                            DocumentSnapshot document = postedJobs[index];

                            return GestureDetector(
                              onTap: () {
                                // Navigator.pushNamed(
                                //     context, JobDetailPage.routName,
                                //     arguments: document);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JobDetailPage(
                                      index: index,
                                      job: document,
                                    ),
                                    settings: const RouteSettings(
                                        name: "jobDetailRoute"),
                                  ),
                                );
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height - 585,
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      // side:
                                      //     BorderSide(color: Colors.black, width: 1),
                                      // borderRadius: BorderRadius.circular(15),
                                      borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                    topLeft: Radius.circular(20.0),
                                  )),
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 15.0),
                                    leading: document['company'] != null &&
                                            document['company']?['logoUrl']
                                                is String &&
                                            document['company']?['logoUrl']
                                                .isNotEmpty
                                        ? CircleAvatar(
                                            radius: 30,
                                            backgroundImage: NetworkImage(
                                                document['company']?['logoUrl']
                                                    as String),
                                          )
                                        : CircleAvatar(
                                            radius: 30,
                                            child: Icon(Icons.person, size: 30),
                                          ),
                                    title: Text(
                                      document['title'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        Wrap(
                                          spacing: 8.0,
                                          runSpacing: 4.0,
                                          children: [
                                            Chip(
                                              label: Text(
                                                  document['employment type']),
                                              backgroundColor:
                                                  Colors.blue.shade50,
                                            ),
                                            Chip(
                                              label: Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: 60),
                                                child: Text(
                                                  document['experience level'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              backgroundColor:
                                                  Colors.green.shade50,
                                            ),
                                            Chip(
                                              label: Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: 90),
                                                child: Text(
                                                  document['company']
                                                          ?['city'] ??
                                                      '-',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              backgroundColor:
                                                  Colors.orange.shade50,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: Container(
                                      width: 80,
                                      height: 40,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 5.0),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        getPostedTime(document['posted time']),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    tileColor: Colors.grey.shade100,
                                    style: ListTileStyle.drawer,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class converToDate {
  static const DATE_FORMAT = 'dd/MM/yyyy';
  String formattedDate(DateTime dateTime) {
    print('dateTime ($dateTime)');
    return DateFormat(DATE_FORMAT).format(dateTime);
  }
}
