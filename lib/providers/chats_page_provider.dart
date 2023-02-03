import 'dart:async';
//packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

//services
import '../services/database_services.dart';
//providers
import '../providers/authentication_provider.dart';

//models
import '../models/chat.dart';
import '../models/chat_message.dart';
import '../models/chat_user.dart';

class ChatsPageProvider extends ChangeNotifier {
  AuthenticationProvider _auth;

  late DatabaseService _db;
  List<Chat>? chats;

  late StreamSubscription _chatStream;

  ChatsPageProvider(this._auth) {
    _db = GetIt.instance.get<DatabaseService>();
    getChats();
  }

  @override
  void dispose() {
    _chatStream.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      _chatStream =
          _db.getChatsForUser(_auth.user.uid).listen((_snapShot) async {
        chats = await Future.wait(
          _snapShot.docs.map(
            (_d) async {
              Map<String, dynamic> _chatData =
                  _d.data() as Map<String, dynamic>;

              //get user in chat
              List<ChatUser> _members = [];
              for (var _uid in _chatData["members"]) {
                DocumentSnapshot _userSnapshot = await _db.getUser(_uid);
                Map<String, dynamic> _userData =
                    _userSnapshot.data() as Map<String, dynamic>;
                _userData["uid"] = _userSnapshot.id;
                _members.add(ChatUser.fromJSON(_userData));
              }

              //Get Last message for chat
              List<ChatMessage> _messages = [];
              QuerySnapshot _chatMessage =
                  await _db.getLastMessageForChat(_d.id);
              if (_chatMessage.docs.isNotEmpty) {
                Map<String, dynamic> _messageData =
                    _chatMessage.docs.first.data()! as Map<String, dynamic>;
                ChatMessage _message = ChatMessage.fromJson(_messageData);
                _messages.add(_message);
              }

              //return chat instance
              return Chat(
                  uid: _d.id,
                  currentUserId: _auth.user.uid,
                  activity: _chatData["is_activity"],
                  group: _chatData["is_group"],
                  members: _members,
                  messages: _messages);
            },
          ).toList(),
        );
        notifyListeners();
      });
    } catch (e) {
      print('Error Getting Chats');
      print(e);
    }
  }
}
