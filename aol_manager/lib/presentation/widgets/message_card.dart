import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aol_manager/data/models/message_model.dart';
import 'package:aol_manager/presentation/cubits/messages_cubit.dart';
import 'package:aol_manager/presentation/screens/image_search_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  final int? index;
  final VoidCallback? onDelete;

  const MessageCard({super.key, required this.message, required this.index, this.onDelete});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  late TextEditingController _controller;
  late String _imageUrl;
  Timer? _saveTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.message.content);
    _controller.addListener(_scheduleSave);
    _imageUrl = widget.message.image;
  }

  @override
  void didUpdateWidget(covariant MessageCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message != widget.message) {
      _controller.text = widget.message.content;
      _imageUrl = widget.message.image;
    }
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    _controller.removeListener(_scheduleSave);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final selectedUrl = await Navigator.push<String?>(
      context,
      MaterialPageRoute(builder: (_) => ImageSearchScreen(onImageSelected: (url) {})),
    );
    if (selectedUrl != null && selectedUrl.isNotEmpty && mounted) {
      setState(() => _imageUrl = selectedUrl);
      _scheduleSave();
    }
  }

  void _performSave() {
    final updated = widget.message.copyWith(content: _controller.text, image: _imageUrl);
    final messagesCubit = context.read<MessagesCubit>();
    if (widget.index == null || widget.index! < 0) {
      messagesCubit.addMessage(updated);
    } else {
      messagesCubit.updateMessage(widget.index!, updated);
    }
  }

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      _performSave();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : MediaQuery.of(context).size.height;
            final imageHeight = (_imageUrl.isNotEmpty ? availableHeight * 0.45 : availableHeight * 0.35).clamp(
              80.0,
              math.max(120.0, availableHeight),
            );

            // Use a scrollable ListView so the message editor can expand and
            // the card content can scroll when space is limited (keyboard open etc).
            final listHeight = availableHeight;
            final contentAreaHeight = math.max(120.0, listHeight - imageHeight - 120.0);

            return SizedBox(
              height: listHeight,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  if (_imageUrl.isNotEmpty)
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: imageHeight.toDouble(),
                            width: double.infinity,
                            child: Image.network(
                              _imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(color: Colors.grey[300], child: const Icon(Icons.broken_image)),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.white),
                                onPressed: () => _pickImage(),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () => setState(() => _imageUrl = ''),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: imageHeight.toDouble(),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[50],
                        ),
                        child: const Center(child: Icon(Icons.image, size: 48, color: Colors.grey)),
                      ),
                    ),

                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('MMMM dd, yyyy').format(widget.message.date),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),

                        // Give the text field a sizable area to edit within the
                        // scrollable list so it feels larger on small screens.
                        SizedBox(
                          height: contentAreaHeight,
                          child: TextField(
                            controller: _controller,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: widget.onDelete,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
