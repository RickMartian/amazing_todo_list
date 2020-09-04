import 'package:amazing_todo_list/interfaces/persist_data_interface.dart';
import 'package:amazing_todo_list/services/persist_data_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;

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
  final IPersistData localStorage = PersistDataService();
  final data = [];
  TextEditingController _todoInputController = TextEditingController();

  void initState() {
    super.initState();
    localStorage.get("todos").then((todos) {
      if (todos != null) {
        final todosParsed = convert.jsonDecode(todos);
        setState(() {
          data.addAll(todosParsed);
        });
      }
    });
  }

  void _changeCheckBox(bool newValue, int index) {
    setState(() {
      data[index]["isChecked"] = newValue;
    });
    localStorage.put("todos", convert.jsonEncode(data));
  }

  void _onDismissed(DismissDirection direction, int index) {
    setState(() {
      data.removeAt(index);
    });
    localStorage.put("todos", convert.jsonEncode(data));
  }

  Widget _dismissBackground(
      Widget firstWidget, Widget secondWidget, bool invert) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment:
            invert ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          firstWidget,
          SizedBox(
            width: 10.0,
          ),
          secondWidget
        ],
      ),
      color: Colors.red,
    );
  }

  Widget _renderTodo(BuildContext context, int index) {
    return Dismissible(
      background:
          _dismissBackground(Icon(Icons.cancel), Text("Excluir"), false),
      secondaryBackground:
          _dismissBackground(Text("Excluir"), Icon(Icons.cancel), true),
      key: ValueKey(data[index]["id"]),
      onDismissed: (DismissDirection direction) =>
          _onDismissed(direction, index),
      child: CheckboxListTile(
        title: Text(data[index]["title"]),
        value: data[index]["isChecked"],
        onChanged: (newValue) => _changeCheckBox(newValue, index),
      ),
    );
  }

  void _onNewTodoSubmitted(String text) {
    final newTodo = {
      "id": (data.length + 1),
      "title": text,
      "isChecked": false
    };
    setState(() {
      data.add(newTodo);
    });
    localStorage.put("todos", convert.jsonEncode(data));
    _todoInputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text('Amazing Todo List'),
            expandedHeight: 150.0,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
                alignment: Alignment.bottomCenter,
                child: TextField(
                  onSubmitted: _onNewTodoSubmitted,
                  controller: _todoInputController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Novo todo',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              _renderTodo,
              childCount: data.length,
            ),
          ),
        ],
      ),
    );
  }
}
