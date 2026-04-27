class ModelsRespontDataMap <T> {
  bool status;
  String message;
  T? data;

  ModelsRespontDataMap({
    required this.status,
    required this.message,
    this.data,
  });
}
