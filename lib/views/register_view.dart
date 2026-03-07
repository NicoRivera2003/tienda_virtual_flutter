import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  // URL base del backend — mismo host que ya usas para Products
  static const String _baseUrl = 'http://10.10.6.185:5248';

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    // Validaciones locales
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showSnack("Por favor completa todos los campos.");
      return;
    }

    if (password != confirm) {
      _showSnack("Las contraseñas no coinciden.");
      return;
    }

    if (password.length < 6) {
      _showSnack("La contraseña debe tener al menos 6 caracteres.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/Auth/Register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Registro exitoso → regresar al Login
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("¡Cuenta creada! Ahora puedes iniciar sesión."),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginView()),
          );
        }
      } else {
        // Error del servidor (email duplicado, etc.)
        _showSnack(body['message'] ?? "Error al registrar.");
      }
    } catch (e) {
      _showSnack("No se pudo conectar al servidor. Verifica tu red.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                const SizedBox(height: 60),

                // ── Título ──────────────────────────────────────────────
                const Center(
                  child: Text(
                    "CREAR CUENTA",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Completa los datos para registrarte y acceder a tu armario privado.",
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 40),

                // ── Nombre ──────────────────────────────────────────────
                _fieldLabel("NOMBRE"),
                const SizedBox(height: 8),
                _textField(
                  controller: _nameController,
                  hint: "Tu nombre completo",
                ),

                const SizedBox(height: 25),

                // ── Email ───────────────────────────────────────────────
                _fieldLabel("CORREO ELECTRÓNICO"),
                const SizedBox(height: 8),
                _textField(
                  controller: _emailController,
                  hint: "ejemplo@correo.com",
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 25),

                // ── Contraseña ──────────────────────────────────────────
                _fieldLabel("CONTRASEÑA"),
                const SizedBox(height: 8),
                _passwordField(
                  controller: _passwordController,
                  obscure: _obscurePassword,
                  onToggle: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),

                const SizedBox(height: 25),

                // ── Confirmar contraseña ────────────────────────────────
                _fieldLabel("CONFIRMAR CONTRASEÑA"),
                const SizedBox(height: 8),
                _passwordField(
                  controller: _confirmPasswordController,
                  obscure: _obscureConfirm,
                  onToggle: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),

                const SizedBox(height: 40),

                // ── Botón registrar ─────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: _isLoading ? null : _register,
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
                            "REGISTRARSE",
                            style: TextStyle(
                              letterSpacing: 2,
                              color: Color(0xFFD8CFC3),
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 35),

                // ── Volver al login ─────────────────────────────────────
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginView()),
                    ),
                    child: const Text(
                      "¿Ya tienes cuenta? Iniciar sesión",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 12, 11, 9),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Widgets reutilizables con el mismo estilo del Login ──────────────────

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        letterSpacing: 1,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
        hintText: hint,
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggle,
        ),
      ),
    );
  }
}
