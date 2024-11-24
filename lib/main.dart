import 'package:flutter/material.dart';
import 'package:taishoapp/pages/login_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:taishoapp/routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..animationStyle = EasyLoadingAnimationStyle.opacity
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.red
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.red.withOpacity(0.3)
    ..userInteractions = false
    ..dismissOnTap = false
    ..maskType = EasyLoadingMaskType.custom;
}

void main() {
  runApp(const MyApp());
  configLoading();
}

PackageInfo _packageInfo = PackageInfo(
  appName: 'Unknown',
  packageName: 'Unknown',
  version: 'Unknown',
  buildNumber: 'Unknown',
  buildSignature: 'Unknown',
  installerStore: 'Unknown',
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaishoApp',
      theme: ThemeData(
        primarySwatch: Colors.red,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red, // Defina a cor desejada
          // Outras propriedades
        ),
      ),
      // home: const MyHomePage(
      //   title: 'TaishoApp',
      // ),
      builder: EasyLoading.init(),
      routes: Routes.list,
      initialRoute: Routes.initial,
      navigatorKey: navigatorKey,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _introScreen();
  }

  Widget _introScreen() {
    return Stack(
      children: <Widget>[
        Center(
          child: SplashScreen.timer(
            seconds: 4,
            image: Image.asset("imagens/taishoappsemfundo.png",
                fit: BoxFit.contain),
            photoSize: 150,
            gradientBackground: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFFFFF),
                Color.fromARGB(255, 253, 227, 235),
                Color.fromARGB(255, 246, 100, 124),
                Color.fromARGB(255, 243, 33, 51)
              ],
            ),
            navigateAfterSeconds: LoginPage(),
            loaderColor: const Color.fromARGB(255, 54, 2, 7),
            loadingText: Text(
              '4web - TaishoApp \n\nVs ${_packageInfo.version}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: const Color.fromARGB(255, 54, 2, 7),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
