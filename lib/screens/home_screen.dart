import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a237e), // Koyu mavi arka plan
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Profil Kartı
              Card(
                color: Colors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      // Profil Resmi
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey[200],
                          child: const Icon(
                            Icons.person,
                            size: 35,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Kullanıcı Bilgileri
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome User',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'user@sabanciuniv.edu',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Menü Grid'i
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    _buildMenuButton(
                      icon: Icons.quiz,
                      label: 'Take The\nTest',
                      onTap: () {
                        Navigator.pushNamed(context, '/test-confirmation');
                      },
                    ),
                    _buildMenuButton(
                      icon: Icons.history,
                      label: 'Previous\nResults',
                      onTap: () {
                        // TODO: Implement results navigation
                      },
                    ),
                    _buildMenuButton(
                      icon: Icons.school,
                      label: 'Dorm\nRules',
                      onTap: () {
                        // TODO: Implement rules navigation
                      },
                    ),
                    _buildMenuButton(
                      icon: Icons.home,
                      label: 'SuDorms',
                      onTap: () {
                        // TODO: Implement dorms navigation
                      },
                    ),
                    _buildMenuButton(
                      icon: Icons.contact_phone,
                      label: 'Contact',
                      onTap: () {
                        Navigator.pushNamed(context, '/contact');
                      },
                    ),
                    _buildMenuButton(
                      icon: Icons.feedback,
                      label: 'Feedback',
                      onTap: () {
                        Navigator.pushNamed(context, '/feedback');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
