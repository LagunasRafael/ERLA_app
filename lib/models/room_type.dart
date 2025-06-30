
import 'amenity.dart';

class RoomType {
  final String id;
  final String name; // Ej: "Suite Junior con Vista al Mar"
  final String shortDescription; // Ej: "Ideal para parejas, con balcón privado."
  final double pricePerNight; // El precio inicial por noche.
  final List<String> imageUrls; // Una lista de URLs de imágenes para la galería.
  final List<Amenity> amenities;

  RoomType({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.pricePerNight,
    required this.imageUrls,
     required this.amenities,
  });
}