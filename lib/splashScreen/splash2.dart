// Your existing code with improvements

import 'package:flutter/material.dart';
import 'package:project1/main.dart';

class Splash1 extends StatefulWidget {
  const Splash1({super.key});

  @override
  State<Splash1> createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> {
  int currentPage = 0;
  List<int> pageIndex = [1, 2, 3, 4, 5];
  PageController _pageController = PageController(initialPage: 0);
  Container dotIndicator(index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
          color: currentPage == index ? Colors.amber : Colors.grey,
          shape: BoxShape.circle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              width: double.infinity,
              child: PageView(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                children: [
                  _buildSplashItem('assets/images/splash3.jpg',
                      'Looking for job ? Get your dream job !'),
                  _buildSplashItem('assets/images/images.jpeg',
                      ' Emplolyer ? Find the best potentials !'),
                  _buildCenteredTextSplashItem(' Hullu Jobs'),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < 3; i++) dotIndicator(i)
                  ],
                ),
              ],
            ),
            currentPage == 2
                ? ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MyHomePage())),
                    child: const Text('Get started'),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _buildSplashItem(String imagePath, String text) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 0,
            // color: const Color.fromARGB(255, 18, 211, 224),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.fill,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 40,
          left: 40,
          child: Text(
            text,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
              color: Colors.blue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCenteredTextSplashItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        // color: const Color.fromARGB(255, 18, 211, 224),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 25,
              // fontWeight: FontWeight.bold,
              decorationColor: Colors.black.withOpacity(0.9),
            ),
          ),
        ),
      ),
    );
  }
}
