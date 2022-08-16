import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plastic/constants.dart';
import 'package:plastic/service/auth_service.dart';
import 'package:plastic/service/database_service.dart';
import 'package:plastic/service/image_service.dart';
import 'package:plastic/service/notification_service.dart';
import 'package:plastic/service/position_service.dart';
import 'package:plastic/view/language_selected_view.dart';
import 'package:provider/provider.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<ImageService>(create: (BuildContext context) => ImageService()),
        ChangeNotifierProvider<PositionService>(create: (BuildContext context) => PositionService()),
        ChangeNotifierProvider<NotificationService>(create: (BuildContext context) => NotificationService()),
        ChangeNotifierProvider<DatabaseService>(create: (BuildContext context) => DatabaseService()),
        ChangeNotifierProvider<AuthService>(create: (BuildContext context) => AuthService()),
      ],
      child: EasyLocalization(
          supportedLocales: AppConstant.SUPPORTED_LOCALE,
          path: AppConstant.LANG_PATH,
          fallbackLocale: Locale('tr', 'TR'),
          child: MyApp()
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Plastic',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LanguageSelectedView(),
    );
  }
}
