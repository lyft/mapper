lint:
	brew install https://raw.githubusercontent.com/Homebrew/homebrew/fffa4b271ba57c7633e8e24cae543a197a9e3e01/Library/Formula/swiftlint.rb
	swiftlint lint --strict 2>/dev/null

test-iOS:
	set -o pipefail && \
		xcodebuild \
		-project Mapper.xcodeproj \
		-scheme Mapper \
		-destination "name=iPhone 6s" \
		test \
		| xcpretty -ct

test-OSX:
	set -o pipefail && \
		xcodebuild \
		-project Mapper.xcodeproj \
		-scheme Mapper \
		test \
		| xcpretty -ct

test-tvOS:
	set -o pipefail && \
		xcodebuild \
		-project Mapper.xcodeproj \
		-scheme Mapper \
		-destination "name=Apple TV 1080p" \
		test \
		| xcpretty -ct

test-carthage:
	brew rm carthage || true
	brew install https://raw.githubusercontent.com/Homebrew/homebrew/96664cb3befd42f933de07d9fc0f61e8756d86c3/Library/Formula/carthage.rb
	carthage build --no-skip-current
	ls Carthage/build/Mac/Mapper.framework
	ls Carthage/build/iOS/Mapper.framework
	ls Carthage/build/tvOS/Mapper.framework
	ls Carthage/build/watchOS/Mapper.framework
