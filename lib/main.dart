import 'package:datastore_hive/screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';


//import 'package:hive_flutter/hive_flutter.dart';

/* void main() {
  runApp(const MyApp());
} */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive beffore runApp
  await Hive.initFlutter();
  await Hive.openBox('adresse_List');
  runApp(const MyApp());
} 

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const HomePage(),
    );
  }
}
