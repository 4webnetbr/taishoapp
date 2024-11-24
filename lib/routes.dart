import 'package:flutter/material.dart';
import 'package:taishoapp/pages/entradas_page.dart';
import 'package:taishoapp/pages/home_page.dart';
import 'package:taishoapp/pages/login_page.dart';
import 'package:taishoapp/pages/saidas_page.dart';

import 'main.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    '/': (_) => MyHomePage(
          title: 'TaishoApp',
        ),
    '/login': (_) => LoginPage(),
    '/principal': (_) => HomePage(),
    '/saidas': (_) => SaidasPage(),
    '/entradas': (_) => EntradasPage()
  };

  static String initial = '/';
}
