class LxResponse<T> {
  bool success;
  T? data;
  String? error;

  LxResponse({this.success = false, this.data, this.error});
}
