// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:taishoapp/services/simnao.dart';

class AppbarWidget extends StatefulWidget implements PreferredSizeWidget {
  final String titulo;
  final bool mostrarBotaoVoltar;

  const AppbarWidget({
    Key? key,
    required this.titulo,
    this.mostrarBotaoVoltar = false,
  }) : super(key: key);

  @override
  _AppbarWidgetState createState() => _AppbarWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppbarWidgetState extends State<AppbarWidget> {
  late SharedPreferences _prefs;
  String _login = 'Usuário';
  bool _estoqueExpanded = true;

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    _initPackageInfo();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    final login = _prefs.getString('login') ?? 'Usuário';

    setState(() {
      _login = login;
    });
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> _onMenuItemSelected(String value) async {
    if (value == 'Sair') {
      var simnao = await showAlertDialogSimNao(
          context, 'Fazer Logoff?', 'Deseja fechar o TaishoApp');
      if (simnao) {
        simnao = await showAlertDialogSimNao(
            context, 'Fazer Logoff?', 'Deseja limpar suas Credenciais?');
        if (simnao) {
          _limpaUser();
        }
        SystemNavigator.pop();
      }
    }
  }

  void _limpaUser() async {
    await _prefs.clear();
  }

  @override
  Widget build(BuildContext context) => AppBar(
        automaticallyImplyLeading: widget.mostrarBotaoVoltar,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.titulo,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Vs ${_packageInfo.version} - $_login',
                    style: const TextStyle(fontSize: 10, color: Colors.white70),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: _onMenuItemSelected,
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.menu, color: Colors.white),
              ),
              color: Colors.grey[600],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'Saldos',
                  child: ListTile(
                    selectedTileColor: Colors.red,
                    tileColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    leading: const Icon(Icons.curtains_closed_outlined,
                        color: Colors.white),
                    title: const Text('Saldos',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pushNamed(context, '/principal');
                    },
                  ),
                ),
                PopupMenuItem<String>(
                  enabled: false,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 150),
                    child: ExpansionTile(
                      title: Row(
                        children: const [
                          Icon(Icons.inventory, color: Colors.black),
                          SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Estoque',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      initiallyExpanded: true,
                      trailing: Icon(
                        _estoqueExpanded
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: Colors.black,
                      ),
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.arrow_forward_rounded,
                              color: Colors.white),
                          title: const Text('Entradas',
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.pushNamed(context, '/entradas');
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.arrow_back_rounded,
                              color: Colors.white),
                          title: const Text('Saídas',
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            Navigator.pushNamed(context, '/saidas');
                          },
                        ),
                      ],
                      onExpansionChanged: (expanded) {
                        setState(() {
                          _estoqueExpanded = expanded;
                        });
                      },
                    ),
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<String>(
                  value: 'Sair',
                  child: ListTile(
                    selectedTileColor: Colors.white,
                    splashColor: Colors.white,
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    leading:
                        const Icon(Icons.exit_to_app, color: Colors.redAccent),
                    title: const Text('Sair',
                        style: TextStyle(color: Colors.redAccent)),
                  ),
                ),
              ],
            ),
          ],
        ),
        centerTitle: false,
      );
}
