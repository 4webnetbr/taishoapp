import 'dart:async';

import 'package:taishoapp/apis/estoque_api.dart';
import 'package:taishoapp/entidades/produto.dart';

class SaldoBloc {
  final _streamSaldos = StreamController<List<Produto>>();

  get produtoSaldos => _streamSaldos.stream;

  loadSaldos(empresa, deposito) async {
    List<Produto>? lstprodutos = await EstoqueApi.getSaldos(empresa, deposito);
    _streamSaldos.add(lstprodutos);
  }

  void dispose() {
    _streamSaldos.close();
  }
}
