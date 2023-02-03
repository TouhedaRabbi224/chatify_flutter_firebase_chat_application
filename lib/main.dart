//packages

import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
//services
import './services/navigation_services.dart';
//providers
import './providers/authentication_provider.dart';
//pages
import './pages/splash_page.dart';
import './pages/login_page.dart';
import './pages/home_page.dart';
import './pages/register_page.dart';

void main() {
  runApp(SplashPage(
      key: UniqueKey(),
      onInitializeationComplete: (() {
        runApp(MyApp());
      })));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationProvider>(
          create: ((context) {
            return AuthenticationProvider();
          }),
        )
      ],
      child: MaterialApp(
        title: 'Chatify_Udemy',
        theme: ThemeData(
          backgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
          scaffoldBackgroundColor: Color.fromRGBO(36, 35, 49, 1.0),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
          ),
        ),
        navigatorKey: NavigationServices.navigatorKey,
        initialRoute: '/logIn',
        routes: {
          '/logIn': (BuildContext _context) => LogInPage(),
          '/register': (BuildContext _context) => RegisterPage(),
          '/homePage': (BuildContext _context) => HomePage(),
        },
      ),
    );
  }
}
