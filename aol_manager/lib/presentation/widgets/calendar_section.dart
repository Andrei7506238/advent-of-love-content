import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:aol_manager/data/models/message_model.dart';

class CalendarSection extends StatelessWidget {
  final DateTime focusedDay;
  final CalendarFormat calendarFormat;
  final void Function(DateTime, DateTime) onDaySelected;
  final void Function(CalendarFormat) onFormatChanged;
  final List<Message> Function(DateTime) eventLoader;
  final DateTime? selectedDay;

  const CalendarSection({
    required this.focusedDay,
    required this.calendarFormat,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.eventLoader,
    this.selectedDay,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: SingleChildScrollView(
            child: TableCalendar<Message>(
              firstDay: DateTime(2020, 1, 1),
              lastDay: DateTime(2030, 12, 31),
              focusedDay: focusedDay,
              calendarFormat: calendarFormat,
              selectedDayPredicate: (day) => isSameDay(day, selectedDay),
              eventLoader: eventLoader,
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, date, focusedDay) {
                  return Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Text(
                      '${date.day}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  );
                },
                markerBuilder: (context, date, eventsForDay) {
                  final eventsList = eventsForDay;
                  final hasText = eventsList.any((m) => m.content.trim().isNotEmpty);
                  final hasImage = eventsList.any((m) => m.image.trim().isNotEmpty);

                  if (!hasText && !hasImage) return const SizedBox.shrink();

                  return Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasText)
                          Container(width: 6, height: 6, margin: const EdgeInsets.symmetric(horizontal: 1), decoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle)),
                        if (hasImage)
                          Container(width: 6, height: 6, margin: const EdgeInsets.symmetric(horizontal: 1), decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle)),
                      ],
                    ),
                  );
                },
              ),
              onDaySelected: onDaySelected,
              onFormatChanged: onFormatChanged,
              calendarStyle: const CalendarStyle(
                isTodayHighlighted: false,
                selectedDecoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
