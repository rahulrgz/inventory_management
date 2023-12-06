import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management_shop/core/theme/pallete.dart';
import 'package:inventory_management_shop/router.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //for web running
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyDkIOLxo-tBUi-a8ZdqYK13Ia7TWXJN-zU",
      appId: "1:345945997233:web:0ca4c1f143f4ed623ac790",
      messagingSenderId: "345945997233",
      projectId: "inventory-management-3f5bb",
      storageBucket: "inventory-management-3f5bb.appspot.com",
    ));
  } else {
    //for app initialising
    await Firebase.initializeApp();
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
      .then((value) => runApp(const ProviderScope(child: MyApp())));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: "Inventory Management Shop",
      theme: Pallete.lightModeAppTheme,
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (context) => route,
      ),
      routeInformationParser: const RoutemasterParser(),
      debugShowCheckedModeBanner: false,
    );
  }
}
