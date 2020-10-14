
import 'package:flutter/material.dart';
import 'package:otistories/views/start_view/start_view.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oti Stories',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: StartView(),
     
    );
  }
 
}
