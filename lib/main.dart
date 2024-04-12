import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:one_skin/themes/theme.dart';
import 'package:one_skin/views/home_view.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const OneSkin());
  FlutterNativeSplash.remove();
}

class OneSkin extends StatelessWidget {
  const OneSkin({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialTheme theme = const MaterialTheme(
        TextTheme(displayMedium: TextStyle(fontFamily: 'Manrope')));
    return MaterialApp(
      title: 'One Skin',
      debugShowCheckedModeBanner: false,
      theme: theme.dark(),
      initialRoute: '/',
      home: const HomeView(),
    );
  }
}
