import 'package:flutter/material.dart';
import 'package:task_app/services/task_model.dart';
import 'package:task_app/widgets/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _model = TaskWidgetModel();
  @override
  Widget build(BuildContext context) {
    return TaskWidgetProvider(
      model: _model,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          buttonColor: Colors.green,
          cardColor: Color(0xFFE9FFE6),
          indicatorColor: Colors.red,
        ),
        home: MainPage(),
      ),
    );
  }
}
