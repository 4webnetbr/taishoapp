// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taishoapp/apis/config_api.dart';
import 'package:taishoapp/entidades/empresa.dart';
import 'package:taishoapp/entidades/deposito.dart';

class SelEmpresa extends StatefulWidget {
  final VoidCallback onDepositChange;

  const SelEmpresa({Key? key, required this.onDepositChange}) : super(key: key);

  @override
  _SelEmpresaState createState() => _SelEmpresaState();
}

class _SelEmpresaState extends State<SelEmpresa> {
  late SharedPreferences _prefs;
  List<Empresa> empresas = [];
  List<Deposito> depositos = [];
  String? selectedEmpresaId;
  String? selectedDepositoId;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    _fetchEmpresas();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    selectedEmpresaId = _prefs.getString('empresaId');
    selectedDepositoId = _prefs.getString('depositoId');
    setState(() {});
  }

  Future<void> _fetchEmpresas() async {
    empresas = await ConfigApi.getEmpresas();
    if (empresas.isNotEmpty) {
      selectedEmpresaId ??= empresas[0].empid.toString();
      await _prefs.setString('empresaId', selectedEmpresaId!);
      await _fetchDepositos();
      setState(() {});
    }
  }

  Future<void> _fetchDepositos() async {
    if (selectedEmpresaId != null) {
      depositos = await ConfigApi.getDepositos(selectedEmpresaId!);
      if (depositos.isNotEmpty) {
        if (selectedDepositoId == null ||
            !depositos.any((d) => d.depid.toString() == selectedDepositoId)) {
          selectedDepositoId = depositos[0].depid.toString();
          await _prefs.setString('depositoId', selectedDepositoId!);
        }
        widget.onDepositChange();
      }
    }
  }

  void _onEmpresaChanged(String? empresaId) async {
    setState(() {
      selectedEmpresaId = empresaId;
      selectedDepositoId = null;
    });
    await _prefs.setString('empresaId', selectedEmpresaId!);
    await _fetchDepositos();
    widget.onDepositChange();
  }

  void _onDepositoChanged(String? depositoId) async {
    setState(() {
      selectedDepositoId = depositoId;
    });
    await _prefs.setString('depositoId', selectedDepositoId!);
    widget.onDepositChange();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Coluna para Empresa
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
                width: (MediaQuery.of(context).size.width / 2) - 10,
                child: Text(
                  'Empresa',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              SizedBox(
                height: 24,
                width: (MediaQuery.of(context).size.width / 2) - 10,
                child: _buildDropdown(
                  value: selectedEmpresaId,
                  items: empresas.map((empresa) {
                    return DropdownMenuItem<String>(
                      value: empresa.empid.toString(),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.fromLTRB(10, 1, 2, 1),
                        margin: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: (selectedEmpresaId == empresa.empid.toString())
                              ? Colors.red // Fundo vermelho quando selecionado
                              : Colors
                                  .white, // Fundo branco quando não selecionado
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          empresa.empapelido.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: (selectedEmpresaId ==
                                    empresa.empid.toString())
                                ? Colors
                                    .white // Texto branco quando selecionado
                                : Colors
                                    .red, // Texto vermelho quando não selecionado
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  hint: "Empresa",
                  onChanged: empresas.length > 1 ? _onEmpresaChanged : null,
                ),
              ),
            ],
          ),

          // Coluna para Depósito
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: 20,
                width: (MediaQuery.of(context).size.width / 3),
                child: Text(
                  'Depósito',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                  textAlign: TextAlign.end,
                ),
              ),
              SizedBox(
                height: 24,
                width: (MediaQuery.of(context).size.width / 3),
                child: _buildDropdown(
                  value: selectedDepositoId,
                  items: depositos.map((deposito) {
                    return DropdownMenuItem<String>(
                      value: deposito.depid.toString(),
                      alignment: Alignment.centerRight,
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: 30,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.fromLTRB(2, 1, 10, 1),
                        decoration: BoxDecoration(
                          color: (selectedDepositoId ==
                                  deposito.depid.toString())
                              ? Colors.red // Fundo vermelho quando selecionado
                              : Colors
                                  .white, // Fundo branco quando não selecionado
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          deposito.depnome.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: (selectedDepositoId ==
                                    deposito.depid.toString())
                                ? Colors
                                    .white // Texto branco quando selecionado
                                : Colors
                                    .red, // Texto vermelho quando não selecionado
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  hint: "Depósito",
                  onChanged: depositos.length > 1 ? _onDepositoChanged : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    String? value,
    required List<DropdownMenuItem<String>> items,
    required String hint,
    required Function(String?)? onChanged,
  }) {
    return Container(
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white, // Cor do fundo do botão fechado
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red), // Borda vermelha
      ),
      child: DropdownButton<String>(
        value: value,
        elevation: 8,
        onChanged: onChanged,
        items: items,
        isDense: false,
        // padding: EdgeInsets.fromLTRB(2, 1, 0, 1),
        dropdownColor: Colors.white, // Cor do fundo da lista
        hint: Text(
          hint,
          style: TextStyle(
              color: Colors.red, fontSize: 10), // Cor do texto do hint
        ),
        iconEnabledColor: Colors.red,
        iconDisabledColor: Colors.grey,
        disabledHint: Text(
          hint,
          style: TextStyle(color: Colors.grey, fontSize: 10),
        ),
        style: TextStyle(
            color: Colors.red, fontSize: 10), // Texto vermelho no botão fechado
        underline: Container(), // Remover a linha embaixo do botão
        selectedItemBuilder: (BuildContext context) {
          return items.map<Widget>((DropdownMenuItem<String> item) {
            return Container(
              height: 24,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: item.value == value
                    ? Colors.white
                    : Colors.red, // Fundo vermelho para item selecionado
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                ((item.child as Container).child as Text).data.toString(),
                style: TextStyle(
                  color: item.value == value
                      ? Colors.red
                      : Colors.grey, // Texto branco para item selecionado
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList();
        },
      ),
    );
  }
}
