//packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//pages
import '../services/navigation_services.dart';
import '../services/media_service.dart';
import '../services/cloud_storage_services.dart';
import '../services/database_services.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onInitializeationComplete;
  const SplashPage({
    required Key key,
    required this.onInitializeationComplete,
  }) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4)).then(
      (_) {
        _setUp().then(
          (_) => widget.onInitializeationComplete(),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatify',
      theme: ThemeData(
          backgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
          scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1.0)),
      home: Scaffold(
          body: Center(
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage('assets/images/logo.png'))),
        ),
      )),
    );
  }

  Future<void> _setUp() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    _registerServices();
  }

  void _registerServices() {
    GetIt.instance.registerSingleton<NavigationServices>(NavigationServices());
    GetIt.instance.registerSingleton<MediaService>(MediaService());
    GetIt.instance
        .registerSingleton<CloudStorageService>(CloudStorageService());
    GetIt.instance.registerSingleton<DatabaseService>(DatabaseService());
  }
}
