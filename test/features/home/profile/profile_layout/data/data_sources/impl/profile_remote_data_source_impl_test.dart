import 'package:flowrist/features/home/profile/profile_layout/data/client/profile_api_client.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/data_sources/contract/profile_remote_data_source.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/data_sources/impl/profile_remote_data_source_impl.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/logout_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/response/logout_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ProfileApiClient])
void main() {
  late MockProfileApiClient mockApiClient;
  late ProfileRemoteDataSource dataSource;

  setUp(() {
    mockApiClient = MockProfileApiClient();
    dataSource = ProfileRemoteDataSourceImpl(mockApiClient);
  });

  group('ProfileRemoteDataSourceImpl.logout', () {
    const request = LogoutRequestDto(refreshToken: 'test_token');
    const response = LogoutResponseDto(
      status: true,
      code: 200,
      message: 'Logged out',
    );

    test(
      'should return LogoutResponseDto when api client completes successfully',
      () async {
        when(mockApiClient.logout(request)).thenAnswer((_) async => response);

        final result = await dataSource.logout(request);

        expect(result, response);
        verify(mockApiClient.logout(request)).called(1);
        verifyNoMoreInteractions(mockApiClient);
      },
    );

    test('should rethrow Exception when api client throws an error', () async {
      when(mockApiClient.logout(request)).thenThrow(Exception('Server error'));

      expect(() => dataSource.logout(request), throwsA(isA<Exception>()));
      verify(mockApiClient.logout(request)).called(1);
    });
  });
}
