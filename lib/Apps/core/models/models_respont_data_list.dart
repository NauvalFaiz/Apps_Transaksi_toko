class ModelsRespontDataList<T> {
  bool status;
  String message;
  List<T>? data;
  ModelsRespontDataList({
    required this.status,
    required this.message,
    this.data,
  });
}
