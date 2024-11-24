import 'package:taishoapp/apis/login_api.dart';
import 'package:taishoapp/entidades/usuario.dart';

class LoginBloc {
  Future<Usuario> login(String login, String senha) async {
    var usuario = await LoginApi.login(login, senha);

    return usuario;
  }
}
