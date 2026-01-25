
extension StringExtensions on String {
  String get soNumero => replaceAll(RegExp(r'\D'), '');

  String get normalize => toLowerCase().trim();
}
