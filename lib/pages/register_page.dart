//packages
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

//services

import '../services/media_service.dart';
import '../services/database_services.dart';
import '../services/cloud_storage_services.dart';
import '../services/navigation_services.dart';

//widgets
import '../widgets/custom_input_field.dart';
import '../widgets/rounded_button.dart';
import '../widgets/rounded_images.dart';

//Providers
import '../providers/authentication_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late DatabaseService _db;
  late CloudStorageService _cloudStoregae;

  late NavigationServices _navigation;

  PlatformFile? _profileImage;

  final _registerFormKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _password;

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthenticationProvider>(context);
    _db = GetIt.instance.get<DatabaseService>();
    _cloudStoregae = GetIt.instance.get<CloudStorageService>();
    _navigation = GetIt.instance.get<NavigationServices>();

    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
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
            _profileImageField(),
            SizedBox(
              height: _deviceHeight * 0.01,
            ),
            _registerForm(),
            SizedBox(
              height: _deviceHeight * 0.03,
            ),
            _registerButton(),
          ],
        ),
      ),
    );
  }

  Widget _profileImageField() {
    return GestureDetector(
      onTap: (() {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then(
          (_file) {
            setState(
              () {
                _profileImage = _file;
              },
            );
          },
        );
      }),
      child: () {
        if (_profileImage != null) {
          return RoundedImageFille(
              key: UniqueKey(),
              image: _profileImage!,
              size: _deviceHeight * 0.15);
        } else {
          return RoundedImageNetwork(
            key: UniqueKey(),
            imagePath:
                "https://www.eventstodayz.com/wp-content/uploads/2018/04/cute-profile-pic-2018.jpg",
            size: _deviceHeight * 0.15,
          );
          //}
        }
      }(),
    );
  }

  Widget _registerForm() {
    return Container(
      height: _deviceHeight * 0.35,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFromField(
              onSaved: (_value) {
                setState(() {
                  _name = _value;
                });
              },
              regEx: r'.{8}',
              hintText: 'Name',
              obscureText: false,
            ),
            CustomTextFromField(
              onSaved: (_value) {
                setState(() {
                  _email = _value;
                });
              },
              regEx:
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+",
              hintText: 'Email',
              obscureText: false,
            ),
            CustomTextFromField(
              onSaved: (_value) {
                _password = _value;
              },
              regEx: r'.{8}',
              hintText: 'Password',
              obscureText: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return RoundedButton(
      name: "Register",
      height: _deviceHeight * 0.070,
      width: _deviceWidth * 0.65,
      onPressed: () async {
        if (_registerFormKey.currentState!.validate() &&
            _profileImage != null) {
          _registerFormKey.currentState!.save();
          String? _uid = await _auth.registerUserUsingEmailAndPassword(
              _email!, _password!);
          String? _image = await _cloudStoregae.saveUserImageToStorage(
              _uid!, _profileImage!);
          await _db.CreateUser(_uid, _email!, _image!, _name!);
          await _auth.logout();
          await _auth.loginUsingEmailAndPassword(_email!, _password!);
          //_navigation.goBack();
        }
      },
    );
  }
}
