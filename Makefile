# Install Tasks

export HOMEBREW_NO_AUTO_UPDATE = 1
export PATH := $(HOME)/bin:$(PATH)

install-lint:
	brew remove swiftlint --force || true
	brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/af232506f5f1879af77852d6297b1e2a5b040270/Formula/swiftlint.rb

install-carthage:
	brew remove carthage --force || true
	brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/af232506f5f1879af77852d6297b1e2a5b040270/Formula/carthage.rb

install-bazel-%:
	curl -fsSL -o installer.sh https://github.com/bazelbuild/bazel/releases/download/0.16.1/bazel-0.16.1-installer-darwin-x86_64.sh
	chmod +x installer.sh
	./installer.sh --user

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

test-bazel-iOS:
	bazel test //:MapperiOSTests --test_output=all

test-macOS:
	set -o pipefail && \
		xcodebuild \
		-project Mapper.xcodeproj \
		-scheme Mapper \
		-configuration Release \
		test \
		| xcpretty -ct

test-bazel-macOS:
	bazel test //:MappermacOSTests --test_output=all

test-tvOS:
	set -o pipefail && \
		xcodebuild \
		-project Mapper.xcodeproj \
		-scheme Mapper \
		-configuration Release \
		-destination "platform=tvOS Simulator,name=Apple TV,OS=11.0" \
		test \
		| xcpretty -ct

test-bazel-tvOS:
	bazel build //:MapperTestsBinary --apple_platform_type tvos --tvos_minimum_os 9.0

test-bazel-watchOS:
	bazel build //:Mapper --apple_platform_type watchos --watchos_minimum_os 2.0

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
		-derivedDataPath build.noindex \
		-enableCodeCoverage YES \
		test \
		| xcpretty -ct
	Resources/coverage.sh build.noindex

test-swiftpm-macOS:
	swift test
