import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aol_manager/data/models/message_model.dart';
import 'package:aol_manager/presentation/cubits/messages_cubit.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:aol_manager/presentation/widgets/message_card.dart';
import 'package:aol_manager/presentation/widgets/calendar_section.dart';
import 'package:aol_manager/presentation/widgets/selected_day_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  Map<DateTime, List<Message>> _eventsFromMessages(List<Message> messages) {
    final map = <DateTime, List<Message>>{};
    for (final m in messages) {
      final day = _normalize(m.date);
      map.putIfAbsent(day, () => []);
      map[day]!.add(m);
    }
    return map;
  }

  // inline editor removed; MessageCard handles editing

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // nothing to dispose for inline editor
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Love Messages'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportMessages(context),
            tooltip: 'Export JSON',
          ),
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () => _importMessages(context),
            tooltip: 'Import JSON',
          ),
        ],
      ),
      body: BlocBuilder<MessagesCubit, MessagesState>(
        builder: (context, state) {
          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          }

          final events = _eventsFromMessages(state.messages);
          final List<Message> selected = _selectedDay == null
              ? <Message>[]
              : (events[_normalize(_selectedDay!)] ?? <Message>[]);

          List<Message> eventLoader(DateTime day) => events[_normalize(day)] ?? [];

          final isDesktop = MediaQuery.of(context).size.width >= 800;

          // Single-column mobile layout
          if (!isDesktop) {
            return Column(
              children: [
                CalendarSection(
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) => setState(() => _calendarFormat = format),
                  eventLoader: eventLoader,
                ),
                SelectedDayHeader(selectedDay: _selectedDay),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (_selectedDay == null) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.favorite_outline, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'Select a date to view or edit the message',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      }

                      if (selected.isEmpty) {
                        final newMsg = Message(date: _selectedDay!, content: '', image: '');
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MessageCard(message: newMsg, index: null, onDelete: null),
                        );
                      }

                      final message = selected.first;
                      final globalIndex = state.messages.indexOf(message);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MessageCard(
                          message: message,
                          index: globalIndex,
                          onDelete: () => _deleteMessage(context, globalIndex, message),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          // Desktop: two-column layout (calendar left, editor right)
          return Row(
            children: [
              SizedBox(
                width: 360,
                child: Column(
                  children: [
                    CalendarSection(
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      onFormatChanged: (format) => setState(() => _calendarFormat = format),
                      eventLoader: eventLoader,
                    ),
                    const Divider(height: 1),
                    SelectedDayHeader(selectedDay: _selectedDay),
                  ],
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (_selectedDay == null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.favorite_outline, size: 96, color: Colors.grey[400]),
                            const SizedBox(height: 24),
                            Text(
                              'Select a date to view or edit the message',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    if (selected.isEmpty) {
                      final newMsg = Message(date: _selectedDay!, content: '', image: '');
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: MessageCard(message: newMsg, index: null, onDelete: null),
                      );
                    }

                    final message = selected.first;
                    final globalIndex = state.messages.indexOf(message);
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: MessageCard(
                        message: message,
                        index: globalIndex,
                        onDelete: () => _deleteMessage(context, globalIndex, message),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // navigation to full-screen editor removed; editor is inline

  void _deleteMessage(BuildContext context, int index, Message message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message?'),
        content: Text('Delete the message from ${DateFormat('MMM dd, yyyy').format(message.date)}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<MessagesCubit>().deleteMessage(index);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _exportMessages(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Messages'),
        content: const Text('Export all messages to a JSON file that you can save or share.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<MessagesCubit>().exportMessages();
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Messages exported successfully')));
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _importMessages(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Messages'),
        content: const Text('Import messages from a JSON file. Existing messages will be preserved.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
                try {
                  final messagesCubit = context.read<MessagesCubit>();
                  final count = await messagesCubit.importFromFile();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Imported $count message(s) successfully')));
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }
}
