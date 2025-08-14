import 'dart:async';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    // Emit initial state
    _authStateController.add(false);
  }

  final StreamController<bool> _authStateController =
      StreamController<bool>.broadcast();
  bool _isAuthenticated = false;

  Stream<bool> get authStateChanges => _authStateController.stream;

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> signIn(String email, String password) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Simple validation - in a real app, this would call an API
    if (email.isNotEmpty && password.isNotEmpty) {
      _isAuthenticated = true;
      _authStateController.add(true);
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    _isAuthenticated = false;
    _authStateController.add(false);
  }

  void dispose() {
    // Don't close the stream for singleton - it should live for the app lifetime
    // _authStateController.close();
  }
}
