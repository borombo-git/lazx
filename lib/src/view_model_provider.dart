import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///
///
///
///
class ViewModelProvider {
  static T getViewModel<T>(BuildContext context) {
    return Provider.of<T>(context, listen: false);
  }
}
