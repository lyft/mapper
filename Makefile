lint:
	brew install https://raw.githubusercontent.com/Homebrew/homebrew/fffa4b271ba57c7633e8e24cae543a197a9e3e01/Library/Formula/swiftlint.rb
	swiftlint lint --strict 2>/dev/null

test-iOS:
	set -o pipefail && \
		xcodebuild \
		-project Mapper.xcodeproj \
		-scheme Mapper-iOS \
		-sdk iphonesimulator \
		-destination "name=iPhone 6" \
		test \
		| xcpretty -ct

test-OSX:
	set -o pipefail && \
		xcodebuild \
		-project Mapper.xcodeproj \
		-scheme Mapper-OSX \
		test \
		| xcpretty -ct
