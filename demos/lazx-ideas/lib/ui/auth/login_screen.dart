import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';
import 'package:lazx_idea/ui/auth/login_view_model.dart';

import '../../common/constants.dart';

class LoginScreen extends LazxView<LoginViewModel> {
  @override
  LoginViewModel getViewModel() => LoginViewModel();

  @override
  void init(BuildContext context, LoginViewModel viewModel) {
    super.init(context, viewModel);
    LazxListener(
      data: viewModel.loginRequest,
      error: (state) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An error occurred. Please try again.')));
      },
    );
  }

  @override
  Widget build(BuildContext context, LoginViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lazx Ideas'),
        backgroundColor: kAccentColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: viewModel.emailTextController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                controller: viewModel.passwordTextController,
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                  onPressed: () {
                    viewModel.signUp();
                  },
                  child: Text('Login'))
            ],
          ),
        ),
      ),
    );
  }
}
