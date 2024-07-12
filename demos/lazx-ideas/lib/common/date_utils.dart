class DateUtils {
  static DateUtils? _instance;
  factory DateUtils() => _instance ??= DateUtils._();

  DateUtils._();

  //final DateFormat apiDateFormat = DateFormat("yyyy-MM-DD");
  //final DateFormat textDateFormat = DateFormat('MMM dd, yyyy');
}
