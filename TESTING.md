# Testing Guide for New BBB App

This document provides comprehensive information about testing the Flutter app, including unit tests, widget tests, integration tests, and web testing with Selenium.

## 📋 Table of Contents

- [Test Types](#test-types)
- [Running Tests](#running-tests)
- [Test Structure](#test-structure)
- [Web Testing with Selenium](#web-testing-with-selenium)
- [Test Coverage](#test-coverage)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## 🧪 Test Types

### 1. Unit Tests
- **Location**: `test/services/`
- **Purpose**: Test individual functions and classes in isolation
- **Example**: Testing `AuthService` authentication logic
- **Command**: `flutter test test/services/`

### 2. Widget Tests
- **Location**: `test/widgets/`
- **Purpose**: Test individual widgets and their interactions
- **Example**: Testing `LoginScreen` form validation
- **Command**: `flutter test test/widgets/`

### 3. Integration Tests
- **Location**: `integration_test/`
- **Purpose**: Test complete user flows across multiple screens
- **Example**: Testing login → dashboard → logout flow
- **Command**: `flutter test integration_test/`

### 4. Web Tests
- **Location**: `test/web/`
- **Purpose**: Test the app in a real browser environment
- **Example**: Testing with Selenium WebDriver
- **Command**: `flutter test test/web/`

## 🚀 Running Tests

### Quick Start
```bash
# Run all tests
./scripts/run_tests.sh

# Run specific test types
./scripts/run_tests.sh unit
./scripts/run_tests.sh widget
./scripts/run_tests.sh integration
./scripts/run_tests.sh web
./scripts/run_tests.sh coverage
```

### Manual Commands
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/services/auth_service_test.dart

# Run tests in verbose mode
flutter test --verbose

# Run tests and watch for changes
flutter test --watch
```

## 📁 Test Structure

```
test/
├── services/
│   └── auth_service_test.dart      # Unit tests for AuthService
├── widgets/
│   └── login_screen_test.dart      # Widget tests for LoginScreen
└── web/
    └── web_test.dart               # Web-specific tests

integration_test/
└── app_test.dart                   # Integration tests

scripts/
├── run_tests.sh                    # Test runner script
├── setup_selenium.sh               # Selenium setup script
├── start_selenium.sh               # Start Selenium server
├── stop_selenium.sh                # Stop Selenium server
└── run_web_tests.sh                # Web test runner
```

## 🌐 Web Testing with Selenium

### Prerequisites
- Java 8 or higher
- Chrome browser
- Flutter app running on `http://localhost:8080`

### Setup Selenium
```bash
# Run the setup script
./scripts/setup_selenium.sh
```

### Running Web Tests
```bash
# 1. Start Selenium server
./scripts/start_selenium.sh

# 2. Start Flutter app (in another terminal)
flutter run -d chrome

# 3. Run web tests
./scripts/run_web_tests.sh

# 4. Stop Selenium server
./scripts/stop_selenium.sh
```

### Selenium Features
- **Headless testing**: Tests run in background
- **Cross-browser support**: Chrome, Firefox, Safari
- **Real browser interactions**: Click, type, scroll
- **Screenshot capture**: For debugging
- **Parallel execution**: Multiple tests simultaneously

## 📊 Test Coverage

### Generate Coverage Report
```bash
# Run tests with coverage
flutter test --coverage

# Generate HTML report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
```

### Coverage Metrics
- **Line Coverage**: Percentage of code lines executed
- **Branch Coverage**: Percentage of code branches executed
- **Function Coverage**: Percentage of functions called

### Coverage Goals
- **Unit Tests**: 90%+ line coverage
- **Widget Tests**: 80%+ line coverage
- **Integration Tests**: 70%+ line coverage

## ✅ Best Practices

### 1. Test Organization
- Group related tests using `group()`
- Use descriptive test names
- Follow AAA pattern (Arrange, Act, Assert)

### 2. Test Data
- Use factories for test data
- Mock external dependencies
- Clean up after each test

### 3. Widget Testing
- Test user interactions
- Verify UI state changes
- Test error scenarios

### 4. Integration Testing
- Test complete user flows
- Use realistic test data
- Test edge cases

### 5. Web Testing
- Wait for elements to load
- Use reliable selectors
- Handle dynamic content

## 🔧 Troubleshooting

### Common Issues

#### 1. Tests Not Running
```bash
# Check Flutter installation
flutter doctor

# Clean and get dependencies
flutter clean
flutter pub get
```

#### 2. Web Tests Failing
```bash
# Check if app is running
curl http://localhost:8080

# Check if Selenium is running
curl http://localhost:4444/wd/hub/status

# Restart Selenium
./scripts/stop_selenium.sh
./scripts/start_selenium.sh
```

#### 3. Coverage Not Generated
```bash
# Install lcov
# macOS
brew install lcov

# Ubuntu/Debian
sudo apt-get install lcov

# Generate coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

#### 4. Selenium Setup Issues
```bash
# Check Java installation
java -version

# Check Chrome installation
google-chrome --version

# Re-run setup
./scripts/setup_selenium.sh
```

### Debug Tips

#### 1. Verbose Output
```bash
flutter test --verbose
```

#### 2. Debug Widget Tests
```bash
flutter test --debug
```

#### 3. Screenshot on Failure
```bash
# Add to web tests
await driver.saveScreenshot('test_failure.png');
```

#### 4. Test Timeout
```bash
# Increase timeout for slow tests
flutter test --timeout 60s
```

## 📚 Additional Resources

- [Flutter Testing Documentation](https://flutter.dev/docs/testing)
- [Selenium Documentation](https://www.selenium.dev/documentation/)
- [WebDriver Package](https://pub.dev/packages/webdriver)
- [Mockito Package](https://pub.dev/packages/mockito)

## 🤝 Contributing

When adding new features, please:

1. Write unit tests for business logic
2. Write widget tests for UI components
3. Write integration tests for user flows
4. Update this documentation
5. Ensure all tests pass before submitting

## 📈 Continuous Integration

The app includes GitHub Actions workflows for:

- **Unit Tests**: Run on every push
- **Widget Tests**: Run on every push
- **Integration Tests**: Run on pull requests
- **Web Tests**: Run on pull requests
- **Coverage Reports**: Generated automatically

---

For questions or issues, please create an issue in the repository. 