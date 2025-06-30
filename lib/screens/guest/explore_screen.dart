import 'package:flutter/material.dart';
import 'package:hotel_huesped_app/data/mock_data.dart';
import 'package:hotel_huesped_app/models/local_attraction.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<LocalAttraction> attractions = MockDataService.getLocalAttractions();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explora y Descubre'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECCION DEL HOTEL
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(
                'En el Hotel',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: const [
                AmenityImageCard(
                  title: 'Haiku Pool Bar',
                  imageUrl: 'assets/images/amenidades/Hotel/pool_bar/04.- ALBERCA.jpeg',
                ),
                AmenityImageCard(
                  title: 'Spa "Kimiry"',
                  imageUrl: 'assets/images/amenidades/Hotel/spa/03.- CABINA SPA.HEIC',
                ),
                AmenityImageCard(
                  title: 'Restaurante Kwaiya',
                  imageUrl: 'assets/images/amenidades/Hotel/restaurant/02.- RESTAURANTE.JPG',
                ),
                AmenityImageCard(
                  title: 'Salon Haramara',
                  imageUrl: 'assets/images/amenidades/Hotel/salones/07.- SALÓN HARAMARA.jpeg',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // SECCION DE GUIA LOCAL
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(
                'Guía Local',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: attractions.length,
                itemBuilder: (context, index) {
                  final attraction = attractions[index];
                  return AttractionCarouselCard(attraction: attraction);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// widgets para las amenidades
class AmenityImageCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  const AmenityImageCard({super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(imageUrl, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black, blurRadius: 2)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET REUTILIZABLE PARA LA GUÍA LOCAL (sin cambios) ---
class AttractionCarouselCard extends StatelessWidget {
  final LocalAttraction attraction;
  const AttractionCarouselCard({super.key, required this.attraction});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(right: 12),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network( // Este sigue siendo de red por ahora
              attraction.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                attraction.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}