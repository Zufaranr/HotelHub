import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hotelhub/components/my_app.dart';
import 'package:hotelhub/screens/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      appId: '1:114539225164:android:68e0c158cf52facc2794e9',
      apiKey: 'AIzaSyDFmYQSpG0XkfEXbI6Dlbxc1PL5GlaTQiQ',
      messagingSenderId: '114539225164',
      projectId: 'hotelhub-7be75',
      // storageBucket: 'gs://hotelhub-7be75.appspot.com',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => UiProvider()..init(),
      child:
          Consumer<UiProvider>(builder: (context, UiProvider notifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          //By default theme setting, u can also set system
          //when ur mobile theme is dark the app also become dark
          themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
          //Our custom theme applied
          darkTheme: notifier.isDark ? notifier.darkTheme : notifier.lightTheme,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          home: SplashScreen(),
        );
      }),
    );
  }
}
