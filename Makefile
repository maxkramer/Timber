test:
	set -o pipefail && xcodebuild test -workspace Example/Timber.xcworkspace -scheme Timber-Example -sdk iphonesimulator9.3 | xcpretty        
codecov:
	bundle exec slather coverage --verbose
        bash <(curl -s https://codecov.io/bash) -f ./cobertura.xml
gendocs:
	bundle exec jazzy -x -workspace,$(PWD)/Example/Timber.xcworkspace,-scheme,Timber-Example
pushdocs:
	git push origin `git subtree split --prefix docs gh-pages`:gh-pages --force
	git subtree push --prefix docs origin gh-pages
