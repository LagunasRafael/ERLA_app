// Creamos un 'enum' para definir las categorías posibles.
// Esto evita errores de escritura y mantiene el código limpio.
enum MenuCategory { platillos, bebidas, postres }

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final MenuCategory category; // <-- NUEVA PROPIEDAD

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category, // <-- AÑADIDA AL CONSTRUCTOR
  });
}