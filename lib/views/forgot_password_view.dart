import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_view.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _tokenSent = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  static const String _baseUrl = 'http://192.168.0.12:5248';

  Future<void> _sendCode() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) { _showSnack("Ingresa tu correo."); return; }

    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/Auth/ForgotPassword'), //PETICIÓN POST PARA LA AUTENCICACIÓN DE USUARIO ENVIANDO AL CORREO EL CÓDIGO DE 6 DIGITOS
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() => _tokenSent = true);
        _showSnack("¡Código enviado! Revisa tu correo.");
      } else {
        _showSnack(body['message'] ?? "Error al enviar el código.");
      }
    } catch (e) {
      _showSnack("No se pudo conectar al servidor.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    final email    = _emailController.text.trim();
    final token     = _tokenController.text.trim();
    final password = _passwordController.text;
    final confirm  = _confirmPasswordController.text;

    print('email: $email, token: $token, password: $password');

    if (token.isEmpty || password.isEmpty || confirm.isEmpty) {
      _showSnack("Completa todos los campos."); return;
    }
    if (password != confirm) {
      _showSnack("Las contraseñas no coinciden."); return;
    }
    if (password.length < 6) {
      _showSnack("La contraseña debe tener al menos 6 caracteres."); return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/Auth/ResetPassword'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'token': token,
          'newPassword': password,
        }),
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("¡Contraseña actualizada! Ya puedes iniciar sesión."),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginView()),
          );
        }
      } else {
        _showSnack(body['message'] ?? "Código incorrecto o expirado.");
      }
    } catch (e) {
      _showSnack("No se pudo conectar al servidor.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
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
                const SizedBox(height: 80),

                const Center(
                  child: Text(
                    "RECUPERAR\nCONTRASEÑA",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  _tokenSent
                  ? "Ingresa el código de 6 dígitos que enviamos a tu correo y crea una nueva contraseña."
                  : "Ingresa tu correo y te enviaremos un código de verificación.",
                  style: TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 40),

                _label("CORREO ELECTRÓNICO"),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_tokenSent,   // bloqueado una vez enviado el código
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _tokenSent ? Colors.grey[200] : Colors.white,
                    border: const OutlineInputBorder(),
                    hintText: "ejemplo@correo.com",
                  ),
                ),

                const SizedBox(height: 25),

                if (!_tokenSent) ...[
                  SizedBox(
                    width: double.infinity, height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                      onPressed: _isLoading ? null : _sendCode,
                      child: _isLoading
                          ? const SizedBox(height: 22, width: 22,
                              child: CircularProgressIndicator(color: Color(0xFFD8CFC3), strokeWidth: 2.5))
                          : const Text("ENVIAR CÓDIGO",
                              style: TextStyle(letterSpacing: 2, color: Color(0xFFD8CFC3))),
                    ),
                  ),
                ] else ...[
                  //Código de 6 dígitos
                  _label("CÓDIGO DE VERIFICACIÓN"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _tokenController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      filled: true, fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: "123456",
                      counterText: "",
                    ),
                  ),

                  const SizedBox(height: 25),

                  _label("NUEVA CONTRASEÑA"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      filled: true, fillColor: Colors.white,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),


                  _label("CONFIRMAR CONTRASEÑA"),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirm,
                    decoration: InputDecoration(
                      filled: true, fillColor: Colors.white,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity, height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                      onPressed: _isLoading ? null : _resetPassword,
                      child: _isLoading
                          ? const SizedBox(height: 22, width: 22,
                              child: CircularProgressIndicator(color: Color(0xFFD8CFC3), strokeWidth: 2.5))
                          : const Text("CAMBIAR CONTRASEÑA",
                              style: TextStyle(letterSpacing: 2, color: Color(0xFFD8CFC3))),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Center(
                    child: TextButton(
                      onPressed: _isLoading ? null : () => setState(() => _tokenSent = false),
                      child: const Text("¿No recibiste el código? Reenviar",
                          style: TextStyle(decoration: TextDecoration.underline,
                              color: Color.fromARGB(255, 12, 11, 9))),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginView()),
                    ),
                    child: const Text("Volver al inicio de sesión",
                        style: TextStyle(fontSize: 16,
                            color: Color.fromARGB(255, 12, 11, 9),
                            decoration: TextDecoration.underline)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.w900));
}