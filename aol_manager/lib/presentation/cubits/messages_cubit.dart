import 'package:bloc/bloc.dart';
import 'package:aol_manager/data/models/message_model.dart';
import 'package:aol_manager/data/repositories/file_repository.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  final FileRepository fileRepository;

  MessagesCubit({required this.fileRepository}) : super(const MessagesState(messages: [])) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final messages = await fileRepository.loadMessages();
      emit(state.copyWith(messages: messages));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> addMessage(Message message) async {
    try {
      final messages = [...state.messages, message];
      await fileRepository.saveMessages(messages);
      emit(state.copyWith(messages: messages, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> updateMessage(int index, Message message) async {
    try {
      final messages = [...state.messages];
      messages[index] = message;
      await fileRepository.saveMessages(messages);
      emit(state.copyWith(messages: messages, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> deleteMessage(int index) async {
    try {
      final messages = [...state.messages];
      messages.removeAt(index);
      await fileRepository.saveMessages(messages);
      emit(state.copyWith(messages: messages, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> importMessages(List<Message> importedMessages) async {
    try {
      final messages = [...state.messages, ...importedMessages];
      await fileRepository.saveMessages(messages);
      emit(state.copyWith(messages: messages, error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Import messages from an external JSON file using the repository,
  /// then merge and persist them into the current state.
  /// Returns the number of messages imported.
  Future<int> importFromFile() async {
    try {
      final imported = await fileRepository.importMessages();
      await importMessages(imported);
      return imported.length;
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
      rethrow;
    }
  }

  Future<void> exportMessages() async {
    try {
      await fileRepository.exportMessages(state.messages);
      emit(state.copyWith(error: null));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
