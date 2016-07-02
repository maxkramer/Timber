test:
	set -o pipefail && xcodebuild test -workspace Example/Timber.xcworkspace -scheme Timber-Example -sdk iphonesimulator9.3 | xcpretty        
codecov:
	slather coverage --verbose
        bash <(curl -s https://codecov.io/bash) -f ./cobertura.xml
