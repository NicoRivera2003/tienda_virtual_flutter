import 'package:flutter/material.dart';
import '../data/repository.dart';
import '../controllers/authController.dart';
import 'catalog_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Repository _repository = Repository();

  bool _obscurePassword = true;

  // Lógica para autenticarse en el login y acceder al catálogo
  void _login() {
    if (AuthController.login(_emailController.text, _passwordController.text)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CatalogView()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Credenciales incorrectas")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8CFC3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),

                Center(
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Ingresa tus credenciales para acceder a tu armario privado.",
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 40),

                const Text(
                  "CORREO ELECTRÓNICO",
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    hintText: "ejemplo@correo.com",
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "CONTRASEÑA",
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: _login,
                    child: const Text(
                      "INICIAR SESIÓN",
                      style: TextStyle(
                        letterSpacing: 2,
                        color: const Color(0xFFD8CFC3),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                Center(
                  child: const Text(
                    "¿Olvidastes tu contraseña?",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),

                const SizedBox(height: 30),

                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "¿Eres nuevo? Crear cuenta",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 12, 11, 9),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
