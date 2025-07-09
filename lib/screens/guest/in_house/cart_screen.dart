import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Mi Pedido'),
            actions: [
              if (cart.items.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined),
                  onPressed: () => cart.clearCart(),
                )
            ],
          ),
          body: cart.items.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Tu carrito está vacío', style: TextStyle(fontSize: 20, color: Colors.grey)),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart.items.length,
                        itemBuilder: (context, index) {
                          final item = cart.items[index];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                            ),
                            title: Text(item.name),
                            subtitle: Text('\$${item.price.toStringAsFixed(2)} MXN'),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                              onPressed: () => cart.removeItem(item),
                            ),
                          );
                        },
                      ),
                    ),
                    _buildTotalSummary(context, cart), // Pasamos el cart completo
                  ],
                ),
        );
      },
    );
  }

  // Widget auxiliar para el resumen del total y el botón de confirmar

  Widget _buildTotalSummary(BuildContext context, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total:', style: Theme.of(context).textTheme.titleLarge),
              Text(
                '\$${cart.totalPrice} MXN', // Ya viene formateado con comas y decimales
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('¿Confirmar Pedido?'),
                      content: Text('Se añadirá un cargo de \$${cart.totalPrice} a la cuenta de tu habitación.'), // Ya formateado
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancelar'),
                          onPressed: () => Navigator.of(dialogContext).pop(),
                        ),
                        FilledButton(
                          child: const Text('Confirmar'),
                          onPressed: () {
                            cart.clearCart();
                            Navigator.of(dialogContext).pop();
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('¡Pedido realizado con éxito!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Confirmar Pedido', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}