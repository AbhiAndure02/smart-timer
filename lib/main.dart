import 'package:flutter/material.dart';
import 'package:smart_timer/components/cyclic_screen.dart';
import 'package:smart_timer/components/home_screen.dart';
import 'package:smart_timer/components/schedule_screen.dart';
import 'package:smart_timer/components/timer_screen.dart';
import 'package:smart_timer/navigation/btn_navigation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BtnNavigationScreen(),
      routes: {
        // Add other routes here if needed
        '/home': (context) => HomeScreen(),
        '/schedule': (context) => ScheduleScreen(),
        '/timer': (context) => TimerScreen(),
        '/cycle':
            (context) =>
                CyclicScreen(), // Assuming cycle is also a timer screen
      },
    );
  }
}
