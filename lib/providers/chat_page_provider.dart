import 'dart:async';
//packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

//services
import '../services/cloud_storage_services.dart';
import '../services/database_services.dart';
import '../services/media_service.dart';
import '../services/navigation_services.dart';

//providers
import '../providers/authentication_provider.dart';

//models
import '../models/chat_message.dart';

class ChatPageProvider extends ChangeNotifier {
  late DatabaseService _db;
  late CloudStorageService _storage;
  late MediaService _media;
  late NavigationServices _navigation;

  AuthenticationProvider _auth;
  ScrollController _messageListViewController;

  String _chatId;
  List<ChatMessage>? messages;

  late StreamSubscription _messagesStrem;
  late StreamSubscription _keyboardVisibilityStream;
  late KeyboardVisibilityController _keyboardVisibilityController;

  String? _message;

  String get message {
    return message;
  }

  void set message(String _value) {
    _message = _value;
  }

  ChatPageProvider(this._chatId, this._auth, this._messageListViewController) {
    _db = GetIt.instance.get<DatabaseService>();
    _media = GetIt.instance.get<MediaService>();
    _storage = GetIt.instance.get<CloudStorageService>();
    _navigation = GetIt.instance.get<NavigationServices>();
    _keyboardVisibilityController = KeyboardVisibilityController();
    ListenToMessage();
    ListenToKeyboardChanges();
  }

  @override
  void dispose() {
    _messagesStrem.cancel();
    super.dispose();
  }

  void ListenToMessage() {
    try {
      _messagesStrem = _db.streamMessageForChat(_chatId).listen((_snapShot) {
        List<ChatMessage> _messages = _snapShot.docs.map(
          (_m) {
            Map<String, dynamic> _messagesData =
                _m.data() as Map<String, dynamic>;
            return ChatMessage.fromJson(_messagesData);
          },
        ).toList();
        messages = _messages;
        notifyListeners();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_messageListViewController.hasClients) {
            _messageListViewController
                .jumpTo(_messageListViewController.position.maxScrollExtent);
          }
        });
      });
    } catch (e) {
      print(e);
    }
  }

  void ListenToKeyboardChanges() {
    _keyboardVisibilityStream =
        _keyboardVisibilityController.onChange.listen((_event) {
      _db.updateChatData(_chatId, {"is_activity ": _event});
    });
  }

  void sendTextMessage() {
    if (_message != null) {
      ChatMessage _messageToSend = ChatMessage(
          senderID: _auth.user.uid,
          type: MessageType.TEXT,
          content: _message!,
          sentTime: DateTime.now());
      _db.addMessageForChat(_chatId, _messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? _file = await _media.pickImageFromLibrary();
      if (_file != null) {
        String? _downloadUrl = await _storage.saveChatImageToStorage(
            _chatId, _auth.user.uid, _file);
        ChatMessage _messageToSend = ChatMessage(
            content: _downloadUrl!,
            senderID: _auth.user.uid,
            type: MessageType.IMAGE,
            sentTime: DateTime.now());
        _db.addMessageForChat(_chatId, _messageToSend);
      }
    } catch (e) {
      print("Error sending Image Message");
    }
  }

  void deleteChat() {
    goBack();
    _db.deleteChat(_chatId);
  }

  void goBack() {
    _navigation.goBack();
  }
}
