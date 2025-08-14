import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:new_bbb_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('complete login flow test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify we start on login screen
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to your account'), findsOneWidget);

      // Enter valid credentials
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'password123',
      );

      // Tap sign in button
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Verify we're now on dashboard
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Welcome back!'), findsOneWidget);
      expect(find.text('Quick Stats'), findsOneWidget);
      expect(find.text('Recent Activity'), findsOneWidget);

      // Test navigation
      await tester.tap(find.text('Analytics'));
      await tester.pumpAndSettle();
      expect(find.text('Analytics Dashboard'), findsOneWidget);

      await tester.tap(find.text('Users'));
      await tester.pumpAndSettle();
      expect(find.text('User Management'), findsOneWidget);

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);

      // Go back to dashboard
      await tester.tap(find.text('Dashboard'));
      await tester.pumpAndSettle();
      expect(find.text('Welcome back!'), findsOneWidget);

      // Test logout
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();

      // Verify we're back on login screen
      expect(find.text('Welcome Back'), findsOneWidget);
    });

    testWidgets('login validation test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Try to submit empty form
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);

      // Enter invalid email
      await tester.enterText(
        find.byType(TextFormField).first,
        'invalid-email',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'password123',
      );

      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Should show email validation error
      expect(find.text('Please enter a valid email'), findsOneWidget);

      // Enter valid email but short password
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        '123',
      );

      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Should show password validation error
      expect(
          find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('dashboard stats display test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login first
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        'password123',
      );
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // Verify stats are displayed
      expect(find.text('Total Users'), findsOneWidget);
      expect(find.text('1,234'), findsOneWidget);
      expect(find.text('Active Sessions'), findsOneWidget);
      expect(find.text('567'), findsOneWidget);
      expect(find.text('Revenue'), findsOneWidget);
      expect(find.text('\$12,345'), findsOneWidget);
      expect(find.text('Orders'), findsOneWidget);
      expect(find.text('89'), findsOneWidget);

      // Verify recent activity
      expect(find.text('New User Registration'), findsOneWidget);
      expect(find.text('Order Completed'), findsOneWidget);
      expect(find.text('System Update'), findsOneWidget);
    });

    testWidgets('password visibility toggle test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find password field and visibility toggle
      final passwordField = find.byType(TextFormField).last;
      final visibilityToggle = find.byIcon(Icons.visibility);

      // Initially should show visibility icon
      expect(visibilityToggle, findsOneWidget);

      // Tap to toggle visibility
      await tester.tap(visibilityToggle);
      await tester.pumpAndSettle();

      // Should now show visibility_off icon
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Tap again to toggle back
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      // Should show visibility icon again
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });
}
