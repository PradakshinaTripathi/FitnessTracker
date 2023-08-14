import 'package:flutter/material.dart';
import 'package:health_fitness_tracker/screens/setting_goal_screen.dart';
import 'package:health_fitness_tracker/screens/track_progress_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_image.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 250.0,
            left: 35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'F i T R A C K',
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.white,
                    fontFamily: 'RaleWay',
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(
                  height:70,
                ),
                SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>TrackProgress()));
                    },
                      child: Text('Track Progress'),style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.white,foregroundColor: Colors.brown),)),
                SizedBox(
                  height:20,
                ),
                SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingGoal(),));

                    }, child: Text('Set Goals'),style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.brown,foregroundColor: Colors.white),))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
