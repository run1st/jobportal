import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project1/user_account/login.dart';
import 'package:project1/user_account/login_page.dart';
import 'package:project1/user_account/signUp.dart';
import 'package:project1/user_account/signup_signin.dart';

class AuthPage extends StatefulWidget {
  static const routName = '/AuthPage';
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  void toggle() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginPage(onclickedSignIn: toggle)
        : Sign_up_in(onclickedSignUp: toggle);
  }
}
