import 'package:equatable/equatable.dart';

class NotificationState extends Equatable {
  final bool isEnabled;
  final bool isLoading;
  final String? errorMessage;

  const NotificationState({
    this.isEnabled = true,
    this.isLoading = false,
    this.errorMessage,
  });

  NotificationState copyWith({
    bool? isEnabled,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationState(
      isEnabled: isEnabled ?? this.isEnabled,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isEnabled,
        isLoading,
        errorMessage,
      ];
}