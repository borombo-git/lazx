import 'package:intl/intl.dart';

class LxDateUtils {
  static LxDateUtils? _instance;
  factory LxDateUtils() => _instance ??= LxDateUtils._();

  LxDateUtils._();

  String getCurrentDate() {
    return DateFormat('MMMM dd. EEEE').format(DateTime.now());
  }
}
