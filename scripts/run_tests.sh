#!/bin/bash

# Flutter App Test Runner Script
# This script runs all types of tests for the New BBB App

set -e

echo "🧪 Starting Flutter App Tests..."
echo "=================================="

# Function to run tests with coverage
run_tests_with_coverage() {
    echo "📊 Running tests with coverage..."
    flutter test --coverage
    echo "✅ Tests completed with coverage"
}

# Function to run unit tests only
run_unit_tests() {
    echo "🔬 Running unit tests..."
    flutter test test/services/
    echo "✅ Unit tests completed"
}

# Function to run widget tests only
run_widget_tests() {
    echo "🎨 Running widget tests..."
    flutter test test/widgets/
    echo "✅ Widget tests completed"
}

# Function to run integration tests
run_integration_tests() {
    echo "🔗 Running integration tests..."
    flutter test integration_test/
    echo "✅ Integration tests completed"
}

# Function to run all tests
run_all_tests() {
    echo "🚀 Running all tests..."
    flutter test
    echo "✅ All tests completed"
}

# Function to generate coverage report
generate_coverage_report() {
    echo "📈 Generating coverage report..."
    if command -v genhtml &> /dev/null; then
        genhtml coverage/lcov.info -o coverage/html
        echo "📊 Coverage report generated at coverage/html/index.html"
    else
        echo "⚠️  genhtml not found. Install lcov to generate HTML coverage reports."
    fi
}

# Function to run web tests (requires app to be running)
run_web_tests() {
    echo "🌐 Running web tests..."
    echo "⚠️  Make sure the app is running on http://localhost:8080"
    echo "⚠️  Install and start Selenium WebDriver if needed"
    flutter test test/web/
    echo "✅ Web tests completed"
}

# Function to show help
show_help() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  all              Run all tests"
    echo "  unit             Run unit tests only"
    echo "  widget           Run widget tests only"
    echo "  integration      Run integration tests only"
    echo "  web              Run web tests only"
    echo "  coverage         Run tests with coverage report"
    echo "  help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 all           # Run all tests"
    echo "  $0 unit          # Run unit tests only"
    echo "  $0 coverage      # Run tests with coverage"
}

# Main script logic
case "${1:-all}" in
    "all")
        run_all_tests
        ;;
    "unit")
        run_unit_tests
        ;;
    "widget")
        run_widget_tests
        ;;
    "integration")
        run_integration_tests
        ;;
    "web")
        run_web_tests
        ;;
    "coverage")
        run_tests_with_coverage
        generate_coverage_report
        ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        echo "❌ Unknown option: $1"
        show_help
        exit 1
        ;;
esac

echo ""
echo "🎉 Test execution completed!" 