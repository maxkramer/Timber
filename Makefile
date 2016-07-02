test:
	set -o pipefail && xcodebuild test -workspace Example/Timber.xcworkspace -scheme Timber-Example -sdk iphonesimulator9.3 | xcpretty        
codecov:
	PROJECT_TEMP_ROOT=$(shell xcodebuild -showBuildSettings -workspace Example/Timber.xcworkspace -scheme Timber-Example -sdk iphonesimulator9.3 -configuration Debug | grep -m1 PROJECT_TEMP_ROOT | cut -d= -f2 | xargs)
	slather coverage --verbose -b $(PROJECT_TEMP_ROOT)
        ##bash <(curl -s https://codecov.io/bash) -f ./cobertura.xml
