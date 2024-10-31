
import 'package:TapOn_merchant/home.dart';
import 'package:flutter/material.dart';


class LaunchPage extends StatelessWidget {
  const LaunchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.amber[700],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Circle Avatar with image
                CircleAvatar(
                  radius: 180,
                  backgroundColor: const Color.fromARGB(255, 252, 250, 250),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 40), 
                const Text(
                  'Discover new interests.',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Empower your team with our application',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                           Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TapOnHomePage()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber, // Button color
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16, color: Colors.blue)),
                  child: const Text('GET STARTED'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
