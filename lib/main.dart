import 'package:firebase_core/firebase_core.dart';
import 'package:flowrist/config/di/di.dart';
import 'package:flowrist/config/notifications/local_notificatoin_service.dart';
import 'package:flowrist/config/notifications/notification_service.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/config/l10n/cubit/app_language_cubit.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_strings.dart';
import 'package:flowrist/core/ui/theme/app_theme.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_cubit.dart';
import 'package:flowrist/features/home/cart/presentation/cubit/cart_state.dart';
import 'package:flowrist/firebase_options.dart';
import 'package:flowrist/flowrist_bloc_observer.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_event.dart';
import 'package:flowrist/shared/addresses/presentation/view_model/addresses_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await LocalNotificationService.init();

  await _loadEnvironmentVariables();

  configureDependencies();

  Bloc.observer = FlowristBlocObserver();

  await PushNotificationsServices.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CartCubit>()),
        BlocProvider(create: (_) => getIt<AddressesViewModel>()),
        BlocProvider(create: (_) => getIt<AppLanguageCubit>()),
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

class FlowristApp extends StatefulWidget {
  const FlowristApp({super.key});

  @override
  State<FlowristApp> createState() => _FlowristAppState();
}

class _FlowristAppState extends State<FlowristApp> with WidgetsBindingObserver {
  bool _isRefreshingAddress = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshAddress();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshAddress();
    }
  }

  Future<void> _refreshAddress() async {
    if (!mounted || _isRefreshingAddress) {
      return;
    }

    _isRefreshingAddress = true;

    try {
      await context.read<AddressesViewModel>().doEvent(InitializeAddress());
    } finally {
      _isRefreshingAddress = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.watch<AppLanguageCubit>().state;

    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      locale: currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return BlocListener<CartCubit, CartState>(
          listenWhen: (prev, curr) =>
              prev.cart.errorMessage != curr.cart.errorMessage &&
              curr.cart.errorMessage != null &&
              curr.cart.errorMessage!.isNotEmpty,
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
