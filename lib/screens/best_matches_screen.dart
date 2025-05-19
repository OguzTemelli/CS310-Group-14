// screens/best_matches_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';

class BestMatchesScreen extends StatefulWidget {
  const BestMatchesScreen({super.key});

  @override
  State<BestMatchesScreen> createState() => _BestMatchesScreenState();
}

class _BestMatchesScreenState extends State<BestMatchesScreen> {
  @override
  void initState() {
    super.initState();
    // Load matches when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MatchesProvider>(context, listen: false).loadMatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Best Matches'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Consumer<MatchesProvider>(
        builder: (context, matchesProvider, child) {
          if (matchesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (matchesProvider.errorMessage != null && matchesProvider.errorMessage!.isNotEmpty) {
            return Center(child: Text(matchesProvider.errorMessage!));
          }
          
          final matches = matchesProvider.matches;
          
          if (matches.isEmpty) {
            return const Center(child: Text('No matches found'));
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              final similarity = match['similarity'] as double;
              final percentage = (similarity * 100).toStringAsFixed(0);
              
              return GestureDetector(
                onTap: () {
                  // Save match when tapped (optional)
                  matchesProvider.saveMatch(match);
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                match['name'].toString().substring(0, 1).toUpperCase(),
                                style: TextStyle(
                                  color: Colors.blue.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    match['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    match['email'],
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$percentage% Match',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}