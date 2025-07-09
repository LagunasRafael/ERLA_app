import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart'; // <-- AÑADE ESTE IMPORT
import '../../data/mock_data.dart';
import '../../models/room_type.dart';
import 'room_detail_screen.dart';

class RoomsScreen extends StatelessWidget {
  const RoomsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<RoomType> roomTypes = MockDataService.getRoomTypes();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuestras Habitaciones'),
      ),
      // Envolvemos nuestra lista con el widget 'AnimationLimiter'.
      body: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: roomTypes.length,
          itemBuilder: (BuildContext context, int index) {
            final room = roomTypes[index];
            
            // Cada elemento de la lista ahora está envuelto en widgets de animación.
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 500), // Duración de la animación
              child: SlideAnimation( // Animación de deslizamiento
                verticalOffset: 50.0,
                child: FadeInAnimation( // Animación de aparición gradual
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoomDetailScreen(room: room),
                        ),
                      );
                    },
                    // Nuestra tarjeta de habitación original va aquí dentro, sin cambios.
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      clipBehavior: Clip.antiAlias,
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            room.imageUrls.first,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
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
                                      'Desde \$${room.formattedPricePerNight} / noche',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.grey),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}