import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project1/Employers/home_page/applyers_detail.dart';

enum SortBy { Relevance, Experience, ApplicationDate }

enum ViewMode { Grid, List }

class Appliers extends StatefulWidget {
  final String jobId;

  Appliers({
    Key? key,
    required this.jobId,
  }) : super(key: key);

  @override
  State<Appliers> createState() => _AppliersState();
}

class _AppliersState extends State<Appliers> {
  String selectedCategory = 'All';
  bool isFilterVisible = false;
  void toggleFilterVisibility() {
    setState(() {
      isFilterVisible = !isFilterVisible;
    });
  }

  List<QueryDocumentSnapshot> filteredJobs = [];
  bool dropDownSelected = false;
  var selectedValue;

  final searchController = TextEditingController();
  String searchQuery = '';
  List<String> categories = [
    'All',
    'Region',
    'City',
    'Education level',
    'salary Expectation',
    'Experience level',
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
  String institution = '';
  String fieldOfStudy = '';
  String firstName = '';
  String lastName = '';
  bool isFilterOptionSelected = false;
  void updateSelectedValue(String value, bool isSelected) {
    setState(() {
      selectedValue = value;
      isFilterOptionSelected = isSelected;
    });
  }

  void openAlertDialog(List<String> selectedItem, IconData? icon) {
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

  final List<String> educationLevel = ['Bachelor', 'MSC', 'PHD'];
  final List<String> employmentType = ['Full time', 'Partime', 'remote'];
  List companyName = [];
  final List<String> salaryExpectation = [
    '1,000 - 5,000',
    '5,000 - 10,000',
    '10,000 - 20,000',
    '20,000 - 30,000',
    '30,000 - 40,000',
    '40,000 - 50,000',
    '50,000 - 60,000',
    '60,000 - 70,000',
    '70,000 - 80,000',
    '80,000 - 90,000',
    '90,000 - 100,000',
    '100,000 - 110,000',
    '110,000 - 120,000',
    'Above 120,000',
  ];
  final List<String> ExperienceLevel = [
    'fresh',
    '1 year',
    '2 years',
    '3 years',
    '5 years',
    '10 years',
    'above 10 '
  ];
  final List<String> cities = [
    'Bahirdar',
    'Gonder',
    'Addiss Ababa',
    'Mekele',
    'Dere Dawa',
    'Hawasa',
    'Dessie',
    'jigjiga',
    'Jimma',
    'shashemene'
  ];
  SortBy _filterBy = SortBy.Relevance;
  ViewMode _viewMode = ViewMode.List;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applicants'),
        backgroundColor: Colors.blueAccent,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.filter_list),
        //     onPressed: toggleFilterVisibility,
        //   ),
        // ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('employers-job-postings')
              .doc('post-id')
              .collection('job posting')
              .doc(widget.jobId)
              .collection('Applicants')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            if (!snapshot.hasData) return Text('OOPS there is no posted jobs');
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            List<DocumentSnapshot> appliers = snapshot.data!.docs;

            if (searchQuery.isNotEmpty) {
              appliers = appliers.where((doc) {
                String fieldOfStudy = (doc['education']?['fieldOfStudy'] ?? '')
                    .toString()
                    .toLowerCase();
                String gender = (doc['personal-info']?['gender'] ?? '')
                    .toString()
                    .toLowerCase();
                String location = (doc['personal-info']?['city'] ?? '')
                    .toString()
                    .toLowerCase();
                String lowercaseQuery = searchQuery.toLowerCase();
                return fieldOfStudy.contains(lowercaseQuery) ||
                    gender.contains(lowercaseQuery) ||
                    location.contains(lowercaseQuery);
              }).toList();
            }

            if (isFilterOptionSelected) {
              if (selectedCategory == 'City') {
                appliers = appliers.where((doc) {
                  String city = (doc['personal-info']?['city'] ?? '')
                      .toString()
                      .toLowerCase();
                  return city == selectedValue.toLowerCase();
                }).toList();
              } else if (selectedCategory == 'Education level') {
                appliers = appliers.where((doc) {
                  String levelOfEducation =
                      (doc['education']?['levelOfEducation'] ?? '')
                          .toString()
                          .toLowerCase();
                  return levelOfEducation == selectedValue.toLowerCase();
                }).toList();
              } else if (selectedCategory == 'salary Expectation') {
                appliers = appliers.where((doc) {
                  String salaryExpectation =
                      (doc['other-data']?['Expected salary'] ?? '')
                          .toString()
                          .toLowerCase();
                  return salaryExpectation == selectedValue.toLowerCase();
                }).toList();
              } else if (selectedCategory == 'Experience level') {
                appliers = appliers.where((doc) {
                  String experienceLevel =
                      (doc['other-data']?['Experience level'] ?? '')
                          .toString()
                          .toLowerCase();
                  return experienceLevel == selectedValue.toLowerCase();
                }).toList();
              }
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 7,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      border: Border.all(color: Colors.blueAccent, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Applicants',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.yellow,
                          ),
                          child: Center(
                            child: Text(
                              '${snapshot.data!.docs.length}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Expanded(
                        //   flex: 3,
                        //   child: TextField(
                        //     controller: searchController,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         searchQuery = value;
                        //       });
                        //     },
                        //     decoration: InputDecoration(
                        //       hintText: 'Search applicants',
                        //       prefixIcon: Icon(Icons.search),
                        //       enabledBorder: OutlineInputBorder(
                        //         borderSide: BorderSide(color: Colors.grey),
                        //         borderRadius: BorderRadius.circular(15),
                        //       ),
                        //       focusedBorder: OutlineInputBorder(
                        //         borderSide:
                        //             BorderSide(color: Colors.blueAccent),
                        //         borderRadius: BorderRadius.circular(15),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blueAccent,
                          ),
                          width: MediaQuery.of(context).size.width - 50,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              borderRadius: BorderRadius.circular(5),
                              style: const TextStyle(color: Colors.black),
                              dropdownColor: Colors.blueAccent,
                              hint: const Text(
                                'Filter Applicants',
                                style: TextStyle(color: Colors.white),
                              ),
                              elevation: 16,
                              icon: const Icon(
                                Icons.filter_list,
                                color: Colors.white,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedCategory = newValue!;
                                  dropDownSelected = true;
                                });
                                switch (selectedCategory) {
                                  case 'All':
                                    return;
                                  case 'Region':
                                    openAlertDialog(Regions, Icons.public);
                                    break;
                                  case 'City':
                                    openAlertDialog(
                                        cities, Icons.location_city);
                                    break;
                                  case 'Education level':
                                    openAlertDialog(
                                        educationLevel, Icons.school);
                                    break;
                                  case 'salary Expectation':
                                    openAlertDialog(
                                        salaryExpectation, Icons.work);
                                    break;
                                  case 'Experience level':
                                    openAlertDialog(
                                        ExperienceLevel, Icons.business);
                                    break;
                                }
                              },
                              items: categories.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    itemCount: appliers.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document = appliers[index];
                      // String institution =
                      //     (document['education']?['institution'] ?? '');
                      // String fieldOfStudy =
                      //     (document['education']?['fieldOfStudy'] ?? '');

                      Map<String, dynamic>? data =
                          document.data() as Map<String, dynamic>?;
                      try {
                        if (data != null && data['education'] != null) {
                          institution =
                              data['education']['institution'] as String;
                          fieldOfStudy =
                              data['education']['fieldOfStudy'] as String;
                        } else {
                          institution = ''; // Or a different default value
                          print(
                              'Institution information not found in document ${document.reference.id}'); // Log a message
                        }
                        if (data != null && data['personal-info'] != null) {
                          firstName =
                              data['personal-info']['first name'] as String;
                          lastName =
                              data['personal-info']['last name'] as String;
                        } else {
                          // institution = ''; // Or a different default value
                          print(
                              'Institution information not found in document ${document.reference.id}'); // Log a message
                        }
                      } catch (error) {
                        // Handle potential errors during data access (e.g., unexpected data format)
                        print('Error accessing document data: $error');
                        institution =
                            'Error retrieving institution'; // Or a different error message
                      }
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            firstName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(fieldOfStudy),
                          trailing: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                ApplicantPage.routeName,
                                arguments: [
                                  (document['personal-info']?['id'] ?? ''),
                                  widget.jobId,
                                ],
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              width: 100,
                              height: 40,
                              child: const Center(
                                child: Text(
                                  'View Profile',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class OverlayScreen extends StatelessWidget {
  final IconData? icon;
  final Function(String, bool) callback;
  final List<String> items;

  OverlayScreen({
    required this.icon,
    required this.callback,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Icon(icon, size: 40, color: Colors.blueAccent),
      content: SizedBox(
        width: double.minPositive,
        height: 200,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),
              onTap: () {
                callback(items[index], true);
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
    );
  }
}
