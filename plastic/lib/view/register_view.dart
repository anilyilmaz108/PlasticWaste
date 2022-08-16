import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:plastic/extensions/locale_keys.dart';
import 'package:plastic/service/auth_service.dart';
import 'package:plastic/service/image_service.dart';
import 'package:plastic/view/beginning.dart';
import 'package:provider/provider.dart';


enum FormStatus { signIn, register, reset }

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _obscure = true;
  String? userName;
  File? file;
  FirebaseStorage storage = FirebaseStorage.instance;
  final _signInFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();

  @override

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();

  void _toggle() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  Future<void> _refresh(){
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.register_view_refresh_title_1.tr()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(LocaleKeys.register_view_refresh_title_2.tr()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(LocaleKeys.register_view_refresh_title_3.tr()),
              onPressed: () {
                setState(() {
                  file = ImageService.file;
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  FormStatus _formStatus = FormStatus.signIn;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: _formStatus == FormStatus.signIn
                ? buildSignInForm()
                : _formStatus == FormStatus.register
                    ? buildRegisterForm()
                    : buildResetForm(),
          ),
        ),
      ),
    );
  }

  Widget buildSignInForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _signInFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.register_view_sign_in_title_1.tr(),
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _emailController,
              validator: (value) {
                if (!EmailValidator.validate(value!)) {
                  return LocaleKeys.register_view_sign_in_title_2.tr();
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: LocaleKeys.register_view_sign_in_title_3.tr(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _passwordController,
              validator: (value) {
                if(value!=null){
                  if (value.length < 6) {
                    return LocaleKeys.register_view_sign_in_title_4.tr();
                  } else {
                    return null;
                  }
                }
              },
              obscureText: _obscure,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: _obscure == true ? Colors.grey : Colors.blue,
                    ),
                    onPressed: _toggle),
                prefixIcon: Icon(Icons.lock),
                hintText: LocaleKeys.register_view_sign_in_title_5.tr(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_signInFormKey.currentState!.validate()) {}
                final user = await Provider.of<AuthService>(context,listen: false).signInWithEmailAndPassword(
                    _emailController.text, _passwordController.text);
                if (!user!.emailVerified) {
                  await _showMyDialog();
                  Provider.of<AuthService>(context,listen: false).SignOut();
                }
                Navigator.pop(context);
              },
              child: Text(LocaleKeys.register_view_sign_in_title_6.tr(),),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _formStatus = FormStatus.register;
                });
              },
              child: Text(LocaleKeys.register_view_sign_in_title_7.tr(),),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _formStatus = FormStatus.reset;
                });
              },
              child: Text(LocaleKeys.register_view_sign_in_title_8.tr(),),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRegisterForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.register_view_register_title_1.tr(),
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 20,
            ),
            file == null
                ? GestureDetector(
              onTap: () {
                Provider.of<ImageService>(context,listen: false).showImageDialog(context).then((value) => _refresh());
              },
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: NetworkImage('https://www.29mayis.edu.tr/public/images/default-profile.png'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            )
                : GestureDetector(
              onTap: () {
                Provider.of<ImageService>(context,listen: false).showImageDialog(context).then((value) => _refresh());
              },
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  image: DecorationImage(
                    image: FileImage(file!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 23.0),
              child: Text(
                LocaleKeys.register_view_register_title_2.tr(),
                style: TextStyle(fontSize: 15, color: Colors.black45),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _userNameController,
              validator: (value) {
                if (value!.length < 1) {
                  return LocaleKeys.register_view_register_title_3.tr();
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_rounded),
                hintText: LocaleKeys.register_view_register_title_4.tr(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _emailController,
              validator: (value) {
                if (!EmailValidator.validate(value!)) {
                  return LocaleKeys.register_view_register_title_5.tr();
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: LocaleKeys.register_view_register_title_6.tr(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _passwordController,
              validator: (value) {
                if(value!=null){
                  if (value.length < 6) {
                    return LocaleKeys.register_view_register_title_7.tr();
                  } else {
                    return null;
                  }
                }
              },
              obscureText: _obscure,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: _obscure == true ? Colors.grey : Colors.blue,
                    ),
                    onPressed: _toggle),
                hintText: LocaleKeys.register_view_register_title_8.tr(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _passwordConfirmController,
              validator: (value) {
                if (value != _passwordController.text) {
                  return LocaleKeys.register_view_register_title_9.tr();
                } else {
                  return null;
                }
              },
              obscureText: _obscure,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: _obscure == true ? Colors.grey : Colors.blue,
                    ),
                    onPressed: _toggle),
                prefixIcon: Icon(Icons.lock),
                hintText: LocaleKeys.register_view_register_title_10.tr(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  if (_registerFormKey.currentState!.validate()) {
                    final user = await Provider.of<AuthService>(context,listen: false).CreateUserWithEmailAndPassword(
                        _emailController.text,
                        _passwordController.text,
                        _userNameController.text);

                    Reference avatarStgRef = FirebaseStorage.instance
                        .ref("Usuarios/" + user!.uid + "/avatar.jpg");

                    avatarStgRef.putFile(file!).then((snapshot) {
                      snapshot.ref.getDownloadURL().then((url) {
                        // Now I can use url
                        user.updateProfile(
                            displayName: _userNameController.text,
                            photoURL: url);
                      });
                    });

                    if (!user.emailVerified) {
                      await user.sendEmailVerification();
                    }
                    await _showMyDialog();
                    Provider.of<AuthService>(context,listen: false).SignOut();

                    setState(() {
                      _formStatus = FormStatus.signIn;
                    });
                  }
                } on FirebaseAuthException catch (e) {}
              },
              child: Text(LocaleKeys.register_view_register_title_11.tr(),),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _formStatus = FormStatus.signIn;
                });
              },
              child: Text(LocaleKeys.register_view_register_title_12.tr(),),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResetForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _resetFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocaleKeys.register_view_reset_title_1.tr(),
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _emailController,
              validator: (value) {
                if (!EmailValidator.validate(value!)) {
                  return LocaleKeys.register_view_reset_title_2.tr();
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: LocaleKeys.register_view_reset_title_3.tr(),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_resetFormKey.currentState!.validate()) {
                  await Provider.of<AuthService>(context,listen: false).sendPasswordResetEmail(_emailController.text);
                  await _showResetPasswordDialog();
                  Navigator.pop(context);
                  //print(user.emailVerified);
                }
              },
              child: Text(LocaleKeys.register_view_reset_title_4.tr(),),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.register_view_my_dialog_title_1.tr(),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(LocaleKeys.register_view_my_dialog_title_2.tr(),),
                Text(LocaleKeys.register_view_my_dialog_title_3.tr(),),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(LocaleKeys.register_view_my_dialog_title_4.tr(),),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Beginning()));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showResetPasswordDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.register_view_reset_dialog_title_1.tr(),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(LocaleKeys.register_view_reset_dialog_title_2.tr(),),
                Text(LocaleKeys.register_view_reset_dialog_title_3.tr(),),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(LocaleKeys.register_view_reset_dialog_title_4.tr(),),
              onPressed: () {
                //Provider.of<AuthHelper>(context,listen: false).sendPasswordResetEmail(_emailController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
