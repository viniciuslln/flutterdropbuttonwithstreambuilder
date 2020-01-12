import 'package:drop/models/value.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

class HomeBloc extends BlocBase {
  var selecteValuesText = BehaviorSubject<String>.seeded("Nada Selecionado");

  var valuesSelecionadas = List<BehaviorSubject<ValueItem>>();

  var valuesDrop =
      BehaviorSubject<List<List<ValueItem>>>.seeded(List<List<ValueItem>>());
  ValueStream<List<List<ValueItem>>> get valuesDropSaida => valuesDrop.stream;
  Sink<List<List<ValueItem>>> get valuesDropEntrada => valuesDrop.sink;

  List<ValueItem> getValuesFromEMpresa(Value value) {
    double soma = 0;
    var count = (value.valorFinal) / value.intervalo;
    var itens = List<ValueItem>();
    for (var i = 0; i < count; i++) {
      soma += value.valorInicial;
      itens.add(ValueItem(value.name, soma, i));
    }
    return itens;
  }

  obeterValues() {
    // ober do backend
    var empresas = <Value>[
      Value.of("Panda Co", 500000, 10000, 5000, 1, true),
      Value.of("neo LDTA", 500000, 10000, 5000, 1, true)
    ];

    var listaEmpresas = empresas
        .where((empresa) => empresa.active)
        .map((empresaValue) => getValuesFromEMpresa(empresaValue))
        .toList();
    valuesDropEntrada.add(listaEmpresas);
    valuesSelecionadas = listaEmpresas
        .map((values) => BehaviorSubject.seeded(values[0]))
        .toList();
  }

  selecionarItem(int index, int valor) {
    var drop = valuesDrop.value[index];
    var valueSelecionada = drop.firstWhere((value) => value.index == valor);
    valuesSelecionadas[index].sink.add(valueSelecionada);
  }

  @override
  void dispose() {
    valuesDrop.close();
    valuesSelecionadas.forEach((sub) => sub.close());
    selecteValuesText.close();
    super.dispose();
  }

  void getSelectedValues() => selecteValuesText.sink.add(
      """Você selecionou ${valuesSelecionadas[0].value.name}: ${valuesSelecionadas[0].value.valor}
     Você selecionou ${valuesSelecionadas[1].value.name}: ${valuesSelecionadas[1].value.valor}
  """);
}
