import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              //Temp Outcrop logo
              Text('Outcrop', style: TextStyle(fontSize: 30)),
              SizedBox(height: 40),

              //Login Text
              Text('Login', style: TextStyle(fontSize: 30)),
              SizedBox(height: 40),

              // Username
              SizedBox(
                width: 300,
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // Password
              SizedBox(
                width: 300,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Login Button
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    // Temporary login logic
                    final username = usernameController.text;
                    final password = passwordController.text;

                    // Later: validate / call auth service. Go to homepage for now
                    context.go('/home');
                  },
                  child: const Text('Login'),
                ),
              ),
              SizedBox(height: 10),
              Text('or'),
              SizedBox(height: 10),

              // Sign Up Button
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/signup');
                  },
                  child: const Text('signup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
