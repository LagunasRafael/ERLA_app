import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../data/mock_data.dart';
import '../../models/local_attraction.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos los datos de la guía local de nuestro MockDataService
    final List<LocalAttraction> attractions = MockDataService.getLocalAttractions();
    
    // Definimos la lista de amenidades con sus rutas de imágenes locales
    final amenities = [
      {'title': 'Haiku Pool Bar', 'imageUrl': 'assets/images/amenidades/Hotel/pool_bar/03.- ALBERCA.jpeg'},
      {'title': 'Spa "Kimiry"', 'imageUrl': 'assets/images/amenidades/Hotel/spa/03.- CABINA SPA.HEIC'},
      {'title': 'Restaurantes', 'imageUrl': 'assets/images/amenidades/Hotel/restaurant/02.- RESTAURANTE.JPG'},
      {'title': 'Salones', 'imageUrl': 'assets/images/amenidades/Hotel/salones/07.- SALÓN HARAMARA.jpeg'}, 
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explora y Descubre'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SECCIÓN "EN EL HOTEL" ---
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text('En el Hotel', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            AnimationLimiter(
              child: GridView.builder(
                itemCount: amenities.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    columnCount: 2,
                    duration: const Duration(milliseconds: 500),
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: AmenityImageCard(
                          title: amenities[index]['title']!,
                          imageUrl: amenities[index]['imageUrl']!,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // --- SECCIÓN "GUÍA LOCAL" ---
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text('Guía Local', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            AnimationLimiter(
              child: SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: attractions.length,
                  itemBuilder: (context, index) {
                    final attraction = attractions[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: AttractionCarouselCard(attraction: attraction),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET REUTILIZABLE PARA LAS AMENIDADES ---
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

// --- WIDGET REUTILIZABLE PARA LA GUÍA LOCAL ---
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
            Image.asset( // Usamos Image.asset aquí también
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