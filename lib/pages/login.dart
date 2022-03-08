import 'package:bigsam_pos/main.dart';
import 'package:bigsam_pos/models/user.dart';
import 'package:bigsam_pos/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:bigsam_pos/global/auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    final users = await DatabaseHelper.instance.getUserbyUsername(data.name);
    return Future.delayed(loginTime).then((_) {
      if (users.isNotEmpty) {
        if (users[0].password != data.password) {
          userGlobal = users[0].name;
          return 'Password Salah';
        }
      } else {
        return 'User Tidak Ditemukan';
      }
      return '';
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      return '';
    });
  }

  @override
  Widget build(BuildContext context) {
    _checkDb();
    return FlutterLogin(
      // logo: 'assets/images/ecorp-lightblue.png',
      onLogin: _authUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const MyStatefulWidget(),
        ));
      },
      onRecoverPassword: _recoverPassword,
      userType: LoginUserType.name,
      userValidator: (value) {
        userGlobal = value;
        if (value!.isEmpty) {
          return 'Username tidak boleh kosong';
        }
        return null;
      },
      messages: LoginMessages(
        userHint: 'Username',
        passwordHint: 'Password',
      ),
    );
  }
}

_checkDb() async {
  final users = await DatabaseHelper.instance.getUserbyUsername('admin');
  if (users.isEmpty) {
    UserModel user = UserModel(
      name: 'admin',
      password: 'admin',
    );
    await DatabaseHelper.instance.insertUser(user);
  }
}
