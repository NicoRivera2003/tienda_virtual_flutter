import 'package:flutter/material.dart';
import 'forgot_password_view.dart';
import '../controllers/authController.dart';
import 'catalog_view.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  /* final Repository _repository = Repository(); */

  bool _obscurePassword = true;
  bool _isLoading = false;

  // Lógica para autenticarse en el login y acceder al catálogo
  Future<void> _login() async {
    setState(() => _isLoading = true);

    final success = await AuthController.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
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
                  keyboardType: TextInputType.emailAddress,
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
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Color(0xFFD8CFC3),
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "INICIAR SESIÓN",
                            style: TextStyle(
                              letterSpacing: 2,
                              color: Color(0xFFD8CFC3),
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 35),

                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ForgotPasswordView()),
                    ),
                    child: const Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterView()),
                      );
                    },
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
