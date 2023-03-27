import 'package:flutter/material.dart';
import 'package:lazx/lazx.dart';
import 'package:lazx_idea/common/constants.dart';
import 'package:lazx_idea/ui/home_view_model.dart';

class HomeScreen extends LazxView<HomeViewModel> {
  @override
  HomeViewModel getViewModel() => HomeViewModel();

  @override
  void init(BuildContext context, HomeViewModel viewModel) {
    super.init(context, viewModel);
    LazxListener(
      data: viewModel.logoutRequest,
      error: (state) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An error occurred. Please try again.')));
      },
    );
  }

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lazx Ideas'),
        backgroundColor: kAccentColor,
      ),
      body: Center(
        child: Column(
          children: [
            Text('Hello Flutter 🐦', style: titleTextStyle),
            ElevatedButton(
                onPressed: () {
                  viewModel.logout();
                },
                child: Text('Logout'))
          ],
        ),
      ),
    );
  }
}
