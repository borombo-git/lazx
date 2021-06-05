extension StringExtension on String {
  String capitalize() {
    if (this.length > 0) {
      return "${this[0].toUpperCase()}${this.substring(1)}";
    } else {
      return '';
    }
  }
}
