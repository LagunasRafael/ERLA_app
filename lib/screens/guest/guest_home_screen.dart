import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hotel_huesped_app/data/mock_data.dart';
import 'package:hotel_huesped_app/models/room_type.dart';
import 'package:hotel_huesped_app/screens/guest/room_detail_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hotel_huesped_app/screens/guest/rooms_screen.dart';

class GuestHomeScreen extends StatefulWidget {
  const GuestHomeScreen({super.key});

  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;
  String _selectedCategory = 'Todas';

  @override
  void initState() {
    super.initState();
    _bannerController.addListener(() {
      setState(() {
        _currentBannerIndex = _bannerController.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final featuredRooms = MockDataService.getRoomTypes().take(3).toList();
    final filteredRooms = _selectedCategory == 'Todas'
        ? featuredRooms
        : featuredRooms.where((room) => room.name.contains(_selectedCategory)).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBarWithBanner(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHotelInfo(),
                  const SizedBox(height: 24),
                  _buildCategoryFilter(),
                  const SizedBox(height: 16),
                  _buildFeaturedRoomsSection(filteredRooms),
                  const SizedBox(height: 24),
                  _buildSpecialOfferCard(),
                  const SizedBox(height: 24),
                  _buildAmenitiesSection(),
                  const SizedBox(height: 24),
                  _buildLocationSection(),
                  const SizedBox(height: 24),
                  _buildSocialMediaSection(),
                  const SizedBox(height: 32),
                  _buildSeeAllButton(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.search),
        label: const Text('Buscar'),
        onPressed: () {},
        backgroundColor: colorScheme.primary,
      ),
    );
  }

  SliverAppBar _buildAppBarWithBanner() {
    return SliverAppBar(
      expandedHeight: 350,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _bannerController,
              itemCount: 3,
              itemBuilder: (_, index) => Image.asset(
                'assets/images/fotohotel.jpg',
                fit: BoxFit.cover,
              ),
            ),
            _buildGradientOverlay(),
            _buildBannerIndicators(),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildBannerIndicators() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) => 
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentBannerIndex == index 
                  ? Colors.white 
                  : Colors.white.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHotelInfo() {
    return Column(
      children: [
        Text(
          'Hotel Grand Nayar',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Donde cada estancia es una obra de arte',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        _buildRatingStars(),
      ],
    );
  }

  Widget _buildRatingStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 20),
        const Icon(Icons.star, color: Colors.amber, size: 20),
        const Icon(Icons.star, color: Colors.amber, size: 20),
        const Icon(Icons.star, color: Colors.amber, size: 20),
        const Icon(Icons.star_half, color: Colors.amber, size: 20),
        const SizedBox(width: 8),
        Text(
          '4.8 (124 reseñas)',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    final categories = ['Todas', 'Suite', 'Familiar', 'Lujo'];
    
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: categories.map((category) => 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(category),
              selected: _selectedCategory == category,
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: _selectedCategory == category ? Colors.white : Colors.black,
              ),
              onSelected: (_) => setState(() => _selectedCategory = category),
            ),
          ),
        ).toList(),
      ),
    );
  }

  Widget _buildFeaturedRoomsSection(List<RoomType> rooms) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Habitaciones Destacadas',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: AnimationLimiter(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: _buildRoomCard(rooms[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoomCard(RoomType room) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RoomDetailScreen(room: room),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildRoomImage(room.imageUrls.first),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Desde \$${room.formattedPricePerNight} / noche',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoomImage(String imageUrl) {
    return Image.asset(
      imageUrl,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSpecialOfferCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.local_offer, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OFERTA ESPECIAL',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('15% de descuento en suites este mes'),
                ],
              ),
            ),
            const CountdownTimer(),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Servicios destacados',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildAmenityChip(Icons.pool, 'Alberca'),
            _buildAmenityChip(Icons.wifi, 'Wi-Fi Premium'),
            _buildAmenityChip(Icons.restaurant, 'Restaurante'),
            _buildAmenityChip(Icons.spa, 'Spa'),
            _buildAmenityChip(Icons.fitness_center, 'Gimnasio'),
            _buildAmenityChip(Icons.beach_access, 'Playa privada'),
          ],
        ),
      ],
    );
  }

  Widget _buildAmenityChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(text),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ubicación',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            'assets/images/fotohotel.jpg',
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          icon: const Icon(Icons.map),
          label: const Text('Cómo llegar'),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildSocialMediaSection() {
    return Column(
      children: [
        Text(
          'Síguenos',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.facebook, size: 30),
            ),
            //IconButton(
             // onPressed: () {},
              //icon: const Icon(Icons.instagram, size: 30),
            //),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.tiktok, size: 30),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSeeAllButton() {
    return FilledButton(
      onPressed: () {
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RoomsScreen(), // Navegación a RoomsScreen
        ),
      );
      },
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: const Text('Ver Todas las Habitaciones'),
    );
  }
}

// Widget temporal para el contador de oferta
class CountdownTimer extends StatelessWidget {
  const CountdownTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        '24:59:59',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}