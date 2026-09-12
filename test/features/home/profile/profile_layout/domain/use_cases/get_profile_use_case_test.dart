import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/entities/user_profile_entity.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/repositories/profile_repository.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/use_cases/get_profile_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_profile_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepository])
void main() {
  late MockProfileRepository mockRepository;
  late GetProfileUseCase useCase;

  const userEntity = UserProfileEntity(
    id: '1',
    firstName: 'Ali',
    lastName: 'Ibrahim',
    email: 'ali@example.com',
    phoneNumber: '01000000000',
    gender: 0,
    profilePictureUrl: '',
  );

  setUpAll(() {
    provideDummy<BaseResponse<UserProfileEntity>>(SuccessResponse(userEntity));
  });

  setUp(() {
    mockRepository = MockProfileRepository();
    useCase = GetProfileUseCase(mockRepository);
  });

  group('GetProfileUseCase', () {
    test('should delegate call to ProfileRepository.getProfile', () async {
      when(
        mockRepository.getProfile(),
      ).thenAnswer((_) async => SuccessResponse(userEntity));

      final result = await useCase();

      expect(result, isA<SuccessResponse<UserProfileEntity>>());
      expect((result as SuccessResponse<UserProfileEntity>).data, userEntity);
      verify(mockRepository.getProfile()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
