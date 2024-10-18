import 'package:flutter/material.dart';
import 'package:responsi1/helpers/user_info.dart';
import 'package:responsi1/ui/laporan_page.dart';
import 'package:responsi1/ui/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = const CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    var token = await UserInfo().getToken();
    if (token != null) {
      setState(() {
        page = const LaporanPage();
      });
    } else {
      setState(() {
        page = const LoginPage();
      });
    }
  } 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laporan Keuangan',
      debugShowCheckedModeBanner: false,
      home: page,
    );
  }
}
