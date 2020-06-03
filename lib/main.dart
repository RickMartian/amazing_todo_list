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
    {"id": 03, "title": "Estudar para a prova", "isChecked": false},
  ];
  TextEditingController _todoInputController = TextEditingController();

  void _changeCheckBox(bool newValue, int index) {
    setState(() {
      data[index]["isChecked"] = newValue;
    });
  }

  void _onDismissed(DismissDirection direction, int index) {
    setState(() {
      data.removeAt(index);
    });
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
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
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
