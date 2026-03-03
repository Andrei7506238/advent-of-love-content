part of 'message_editor_cubit.dart';

class MessageEditorState {
  final Message message;

  const MessageEditorState({required this.message});

  MessageEditorState copyWith({
    Message? message,
  }) {
    return MessageEditorState(
      message: message ?? this.message,
    );
  }
}
