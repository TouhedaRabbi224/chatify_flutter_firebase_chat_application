import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
//widget
import '../widgets/custom_input_field.dart';
import '../widgets/rounded_button.dart';
//provider
import '../providers/authentication_provider.dart';
//services
import '../services/navigation_services.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;
  late NavigationServices _navigation;

  final _loginFromKey = GlobalKey<FormState>();

  String? _email;
  String? _password;
  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationServices>();
    return buildUI();
  }

  Widget buildUI() {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.03,
        vertical: _deviceHeight * 0.02,
      ),
      height: _deviceHeight * 0.98,
      width: _deviceWidth * 0.97,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _pageTitle(),
          _logInForm(),
          SizedBox(
            height: _deviceHeight * 0.02,
          ),
          _logInButton(),
          SizedBox(
            height: _deviceHeight * 0.1,
          ),
          _registerAccountLink(),
        ],
      ),
    )));
  }

  Widget _pageTitle() {
    return Container(
      height: _deviceHeight * 0.10,
      child: Text(
        'Chatify',
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
    );
  }

  Widget _logInForm() {
    return Container(
      height: _deviceHeight * 0.34,
      child: Form(
          key: _loginFromKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextFromField(
                  onSaved: (_value) {
                    setState(() {
                      _email = _value;
                    });
                  },
                  hintText: 'Email',
                  regEx:
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+",
                  obscureText: false),
              SizedBox(
                height: _deviceHeight * 0.02,
              ),
              CustomTextFromField(
                  onSaved: (_value) {
                    setState(() {
                      _password = _value;
                    });
                  },
                  hintText: 'Password',
                  regEx: r".{8,}",
                  obscureText: true),
            ],
          )),
    );
  }

  Widget _logInButton() {
    return RoundedButton(
        name: 'LogIn',
        height: _deviceHeight * 0.070,
        width: _deviceWidth * 0.65,
        onPressed: () {
          if (_loginFromKey.currentState!.validate()) {
            _loginFromKey.currentState!.save();
            _auth.loginUsingEmailAndPassword(_email!, _password!);
          }
        });
  }

  Widget _registerAccountLink() {
    return InkWell(
        onTap: () => _navigation.navigateToRoute('/register'),
        child: Container(
            child: Text(
          "Don\'t have an account?",
          style: TextStyle(
            color: Colors.blueAccent,
          ),
        )));
  }
}
