import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:plastic/extensions/locale_keys.dart';
import 'package:plastic/view/login_view.dart';


class IntroView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pages = [
      PageViewModel(
        pageColor: const Color(0xFF03A9F4),
        body: Text(LocaleKeys.intro_view_title_1.tr()),
        title: Text(LocaleKeys.intro_view_subtitle_1.tr()),
        titleTextStyle:
        const TextStyle(color: Colors.white),
        bodyTextStyle: const TextStyle(color: Colors.white),
        mainImage: Image.asset(
          'assets/images/1.jpg',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        ),
      ),
      PageViewModel(
        pageColor: const Color(0xFF8BC34A),
        body: Text(LocaleKeys.intro_view_title_2.tr()),
        title: Text(LocaleKeys.intro_view_subtitle_2.tr()),
        mainImage: Image.asset(
          'assets/images/2.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        ),
        titleTextStyle:
        const TextStyle(color: Colors.white),
        bodyTextStyle: const TextStyle(color: Colors.white),
      ),
      PageViewModel(
        pageBackground: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              stops: [0.0, 1.0],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              tileMode: TileMode.repeated,
              colors: [
                Colors.orange,
                Colors.purpleAccent,
              ],
            ),
          ),
        ),
        body: Text(LocaleKeys.intro_view_title_3.tr()),
        title: Text(LocaleKeys.intro_view_subtitle_3.tr()),
        mainImage: Image.asset(
          'assets/images/3.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        ),
        titleTextStyle:
        const TextStyle(color: Colors.white),
        bodyTextStyle: const TextStyle(color: Colors.white),
      ),
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Plastic",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) => IntroViewsFlutter(
          pages,
          doneText: Text(LocaleKeys.intro_view_done.tr()),
          nextText: Text(LocaleKeys.intro_view_next.tr()),
          backText: Text(LocaleKeys.intro_view_back.tr()),
          skipText: Text(LocaleKeys.intro_view_skip.tr()),
          showNextButton: true,
          showBackButton: true,
          onTapDoneButton: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => LoginView()),
            );
          },
          pageButtonTextStyles: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}

