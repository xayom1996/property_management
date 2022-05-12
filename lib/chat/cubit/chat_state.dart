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
    this.newMessages = false,
    this.status = ChatStateStatus.initial,
  });

  final List<Chat> chats;
  final bool newMessages;
  final ChatStateStatus status;

  @override
  List<Object> get props => [chats, status, newMessages];

  ChatState copyWith({
    List<Chat>? chats,
    ChatStateStatus? status,
    bool? newMessages,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      status: status ?? this.status,
      newMessages: newMessages ?? this.newMessages,
    );
  }
}

