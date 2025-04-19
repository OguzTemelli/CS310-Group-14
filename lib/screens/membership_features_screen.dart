import 'package:flutter/material.dart';

class MembershipFeature {
  final String name;
  final String description;
  final double price;

  MembershipFeature({
    required this.name,
    required this.description,
    required this.price,
  });
}

class MembershipFeaturesScreen extends StatefulWidget {
  const MembershipFeaturesScreen({super.key});

  @override
  State<MembershipFeaturesScreen> createState() =>
      _MembershipFeaturesScreenState();
}

class _MembershipFeaturesScreenState extends State<MembershipFeaturesScreen> {
  final List<MembershipFeature> _availableFeatures = [
    MembershipFeature(
      name: 'Advanced Matching',
      description: 'Get better roommate matches with our advanced algorithm',
      price: 4.99,
    ),
    MembershipFeature(
      name: 'Priority Support',
      description: '24/7 priority customer support',
      price: 2.99,
    ),
    MembershipFeature(
      name: 'Unlimited Tests',
      description: 'Take compatibility tests as many times as you want',
      price: 3.99,
    ),
    MembershipFeature(
      name: 'Detailed Reports',
      description: 'Get detailed compatibility reports and insights',
      price: 4.99,
    ),
    MembershipFeature(
      name: 'Early Access',
      description: 'Get early access to new features',
      price: 2.99,
    ),
  ];

  final List<MembershipFeature> _cartFeatures = [];

  double get _totalPrice =>
      _cartFeatures.fold(0, (sum, feature) => sum + feature.price);

  void _addToCart(MembershipFeature feature) {
    setState(() {
      _cartFeatures.add(feature);
      _availableFeatures.remove(feature);
    });
  }

  void _removeFromCart(MembershipFeature feature) {
    setState(() {
      _cartFeatures.remove(feature);
      _availableFeatures.add(feature);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a237e),
      appBar: AppBar(
        title: const Text(
          'Customize Your Plan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Available Features',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ..._availableFeatures.map((feature) => _buildFeatureCard(
                      feature,
                      isInCart: false,
                    )),
                if (_cartFeatures.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Your Cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._cartFeatures.map((feature) => _buildFeatureCard(
                        feature,
                        isInCart: true,
                      )),
                ],
              ],
            ),
          ),
          if (_cartFeatures.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Price',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '\$${_totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/payment-success',
                          arguments: 'Custom Plan',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Proceed to Payment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(MembershipFeature feature,
      {required bool isInCart}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feature.description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${feature.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isInCart ? Icons.remove_circle : Icons.add_circle,
                color: isInCart ? Colors.red : Colors.green,
                size: 28,
              ),
              onPressed: () {
                if (isInCart) {
                  _removeFromCart(feature);
                } else {
                  _addToCart(feature);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
