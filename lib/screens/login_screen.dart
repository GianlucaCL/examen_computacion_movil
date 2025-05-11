import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/widgets.dart';
import '../providers/login_form_provider.dart';
import '../ui/input_decorations.dart';
import '../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 150, 243), // Fondo azul
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 150),
            CardContainer(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Login',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 30),
                  ChangeNotifierProvider(
                    create: (_) => LoginFormProvider(),
                    child: const LoginForm(),
                  ),
                  const SizedBox(height: 50),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/register'),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                        Colors.blueAccent.withOpacity(0.1),
                      ),
                      shape: MaterialStateProperty.all(
                        const StadiumBorder(),
                      ),
                    ),
                    child: const Text('No tienes una cuenta?, creala',
                        style: TextStyle(color: Colors.blueAccent)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(children: [
        TextFormField(
          autocorrect: false,
          keyboardType: TextInputType.text,
          decoration: InputDecortions.authInputDecoration(
            hinText: 'Ingrese su correo',
            labelText: 'Email',
            prefixIcon: Icons.people,
          ),
          onChanged: (value) => loginForm.email = value,
          validator: (value) {
            return (value != null && value.length >= 4)
                ? null
                : 'El usuario no puede estar vacio';
          },
        ),
        const SizedBox(height: 30),
        TextFormField(
          autocorrect: false,
          obscureText: true,
          keyboardType: TextInputType.text,
          decoration: InputDecortions.authInputDecoration(
            hinText: '************',
            labelText: 'Password',
            prefixIcon: Icons.lock_outline,
          ),
          onChanged: (value) => loginForm.password = value,
          validator: (value) {
            return (value != null && value.length >= 4)
                ? null
                : 'La contraseña no puede estar vacio';
          },
        ),
        const SizedBox(height: 50),
        MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          disabledColor: Colors.grey,
          color: Colors.blue, // Botón azul
          elevation: 0,
          onPressed: loginForm.isLoading
              ? null
              : () async {
                  FocusScope.of(context).unfocus();
                  final authService =
                      Provider.of<AuthService>(context, listen: false);
                  if (!loginForm.isValidForm()) return;
                  loginForm.isLoading = true;
                  final String? errorMessage = await authService.login(
                      loginForm.email, loginForm.password);
                  if (errorMessage == null) {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  } else {
                    print(errorMessage);
                  }
                  loginForm.isLoading = false;
                },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
            child: const Text(
              'Ingresar',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        )
      ]),
    );
  }
}
