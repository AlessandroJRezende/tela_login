import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:tela_login/login_page.dart';
import 'package:tela_login/academico.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://mmsihkgyreazzvoohxsp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1tc2loa2d5cmVhenp2b29oeHNwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU5NDc3NzIsImV4cCI6MjA2MTUyMzc3Mn0.9-j8-x5vDZE0oFlh0xIz6n2VIIMBwm4cKPS6n3xr5vI',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login com Supabase',
      debugShowCheckedModeBanner: false,
      home: PortaisApp(),
    );
  }
}
