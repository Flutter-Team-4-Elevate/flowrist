import 'package:bloc_test/bloc_test.dart';
import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/addresses/presentation/saved_addresses/view_model/saved_addresses_event.dart';
import 'package:flowrist/features/addresses/presentation/saved_addresses/view_model/saved_addresses_state.dart';
import 'package:flowrist/features/addresses/presentation/saved_addresses/view_model/saved_addresses_view_model.dart';
import 'package:flowrist/shared/addresses/domain/entities/address_entity.dart';
import 'package:flowrist/shared/addresses/domain/use_cases/delete_address_use_case.dart';
import 'package:flowrist/shared/addresses/domain/use_cases/get_all_user_addresses_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'saved_addresses_view_model_test.mocks.dart';

@GenerateMocks([GetAllUserAddressesUseCase, DeleteAddressUseCase])
void main() {
  provideDummy<BaseResponse<List<AddressEntity>>>(
    SuccessResponse<List<AddressEntity>>([]),
  );
  provideDummy<BaseResponse<String>>(
    SuccessResponse<String>('Address deleted successfully.'),
  );

  late MockGetAllUserAddressesUseCase mockGetAllUserAddressesUseCase;
  late MockDeleteAddressUseCase mockDeleteAddressUseCase;
  late SavedAddressesViewModel viewModel;

  setUp(() {
    mockGetAllUserAddressesUseCase = MockGetAllUserAddressesUseCase();
    mockDeleteAddressUseCase = MockDeleteAddressUseCase();
    viewModel = SavedAddressesViewModel(
      mockGetAllUserAddressesUseCase,
      mockDeleteAddressUseCase,
    );
  });

  const tAddress1 = AddressEntity(
    id: '1',
    recipientName: 'John Doe',
    recipientPhone: '01234567890',
    addressLine: '2XVP+XC',
    city: 'Cairo',
    area: 'Sheikh Zayed',
    lat: 30.0444,
    lng: 31.2357,
    isDefault: true,
    isServiceable: true,
  );

  const tAddress2 = AddressEntity(
    id: '2',
    recipientName: 'Jane Doe',
    recipientPhone: '01234567891',
    addressLine: '4YZA+WD',
    city: 'Giza',
    area: 'Dokki',
    lat: 30.0384,
    lng: 31.2115,
    isDefault: false,
    isServiceable: true,
  );

  final tAddressesList = [tAddress1, tAddress2];

  group('SavedAddressesViewModel', () {
    test('initial state should be SavedAddressesState.initial()', () {
      expect(viewModel.state, equals(SavedAddressesState.initial()));
      expect(viewModel.state.addressesState.isLoading, isFalse);
      expect(viewModel.state.addressesState.data, isNull);
      expect(viewModel.state.addressesState.errorMessage, isNull);
      expect(viewModel.state.deleteAddressState.isLoading, isFalse);
      expect(viewModel.state.deleteAddressState.data, isNull);
      expect(viewModel.state.deletingAddressId, isNull);
    });

    group('GetSavedAddressesEvent', () {
      blocTest<SavedAddressesViewModel, SavedAddressesState>(
        'emits [isLoading: true] then [isLoading: false, data: addresses] on SuccessResponse',
        build: () {
          when(mockGetAllUserAddressesUseCase()).thenAnswer(
            (_) async => SuccessResponse<List<AddressEntity>>(tAddressesList),
          );
          return viewModel;
        },
        act: (cubit) => cubit.doEvent(GetSavedAddressesEvent()),
        expect: () => [
          isA<SavedAddressesState>().having(
            (s) => s.addressesState,
            'addressesState',
            const BaseState<List<AddressEntity>>(
              isLoading: true,
              errorMessage: null,
              data: null,
            ),
          ),
          isA<SavedAddressesState>().having(
            (s) => s.addressesState,
            'addressesState',
            BaseState<List<AddressEntity>>(
              isLoading: false,
              errorMessage: null,
              data: tAddressesList,
            ),
          ),
        ],
        verify: (_) {
          verify(mockGetAllUserAddressesUseCase()).called(1);
        },
      );

      blocTest<SavedAddressesViewModel, SavedAddressesState>(
        'emits [isLoading: true] then [isLoading: false, data: []] on empty SuccessResponse',
        build: () {
          when(
            mockGetAllUserAddressesUseCase(),
          ).thenAnswer((_) async => SuccessResponse<List<AddressEntity>>([]));
          return viewModel;
        },
        act: (cubit) => cubit.doEvent(GetSavedAddressesEvent()),
        expect: () => [
          isA<SavedAddressesState>().having(
            (s) => s.addressesState,
            'addressesState',
            const BaseState<List<AddressEntity>>(
              isLoading: true,
              errorMessage: null,
              data: null,
            ),
          ),
          isA<SavedAddressesState>().having(
            (s) => s.addressesState,
            'addressesState',
            const BaseState<List<AddressEntity>>(
              isLoading: false,
              errorMessage: null,
              data: [],
            ),
          ),
        ],
        verify: (_) {
          verify(mockGetAllUserAddressesUseCase()).called(1);
        },
      );

      blocTest<SavedAddressesViewModel, SavedAddressesState>(
        'emits [isLoading: true] then [isLoading: false, errorMessage: error] on ErrorResponse',
        build: () {
          when(mockGetAllUserAddressesUseCase()).thenAnswer(
            (_) async =>
                ErrorResponse<List<AddressEntity>>('Failed to load addresses'),
          );
          return viewModel;
        },
        act: (cubit) => cubit.doEvent(GetSavedAddressesEvent()),
        expect: () => [
          isA<SavedAddressesState>().having(
            (s) => s.addressesState,
            'addressesState',
            const BaseState<List<AddressEntity>>(
              isLoading: true,
              errorMessage: null,
              data: null,
            ),
          ),
          isA<SavedAddressesState>().having(
            (s) => s.addressesState,
            'addressesState',
            const BaseState<List<AddressEntity>>(
              isLoading: false,
              errorMessage: 'Failed to load addresses',
              data: null,
            ),
          ),
        ],
        verify: (_) {
          verify(mockGetAllUserAddressesUseCase()).called(1);
        },
      );

      blocTest<SavedAddressesViewModel, SavedAddressesState>(
        'emits [isLoading: true] then [isLoading: false, errorMessage: Exception] on thrown Exception',
        build: () {
          when(
            mockGetAllUserAddressesUseCase(),
          ).thenThrow(Exception('Network connection failed'));
          return viewModel;
        },
        act: (cubit) => cubit.doEvent(GetSavedAddressesEvent()),
        expect: () => [
          isA<SavedAddressesState>().having(
            (s) => s.addressesState,
            'addressesState',
            const BaseState<List<AddressEntity>>(
              isLoading: true,
              errorMessage: null,
              data: null,
            ),
          ),
          isA<SavedAddressesState>()
              .having((s) => s.addressesState.isLoading, 'isLoading', isFalse)
              .having(
                (s) => s.addressesState.errorMessage,
                'errorMessage',
                contains('Network connection failed'),
              ),
        ],
        verify: (_) {
          verify(mockGetAllUserAddressesUseCase()).called(1);
        },
      );
    });

    group('DeleteAddressEvent', () {
      blocTest<SavedAddressesViewModel, SavedAddressesState>(
        'emits loading delete state then removes address and emits success on SuccessResponse',
        seed: () => SavedAddressesState.initial().copyWith(
          addressesState: BaseState.success(tAddressesList),
        ),
        build: () {
          when(mockDeleteAddressUseCase('1')).thenAnswer(
            (_) async =>
                SuccessResponse<String>('Address deleted successfully.'),
          );
          return viewModel;
        },
        act: (cubit) => cubit.doEvent(DeleteAddressEvent('1')),
        expect: () => [
          isA<SavedAddressesState>()
              .having((s) => s.deletingAddressId, 'deletingAddressId', '1')
              .having(
                (s) => s.deleteAddressState.isLoading,
                'deleteAddressState.isLoading',
                isTrue,
              ),
          isA<SavedAddressesState>()
              .having((s) => s.deletingAddressId, 'deletingAddressId', isNull)
              .having(
                (s) => s.deleteAddressState.data,
                'deleteAddressState.data',
                'Address deleted successfully.',
              )
              .having((s) => s.addressesState.data, 'addressesState.data', [
                tAddress2,
              ]),
        ],
        verify: (_) {
          verify(mockDeleteAddressUseCase('1')).called(1);
        },
      );

      blocTest<SavedAddressesViewModel, SavedAddressesState>(
        'emits loading delete state then emits error on ErrorResponse',
        seed: () => SavedAddressesState.initial().copyWith(
          addressesState: BaseState.success(tAddressesList),
        ),
        build: () {
          when(mockDeleteAddressUseCase('1')).thenAnswer(
            (_) async => ErrorResponse<String>('Address not found.'),
          );
          return viewModel;
        },
        act: (cubit) => cubit.doEvent(DeleteAddressEvent('1')),
        expect: () => [
          isA<SavedAddressesState>()
              .having((s) => s.deletingAddressId, 'deletingAddressId', '1')
              .having(
                (s) => s.deleteAddressState.isLoading,
                'deleteAddressState.isLoading',
                isTrue,
              ),
          isA<SavedAddressesState>()
              .having((s) => s.deletingAddressId, 'deletingAddressId', isNull)
              .having(
                (s) => s.deleteAddressState.errorMessage,
                'deleteAddressState.errorMessage',
                'Address not found.',
              )
              .having(
                (s) => s.addressesState.data,
                'addressesState.data',
                tAddressesList,
              ),
        ],
        verify: (_) {
          verify(mockDeleteAddressUseCase('1')).called(1);
        },
      );

      blocTest<SavedAddressesViewModel, SavedAddressesState>(
        'emits loading delete state then emits error on thrown Exception',
        seed: () => SavedAddressesState.initial().copyWith(
          addressesState: BaseState.success(tAddressesList),
        ),
        build: () {
          when(
            mockDeleteAddressUseCase('1'),
          ).thenThrow(Exception('Server unreachable'));
          return viewModel;
        },
        act: (cubit) => cubit.doEvent(DeleteAddressEvent('1')),
        expect: () => [
          isA<SavedAddressesState>()
              .having((s) => s.deletingAddressId, 'deletingAddressId', '1')
              .having(
                (s) => s.deleteAddressState.isLoading,
                'deleteAddressState.isLoading',
                isTrue,
              ),
          isA<SavedAddressesState>()
              .having((s) => s.deletingAddressId, 'deletingAddressId', isNull)
              .having(
                (s) => s.deleteAddressState.errorMessage,
                'deleteAddressState.errorMessage',
                contains('Server unreachable'),
              ),
        ],
        verify: (_) {
          verify(mockDeleteAddressUseCase('1')).called(1);
        },
      );
    });
  });
}
