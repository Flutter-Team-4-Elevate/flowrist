import 'package:flowrist/features/auth/data/data_sources/impl/remote/auth_remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/features/auth/data/client/auth_api_client.dart';
import 'package:flowrist/features/auth/data/models/register_request_dto.dart';
import 'package:flowrist/features/auth/data/models/register_response_dto.dart';

@GenerateMocks([AuthApiClient])
import 'auth_remote_data_source_impl_test.mocks.dart';

void main() {
  late MockAuthApiClient mockApiClient;
  late AuthRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    mockApiClient = MockAuthApiClient();
    remoteDataSource = AuthRemoteDataSourceImpl(mockApiClient);
  });

  const tRequestDto = RegisterRequestDto(
    firstName: 'Ali',
    lastName: 'Ibrahim',
    email: 'ali@example.com',
    phone: '01000000000',
    gender: 0,
    password: 'Password123!',
    confirmPassword: 'Password123!',
    fcmToken: 'token',
    notificationStatus: 1,
  );

  const tResponseDto = RegisterResponseDto(
    message: 'Success',
    data: RegisterDataDto(token: 'jwt_token_example'),
  );

  group('AuthRemoteDataSourceImpl Unit Tests', () {
    test(
      'should call apiClient.register and return RegisterResponseDto on success',
      () async {
        // Arrange
        when(mockApiClient.register(any)).thenAnswer((_) async => tResponseDto);

        // Act
        final result = await remoteDataSource.register(tRequestDto);

        // Assert
        expect(result, equals(tResponseDto));
        verify(mockApiClient.register(tRequestDto)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test('should rethrow exception when apiClient.register fails', () async {
      // Arrange
      when(mockApiClient.register(any)).thenThrow(Exception('Server error'));

      // Act & Assert
      expect(
        () => remoteDataSource.register(tRequestDto),
        throwsA(isA<Exception>()),
      );
      verify(mockApiClient.register(tRequestDto)).called(1);
    });
  });
}
