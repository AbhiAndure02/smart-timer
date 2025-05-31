import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoadOn = false;
  bool isLoading = false;

  Future<void> toggleLoad() async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = isLoadOn ? 'http://192.168.4.1/on' : 'http://192.168.4.1/off';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          isLoadOn = !isLoadOn;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to toggle load: ${response.statusCode}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red[800],
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red[800],
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text(
          'Smart Controller',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 10,
        shadowColor: Colors.blueAccent.withOpacity(0.5),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey[850]!, Colors.black],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.power_settings_new,
                size: 80,
                color: isLoadOn ? Colors.blueAccent : Colors.grey[600],
              ),
              const SizedBox(height: 30),
              Text(
                isLoadOn ? 'LOAD IS ON' : 'LOAD IS OFF',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isLoadOn ? Colors.blueAccent : Colors.grey[400],
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : toggleLoad,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isLoadOn ? Colors.red[900] : Colors.blue[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 8,
                    shadowColor:
                        isLoadOn
                            ? Colors.redAccent.withOpacity(0.5)
                            : Colors.blueAccent.withOpacity(0.5),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          )
                          : Text(
                            isLoadOn ? 'TURN OFF' : 'TURN ON',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
