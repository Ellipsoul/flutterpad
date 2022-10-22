// Custom response model returning an optional error
class ErrorModel {
  final String? error;
  final dynamic data;
  ErrorModel({
    required this.error,
    required this.data,
  });
}
