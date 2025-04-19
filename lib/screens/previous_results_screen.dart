import 'package:flutter/material.dart';

class PreviousResultsScreen extends StatefulWidget {
  const PreviousResultsScreen({super.key});

  @override
  State<PreviousResultsScreen> createState() => _PreviousResultsScreenState();
}

class _PreviousResultsScreenState extends State<PreviousResultsScreen> {
  final List<Map<String, dynamic>> _tests = [
    {'name': 'test8', 'status': 'Submitted', 'number': 1},
    {'name': 'test7', 'status': 'Removed', 'number': 2},
    {'name': 'test6', 'status': 'Removed', 'number': 3},
  ];

  void _removeTest(int index) {
    setState(() {
      _tests[index]['status'] = 'Removed';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a237e), // Koyu mavi arka plan
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  // Back Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Title
                  const Text(
                    'Previous Results',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Results List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _tests.length,
                itemBuilder: (context, index) {
                  final test = _tests[index];
                  return _buildResultItem(
                    test['name'],
                    test['status'],
                    test['number'],
                    onRemove: test['status'] == 'Submitted' ? () => _removeTest(index) : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(
    String testName,
    String status,
    int number, {
    VoidCallback? onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/test_icon.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.assignment,
                  color: Colors.white70,
                  size: 30,
                );
              },
            ),
          ),
        ),
        title: Text(
          testName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          status,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  number.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (onRemove != null) ...[
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: onRemove,
              ),
            ],
          ],
        ),
      ),
    );
  }
} 