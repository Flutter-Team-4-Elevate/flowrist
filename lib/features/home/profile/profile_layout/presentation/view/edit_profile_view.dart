import 'dart:io';
import 'package:flowrist/config/form_validator/form_validator.dart';
import 'package:flowrist/config/l10n/app_localizations.dart';
import 'package:flowrist/core/constants/app_colors.dart';
import 'package:flowrist/core/constants/app_dimensions.dart';
import 'package:flowrist/core/constants/app_router.dart';
import 'package:flowrist/core/constants/app_styles.dart';
import 'package:flowrist/core/ui/widgets/app_text_field.dart';
import 'package:flowrist/features/auth/presentation/signup/widgets/gender_section.dart';
import 'package:flowrist/features/auth/presentation/signup/widgets/name_fields.dart';
import 'package:flowrist/features/home/profile/profile_layout/data/models/request/update_profile_request_dto.dart';
import 'package:flowrist/features/home/profile/profile_layout/domain/entities/user_profile_entity.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/cubit/profile_cubit.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/cubit/profile_events.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/cubit/profile_state.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/view/widgets/edit_profile_avatar.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/view/widgets/edit_profile_password_field.dart';
import 'package:flowrist/features/home/profile/profile_layout/presentation/view/widgets/edit_profile_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends StatefulWidget {
  final UserProfileEntity userProfile;

  const EditProfileView({super.key, required this.userProfile});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordPlaceholderController;
  late Gender _selectedGender;

  File? _selectedImageFile;
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _firstNameController = TextEditingController(
      text: widget.userProfile.firstName,
    );
    _lastNameController = TextEditingController(
      text: widget.userProfile.lastName,
    );
    _emailController = TextEditingController(text: widget.userProfile.email);
    _phoneController = TextEditingController(
      text: widget.userProfile.phoneNumber,
    );
    _passwordPlaceholderController = TextEditingController(text: '••••••••');
    _selectedGender = widget.userProfile.gender == 0
        ? Gender.male
        : Gender.female;

    _firstNameController.addListener(_checkFormChanges);
    _lastNameController.addListener(_checkFormChanges);
    _phoneController.addListener(_checkFormChanges);
  }

  void _checkFormChanges() {
    final hasChanged =
        _selectedImageFile != null ||
        _firstNameController.text.trim() != widget.userProfile.firstName ||
        _lastNameController.text.trim() != widget.userProfile.lastName ||
        _phoneController.text.trim() != widget.userProfile.phoneNumber ||
        _selectedGender.value != widget.userProfile.gender;

    _isButtonEnabled.value = hasChanged;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
      _checkFormChanges();
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordPlaceholderController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.sizeOf(context);
    final screenHeight = size.height;
    final screenWidth = size.width;

    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (prev, current) =>
          prev.updateProfileState != current.updateProfileState,
      listener: (context, state) => _handleUpdateState(context, state, l10n),
      child: Scaffold(
        backgroundColor: AppColors.whiteBase,
        appBar: _buildAppBar(l10n),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.defaultScreenPadding,
            ),
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: _buildFormFields(
                  l10n: l10n,
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations l10n) {
    return AppBar(
      title: Text(l10n.editProfile, style: AppStyles.medium18Inter),
      titleSpacing: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
      ],
    );
  }

  List<Widget> _buildFormFields({
    required AppLocalizations l10n,
    required double screenWidth,
    required double screenHeight,
  }) {
    return [
      SizedBox(height: screenHeight * 0.02),
      EditProfileAvatar(
        photoUrl: widget.userProfile.profilePictureUrl,
        imageFile: _selectedImageFile,
        onPickImage: _pickImage,
      ),
      SizedBox(height: screenHeight * 0.03),
      NameFields(
        firstNameController: _firstNameController,
        lastNameController: _lastNameController,
        localizations: l10n,
        screenWidth: screenWidth,
      ),
      SizedBox(height: screenHeight * 0.025),
      _buildEmailField(l10n),
      SizedBox(height: screenHeight * 0.025),
      _buildPhoneField(l10n),
      SizedBox(height: screenHeight * 0.025),
      EditProfilePasswordField(
        controller: _passwordPlaceholderController,
        localizations: l10n,
        onChangePassword: () => context.push(AppRoutes.resetPassword),
      ),
      SizedBox(height: screenHeight * 0.025),
      GenderSection(
        selectedGender: _selectedGender,
        onGenderChanged: (gender) {
          setState(() => _selectedGender = gender);
          _checkFormChanges();
        },
        localizations: l10n,
        screenWidth: screenWidth,
      ),
      SizedBox(height: screenHeight * 0.04),
      EditProfileSubmitButton(
        isEnabledNotifier: _isButtonEnabled,
        screenHeight: screenHeight,
        localizations: l10n,
        onSubmit: _onSubmit,
      ),
      SizedBox(height: screenHeight * 0.03),
    ];
  }

  Widget _buildEmailField(AppLocalizations l10n) {
    return AppTextField(
      label: l10n.email,
      hint: l10n.enterEmail,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (_) => null,
      localizations: l10n,
    );
  }

  Widget _buildPhoneField(AppLocalizations l10n) {
    return AppTextField(
      label: l10n.phoneNumber,
      hint: l10n.enterPhoneNumber,
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      validationPattern: FormValidator.phonePattern,
      validationErrorMessage: l10n.generalValidationError,
      localizations: l10n,
    );
  }

  void _handleUpdateState(
    BuildContext context,
    ProfileState state,
    AppLocalizations l10n,
  ) {
    final updateState = state.updateProfileState;

    if (updateState.isLoading) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(color: AppColors.purpleBase),
        ),
      );
    } else {
      Navigator.of(context, rootNavigator: true).maybePop();

      if (updateState.errorMessage != null &&
          updateState.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(updateState.errorMessage!),
            backgroundColor: AppColors.red,
          ),
        );
      } else if (updateState.data != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.profileUpdatedSuccessfully),
            backgroundColor: AppColors.green,
          ),
        );
        context.pop();
      }
    }
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final request = UpdateProfileRequestDto(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        gender: _selectedGender.value,
        profilePictureUrl: widget.userProfile.profilePictureUrl,
      );

      context.read<ProfileCubit>().doEvent(UpdateProfileEvent(request));
    }
  }
}
