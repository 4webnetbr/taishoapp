import 'package:flutter/material.dart';
import 'package:taishoapp/widget/button_widget.dart';

alert(
  BuildContext context,
  String titulo,
  String msg,
) async =>
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.yellow,
            title: Card(
              color: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  titulo,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            titlePadding: const EdgeInsets.all(1),
            content: Text(msg),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ButtonWidget(
                    'Ok',
                    onClicked: () => Navigator.pop(context),
                    cor: Colors.blue,
                    cortexto: Colors.white,
                    icone: Icons.check_outlined,
                    padl: 40,
                    padr: 40,
                  ),
                ],
              ),
            ],
          );
        });
