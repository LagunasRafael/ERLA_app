import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/room_type.dart';
import 'room_detail_screen.dart'; // Importamos la pantalla de detalle

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos la lista de todos nuestros tipos de habitación.
    final List<RoomType> roomTypes = MockDataService.getRoomTypes();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuestras Habitaciones'),
      ),
      // Usamos ListView.builder para construir la lista de forma optimizada.
      body: ListView.builder(
        // El padding general para toda la lista.
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: roomTypes.length,
        itemBuilder: (BuildContext context, int index) {
          // Obtenemos la habitación específica para esta fila de la lista.
          final room = roomTypes[index];

          // InkWell hace que toda la tarjeta sea un botón interactivo.
          return InkWell(
            onTap: () {
              // Lógica de navegación: al tocar, vamos a la pantalla de detalle
              // y le pasamos toda la información de la habitación seleccionada.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoomDetailScreen(room: room),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              clipBehavior: Clip.antiAlias,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Usamos la primera imagen de la lista de la habitación como portada.
                  Image.asset(
                    room.imageUrls.first,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  // Padding para el contenido de texto.
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          room.shortDescription,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Desde \$${room.pricePerNight.toStringAsFixed(2)} / noche',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            // Indicador visual para mostrar que es tappable.
                            const Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}