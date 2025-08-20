import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import 'dashboard_screen.dart';

class OTPScreen extends StatefulWidget {
  final String mobileNumber;
  final String userType;
  
  const OTPScreen({
    super.key,
    required this.mobileNumber,
    required this.userType,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );
  
  final _authService = AuthService();
  bool _isLoading = false;
  bool _isResending = false;
  int _resendCountdown = 30;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    // Auto-focus the first OTP field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    _resendCountdown = 30;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendCountdown--;
        });
      }
      return _resendCountdown > 0 && mounted;
    });
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1) {
      // Move to next field when digit is entered
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      }
    } else if (value.isEmpty) {
      // Move to previous field when current field is cleared
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    // Check if all OTP fields are filled
    if (_otpControllers.every((controller) => controller.text.isNotEmpty)) {
      _validateOTP();
    }
  }

  void _handleBackspace(int index) {
    if (_otpControllers[index].text.isEmpty && index > 0) {
      // Move to previous field and clear it
      _focusNodes[index - 1].requestFocus();
      _otpControllers[index - 1].clear();
    }
  }

  void _clearAllOTP() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  Future<void> _validateOTP() async {
    final otp = _otpControllers.map((controller) => controller.text).join();
    
    if (otp.length != 4) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate OTP validation (replace with actual validation logic)
      await Future.delayed(const Duration(seconds: 2));
      
      // For testing purposes, accept any 4-digit code
      if (mounted) {
        // Navigate to dashboard on successful validation
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
          (route) => false, // Remove all previous routes
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid OTP: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        // Clear OTP fields on error
        for (var controller in _otpControllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendOTP() async {
    setState(() {
      _isResending = true;
    });

    try {
      // Simulate resending OTP
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP resent successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _startResendTimer();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend OTP: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 768;
    final double cardWidth = isLargeScreen ? 400 : double.infinity;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: cardWidth,
                ),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isLargeScreen ? 32.0 : 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // OTP Icon
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lock_clock,
                            size: isLargeScreen ? 48 : 40,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Title
                        Text(
                          'Verify OTP',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter the 4-digit code sent to',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.mobileNumber,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: 32),

                        // OTP Input Fields
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(4, (index) {
                            return SizedBox(
                              width: 60,
                              child: KeyboardListener(
                                focusNode: FocusNode(),
                                onKeyEvent: (KeyEvent event) {
                                  // Handle backspace when field is empty
                                  if (event is KeyDownEvent && 
                                      event.logicalKey == LogicalKeyboardKey.backspace) {
                                    _handleBackspace(index);
                                  }
                                },
                                child: TextFormField(
                                  controller: _otpControllers[index],
                                  focusNode: _focusNodes[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(1),
                                  ],
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.primary,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  onChanged: (value) => _onOtpChanged(value, index),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),

                        // Clear All Button
                        TextButton.icon(
                          onPressed: _clearAllOTP,
                          icon: const Icon(Icons.clear_all, size: 16),
                          label: const Text('Clear All'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                            textStyle: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Loading indicator or validation message
                        if (_isLoading)
                          const Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Validating OTP...'),
                            ],
                          ),

                        const SizedBox(height: 24),

                        // Resend OTP Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive the code? ",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            if (_resendCountdown > 0)
                              Text(
                                'Resend in $_resendCountdown seconds',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              )
                            else
                              TextButton(
                                onPressed: _isResending ? null : _resendOTP,
                                child: _isResending
                                    ? const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        'Resend OTP',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Back to Login Button
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Back to Login',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Demo hint
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline,
                                  color: Colors.blue[600], size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Demo: Enter any 4-digit code to proceed',
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
