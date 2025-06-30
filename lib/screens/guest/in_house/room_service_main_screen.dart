import 'package:flutter/material.dart';
import '/data/mock_data.dart';
import '/models/menu_item.dart';
import 'package:provider/provider.dart';
import '/providers/cart_provider.dart';
import 'cart_screen.dart';


class RoomServiceMainScreen extends StatefulWidget {
  const RoomServiceMainScreen({super.key});

  @override
  State<RoomServiceMainScreen> createState() => _RoomServiceMainScreenState();
}

class _RoomServiceMainScreenState extends State<RoomServiceMainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<MenuItem> _allItems;
  late List<MenuItem> _platillos;
  late List<MenuItem> _bebidas;
  late List<MenuItem> _postres;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _allItems = MockDataService.getMenuItems();
    _platillos = _allItems.where((item) => item.category == MenuCategory.platillos).toList();
    _bebidas = _allItems.where((item) => item.category == MenuCategory.bebidas).toList();
    _postres = _allItems.where((item) => item.category == MenuCategory.postres).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Room Service'),

        actions: [
          // Consumer reconstruirá solo este pequeño trozo de la UI cuando el carrito cambie.
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                // Usamos un Stack para poner el número encima del ícono del carrito.
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      onPressed: () {
                        // Navegamos a nuestra nueva pantalla del carrito
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CartScreen()),
                        );
                      },
                    ),
                    // contador si el carrito no esta vacio
                    if (cart.items.isNotEmpty)
                      Positioned(
                        top: 6,
                        right: 4,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.red,
                          child: Text(
                            cart.items.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],

        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Platillos'),
            Tab(text: 'Bebidas'),
            Tab(text: 'Postres'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _MenuList(items: _platillos),
          _MenuList(items: _bebidas),
          _MenuList(items: _postres),
        ],
      ),
    );
  }
}

class _MenuList extends StatelessWidget {
  final List<MenuItem> items;
  const _MenuList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No hay artículos en esta categoría.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _MenuItemCard(item: item);
      },
    );
  }
}

// Un widget para mostrar la información de un solo item del menú en una tarjeta
class _MenuItemCard extends StatelessWidget {
  final MenuItem item;
  const _MenuItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                item.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(item.description, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text(
                    '\$${item.price.toStringAsFixed(2)} MXN',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // --- MODIFICACIÓN AQUÍ ---
            IconButton(
              icon: const Icon(Icons.add_shopping_cart_outlined),
              onPressed: () {
                // 1. Buscamos el CartProvider en el contexto.
                //    'listen: false' es una optimización importante aquí. Le decimos
                //    que solo queremos llamar a una función, no necesitamos que este
                //    botón se redibuje si el carrito cambia.
                final cart = Provider.of<CartProvider>(context, listen: false);

                // 2. Llamamos al método para añadir el item actual.
                cart.addItem(item);

                // 3. Mostramos una confirmación visual al usuario.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.name} añadido al carrito.'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}