import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  TimeOfDay _selectedTime = const TimeOfDay(hour: 0, minute: 0);
  bool _isActive = false;
  bool _isLoading = false;
  String _apiResponse = '';

  final String _baseUrl = 'http://192.168.4.1/schedule';

  int get _totalSeconds => _selectedTime.hour * 60 + _selectedTime.minute * 60;

  Future<void> _sendCommand() async {
    setState(() {
      _isLoading = true;
      _apiResponse = '';
    });

    try {
      final response = await http
          .get(
            Uri.parse(
              '$_baseUrl?delay=$_totalSeconds&state=${_isActive ? 'on' : 'off'}',
            ),
          )
          .timeout(const Duration(seconds: 10));

      setState(() {
        _apiResponse = response.body;
        if (response.body.toLowerCase().contains('off')) {
          _isActive = true;
        } else if (response.body.toLowerCase().contains('on')) {
          _isActive = false;
        }
      });
    } catch (e) {
      setState(() {
        _apiResponse = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleStatus() {
    setState(() {
      _isActive = !_isActive;
    });
    _sendCommand();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              surface: Colors.grey,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[900],
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 400;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Schedule Control'),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status Indicator
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isActive ? Colors.green : Colors.red,
                    width: 3,
                  ),
                ),
                child: Icon(
                  _isActive ? Icons.power_settings_new : Icons.power_off,
                  size: isSmallScreen ? 40 : 50,
                  color: _isActive ? Colors.green : Colors.red,
                ),
              ),
              SizedBox(height: isPortrait ? 30 : 20),

              // Time Picker Button
              ElevatedButton(
                onPressed: () => _selectTime(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 20 : 30,
                    vertical: isSmallScreen ? 15 : 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      'Set Time (${_selectedTime.format(context)})',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Total Seconds Display
              Container(
                padding: const EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(vertical: isPortrait ? 10 : 5),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Total: $_totalSeconds seconds',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: isPortrait ? 20 : 10),

              // Control Buttons
              Wrap(
                alignment: WrapAlignment.center,
                spacing: isPortrait ? 20 : 10,
                runSpacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : _toggleStatus,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isActive ? Colors.red : Colors.green,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 20 : 30,
                        vertical: isSmallScreen ? 12 : 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _isActive ? 'TURN OFF' : 'TURN ON',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _sendCommand,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 20 : 30,
                        vertical: isSmallScreen ? 12 : 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'SEND',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Response Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'API Response:',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _isLoading ? 'Loading...' : _apiResponse,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Endpoint: $_baseUrl?delay=$_totalSeconds&state=${_isActive ? 'on' : 'off'}',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: isSmallScreen ? 10 : 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
