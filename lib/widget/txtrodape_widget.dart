import 'package:flutter/material.dart';

class TextRodape extends StatelessWidget {
  final String palavra;
  final Color cor;
  final Color cortexto;
  final IconData icone;
  final double padl;
  final double padt;
  final double padr;
  final double padb;

  const TextRodape(
    this.palavra, {
    this.cor = Colors.blue,
    this.cortexto = Colors.white,
    this.icone = Icons.check_circle_outlined,
    this.padl = 20.0,
    this.padt = 10.0,
    this.padr = 20.0,
    this.padb = 10.0,
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: cor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: EdgeInsets.fromLTRB(padl, padt, padr, padb),
          shadowColor: Colors.black12,
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
