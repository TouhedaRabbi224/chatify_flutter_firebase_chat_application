//packages

import 'package:chatify_udemy/models/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

//providers
import '../providers/authentication_provider.dart';
import '../providers/chats_page_provider.dart';

//services
import '../services/navigation_services.dart';

//widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_list_view.dart';

//page
import '../pages/chat_page.dart';

//models
import '../models/chat.dart';
import '../models/chat_user.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;
  late NavigationServices _navigation;

  late ChatsPageProvider _PageProvider;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationServices>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(
          create: ((_) => ChatsPageProvider(_auth)),
        )
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(builder: (BuildContext _context) {
      _PageProvider = _context.watch<ChatsPageProvider>();
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopBar(
              'Chats',
              primaryAction: IconButton(
                icon: Icon(Icons.logout),
                color: Color.fromRGBO(0, 82, 218, 1.0),
                onPressed: () {
                  _auth.logout();
                },
              ),
            ),
            _chatList(),
          ],
        ),
      );
    });
  }

  Widget _chatList() {
    List<Chat>? _chats = _PageProvider.chats;

    return Expanded(
        child: (() {
      if (_chats != null) {
        if (_chats.length != 0) {
          return ListView.builder(
              itemCount: (_chats.length),
              itemBuilder: (BuildContext _context, int _index) {
                return _chatTile(_chats[_index]);
              });
        } else {
          return Center(
            child: Text(
              "No Chats Found",
              style: TextStyle(color: Colors.white),
            ),
          );
        }
      } else {
        return Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      }
    }()));
  }

  Widget _chatTile(Chat _chat) {
    List<ChatUser>? _recepients = _chat.recepients();
    bool _isActive = _recepients.any(
      (_d) => _d.recentActive(),
    );
    String _subTitleText = " ";
    if (_chat.messages.isNotEmpty) {
      _subTitleText = _chat.messages.first.type != MessageType.TEXT
          ? "Media Attachment"
          : _chat.messages.first.content;
    }
    return CustomListViewTileWithActivity(
      height: _deviceHeight * 0.10,
      title: _chat.title(),
      subtitle: _subTitleText,
      imagePath: _chat.imageUrl(),
      isActive: _isActive,
      isActivity: _chat.activity,
      onTap: () {
        _navigation.navigateToPage(ChatPage(
          chat: _chat,
        ));
      },
    );
  }
}
