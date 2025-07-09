import 'package:intl/intl.dart'; // Asegúrate de importar el paquete
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

  // Getter para el precio formateado con comas y 2 decimales
  String get formattedPricePerNight {
    return NumberFormat.currency(
      locale: 'es_MX',       // Formato mexicano (comas para miles)
      symbol: '',            // Quitamos el símbolo (lo añadiremos manualmente)
      decimalDigits: 2,      // Siempre 2 decimales
    ).format(pricePerNight);
  }
}