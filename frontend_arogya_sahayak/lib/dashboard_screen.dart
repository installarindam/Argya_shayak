import 'package:ArogyaSahayak/parkinson.dart';
import 'package:ArogyaSahayak/periodtracker.dart';
import 'package:ArogyaSahayak/steptracker.dart';
import 'package:ArogyaSahayak/thalasemia.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'bmicalculator.dart';
import 'breastcancer.dart';
import 'diabaties.dart';
import 'heart.dart';
import 'innerdashboard.dart';
import 'liver.dart';
import 'medreminder.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import 'custom_bottom_navigation_bar.dart';
import 'drawer.dart';
import 'skin.dart'; // Make sure you import the respective disease pages here
// Import other disease pages as well

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<String> imgList = [
    'assets/images/slider4.jpg',
    'assets/images/slaider2.jpg',
    'assets/images/slider3.jpg',
  ];

  final List<String> diseases = [
    'SKIN',
    'THALASSEMIA',
    'HEART',
    'DIABETES',
    'BREAST CANCER',
    'LIVER DISEASE',
    'PARKINSON',
  ];

  final List<String> diseaseImages = [
    'assets/images/skin.jpg',
    'assets/images/thala.jpg',
    'assets/images/heart.jpg',
    'assets/images/dia.jpg',
    'assets/images/breastcancer.jpg',
    'assets/images/liver.jpg',
    'assets/images/parkinson.jpg',
  ];

  final List<Widget> diseasePages = [
    SkinPage(),
    ThalasemiaPredictionScreen(),
    HeartDiseasePredictionScreen(),
    DiabetesPredictionScreen(),
    BreastCancerPredictionScreen(),
    LiverDiseasePredictionScreen(),
    ParkinsonsDiseasePredictionScreen()
  ];
  final List<Widget> menupage = [
    FootCounter(),
    BMICalculator(),
    MedReminderPage(),
    PeriodTrackerPage(),
    // Disease4Page(),
  ];

  final List<String> menuButtons = [
    'Steps Tracker',
    'BMI Calculator',
    'Med Reminder',
    'Period Tracker',
    'About',
  ];

  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Arogya Sahayak',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Alaktra',
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: [
          SizedBox(height: 5),
          CarouselSlider.builder(
            itemCount: imgList.length,
            itemBuilder: (context, index, realIdx) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Image.asset(imgList[index], fit: BoxFit.cover),
                ),
              );
            },
            options: CarouselOptions(
              height: 250.0,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 2.0,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 0.9,
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: menuButtons.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => menupage[index]),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        menuButtons[index],
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
              ),
              itemCount: diseases.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => diseasePages[index]),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(diseaseImages[index], fit: BoxFit.cover),
                        ),
                        Center(
                          child: Text(
                            diseases[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 2.0,
                                  color: Colors.black,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomAppBar(
        onTabSelected: _onTabTapped,
        selectedIndex: _currentIndex,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[50],  // Adjusts the color of the button
        child: Icon(Icons.favorite, color: Colors.red, size: 30,),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => InnerDashboard()));
        },
      ),
      drawer: CustomDrawer(),
    );
  }
}
