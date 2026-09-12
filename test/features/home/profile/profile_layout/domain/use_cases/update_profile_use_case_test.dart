import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/update_profile_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/entities/user_profile_entity.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/repositories/profile_repository.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/use_cases/update_profile_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_profile_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepository])
void main() {
  late MockProfileRepository mockRepository;
  late UpdateProfileUseCase useCase;

  const userEntity = UserProfileEntity(
    id: '1',
    firstName: 'Ali',
    lastName: 'Ibrahim',
    email: 'ali@example.com',
    phoneNumber: '01000000000',
    gender: 0,
    profilePictureUrl: 'https://example.com/pic.jpg',
  );

  setUpAll(() {
    provideDummy<BaseResponse<UserProfileEntity>>(SuccessResponse(userEntity));
  });

  setUp(() {
    mockRepository = MockProfileRepository();
    useCase = UpdateProfileUseCase(mockRepository);
  });

  group('UpdateProfileUseCase', () {
    const request = UpdateProfileRequestDto(
      firstName: 'Ali',
      lastName: 'Ibrahim',
      phoneNumber: '01000000000',
      gender: 0,
      profilePictureUrl: 'https://example.com/pic.jpg',
    );

    test('should delegate call to ProfileRepository.updateProfile', () async {
      when(
        mockRepository.updateProfile(request),
      ).thenAnswer((_) async => SuccessResponse(userEntity));

      final result = await useCase(request);

      expect(result, isA<SuccessResponse<UserProfileEntity>>());
      expect((result as SuccessResponse<UserProfileEntity>).data, userEntity);
      verify(mockRepository.updateProfile(request)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
