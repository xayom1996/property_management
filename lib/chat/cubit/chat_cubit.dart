import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:property_management/app/bloc/app_bloc.dart';
import 'package:property_management/app/bloc/app_state.dart';
import 'package:property_management/app/utils/utils.dart';
import 'package:property_management/chat/models/chat.dart';
import 'package:property_management/chat/models/message_chat.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({required AppBloc appBloc})
      : _appBloc = appBloc,
        super(ChatState()) {
          getListChats();
          _appBlocSubscription = _appBloc.stream.listen(
                (state){
              if (state.status != AppStatus.loading) {
                getListChats();
              }
            });
        }

  late final AppBloc _appBloc;
  late StreamSubscription _appBlocSubscription;

  void getListChats() async {
    emit(state.copyWith(
      status: ChatStateStatus.loading
    ));

    List<Chat> chats = await _appBloc.fireStoreService.getListChats(_appBloc.state.user);
    chats.sort((a, b) {
      if (a.lastMessage != null && b.lastMessage != null) {
        return b.lastMessage!.timestamp.compareTo(a.lastMessage!.timestamp);
      }

      if (a.lastMessage == null && b.lastMessage == null) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }

      return a.lastMessage != null ? 0 : 1;
    });

    bool newMessages = chats.where((element) => element.unreadMessages != 0).isNotEmpty;

    emit(state.copyWith(
      chats: chats,
      status: ChatStateStatus.success,
      newMessages: newMessages,
    ));
  }

  // UploadTask uploadFile(File image, String fileName) {
  //   Reference reference = firebaseStorage.ref().child(fileName);
  //   UploadTask uploadTask = reference.putFile(image);
  //   return uploadTask;
  // }
  //
  // Future<void> updateDataFirestore(String collectionPath, String docPath, Map<String, dynamic> dataNeedUpdate) {
  //   return firebaseFirestore.collection(collectionPath).doc(docPath).update(dataNeedUpdate);
  // }

  Chat? getChat(String chatId) {
    int index = state.chats.lastIndexWhere((element) => element.chatId == chatId);
    if (index == -1) {
      return null;
    }
    return state.chats[index];
  }

  bool showNotification(Map message) {
    String chatId = getChatId(message['idFrom'], message['idTo']);

    List<Chat> chats = state.chats;
    int index = chats.lastIndexWhere((element) => element.chatId == chatId);

    if (chats[index].lastMessage != null
        && int.parse(chats[index].lastMessage!.timestamp) >= int.parse(message['timestamp'])) {
      return false;
    }
    return true;
  }

  void getNewMessage(Map message) {
    String chatId = getChatId(message['idFrom'], message['idTo']);
    if (state.currentChatId == chatId) {
      return;
    }

    emit(state.copyWith(
        status: ChatStateStatus.loading
    ));

    List<Chat> chats = state.chats;
    int index = chats.lastIndexWhere((element) => element.chatId == getChatId(message['idFrom'], message['idTo']));
    MessageChat newMessage = MessageChat(
      idFrom: message['idFrom'],
      idTo: message['idTo'],
      read: false,
      type: int.parse(message['type']),
      content: message['content'],
      timestamp: message['timestamp'],
    );

    if (chats[index].lastMessage == null || chats[index].lastMessage!.timestamp != newMessage.timestamp) {
      chats[index].unreadMessages = chats[index].unreadMessages + 1;
    }
    chats[index].lastMessage = newMessage;

    bool newMessages = state.newMessages;

    chats.sort((a, b) {
      if (a.lastMessage != null && b.lastMessage != null) {
        return b.lastMessage!.timestamp.compareTo(a.lastMessage!.timestamp);
      }

      if (a.lastMessage == null && b.lastMessage == null) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }

      return a.lastMessage != null ? 0 : 1;
    });

    if (chats[index].unreadMessages == 1) {
      newMessages = true;
    }

    emit(state.copyWith(
      status: ChatStateStatus.success,
      chats: chats,
      newMessages: newMessages,
    ));
  }

  void updateLastMessage(String chatId, MessageChat messageChat) {
    emit(state.copyWith(
        status: ChatStateStatus.loading
    ));

    List<Chat> chats = state.chats;
    int index = chats.lastIndexWhere((element) => element.chatId == chatId);
    chats[index].lastMessage = messageChat;

    chats.sort((a, b) {
      if (a.lastMessage != null && b.lastMessage != null) {
        return b.lastMessage!.timestamp.compareTo(a.lastMessage!.timestamp);
      }

      if (a.lastMessage == null && b.lastMessage == null) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }

      return a.lastMessage != null ? 0 : 1;
    });

    bool newMessages = chats.where((element) => element.unreadMessages != 0).isNotEmpty;

    emit(state.copyWith(
      status: ChatStateStatus.success,
      chats: chats,
      newMessages: newMessages,
    ));
  }

  Stream<QuerySnapshot> getChatStream(String chatId, int limit) {
    return _appBloc.fireStoreService.getChatStream(chatId, limit);
  }

  void sendMessage(String content, int type, String chatId, String currentUserName, String currentUserId, String peerId, String fileUrl) {
    _appBloc.fireStoreService.sendMessage(content, type, chatId, currentUserName, currentUserId, peerId, fileUrl);
  }

  void readMessages(String chatId) {
    emit(state.copyWith(
        status: ChatStateStatus.loading
    ));

    _appBloc.fireStoreService.readMessages(chatId);

    List<Chat> chats = state.chats;
    int index = chats.lastIndexWhere((element) => element.chatId == chatId);
    chats[index].unreadMessages = 0;

    bool newMessages = chats.where((element) => element.unreadMessages != 0).isNotEmpty;

    emit(state.copyWith(
      status: ChatStateStatus.success,
      chats: chats,
      newMessages: newMessages,
    ));
  }

  void changeChatId(String chatId) {
    emit(state.copyWith(
      currentChatId: chatId
    ));
  }
}
