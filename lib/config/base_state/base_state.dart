class BaseState<T> {
  final bool isLoading;
  final String? errorMessage;
  final T? data;

  BaseState({
    required this.isLoading,
    required this.errorMessage,
    required this.data,
  });

  BaseState.initial() : this(isLoading: false, errorMessage: null, data: null);

  factory BaseState.loading() =>
      BaseState(isLoading: true, errorMessage: null, data: null);

  factory BaseState.success(T data) =>
      BaseState(isLoading: false, errorMessage: null, data: data);

  factory BaseState.error(String message) =>
      BaseState(isLoading: false, errorMessage: message, data: null);

  BaseState<T> copyWith({bool? isLoading, String? errorMessage, T? data}) {
    return BaseState<T>(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
    );
  }
}
