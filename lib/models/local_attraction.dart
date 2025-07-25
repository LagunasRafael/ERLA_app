// Este archivo define la estructura de una atracción o punto de interés local.
class LocalAttraction {
  final String id;
  final String name;
  final String description;
  final String address;
  final String imageUrl; // URL de una imagen del lugar

  // Constructor con parámetros requeridos.
  const LocalAttraction({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.imageUrl,
  });
}