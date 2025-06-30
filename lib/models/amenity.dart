import 'package:flutter/widgets.dart';

// Este es el molde para una sola amenidad.
class Amenity {
  final String name; // nombre que ira a la par del icono
  final IconData icon; // variable de icono

  const Amenity({
    required this.name,
    required this.icon,
  });
}