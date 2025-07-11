import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '/models/room_type.dart';
import 'booking_summary_screen.dart';

class BookingDateScreen extends StatefulWidget {

  final RoomType room;

  const BookingDateScreen({
    super.key,
    required this.room, //La hacemos requerida en el constructor
  });

  @override
  State<BookingDateScreen> createState() => _BookingDateScreenState();
}

class _BookingDateScreenState extends State<BookingDateScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  // El modo de selección inicia en 'toggledOn' para permitir al usuario empezar a seleccionar.
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona tus Fechas'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              locale: 'es_ES',
              firstDay: DateTime.now(),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              rangeSelectionMode: _rangeSelectionMode,
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(fontSize: 18.0),
              ),
              calendarStyle: CalendarStyle(
                rangeHighlightColor: Theme.of(context).colorScheme.primaryContainer,
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                rangeStartDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                rangeEndDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              // logica de este lado
              onRangeSelected: (start, end, focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                  _rangeStart = start;
                  _rangeEnd = end;
                });
              },
              // Permite al usuario limpiar la selección tocando el día de inicio de nuevo
              onDaySelected: (selectedDay, focusedDay) {
                if (_rangeStart != null && _rangeEnd == null) {
                  // Si ya hay un inicio pero no un fin, y se toca un día anterior, se reinicia.
                  if (selectedDay.isBefore(_rangeStart!)) {
                    setState(() {
                      _rangeStart = selectedDay;
                      _rangeEnd = null;
                    });
                  }
                }
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DateInfo(title: 'Check-in', date: _rangeStart),
                    const Icon(Icons.arrow_forward),
                    DateInfo(title: 'Check-out', date: _rangeEnd),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: (_rangeStart != null && _rangeEnd != null)
                        ? () {
                            // Navegar a la pantalla de resumen de compra
                            // Navegamos a la pantalla de resumen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingSummaryScreen(
                                  // Y le pasamos TODA la información que necesita:
                                  room: widget.room,        // La habitación que recibimos
                                  startDate: _rangeStart!,  // La fecha de inicio que seleccionamos
                                  endDate: _rangeEnd!,      // La fecha de fin que seleccionamos
                                ),
                              ),
                            );
                            print('Fechas seleccionadas: $_rangeStart - $_rangeEnd');
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Confirmar Fechas', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Widget auxiliar para mostrar la información de la fecha
class DateInfo extends StatelessWidget {
  final String title;
  final DateTime? date;

  const DateInfo({super.key, required this.title, this.date});

  @override
  Widget build(BuildContext context) {
    final formattedDate = date != null ? '${date!.day} ${_getMonthAbbr(date!.month)}' : '--';

    return Column(
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: 4),
        Text(formattedDate, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _getMonthAbbr(int month) {
    const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return months[month - 1];
  }
}