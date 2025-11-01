#!/bin/bash
# Сборка для симулятора (без подписи)
flutter clean
flutter pub get
flutter build ios --simulator --debug  # Или --release для релизной сборки

# Путь к .app: build/ios/iphoneos/Runner.app (для симулятора это Debug-iphonesimulator)
echo "Build completed: build/ios/iphoneos/Runner.app"