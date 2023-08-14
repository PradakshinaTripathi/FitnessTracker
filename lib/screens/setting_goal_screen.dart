import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingGoal extends StatefulWidget {
  const SettingGoal({Key? key}) : super(key: key);

  @override
  State<SettingGoal> createState() => _SettingGoalState();
}

class _SettingGoalState extends State<SettingGoal> {
  final TextEditingController _stepGoalController = TextEditingController();
  final TextEditingController _caloriesGoalController = TextEditingController();

  int stepGoal = 0;
  int caloriesGoal = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      stepGoal = pref.getInt('StepGoal') ?? 0;
      caloriesGoal = pref.getInt('stepCalorie') ?? 0;
      _stepGoalController.text = stepGoal.toString();
      _caloriesGoalController.text = caloriesGoal.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _stepGoalController,
                  keyboardType: TextInputType.number,
                  enabled: stepGoal == 0, // Disable editing if goal already set
                  decoration: InputDecoration(
                    labelText: 'Daily Step Goal',
                    labelStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
                    hintText: 'Enter your step goal',
                    prefixIcon: Icon(Icons.directions_walk, color: Colors.brown,),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _caloriesGoalController,
                  keyboardType: TextInputType.number,
                  enabled: caloriesGoal == 0, // Disable editing if goal already set
                  decoration: InputDecoration(
                    labelText: 'Daily Calories Goal',
                    labelStyle: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
                    hintText: 'Enter your calories goal',
                    prefixIcon: Icon(Icons.local_fire_department, color: Colors.brown,),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown, width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    int newStepGoal = int.tryParse(_stepGoalController.text) ?? 0;
                    int newCaloriesGoal = int.tryParse(_caloriesGoalController.text) ?? 0;

                    if (newStepGoal == 0 && newCaloriesGoal == 0) {
                      // Both fields are 0, show a message
                      showInvalidGoalSnackBar('Please set a valid goal.');
                    } else {
                      if (newStepGoal != 0 || newCaloriesGoal != 0) {
                        // Save the goals only if they are not 0
                        _saveData(newStepGoal, newCaloriesGoal);
                      }

                      // Clear the text fields and enable editing
                      setState(() {
                        _stepGoalController.text = '';
                        _caloriesGoalController.text = '';
                        stepGoal = 0;
                        caloriesGoal = 0;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.brown,
                    backgroundColor: Colors.white,
                  ),
                  child: Text(stepGoal == 0 && caloriesGoal == 0 ? 'Save Goals' : 'Save Another Goal'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveData(int newStepGoal, int newCaloriesGoal) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt('StepGoal', newStepGoal);
    await pref.setInt('stepCalorie', newCaloriesGoal);
    _loadData();
    showGoalSavedSnackBar('Bravo! Goal Set. Time to begin your journey.');
  }

  showGoalSavedSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  showInvalidGoalSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red, // Set the snackbar background color to red for emphasis
      ),
    );
  }
}
