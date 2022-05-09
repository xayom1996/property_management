part of 'chat_cubit.dart';

enum ChatStateStatus {
  initial,
  loading,
  valid,
  invalid,
  success,
  error,
}

class ChatState extends Equatable {
  const ChatState({
    this.chats = const [],
    this.status = ChatStateStatus.initial,
  });

  final List<Chat> chats;
  final ChatStateStatus status;

  @override
  List<Object> get props => [chats, status];

  ChatState copyWith({
    List<Chat>? chats,
    ChatStateStatus? status,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      status: status ?? this.status,
    );
  }
}

