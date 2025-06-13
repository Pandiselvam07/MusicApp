import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/custom_text_field.dart';
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
                'Sign In',
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
              AuthGradientButton(buttonText: 'Sign In', onTap: () {}),
              SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  text: 'Don\'t Have An Account?  ',
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: 'Sign up',
                      style: TextStyle(color: Pallete.gradient2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
