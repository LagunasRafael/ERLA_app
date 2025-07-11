import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/models/room_type.dart';
import 'payment_screen.dart';

class BookingSummaryScreen extends StatelessWidget {
  final RoomType room;
  final DateTime startDate;
  final DateTime endDate;

  const BookingSummaryScreen({
    super.key,
    required this.room,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    // Logica del calculo
    final numberOfNights = endDate.difference(startDate).inDays;
    final subtotal = room.pricePerNight * numberOfNights;
    // Usamos un impuesto de ejemplo del 19% (16% IVA)
    //final taxes = subtotal * 0.19;
    final total = subtotal;

    // Formateador de fecha para que se vea más profesional (ej: "jueves, 26 de junio")
    final DateFormat formatter = DateFormat('EEEE, d \'de\' MMMM', 'es_ES');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirma tu Estancia'),
        centerTitle: true,
      ),
      // Usamos un Column dentro de un SingleChildScrollView para evitar desbordamiento en pantallas pequeñas
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tarjeta de la hanitacion seleccionada
              Text('Tu Habitación', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Row(
                  children: [
                    Image.asset(
                      room.imageUrls.first,
                      width: 120,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(room.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(room.shortDescription, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Divider(height: 40),

              // seccion de fechas
              Text('Fechas', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.calendar_today_outlined),
                title: const Text('Check-in'),
                trailing: Text(formatter.format(startDate), style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Check-out'),
                trailing: Text(formatter.format(endDate), style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const Icon(Icons.night_shelter_outlined),
                title: const Text('Total de Noches'),
                trailing: Text('$numberOfNights noches', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 40),

              // Seccion de precios
              Text('Desglose de Precio', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              PriceRow(label: '$numberOfNights noches x \$${room.formattedPricePerNight}', amount: subtotal),
              const SizedBox(height: 8),
              //PriceRow(label: 'Impuestos y tarifas (19%)', amount: taxes),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              PriceRow(label: 'Total a Pagar', amount: total, isTotal: true),
            ],
          ),
        ),
      ),
      //Boton flotante en la parte superior
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: FilledButton(
          onPressed: () {
            //Navegar a la pantalla final de 'Datos del Huésped y Pago'
            //LÓGICA DE NAVEGACIÓN AQUÍ ---
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            // Le pasamos toda la información que necesita la siguiente pantalla
            room: room,
            startDate: startDate,
            endDate: endDate,
          ),
        ),
      );
          },
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Continuar al Pago', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

// Widget auxiliar para mostrar las filas de precios y no repetir código.
class PriceRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;

  const PriceRow({
    super.key,
    required this.label,
    required this.amount,
    this.isTotal = false,
  });

  // getter para el formato de comas
  String get formattedPricePerNight {
    return NumberFormat.currency(
      locale: 'es_MX', 
      symbol: '',            // Quitamos el símbolo 
      decimalDigits: 2,      // Siempre 2 decimales
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final style = isTotal
        ? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyLarge;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text('\$${amount.toStringAsFixed(2)} MXN', style: style),
      ],
    );
  }
}