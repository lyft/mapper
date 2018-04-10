# Install Tasks

export HOMEBREW_NO_AUTO_UPDATE = 1

install-lint:
	brew remove swiftlint --force || true
	brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/af232506f5f1879af77852d6297b1e2a5b040270/Formula/swiftlint.rb

install-carthage:
	brew remove carthage --force || true
	brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/af232506f5f1879af77852d6297b1e2a5b040270/Formula/carthage.rb

install-%:
	true

# Run Tasks

test-lint:
	swiftlint lint --strict 2>/dev/null

test-iOS:
	set -o pipefail && \
		xcodebuild \
		-project Mapper.xcodeproj \
		-scheme Mapper \
		-configuration Release \
		-destination "name=iPhone 7,OS=10.1" \
		test \
		| xcpretty -ct

test-macOS:
	set -o pipefail && \
		xcodebuild \
		-project Mapper.xcodeproj \
		-scheme Mapper \
		-configuration Release \
		test \
		| xcpretty -ct

test-tvOS:
	set -o pipefail && \
		xcodebuild \
		-project Mapper.xcodeproj \
		-scheme Mapper \
		-configuration Release \
		-destination "platform=tvOS Simulator,name=Apple TV,OS=11.0" \
		test \
		| xcpretty -ct

test-carthage:
	set -o pipefail && \
		carthage build \
		--no-skip-current \
		--configuration Release \
		--verbose \
		| xcpretty -ct
	ls Carthage/build/Mac/Mapper.framework
	ls Carthage/build/iOS/Mapper.framework
	ls Carthage/build/tvOS/Mapper.framework
	ls Carthage/build/watchOS/Mapper.framework

test-coverage:
	set -o pipefail && \
		xcodebuild \
		-project Mapper.xcodeproj \
		-scheme Mapper \
		-derivedDataPath build \
		-enableCodeCoverage YES \
		test \
		| xcpretty -ct
	Resources/coverage.sh build

test-swiftpm-macOS:
	swift test
