import 'package:flutter/material.dart';
import 'package:project1/profile/education.dart';
import 'package:project1/profile/experience.dart';
import 'package:project1/profile/personal_info.dart';
import 'package:project1/profile/skills.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimeLine extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final String section;

  const MyTimeLine({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        child: TimelineTile(
          beforeLineStyle: LineStyle(
              color: isPast ? Colors.blue : Colors.deepPurple.shade100),
          indicatorStyle: IndicatorStyle(
              color: isPast ? Colors.blue : Colors.deepPurple.shade100,
              iconStyle: IconStyle(iconData: Icons.done, color: Colors.white)),
          endChild: GestureDetector(
            onTap: () {
              if (section == 'Personal') {
                if (isPast) {
                  // Scaffold.of(context).showBottomSheet((context) => Container(
                  //       color: Colors.blue,
                  //       height: 50,

                  //       //   borderRadius: BorderRadius.circular(10)),
                  //       child: Center(
                  //           child: Text(
                  //         'SECTION COMPLETED! ',
                  //         style: TextStyle(color: Colors.white),
                  //       )),
                  //     ));
                } else {
                  Navigator.pushNamed(context, personal_info.routeName);
                }
              } else if (section == 'Education') {
                if (isPast) {
                } else {
                  Navigator.pushNamed(context, EducationForm.routeName);
                }
              } else if (section == 'Experience') {
                if (isPast) {
                } else {
                  Navigator.pushNamed(context, Experience.routeName);
                }
              } else if (section == 'Skills') {
                if (isPast) {
                } else {
                  Navigator.pushNamed(context, SkillSet.routeName);
                }
              }
            },
            child: Container(
              padding: EdgeInsets.all(25),
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color:
                      isPast ? Colors.blue : Colors.deepOrangeAccent.shade100,
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                section,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ));
  }
}
