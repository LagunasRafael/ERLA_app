import 'package:flutter/material.dart';
import '../../models/room_type.dart';
import '/screens/guest/booking/booking_date_screen.dart'; 

class RoomDetailScreen extends StatelessWidget {
  final RoomType room;

  const RoomDetailScreen({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // app bar simplificada
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                room.name,
                style: const TextStyle(fontSize: 18.0 ),
              ),
              centerTitle: true,
              background: Image.asset(
                room.imageUrls.first, //primera imagen de la lista de mock_data
                fit: BoxFit.cover,
              ),
            ),
          ),

          //Contenido principal de la pantalla
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '\$${room.formattedPricePerNight} MXN / noche',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      //boton de reserva
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonal(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // Ahora le pasamos la información de la habitación actual a la pantalla del calendario
                            builder: (context) => BookingDateScreen(room: room),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Reservar Ahora', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const Divider(height: 48),

                  Text('Descripción', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(room.shortDescription, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5)),
                  const SizedBox(height: 24),

                  Text('Amenidades', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  //GridView de amenidades
                  const Divider(height: 48),

                  GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 5,
                          children: const [
                            AmenityItem(icon: Icons.wifi, label: 'Wi-Fi'),
                            AmenityItem(icon: Icons.ac_unit, label: 'Aire Acondicionado'),
                            AmenityItem(icon: Icons.tv, label: 'Smart TV 55"'),
                            AmenityItem(icon: Icons.balcony, label: 'Balcón Privado'),
                            AmenityItem(icon: Icons.local_cafe, label: 'Cafetera Nespresso'),
                            AmenityItem(icon: Icons.lock, label: 'Caja de Seguridad'),
                          ],
                        ),

                  //secciones de imágenes
                  ImageSection(
                    title: 'Vistas y Balcón',
                    // imagenes para el balcon
                    imageUrls: [room.imageUrls.first, room.imageUrls.first],
                  ),
                  const SizedBox(height: 24),
                  ImageSection(
                    title: 'Baño de Lujo',
                    // imagenes del baño
                    imageUrls: [room.imageUrls.first],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Widget Reutilizable para las Secciones de Imágenes
class ImageSection extends StatelessWidget {
  final String title;
  final List<String> imageUrls;

  const ImageSection({
    super.key,
    required this.title,
    required this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        SizedBox(
          height: 120, // Altura de la galería horizontal
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    imageUrls[index],
                    width: 180, // Ancho de cada imagen
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Widget auxiliar para las Amenidades (lo incluimos para que el código esté completo)
class AmenityItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const AmenityItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}