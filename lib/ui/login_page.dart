import 'package:flutter/material.dart';
import 'package:responsi1/bloc/login_bloc.dart';
import 'package:responsi1/helpers/user_info.dart';
import 'package:responsi1/ui/laporan_page.dart';
import 'package:responsi1/ui/register_page.dart';
import 'package:responsi1/widget/warning_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to free resources
    _emailTextboxController.dispose();
    _passwordTextboxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _emailTextField(),
                const SizedBox(height: 16.0), // Added spacing
                _passwordTextField(),
                const SizedBox(height: 16.0), // Added spacing
                _buttonLogin(),
                const SizedBox(height: 30.0),
                _menuRegistrasi()
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget for email text field
  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Email"),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
    );
  }

  // Widget for password text field
  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Password"),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Password harus diisi";
        } else if (value.length < 6) {
          return "Password minimal 6 karakter";
        }
        return null;
      },
    );
  }

  // Widget for login button
  Widget _buttonLogin() {
    return ElevatedButton(
      child: _isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : const Text("Login"),
      onPressed: _isLoading
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                _submit();
              }
            },
    );
  }

  void _submit() {
    setState(() {
      _isLoading = true;
    });

    LoginBloc.login(
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then((value) async {
      setState(() {
        _isLoading = false;
      });

      if (value.code == 200) {
        await UserInfo().setToken(value.token.toString());
        await UserInfo().setUserID(int.parse(value.userID.toString()));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LaporanPage()),
        );
      } else {
        _showWarningDialog("Login gagal, silahkan coba lagi");
      }
    }).catchError((error) {
      print(error);
      setState(() {
        _isLoading = false;
      });
      _showWarningDialog("Login gagal, silahkan coba lagi");
    });
  }

  // Helper method to show warning dialog
  void _showWarningDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => WarningDialog(description: message),
    );
  }

  // Widget for registration menu
  Widget _menuRegistrasi() {
    return Center(
      child: InkWell(
        child: const Text(
          "Registrasi",
          style: TextStyle(color: Colors.blue),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage()),
          );
        },
      ),
    );
  }
}
