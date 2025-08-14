#!/bin/bash

# Selenium WebDriver Setup Script for Flutter Web Testing
# This script sets up Selenium WebDriver for automated web testing

set -e

echo "🌐 Setting up Selenium WebDriver for Flutter Web Testing..."
echo "=========================================================="

# Check if Java is installed
check_java() {
    if command -v java &> /dev/null; then
        echo "✅ Java is installed: $(java -version 2>&1 | head -n 1)"
    else
        echo "❌ Java is not installed. Please install Java 8 or higher."
        echo "   Download from: https://adoptium.net/"
        exit 1
    fi
}

# Check if Chrome is installed
check_chrome() {
    if command -v google-chrome &> /dev/null; then
        echo "✅ Chrome is installed: $(google-chrome --version)"
    elif command -v chromium-browser &> /dev/null; then
        echo "✅ Chromium is installed: $(chromium-browser --version)"
    else
        echo "❌ Chrome/Chromium is not installed. Please install Chrome browser."
        exit 1
    fi
}

# Download Selenium WebDriver
download_selenium() {
    echo "📥 Downloading Selenium WebDriver..."
    
    # Create selenium directory
    mkdir -p selenium
    
    # Download ChromeDriver
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        CHROMEDRIVER_URL="https://chromedriver.storage.googleapis.com/LATEST_RELEASE"
        CHROMEDRIVER_VERSION=$(curl -s $CHROMEDRIVER_URL)
        CHROMEDRIVER_DOWNLOAD_URL="https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_mac64.zip"
        
        echo "📥 Downloading ChromeDriver for macOS..."
        curl -L -o selenium/chromedriver.zip $CHROMEDRIVER_DOWNLOAD_URL
        unzip -o selenium/chromedriver.zip -d selenium/
        chmod +x selenium/chromedriver
        rm selenium/chromedriver.zip
        
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        CHROMEDRIVER_URL="https://chromedriver.storage.googleapis.com/LATEST_RELEASE"
        CHROMEDRIVER_VERSION=$(curl -s $CHROMEDRIVER_URL)
        CHROMEDRIVER_DOWNLOAD_URL="https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip"
        
        echo "📥 Downloading ChromeDriver for Linux..."
        curl -L -o selenium/chromedriver.zip $CHROMEDRIVER_DOWNLOAD_URL
        unzip -o selenium/chromedriver.zip -d selenium/
        chmod +x selenium/chromedriver
        rm selenium/chromedriver.zip
        
    else
        echo "❌ Unsupported operating system: $OSTYPE"
        exit 1
    fi
    
    # Download Selenium Server
    echo "📥 Downloading Selenium Server..."
    SELENIUM_VERSION="4.15.0"
    SELENIUM_URL="https://github.com/SeleniumHQ/selenium/releases/download/selenium-$SELENIUM_VERSION/selenium-server-$SELENIUM_VERSION.jar"
    
    curl -L -o selenium/selenium-server.jar $SELENIUM_URL
    
    echo "✅ Selenium WebDriver downloaded successfully"
}

# Create start script
create_start_script() {
    echo "📝 Creating Selenium start script..."
    
    cat > scripts/start_selenium.sh << 'EOF'
#!/bin/bash

# Start Selenium WebDriver Server
echo "🚀 Starting Selenium WebDriver Server..."

# Kill any existing Selenium processes
pkill -f selenium-server || true

# Start Selenium Server
java -jar selenium/selenium-server.jar standalone &
SELENIUM_PID=$!

echo "✅ Selenium WebDriver Server started (PID: $SELENIUM_PID)"
echo "🌐 Server running at: http://localhost:4444"
echo "📊 Grid console at: http://localhost:4444/ui"

# Wait for server to start
sleep 3

echo ""
echo "To stop the server, run: kill $SELENIUM_PID"
echo "Or use: pkill -f selenium-server"
EOF

    chmod +x scripts/start_selenium.sh
    echo "✅ Start script created: scripts/start_selenium.sh"
}

# Create stop script
create_stop_script() {
    echo "📝 Creating Selenium stop script..."
    
    cat > scripts/stop_selenium.sh << 'EOF'
#!/bin/bash

# Stop Selenium WebDriver Server
echo "🛑 Stopping Selenium WebDriver Server..."

# Kill Selenium processes
pkill -f selenium-server || true

echo "✅ Selenium WebDriver Server stopped"
EOF

    chmod +x scripts/stop_selenium.sh
    echo "✅ Stop script created: scripts/stop_selenium.sh"
}

# Create web test runner
create_web_test_runner() {
    echo "📝 Creating web test runner..."
    
    cat > scripts/run_web_tests.sh << 'EOF'
#!/bin/bash

# Web Test Runner Script
echo "🌐 Running Flutter Web Tests with Selenium..."

# Check if Selenium is running
if ! curl -s http://localhost:4444/wd/hub/status > /dev/null; then
    echo "❌ Selenium WebDriver is not running."
    echo "   Start it with: ./scripts/start_selenium.sh"
    exit 1
fi

# Check if Flutter app is running
if ! curl -s http://localhost:8080 > /dev/null; then
    echo "❌ Flutter app is not running on http://localhost:8080"
    echo "   Start it with: flutter run -d chrome"
    exit 1
fi

# Run web tests
echo "🧪 Running web tests..."
flutter test test/web/

echo "✅ Web tests completed"
EOF

    chmod +x scripts/run_web_tests.sh
    echo "✅ Web test runner created: scripts/run_web_tests.sh"
}

# Main setup
main() {
    echo "🔍 Checking prerequisites..."
    check_java
    check_chrome
    
    echo ""
    echo "📦 Downloading Selenium WebDriver..."
    download_selenium
    
    echo ""
    echo "📝 Creating helper scripts..."
    create_start_script
    create_stop_script
    create_web_test_runner
    
    echo ""
    echo "🎉 Selenium WebDriver setup completed!"
    echo ""
    echo "📋 Next steps:"
    echo "1. Start Selenium: ./scripts/start_selenium.sh"
    echo "2. Start Flutter app: flutter run -d chrome"
    echo "3. Run web tests: ./scripts/run_web_tests.sh"
    echo "4. Stop Selenium: ./scripts/stop_selenium.sh"
    echo ""
    echo "📚 For more information, see:"
    echo "   - https://www.selenium.dev/documentation/"
    echo "   - https://flutter.dev/docs/testing/integration-tests"
}

# Run main function
main 