import '../../../../core/constants/app_strings.dart';

enum AuthFormMode {
  login,
  register;

  bool get isRegister => this == AuthFormMode.register;

  String get actionLabel => isRegister ? AppStrings.register : AppStrings.login;

  String get headerSubtitle => isRegister
      ? 'Create your account to organize every project.'
      : 'Welcome back! Login to continue.';

  String get panelTitle => isRegister ? 'Create account' : 'Welcome back';

  String get panelSubtitle => isRegister
      ? 'Add your details and start planning with clarity.'
      : 'Use your email and password to open your workspace.';

  String get switchPrompt =>
      isRegister ? AppStrings.alreadyHaveAccount : AppStrings.dontHaveAccount;

  AuthFormMode get opposite =>
      isRegister ? AuthFormMode.login : AuthFormMode.register;
}
