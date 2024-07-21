enum GenericStatus {
  none,
  loading,
  success,
  failure;

  bool get isLoading => this == loading;
  bool get isSuccess => this == success;
  bool get isFailed => this == failure;
  bool get isComplete => isSuccess || isFailed;

  int get _comparisonFactor {
    return switch (this) {
      none => 0,
      success => 1,
      failure => 2,
      loading => 3,
    };
  }

  GenericStatus operator +(GenericStatus other) {
    if (other == this) return this;
    return (_comparisonFactor > other._comparisonFactor) ? this : other;
  }
}
