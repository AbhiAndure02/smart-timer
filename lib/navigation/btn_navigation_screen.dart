import 'package:flutter/material.dart';
import 'package:smart_timer/components/cyclic_screen.dart';
import 'package:smart_timer/components/home_screen.dart';
import 'package:smart_timer/components/schedule_screen.dart';
import 'package:smart_timer/components/timer_screen.dart';

class BtnNavigationScreen extends StatefulWidget {
  const BtnNavigationScreen({super.key});

  @override
  State<BtnNavigationScreen> createState() => _BtnNavigationScreenState();
}

class _BtnNavigationScreenState extends State<BtnNavigationScreen> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [
    const HomeScreen(),
    const TimerScreen(),
    const ScheduleScreen(),
    const CyclicScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.black,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey[600],
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            elevation: 10,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.home, size: 24),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.timer, size: 24),
                ),
                label: 'Timer',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.schedule, size: 24),
                ),
                label: 'Schedule',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.repeat, size: 24),
                ),
                label: 'Cycle',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
