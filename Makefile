# Install Tasks

export HOMEBREW_NO_AUTO_UPDATE = 1

install-lint:
	brew remove swiftlint --force || true
	brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/a97c85994a3f714355a20511b4df3a546ae809cf/Formula/swiftlint.rb

install-carthage:
	brew remove carthage --force || true
	brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/af232506f5f1879af77852d6297b1e2a5b040270/Formula/carthage.rb

install-pods-%:
	bundle install

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
		-destination "name=iPhone X,OS=12.0" \
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
		-destination "platform=tvOS Simulator,name=Apple TV,OS=12.0" \
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

test-pods-%:
	cd $(shell pwd)/Tests/PodTests/$* && \
		bundle exec pod install && \
		xcodebuild \
		-workspace $*.xcworkspace \
		-scheme $* \
		-destination "name=iPhone X,OS=12.0" \
		clean build
