/// [LxResponse] is a base object for a response from an API for example to handle
/// state and data
///
/// [T] is the type of the data returned
class LxResponse<T> {
  /// Value that check if the data is retrieved successfully
  bool success;

  /// Your data object, can be null in case of error
  T? data;

  /// Your error message that you would like to display
  String? error;

  /// By default, a response success is false
  LxResponse({this.success = false, this.data, this.error});
}
