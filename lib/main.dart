import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/checkout/checkout_provider.dart';
import 'app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => CheckoutProvider()),
    ],
    child: const MyApp(),)
    
  );
}
