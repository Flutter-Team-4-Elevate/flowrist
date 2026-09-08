import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/domain/entities/occasion/occasion_entity.dart';
import 'package:flowrist/features/home/home/domain/repositories/occasions_repository.dart';
import 'package:flowrist/features/home/home/domain/use_cases/get_occasions_use_case.dart';

import 'get_occasions_use_case_test.mocks.dart';

@GenerateMocks([OccasionsRepository])
void main() {
  late GetOccasionsUseCase useCase;
  late MockOccasionsRepository mockRepository;

  setUpAll(() {
    provideDummy<BaseResponse<List<OccasionEntity>>>(
      SuccessResponse<List<OccasionEntity>>([]),
    );
  });

  setUp(() {
    mockRepository = MockOccasionsRepository();
    useCase = GetOccasionsUseCase(mockRepository);
  });

  final tOccasions = [
    const OccasionEntity(id: '1', name: 'Birthday', imageUrl: 'birthday.png'),
  ];

  test('should return list of OccasionEntity on success', () async {
    when(
      mockRepository.getOccasions(),
    ).thenAnswer((_) async => SuccessResponse(tOccasions));

    final result = await useCase();

    expect(result, isA<SuccessResponse<List<OccasionEntity>>>());
    expect((result as SuccessResponse).data, tOccasions);
    verify(mockRepository.getOccasions()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
