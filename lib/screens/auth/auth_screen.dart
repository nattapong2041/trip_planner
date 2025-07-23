import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../utils/responsive.dart';
import '../../widgets/common/responsive_error_display.dart';
import '../../widgets/common/loading_button.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Planner'),
      ),
      body: ResponsiveContainer(
        child: ResponsiveBuilder(
          mobile: _buildMobileLayout(context, ref, authState),
          tablet: _buildTabletLayout(context, ref, authState),
          desktop: _buildDesktopLayout(context, ref, authState),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref, AsyncValue authState) {
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
            _buildAuthButtons(context, ref, authState),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, WidgetRef ref, AsyncValue authState) {
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
              _buildAuthButtons(context, ref, authState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref, AsyncValue authState) {
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
                  _buildAuthButtons(context, ref, authState),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthButtons(BuildContext context, WidgetRef ref, AsyncValue authState) {
    final isLoading = authState.isLoading;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: LoadingButton(
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).signInWithGoogle();
            },
            isLoading: isLoading,
            loadingText: 'Signing in...',
            icon: Icon(
              Icons.login,
              size: Responsive.getIconSize(context, baseSize: 20),
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Sign in with Google'),
          ),
        ),
        SizedBox(height: Responsive.getSpacing(context)),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: LoadingButton(
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).signInWithApple();
            },
            isLoading: isLoading,
            loadingText: 'Signing in...',
            icon: Icon(
              Icons.apple,
              size: Responsive.getIconSize(context, baseSize: 20),
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Sign in with Apple'),
          ),
        ),
        if (authState.hasError) ...[
          SizedBox(height: Responsive.getSpacing(context, baseSpacing: 24.0)),
          ResponsiveErrorDisplay(
            error: 'Authentication error: ${authState.error}',
            compact: true,
          ),
        ],
      ],
    );
  }
}