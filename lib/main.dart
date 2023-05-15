import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/models/profile.dart';
import 'package:shopping_cart/services/authentication_service.dart';
import 'package:shopping_cart/views/wrapper.dart';
import 'file:///G:/Programming/Android/Flutter/shopping_cart/lib/views/home/all_products/shopping_item.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider(
      create: (context) => AuthService().profile,
      builder: (context, widget) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Wrapper(),
        );
      }
    );
  }
}