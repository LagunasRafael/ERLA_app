//archivo para definir el formato de las habitaciones
import 'package:intl/intl.dart';
import 'amenity.dart';

class RoomType {
  final String id;
  final String name;
  final String shortDescription;
  final double pricePerNight;
  final List<String> imageUrls;
  final List<Amenity> amenities;

  RoomType({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.pricePerNight,
    required this.imageUrls,
    required this.amenities,
  });

  // getter para el formato de comas
  String get formattedPricePerNight {
    return NumberFormat.currency(
      locale: 'es_MX', 
      symbol: '',            // Quitamos el símbolo 
      decimalDigits: 2,      // Siempre 2 decimales
    ).format(pricePerNight);
  }
}