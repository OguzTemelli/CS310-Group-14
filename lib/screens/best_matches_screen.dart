import 'package:flutter/material.dart';

class BestMatchesScreen extends StatefulWidget {
  const BestMatchesScreen({super.key});

  @override
  State<BestMatchesScreen> createState() => _BestMatchesScreenState();
}

class _BestMatchesScreenState extends State<BestMatchesScreen> {
  // TODO: Bu liste ileride API'den veya veritabanından çekilecek
  final List<Map<String, String>> _matches = [
    {
      'name': 'Taylan İrak',
      'email': 'taylan.irak@sabanciuniv.edu'
    },
    {
      'name': 'Buğra Aydın',
      'email': 'bugra.aydin@sabanciuniv.edu'
    },
    {
      'name': 'Kağan Korkmaz',
      'email': 'kagan.korkmaz@sabanciuniv.edu'
    },
    {
      'name': 'Efe Güçlü',
      'email': 'efe.guclu@sabanciuniv.edu'
    },
    {
      'name': 'Enes Coşkun',
      'email': 'enes.coskun@sabanciuniv.edu'
    },
    {
      'name': 'Oğuz Temelli',
      'email': 'oguz.temelli@sabanciuniv.edu'
    },
    {
      'name': 'Berdan Sönmez',
      'email': 'berdan.sonmez@sabanciuniv.edu'
    },
  ];

  // TODO: İleride kullanılacak metodlar
  Future<void> _loadMatches() async {
    // API'den veya veritabanından eşleşmeleri yükleme
    // setState(() {
    //   _matches = ...
    // });
  }

  @override
  void initState() {
    super.initState();
    // _loadMatches(); // İleride aktif edilecek
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a237e),
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
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Title
                  const Text(
                    'Best Matches',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Matches List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _matches.length,
                itemBuilder: (context, index) {
                  final match = _matches[index];
                  return _buildMatchItem(
                    match['name']!,
                    match['email']!,
                    index + 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchItem(String name, String email, int number) {
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
              'assets/images/profile_icon.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.person,
                  color: Colors.white70,
                  size: 30,
                );
              },
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          email,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        trailing: Container(
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
      ),
    );
  }
} 