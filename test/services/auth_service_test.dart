import 'package:flutter_test/flutter_test.dart';
import 'package:new_bbb_app/services/auth_service.dart';

void main() {
  group('AuthService Tests', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    tearDown(() {
      authService.dispose();
    });

    test('should start with unauthenticated state', () {
      expect(authService.isAuthenticated, isFalse);
    });

    test('should authenticate with valid credentials', () async {
      // Perform sign in
      final result =
          await authService.signIn('test@example.com', 'password123');

      expect(result, isTrue);
      expect(authService.isAuthenticated, isTrue);
    });

    test('should not authenticate with empty email', () async {
      final result = await authService.signIn('', 'password123');

      expect(result, isFalse);
      expect(authService.isAuthenticated, isFalse);
    });

    test('should not authenticate with empty password', () async {
      final result = await authService.signIn('test@example.com', '');

      expect(result, isFalse);
      expect(authService.isAuthenticated, isFalse);
    });

    test('should sign out successfully', () async {
      // First sign in
      await authService.signIn('test@example.com', 'password123');
      expect(authService.isAuthenticated, isTrue);

      // Sign out
      await authService.signOut();
      expect(authService.isAuthenticated, isFalse);
    });

    test('should handle multiple sign in attempts', () async {
      // First sign in
      final result1 =
          await authService.signIn('test@example.com', 'password123');
      expect(result1, isTrue);

      // Second sign in with different credentials
      final result2 =
          await authService.signIn('another@example.com', 'different123');
      expect(result2, isTrue);
      expect(authService.isAuthenticated, isTrue);
    });

    test('should maintain authentication state', () async {
      expect(authService.isAuthenticated, isFalse);

      await authService.signIn('test@example.com', 'password123');
      expect(authService.isAuthenticated, isTrue);

      await authService.signOut();
      expect(authService.isAuthenticated, isFalse);
    });

    test('should provide auth state stream', () {
      expect(authService.authStateChanges, isA<Stream<bool>>());
    });
  });
}
