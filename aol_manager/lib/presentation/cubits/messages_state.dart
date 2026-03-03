part of 'messages_cubit.dart';

class MessagesState {
  final List<Message> messages;
  final String? error;

  const MessagesState({
    required this.messages,
    this.error,
  });

  MessagesState copyWith({
    List<Message>? messages,
    String? error,
  }) {
    return MessagesState(
      messages: messages ?? this.messages,
      error: error,
    );
  }
}
