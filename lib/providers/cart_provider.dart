import 'package:flutter/foundation.dart';
import '../models/menu_item.dart';

// La clase 'CartProvider' usa un 'ChangeNotifier'.
// Esto le permite "notificar" a los widgets cuando sus datos han cambiado
// para que la interfaz se pueda redibujar.
class CartProvider with ChangeNotifier {
  // Una lista privada que almacena los items del carrito.
  final List<MenuItem> _items = [];

  // Un 'getter' público para que los widgets puedan leer los items pero no modificar la lista directamente.
  List<MenuItem> get items => _items;

  // Un 'getter' para calcular el total del carrito.
  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.price);
  }

  // Método para añadir un item al carrito.
  void addItem(MenuItem item) {
    _items.add(item);
    // ¡La línea más importante! Notifica a todos los widgets que están "escuchando"
    // que ha habido un cambio y que necesitan actualizarse.
    notifyListeners();
  }

  // Método para remover un item del carrito.
  void removeItem(MenuItem item) {
    _items.remove(item);
    notifyListeners();
  }

  // Método para vaciar el carrito por completo.
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}