class CarrotOptional<T> {
  final T? value;

  const CarrotOptional.empty() : value = null;

  const CarrotOptional.of(T this.value);

  static T ensure<T>(CarrotOptional<T>? optional, T orElse) => optional != null ? optional.value ?? orElse : orElse;

  static T? valueOr<T>(CarrotOptional<T>? optional, T? orElse) => optional != null ? optional.value : orElse;
}
