// import 'package:flowrist/features/home/shared/home_address/domain/entities/address_entities/address_entity.dart';
// import 'package:flowrist/features/home/shared/home_address/presentation/cubit/home_address_cubit/home_address_cubit.dart';
// import 'package:flowrist/features/home/shared/home_address/presentation/widgets/address_bottom_sheet/address_bottom_sheet_content.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// Future<void> showAddressBottomSheet(
//   BuildContext context, {
//   required List<AddressEntity> addresses,
//   required String? selectedAddressId,
// }) async {
//   await showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     useRootNavigator: true,

//     builder: (bottomSheetContext) {
//       return BlocProvider.value(
//         value: context.read<HomeAddressCubit>(),
//         child: AddressBottomSheetContent(
//           addresses: addresses,
//           selectedAddressId: selectedAddressId,
//         ),
//       );
//     },
//   );
// }
