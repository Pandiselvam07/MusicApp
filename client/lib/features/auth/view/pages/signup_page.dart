import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/custom_text_field.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:flutter/material.dart';
import '../widgets/auth_gradient_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
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
                'Sign Up',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 25),
              CustomTextField(hintText: 'Name', controller: _nameController),
              SizedBox(height: 15),
              CustomTextField(hintText: 'Email', controller: _emailController),
              SizedBox(height: 15),
              CustomTextField(
                hintText: 'Password',
                controller: _passwordController,
                isObscureText: true,
              ),
              SizedBox(height: 15),
              AuthGradientButton(
                buttonText: 'Sign Up',
                onTap: () async {
                  final res = await AuthRemoteRepository().signup(
                    name: _nameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                  );
                  print(res);
                },
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => LoginPage())),
                child: RichText(
                  text: TextSpan(
                    text: 'Already Have An Account?  ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: 'Sign In',
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
