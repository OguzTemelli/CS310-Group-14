import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:async';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  // final Completer<GoogleMapController> _controller = Completer();
  
  // // Sabancı Üniversitesi'nin koordinatları
  // static const LatLng _sabanci = LatLng(40.8930745, 29.3788913);
  
  // // İlk harita pozisyonu
  // static const CameraPosition _initialPosition = CameraPosition(
  //   target: _sabanci,
  //   zoom: 15.0,
  // );
  
  // // İşaretleyici kümesi
  // final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    // // Sabancı Üniversitesi için işaretleyici ekleme
    // _markers.add(
    //   const Marker(
    //     markerId: MarkerId('sabanci'),
    //     position: _sabanci,
    //     infoWindow: InfoWindow(
    //       title: 'Sabancı Üniversitesi',
    //       snippet: 'Orta Mahalle, 34956 Tuzla/İstanbul',
    //     ),
    //   ),
    // );
    // iFrame için element ID
    const String viewID = 'google-map-iframe';
    
    // iframe DOM elemanı oluştur
    final mapIframeElement = html.IFrameElement()
      ..src = 'https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d12919.207409723727!2d29.36945023077881!3d40.89195569430692!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x14cad91aa2f0fd1d%3A0x1b3a3a6c0c61e0e2!2sSabanc%C4%B1%20%C3%9Cniversitesi!5e0!3m2!1str!2str!4v1714246022118!5m2!1str!2str'
      ..style.border = 'none'
      ..style.height = '100%'
      ..style.width = '100%'
      ..allowFullscreen = true;

    // Flutter web platformView oluştur
    ui_web.platformViewRegistry.registerViewFactory(
      viewID, 
      (int viewId) => mapIframeElement
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'MatchMate',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.blue.shade800,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              
              // Title
              const Text(
                'We are here\nto help you!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 60),
              
              // Contact Us section
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Contact us',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Email info
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'matchmate@matchmate.com',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              
              const SizedBox(height: 5),
              
              // Phone info
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '+90 555 123 4567',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Google Maps iframe
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: const HtmlElementView(
                    viewType: 'google-map-iframe',
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