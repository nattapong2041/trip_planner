import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../utils/responsive.dart';
import '../../widgets/common/responsive_error_display.dart';
import '../../widgets/common/loading_button.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final errorState = ref.watch(errorNotifierProvider);

    // Listen for auth state changes and show success message
    ref.listen<AsyncValue<User?>>(authNotifierProvider, (previous, next) {
      if (next.hasValue && next.value != null) {
        ref.read(successNotifierProvider.notifier).showSuccessWithAutoClear(
          'Welcome back, ${next.value!.displayName}!',
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Planner'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: ResponsiveContainer(
        child: ResponsiveBuilder(
          mobile: _buildMobileLayout(context, authState, errorState),
          tablet: _buildTabletLayout(context, authState, errorState),
          desktop: _buildDesktopLayout(context, authState, errorState),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, AsyncValue authState, errorState) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Responsive.getSpacing(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.luggage,
              size: Responsive.getIconSize(context, baseSize: 80),
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: Responsive.getSpacing(context)),
            Text(
              'Welcome to Trip Planner',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
            Text(
              'Plan amazing trips with your friends',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Responsive.getSpacing(context, baseSpacing: 48.0)),
            _buildAuthButtons(context, authState, errorState),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, AsyncValue authState, errorState) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(Responsive.getSpacing(context)),
        child: Container(
          width: Responsive.getDialogWidth(context),
          padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 32.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.luggage,
                size: Responsive.getIconSize(context, baseSize: 100),
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: Responsive.getSpacing(context, baseSpacing: 24.0)),
              Text(
                'Welcome to Trip Planner',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Responsive.getSpacing(context)),
              Text(
                'Plan amazing trips with your friends',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Responsive.getSpacing(context, baseSpacing: 32.0)),
              _buildAuthButtons(context, authState, errorState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AsyncValue authState, errorState) {
    return Row(
      children: [
        // Left side - Hero section
        Expanded(
          flex: 3,
          child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 48.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.luggage,
                      size: Responsive.getIconSize(context, baseSize: 120),
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    SizedBox(height: Responsive.getSpacing(context, baseSpacing: 24.0)),
                    Text(
                      'Trip Planner',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: Responsive.getSpacing(context)),
                    Text(
                      'Collaborate with friends to plan the perfect trip',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Right side - Auth form
        Expanded(
          flex: 2,
          child: Center(
            child: Container(
              width: 400,
              padding: EdgeInsets.all(Responsive.getSpacing(context, baseSpacing: 48.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: Responsive.getSpacing(context, baseSpacing: 8.0)),
                  Text(
                    'Sign in to continue planning',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  SizedBox(height: Responsive.getSpacing(context, baseSpacing: 32.0)),
                  _buildAuthButtons(context, authState, errorState),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthButtons(BuildContext context, AsyncValue authState, errorState) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: LoadingButton(
            onPressed: _isGoogleLoading ? null : () => _handleGoogleSignIn(),
            isLoading: _isGoogleLoading,
            loadingText: 'Signing in with Google...',
            icon: Icon(
              Icons.login,
              size: Responsive.getIconSize(context, baseSize: 20),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Sign in with Google'),
          ),
        ),
        
        SizedBox(height: Responsive.getSpacing(context)),
        
        // Apple Sign In Button (only show on supported platforms)
        if (_isAppleSignInSupported()) ...[
          SizedBox(
            width: double.infinity,
            height: 48,
            child: LoadingButton(
              onPressed: _isAppleLoading ? null : () => _handleAppleSignIn(),
              isLoading: _isAppleLoading,
              loadingText: 'Signing in with Apple...',
              icon: Icon(
                Icons.apple,
                size: Responsive.getIconSize(context, baseSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Sign in with Apple'),
            ),
          ),
        ],
        
        // Error Display
        if (errorState != null) ...[
          SizedBox(height: Responsive.getSpacing(context, baseSpacing: 16.0)),
          ResponsiveErrorDisplay(
            error: errorState.toString().replaceAll('AppError.authentication(message: ', '').replaceAll(')', ''),
            compact: true,
            onRetry: () {
              ref.read(errorNotifierProvider.notifier).clearError();
            },
          ),
        ],
        
        // Success Message
        Consumer(
          builder: (context, ref, child) {
            final successMessage = ref.watch(successNotifierProvider);
            if (successMessage != null) {
              return Padding(
                padding: EdgeInsets.only(top: Responsive.getSpacing(context, baseSpacing: 16.0)),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          successMessage,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  /// Handle Google Sign In
  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      await ref.read(authNotifierProvider.notifier).signInWithGoogle();
    } catch (e) {
      // Error is handled by the provider and shown in UI
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  /// Handle Apple Sign In
  Future<void> _handleAppleSignIn() async {
    setState(() {
      _isAppleLoading = true;
    });

    try {
      await ref.read(authNotifierProvider.notifier).signInWithApple();
    } catch (e) {
      // Error is handled by the provider and shown in UI
    } finally {
      if (mounted) {
        setState(() {
          _isAppleLoading = false;
        });
      }
    }
  }

  /// Check if Apple Sign In is supported on current platform
  bool _isAppleSignInSupported() {
    // Apple Sign In is available on iOS, macOS, and web
    return defaultTargetPlatform == TargetPlatform.iOS ||
           defaultTargetPlatform == TargetPlatform.macOS ||
           kIsWeb;
  }
}