import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Amazing Todo List",
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final data = [
    {"id": 01, "title": "Tomar café", "isChecked": false},
    {"id": 02, "title": "Ir ao médico", "isChecked": false},
    {"id": 03, "title": "Estudar para a prova", "isChecked": false}
  ];

  void _changeCheckBox(bool newValue, int index) {
    setState(() {
      data[index]["isChecked"] = newValue;
    });
  }

  Widget _renderTodo(BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(data[index]["title"]),
        ),
        Checkbox(
            value: data[index]["isChecked"],
            onChanged: (newValue) => _changeCheckBox(newValue, index))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Amazing Todo List"),
      ),
      body: ListView.builder(
        itemBuilder: _renderTodo,
        itemCount: data.length,
      ),
    );
  }
}
