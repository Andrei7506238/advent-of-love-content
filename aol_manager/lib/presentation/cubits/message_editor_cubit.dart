import 'package:bloc/bloc.dart';
import 'package:aol_manager/data/models/message_model.dart';

part 'message_editor_state.dart';

class MessageEditorCubit extends Cubit<MessageEditorState> {
  MessageEditorCubit()
      : super(MessageEditorState(
          message: Message(
            date: DateTime.now(),
            content: '',
            image: '',
          ),
        ));

  void setDate(DateTime date) {
    emit(state.copyWith(
      message: state.message.copyWith(date: date),
    ));
  }

  void setContent(String content) {
    emit(state.copyWith(
      message: state.message.copyWith(content: content),
    ));
  }

  void setImage(String imageUrl) {
    emit(state.copyWith(
      message: state.message.copyWith(image: imageUrl),
    ));
  }

  void setMessage(Message message) {
    emit(state.copyWith(message: message));
  }

  void reset() {
    emit(MessageEditorState(
      message: Message(
        date: DateTime.now(),
        content: '',
        image: '',
      ),
    ));
  }

  bool isValid() {
    return state.message.content.isNotEmpty && state.message.image.isNotEmpty;
  }
}
