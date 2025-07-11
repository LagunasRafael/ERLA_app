import 'package:intl/intl.dart';
// usaremos un enum para definir las categorías posibles. y evitar errores de escritura
enum MenuCategory { platillos, bebidas, postres }

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final MenuCategory category;

  String get formattedPrice {
    return NumberFormat.currency(
      locale: 'es_MX',
      symbol: '',
      decimalDigits: 2,
    ).format(price);
  }

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category, 
  });
}