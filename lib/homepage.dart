import 'package:drop/bloc/blochome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'models/value.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  HomeBloc _bloc = HomeBloc();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    _bloc.obeterValues();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            StreamBuilder<List<List<ValueItem>>>(
                stream: _bloc.valuesDropSaida,
                builder: (context, snapshot) =>
                    Column(children: iterateDrop(snapshot.data))),
            FlatButton(
              child: Text("Me pressiona delicia"),
              onPressed: () => _bloc.getSelectedValues(),
            ),
            StreamBuilder(
                stream: _bloc.selecteValuesText.stream,
                builder: (context, snapshot) => Text(snapshot.data))
          ],
        ),
      ),
    );
  }

  createDropdown(int i) => _bloc.valuesSelecionadas[i] != null
      ? StreamBuilder<ValueItem>(
          stream: _bloc.valuesSelecionadas[i].stream,
          builder: (context2, snapshot2) {
            return DropdownButton<int>(
              value: snapshot2.data.index,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (newValue) => _bloc.selecionarItem(i, newValue),
              items: _bloc?.valuesDropSaida?.value[i]
                      ?.map((ValueItem value) => DropdownMenuItem(
                            value: value.index,
                            child: Text("${value.valor} of ${value.name} "),
                          ))
                      ?.toList() ??
                  [],
            );
          })
      : null;

  List<StreamBuilder> iterateDrop(List<List<ValueItem>> data) {
    var lista = List<StreamBuilder>();
    for (var i = 0; i < data?.length ?? 0; i++) {
      lista.add(createDropdown(i));
    }
    return lista;
  }
}
