import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildGridButton("Take The Test", Icons.check),
            _buildGridButton("Previous Results", Icons.history),
            _buildGridButton("Dorm Rules", Icons.rule),
            _buildGridButton("SuDorms", Icons.apartment),
            _buildGridButton("Contact", Icons.contact_page),
            _buildGridButton("Feedback", Icons.feedback),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton(String title, IconData iconData) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      onPressed: () {
        // Add navigation or logic for each button if needed
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
