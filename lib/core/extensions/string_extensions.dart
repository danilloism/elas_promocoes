extension NullableExtensions on String? {
  String? get valueOrNull {
    if (this == null || this!.isEmpty) return null;
    return this;
  }
}
