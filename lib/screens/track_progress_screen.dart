import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class TrackProgress extends StatefulWidget {
  const TrackProgress({Key? key}) : super(key: key);

  @override
  State<TrackProgress> createState() => _TrackProgressState();
}

class _TrackProgressState extends State<TrackProgress> {
  StreamSubscription<StepCount>? _stepCountStream;
  int steps = 0;
  double caloriesBurned = 0.0;
  Duration timeSpent = Duration();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPermissionsAndInitPedometer();
    // _initPedometer();
  }

  @override
  void dispose() {
    _stepCountStream?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 30, top: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hi, User',
              style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Colors.brown),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your Activity for today',
              style: TextStyle(fontWeight: FontWeight.w300,
                  fontSize: 25,
                  color: Colors.brown),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 280,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.directions_walk_rounded, size: 25),
                            SizedBox(width: 5),
                            Text(
                              'Steps Walked',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(height: 60),
                        Text(
                         '$steps', // Initially displaying zero steps
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight
                              .bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 18),
                                child: Row(
                                  children: [
                                    Icon(Icons.local_fire_department_outlined),
                                    SizedBox(width: 5,),
                                    Text('Calories Burned', style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),)
                                  ],
                                ),
                              ),
                              SizedBox(height: 20,),
                              Text('${caloriesBurned}', style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Container(
                        height: 120,
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 26),
                                child: Row(
                                  children: [
                                    Icon(Icons.timer),
                                    SizedBox(width: 10,),
                                    Text('Time Spent', style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),)
                                  ],
                                ),
                              ),
                              SizedBox(height: 20,),
                              Text('0', style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                      ),
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

  void _checkPermissionsAndInitPedometer() async {
    if (await Permission.activityRecognition.isGranted &&
        await Permission.sensors.isGranted) {
      // Reset the step count to zero here
      setState(() {
        steps = 0;
        _initPedometer();
      });
    } else {
      Map<Permission, PermissionStatus> status = await [
        Permission.activityRecognition,
        Permission.sensors,
      ].request();

      if (status[Permission.activityRecognition] == PermissionStatus.granted &&
          status[Permission.sensors] == PermissionStatus.granted) {
        // Reset the step count to zero here
        setState(() {
          steps = 0;
          _initPedometer();
        });
      } else {
        // Handle case when permissions are not granted
        print('Permissions not granted.');
      }
    }
  }



  void _initPedometer() {
    _stepCountStream = Pedometer.stepCountStream.listen((event) {
      setState(() {
        steps = event.steps;
        _updateCaloriesBurned();
      });
    });
  }
  void _updateCaloriesBurned() {
    const caloriesPerStep = 0.04;
    caloriesBurned = steps * caloriesPerStep;
  }
}


