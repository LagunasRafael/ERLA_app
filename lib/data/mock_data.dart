import 'package:flutter/material.dart';
import '../models/amenity.dart';
import '../models/local_attraction.dart';
import '../models/menu_item.dart';
import '../models/room_type.dart';

/// Un servicio centralizado para proveer todos los datos de muestra (mock data)
/// para la aplicación. Esto nos permite simular un backend y mantener los datos
/// de prueba organizados en un solo lugar.
class MockDataService {
  /// Devuelve una lista de platillos para el menú de Room Service, ahora con categorías.
  static List<MenuItem> getMenuItems() {
    return [
      MenuItem(
        id: 'rs001',
        name: 'Club Sándwich Clásico',
        description: 'Pechuga de pavo, tocino crujiente, lechuga, tomate y mayonesa.',
        price: 180.50,
        imageUrl: 'assets/images/platillos/club_sandwich.jpeg',
        category: MenuCategory.platillos,
      ),
      MenuItem(
        id: 'rs002',
        name: 'Ensalada César con Pollo',
        description: 'Lechuga romana fresca, crutones, queso parmesano y aderezo César con pechuga de pollo a la parrilla.',
        price: 160.00,
        imageUrl: 'assets/images/platillos/ensalada.jpg',
        category: MenuCategory.platillos,
      ),
      MenuItem(
        id: 'rs003',
        name: 'Sopa de Tortilla',
        description: 'Tradicional sopa a base de tomate y chiles, servida con tiras de tortilla frita, aguacate, queso y crema.',
        price: 120.00,
        imageUrl: 'assets/images/platillos/sopa.png',
        category: MenuCategory.platillos,
      ),
      MenuItem(
        id: 'rs004',
        name: 'Agua de Horchata',
        description: 'Refrescante y tradicional agua de arroz con canela y un toque de vainilla.',
        price: 60.00,
        imageUrl: 'assets/images/platillos/horchata.webp',
        category: MenuCategory.bebidas,
      ),
      MenuItem(
        id: 'rs005',
        name: 'Pastel de Chocolate',
        description: 'Denso y rico pastel de chocolate con una cubierta de fudge.',
        price: 110.00,
        imageUrl: 'assets/images/platillos/pastel.jpg',
        category: MenuCategory.postres,
      ),
    ];
  }

  /// Devuelve una lista de atracciones para la Guía Local.
  static List<LocalAttraction> getLocalAttractions() {
    return [
      LocalAttraction(
        id: 'la01',
        name: 'Malecón de Puerto Vallarta',
        description: 'Un vibrante paseo marítimo ideal para caminar, disfrutar del arte local y ver el atardecer.',
        address: 'Paseo Díaz Ordaz S/N, Centro',
        imageUrl: 'https://placehold.co/600x400/87CEEB/FFFFFF?text=Malecón',
      ),
      LocalAttraction(
        id: 'la02',
        name: 'Mercado de Artesanías Río Cuale',
        description: 'Encuentra recuerdos únicos y auténticas artesanías mexicanas hechas por artistas de la región.',
        address: 'Isla Río Cuale S/N, Centro',
        imageUrl: 'https://placehold.co/600x400/FF7F50/FFFFFF?text=Mercado',
      ),
    ];
  }

  /// Devuelve una lista de tipos de habitación, cada una con su propia
  /// lista de amenidades específicas y usando imágenes locales.
  static List<RoomType> getRoomTypes() {
    const standardAmenities = [
      Amenity(name: 'Wi-Fi de Alta Velocidad', icon: Icons.wifi),
      Amenity(name: 'Aire Acondicionado', icon: Icons.ac_unit),
      Amenity(name: 'Smart TV 55"', icon: Icons.tv),
      Amenity(name: 'Caja de Seguridad', icon: Icons.lock),
    ];

    return [
      RoomType(
        id: 'habitacion-estandar',
        name: 'Habitacion Estandar',
        shortDescription: '45m² de lujo con balcón privado y vistas espectaculares al Océano Pacífico.',
        pricePerNight: 4200.00,
        imageUrls: ['assets/images/habitaciones/estandar/03.- HAB. ESTÁNDAR.HEIC'],
        amenities: [
          ...standardAmenities,
          const Amenity(name: 'Balcón Privado', icon: Icons.balcony),
          const Amenity(name: 'Cafetera Nespresso', icon: Icons.local_cafe),
        ],
      ),
      RoomType(
        id: 'hab-estand-handicap',
        name: 'Habitacion Estandar Handicap',
        shortDescription: 'Dos cómodas camas matrimoniales en un ambiente tranquilo rodeado de naturaleza.',
        pricePerNight: 2800.00,
        imageUrls: ['assets/images/habitaciones/estandar_handicap/02.- HAB. HANDICAP.HEIC'],
        amenities: standardAmenities,
      ),
      RoomType(
        id: 'estandar-plus',
        name: 'Habitacion Estandar Plus',
        shortDescription: 'La joya del hotel. 70m² con sala de estar, jacuzzi y la mejor vista panorámica.',
        pricePerNight: 6500.00,
        imageUrls: ['assets/images/habitaciones/estandar_plus/02.- HAB, EST. PLUS.HEIC'],
        amenities: [
          ...standardAmenities,
          const Amenity(name: 'Balcón Panorámico', icon: Icons.balcony),
          const Amenity(name: 'Cafetera Nespresso', icon: Icons.local_cafe),
          const Amenity(name: 'Jacuzzi Privado', icon: Icons.hot_tub),
          const Amenity(name: 'Sala de Estar', icon: Icons.living),
        ],
      ),
      RoomType(
        id: 'hab-jr-suite',
        name: 'Habitacion Junior Suite',
        shortDescription: 'Dos cómodas camas matrimoniales en un ambiente tranquilo rodeado de naturaleza.',
        pricePerNight: 2800.00,
        imageUrls: ['assets/images/habitaciones/jr_suite/15.- HAB. JR SUITE.jpg'],
        amenities: standardAmenities,
      ),
      RoomType(
        id: 'hab-master-suite',
        name: 'Habitacion Master Suite',
        shortDescription: 'Dos cómodas camas matrimoniales en un ambiente tranquilo rodeado de naturaleza.',
        pricePerNight: 2800.00,
        imageUrls: ['assets/images/habitaciones/master_suite/15.- M SUITE PB.HEIC'],
        amenities: standardAmenities,
      ),
    ];
  }
}