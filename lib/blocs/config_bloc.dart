import 'package:taishoapp/apis/config_api.dart';
import 'package:taishoapp/entidades/empresa.dart';

class ConfigBloc {
  Future<List<Empresa>> getEmpresas() async {
    var lstEmpresas = await ConfigApi.getEmpresas();

    return lstEmpresas;
  }
}
