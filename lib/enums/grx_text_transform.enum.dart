/// A Design System's enum that can be used to set text transform to every [GrxText] component.
enum GrxTextTransform {
  /// Default value for most use cases, do not affect the sent [data]
  none,

  /// Transform sent [data] to uppercase with [toUpperCase] string method
  uppercase,

  /// Transform sent [data] to lowercase with [toLowerCase] string method
  lowercase,
}
