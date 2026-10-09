import 'package:bloc_test/bloc_test.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/features/addresses/domain/entities/address_entity.dart';
import 'package:flowrist/features/addresses/presentation/addresses/view/widgets/address_bottom_sheet/empty_address_view.dart';
import 'package:flowrist/features/addresses/presentation/saved_addresses/view/saved_addresses_view.dart';
import 'package:flowrist/features/addresses/presentation/saved_addresses/view/widgets/saved_address_item_card.dart';
import 'package:flowrist/features/addresses/presentation/saved_addresses/view_model/saved_addresses_event.dart';
import 'package:flowrist/features/addresses/presentation/saved_addresses/view_model/saved_addresses_state.dart';
import 'package:flowrist/features/addresses/presentation/saved_addresses/view_model/saved_addresses_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class MockSavedAddressesViewModel extends MockCubit<SavedAddressesState>
    implements SavedAddressesViewModel {
  @override
  Future<void> doEvent(SavedAddressesEvent event) async {}
}

void main() {
  late MockSavedAddressesViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockSavedAddressesViewModel();
  });

  const tAddress = AddressEntity(
    id: '1',
    recipientName: 'John Doe',
    recipientPhone: '01234567890',
    addressLine: '123 Main St',
    city: 'Cairo',
    area: 'Maadi',
    lat: 30.0,
    lng: 31.0,
    isDefault: true,
    isServiceable: true,
  );

  Widget createWidgetUnderTest() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider<SavedAddressesViewModel>.value(
        value: mockViewModel,
        child: const SavedAddressesView(),
      ),
    );
  }

  group('SavedAddressesView Widget Tests', () {
    testWidgets('renders CircularProgressIndicator when loading and no data',
        (tester) async {
      final state = SavedAddressesState.initial().copyWith(
        addressesState: BaseState.loading(),
      );
      whenListen(
        mockViewModel,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders empty view when addresses list is empty',
        (tester) async {
      final state = SavedAddressesState.initial().copyWith(
        addressesState: BaseState.success(const []),
      );
      whenListen(
        mockViewModel,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(EmptyAddressView), findsOneWidget);
    });

    testWidgets('renders address card when addresses list has data',
        (tester) async {
      final state = SavedAddressesState.initial().copyWith(
        addressesState: BaseState.success([tAddress]),
      );
      whenListen(
        mockViewModel,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(SavedAddressItemCard), findsOneWidget);
    });

    testWidgets('renders error message and retry button when error occurs',
        (tester) async {
      final state = SavedAddressesState.initial().copyWith(
        addressesState: BaseState.error('Failed to load addresses'),
      );
      whenListen(
        mockViewModel,
        Stream.value(state),
        initialState: state,
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Failed to load addresses'), findsOneWidget);
    });
  });
}
