import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project1/user_account/login.dart';
import 'package:project1/user_account/login_page.dart';
import 'package:project1/user_account/signUp.dart';
import 'package:project1/user_account/signup_signin.dart';

class AuthPage extends StatefulWidget {
  bool isLogin;
  static const routName = '/AuthPage';
  AuthPage({Key? key, required this.isLogin}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as AuthPage;
    bool isLogin = args.isLogin;
    void toggle() {
      setState(() {
        isLogin = !isLogin;
        print(isLogin);
      });
    }

    return isLogin
        ? LoginPage(onclickedSignIn: toggle)
        : Sign_up_in(onclickedSignUp: toggle);
  }
}
