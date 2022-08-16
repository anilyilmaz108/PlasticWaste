import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plastic/service/auth_service.dart';
import 'package:plastic/view/base_view.dart';
import 'package:plastic/view/intro_view.dart';
import 'package:provider/provider.dart';


class Beginning extends StatefulWidget {
  @override
  _BeginningState createState() => _BeginningState();
}

class _BeginningState extends State<Beginning> {
  bool isLogged = true;
  @override
  void initState() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        setState(() {
          isLogged = false;
        });

      } else {
        print('User is signed in!');
        setState(() {
          isLogged = true;
        });

      }

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: Provider.of<AuthService>(context,listen: false).authStatus(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            return snapshot.data != null ? BaseView() : IntroView();
          }
          else{
            return SizedBox(
              width: 300,
              height: 300,
              child: CircularProgressIndicator(),
            );
          }
        }
    );
  }
}
