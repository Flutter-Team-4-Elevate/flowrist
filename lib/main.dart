import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_strings.dart';
import 'package:flowrist/core/ui/theme/app_theme.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_state.dart';
import 'package:flowrist/flowrist_bloc_observer.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadEnvironmentVariables();
  configureDependencies();

  Bloc.observer = FlowristBlocObserver();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CartCubit>()),
        BlocProvider(create: (_) => getIt<AddressesViewModel>()),
      ],
      child: const FlowristApp(),
    ),
  );
}

Future<void> _loadEnvironmentVariables() async {
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Error loading .env file: $e');
  }
}

class FlowristApp extends StatelessWidget {
  const FlowristApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return BlocListener<CartCubit, CartState>(
          listenWhen: (prev, curr) =>
              curr.cart.errorMessage != null &&
              prev.cart.errorMessage != curr.cart.errorMessage,
          listener: (context, state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.cart.errorMessage!),
                backgroundColor: AppColors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
