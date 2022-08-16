import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plastic/components/my_raised_button.dart';
import 'package:plastic/extensions/locale_keys.dart';
import 'package:plastic/service/auth_service.dart';
import 'package:plastic/view/register_view.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isLoading = false;

  Future<void> _signInAnonymously() async {
    try {
      setState(() {
        _isLoading = true;
      });
      Provider.of<AuthService>(context,listen: false).signInAnonymously();
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.code);
    } catch (e) {
      _showErrorDialog(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _signInWithGoogle() async {
    try {
      setState(() {
        _isLoading = true;
      });
      Provider.of<AuthService>(context,listen: false).signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.code);
    } catch (e) {
      _showErrorDialog(e.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              Provider.of<AuthService>(context,listen: false).SignOut();
              print('logout tıklandı');
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                      image: AssetImage("assets/images/3.png",)
                    )
                  ),
                ),


                SizedBox(height: 60,),
                Text('Plastik', style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                MyRaisedButton(
                  color: Colors.red,
                  child: Text(LocaleKeys.login_view_button_1.tr(),),
                  onPressed: _isLoading ? null : _signInAnonymously,
                ),
                SizedBox(height: 10),
                MyRaisedButton(
                  color: Colors.yellow,
                  child: Text(LocaleKeys.login_view_button_2.tr(),),
                  onPressed: _isLoading
                      ? null
                      : () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterView()));
                  },
                ),
                SizedBox(height: 10),
                MyRaisedButton(
                  color: Colors.lightBlueAccent,
                  child: Text(LocaleKeys.login_view_button_3.tr()),
                  onPressed: _isLoading ? null : _signInWithGoogle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showErrorDialog(String errorText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.login_view_error.tr()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(errorText),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(LocaleKeys.login_view_ok.tr()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
