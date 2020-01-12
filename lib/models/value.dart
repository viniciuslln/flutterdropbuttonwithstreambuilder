class Value {
  String name;
  double valorInicial;
  double valorFinal;
  double intervalo;
  int id;
  bool active;

  Value();

  Value.of(this.name, this.valorFinal, this.valorInicial, this.intervalo,
      this.id, this.active);
}

class ValueItem {
  String name;
  double valor;
  int index;
  ValueItem(this.name, this.valor, this.index);
}
