import 'dart:async';

import 'package:taishoapp/apis/estoque_api.dart';
import 'package:taishoapp/entidades/marca.dart';

class MarcaBloc {
  final _streamMarcas = StreamController<Marca>();

  get produtoMarcas => _streamMarcas.stream;

  loadMarca(empresa, deposito, codigo) async {
    Marca? lstmarca =
        await EstoqueApi.getMarcaCodbar(empresa, deposito, codigo);
    _streamMarcas.add(lstmarca);
  }

  void dispose() {
    _streamMarcas.close();
  }
}
