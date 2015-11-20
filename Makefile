lint:
	brew update && brew install swiftlint
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
