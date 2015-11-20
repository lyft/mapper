lint:
	brew update && brew install swiftlint
	swiftlint lint --strict 2>/dev/null

test:
	set -o pipefail && \
		xcodebuild \
		-project Mapper.xcodeproj \
		-scheme Mapper \
		-sdk iphonesimulator \
		-destination "name=iPhone 6" \
		test \
		| xcpretty -ct
