import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/features/home/home/domain/entities/home_entities/home_layout_entity.dart';
import 'package:flowrist/features/home/home/domain/use_cases/get_home_layout_usecase.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/cubit/home_cubit.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/cubit/home_event.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/cubit/home_state.dart';

import 'home_cubit_test.mocks.dart';

@GenerateMocks([GetHomeLayoutUseCase])
void main() {
  late MockGetHomeLayoutUseCase mockGetHomeLayoutUseCase;

  setUp(() {
    mockGetHomeLayoutUseCase = MockGetHomeLayoutUseCase();
    provideDummy<BaseResponse<List<HomeLayoutEntity>>>(
      SuccessResponse<List<HomeLayoutEntity>>([]),
    );
  });
  group('HomeCubit', () {
    test(
      'should emit loading then success when getHomeLayout succeeds',
      () async {
        // Arrange
        when(
          mockGetHomeLayoutUseCase(),
        ).thenAnswer((_) async => SuccessResponse<List<HomeLayoutEntity>>([]));

        final cubit = HomeCubit(mockGetHomeLayoutUseCase);

        // Act
        final future = expectLater(
          cubit.stream,
          emitsInOrder([
            predicate<HomeState>(
              (state) =>
                  state.homeLayout.isLoading == true &&
                  state.homeLayout.errorMessage == null &&
                  state.homeLayout.data == null,
            ),
            predicate<HomeState>(
              (state) =>
                  state.homeLayout.isLoading == false &&
                  state.homeLayout.errorMessage == null &&
                  state.homeLayout.data != null &&
                  state.homeLayout.data!.isEmpty,
            ),
          ]),
        );

        await cubit.doEvent(GetHomeLayout());

        await future;

        // Assert
        verify(mockGetHomeLayoutUseCase()).called(1);

        await cubit.close();
      },
    );

    test('should emit loading then error when getHomeLayout fails', () async {
      // Arrange
      const errorMessage = 'Failed to load home layout';

      when(mockGetHomeLayoutUseCase()).thenAnswer(
        (_) async => ErrorResponse<List<HomeLayoutEntity>>(errorMessage),
      );

      final cubit = HomeCubit(mockGetHomeLayoutUseCase);

      // Act
      final future = expectLater(
        cubit.stream,
        emitsInOrder([
          predicate<HomeState>(
            (state) =>
                state.homeLayout.isLoading == true &&
                state.homeLayout.errorMessage == null &&
                state.homeLayout.data == null,
          ),
          predicate<HomeState>(
            (state) =>
                state.homeLayout.isLoading == false &&
                state.homeLayout.errorMessage == errorMessage &&
                state.homeLayout.data == null,
          ),
        ]),
      );

      await cubit.doEvent(GetHomeLayout());

      await future;

      // Assert
      verify(mockGetHomeLayoutUseCase()).called(1);

      await cubit.close();
    });
  });
}
