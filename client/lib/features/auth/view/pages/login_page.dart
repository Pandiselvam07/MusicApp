import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/custom_text_field.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:flutter/material.dart';

import '../widgets/auth_gradient_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 25),
              CustomTextField(hintText: 'Email', controller: _emailController),
              SizedBox(height: 15),
              CustomTextField(
                hintText: 'Password',
                controller: _passwordController,
                isObscureText: true,
              ),
              SizedBox(height: 15),
              AuthGradientButton(
                buttonText: 'Sign In',
                onTap: () async {
                  await AuthRemoteRepository().login(
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                },
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => SignupPage())),
                child: RichText(
                  text: TextSpan(
                    text: 'Don\'t Have An Account?  ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(color: Pallete.gradient2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
