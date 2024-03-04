import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rental_app/db/model/bill_model.dart';
import 'package:rental_app/widget/splash_screen_widget.dart';
import 'package:rental_app/db/model/add_product_model.dart';
import 'package:rental_app/db/model/cart_model.dart';

const saveKeyName = 'UserLoggedIn';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if(!Hive.isAdapterRegistered(AddProductmodelAdapter().typeId)){
    Hive.registerAdapter(AddProductmodelAdapter());
  }
  if(!Hive.isAdapterRegistered(CartModelAdapter().typeId)){
    Hive.registerAdapter(CartModelAdapter());
  }
  if(!Hive.isAdapterRegistered(BillDetailsModelAdapter().typeId)){
    Hive.registerAdapter(BillDetailsModelAdapter());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor:const Color(0xff8ECFCB)
      ),
      home: const SplashScreenWidget(),
    );
  }
}