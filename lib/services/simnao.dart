import 'package:taishoapp/widget/button_widget.dart';
import 'package:flutter/material.dart';

Future<bool> showAlertDialogSimNao(
    BuildContext context, String titulo, String conteudo) async {
  // configura o button

  Widget btnNao = ButtonWidget(
    'Não',
    onClicked: () => {Navigator.pop(context, false)},
    cor: Colors.green,
    cortexto: Colors.white,
    icone: Icons.rotate_left,
    padl: 20,
    padr: 20,
    padt: 10,
    padb: 10,
  );

  Widget btnSim = ButtonWidget(
    'Sim',
    onClicked: () => {Navigator.pop(context, true)},
    cor: Colors.red,
    cortexto: Colors.white,
    icone: Icons.check_box,
    padl: 20,
    padr: 20,
    padt: 10,
    padb: 10,
  );

  // configura o  AlertDialog
  AlertDialog alerta = AlertDialog(
    backgroundColor: Colors.black45,
    title: Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          titulo,
          style: const TextStyle(
              color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    ),
    titlePadding: const EdgeInsets.all(1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
      side: BorderSide(color: Colors.white),
    ),
    // title: Text("$titulo"),
    content: Text(conteudo, style: const TextStyle(color: Colors.white)),
    actions: [btnSim, btnNao],
  );

  // exibe o dialog
  return await showDialog(
      // barrierDismissible: false,
      context: context,
      builder: (context) => alerta);
}
