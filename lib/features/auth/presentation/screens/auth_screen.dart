import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_snack_bar.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_form_mode.dart';
import '../widgets/auth_form_panel.dart';
import '../widgets/auth_screen_layout.dart';

class AuthScreen extends StatefulWidget {
  final AuthFormMode initialMode;

  const AuthScreen({
    this.initialMode = AuthFormMode.login,
    super.key,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late AuthFormMode _mode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go('/home');
          } else if (state is AuthError) {
            AppSnackBar.show(
              context,
              message: state.message,
              type: AppSnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return AuthScreenLayout(
            mode: _mode,
            child: AuthFormPanel(
              mode: _mode,
              isLoading: isLoading,
              onModeChanged: _setMode,
            ),
          );
        },
      ),
    );
  }

  @override
  void didUpdateWidget(covariant AuthScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialMode != widget.initialMode) {
      _mode = widget.initialMode;
    }
  }

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
  }

  void _setMode(AuthFormMode mode) {
    if (_mode == mode) {
      return;
    }

    setState(() => _mode = mode);
  }
}
