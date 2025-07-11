import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../models/menu_item.dart';

class CartProvider with ChangeNotifier {
  final List<MenuItem> _items = [];

  List<MenuItem> get items => _items;

  // Devuelve el total como String formateado con comas si es mayor o igual a 1000
  String get totalPrice {
    double total = _items.fold(0.0, (sum, item) => sum + item.price);
    if (total >= 1000) {
      return NumberFormat.currency(
        locale: 'es_MX', // ajuste de la region
        symbol: '', // opcion para quitar el simbolo de la moneda si no se llegara a necesitar
        decimalDigits: 2, // Número de decimales
      ).format(total);
    } else {
      return total.toStringAsFixed(2); // Muestra 2 decimales aunque no llegue a 1000
    }
  }

  void addItem(MenuItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(MenuItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}