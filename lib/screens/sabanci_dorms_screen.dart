import 'package:flutter/material.dart';

class SabanciDormsScreen extends StatefulWidget {
  const SabanciDormsScreen({Key? key}) : super(key: key);

  @override
  State<SabanciDormsScreen> createState() => _SabanciDormsScreenState();
}

class _SabanciDormsScreenState extends State<SabanciDormsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Tüm fotoğrafları ve açıklamalarını içeren liste
  final List<Map<String, String>> _imageData = [
    {
      'image': 'https://images.unsplash.com/photo-1460317442991-0ec209397118?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8c3R1ZWRlbnQlMjBob3VzaW5nfGVufDB8fDB8fA%3D%3D',
      'description': 'Sabancı Üniversitesi Yurt Binası Dış Görünüm'
    },
    {
      'image': 'assets/images/sabanciyurt2.jpg',
      'description': 'Yurt Binası Yan Cephe'
    },
    {
      'image': 'assets/images/yurt-odasi.jpg',
      'description': 'Örnek Yurt Odası'
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sabancı Yurtları'),
        backgroundColor: Colors.blue[900],
      ),
      body: ListView(
        children: [
          // Carousel
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                // PageView for images
                PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemCount: _imageData.length,
                  itemBuilder: (context, index) {
                    final imageUrl = _imageData[index]['image']!;
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageUrl.startsWith('http')
                              ? NetworkImage(imageUrl)
                              : AssetImage(imageUrl) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                // Dots indicator
                Positioned(
                  bottom: 16.0,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _imageData.asMap().entries.map((entry) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == entry.key
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Navigation arrows
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left arrow
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (_currentPage > 0) {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                      // Right arrow
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (_currentPage < _imageData.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Title and current image description
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Sabancı Üniversitesi Yurtları',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Current image description
                Text(
                  _imageData[_currentPage]['description']!,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Additional information
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Sabancı Üniversitesi yurtları, öğrencilere modern ve konforlu bir yaşam alanı sunmaktadır. '
              'Tüm odalarda temel mobilyalar, internet bağlantısı ve gerekli altyapı mevcuttur.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
} 