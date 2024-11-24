import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String palavra;
  final VoidCallback onClicked;
  final Color cor;
  final Color cortexto;
  final IconData icone;
  final double padl;
  final double padt;
  final double padr;
  final double padb;

  const ButtonWidget(
    this.palavra, {
    required this.onClicked,
    this.cor = const Color.fromARGB(255, 141, 1, 1),
    this.cortexto = Colors.white,
    this.icone = Icons.check_circle_outlined,
    this.padl = 10.0,
    this.padt = 15.0,
    this.padr = 10.0,
    this.padb = 15.0,
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onClicked,
        style: ElevatedButton.styleFrom(
          backgroundColor: cor,
          foregroundColor: cortexto,
          shadowColor: cor,
          elevation: 8,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: cortexto, width: 1.5), // Borda interna
            borderRadius: BorderRadius.circular(30.0),
          ),
          // padding: EdgeInsets.fromLTRB(padl, padt, padr, padb),
          // shadowColor: Colors.black12,
        ),
        child: Wrap(
          children: <Widget>[
            Icon(
              icone,
              color: cortexto,
              size: 24.0,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(palavra,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: cortexto)),
          ],
        ),
        // child: Text(text, style: TextStyle(color: cortexto)),
      );
}
