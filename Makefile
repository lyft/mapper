# Install Tasks

TEST_SRCS=$(wildcard Tests/*.swift)
TEST_COMMAND=swiftc \
		-o run-tests \
		-I.build/debug \
		-Xlinker .build/debug/Mapper.a \
		$(TEST_SRCS) \

install-iOS:
	true

install-OSX:
	true

install-tvOS:
	true

install-lint:
	brew install https://raw.githubusercontent.com/Homebrew/homebrew/fffa4b271ba57c7633e8e24cae543a197a9e3e01/Library/Formula/swiftlint.rb

install-carthage:
	brew rm carthage || true
	brew install https://raw.githubusercontent.com/Homebrew/homebrew/96664cb3befd42f933de07d9fc0f61e8756d86c3/Library/Formula/carthage.rb

install-swiftenv:
	curl -sL https://gist.githubusercontent.com/kylef/5c0475ff02b7c7671d2a/raw/b07054552689910f79b3496221f7421a811f9f70/swiftenv-install.sh | bash

install-oss-osx: install-swiftenv
install-linux: install-swiftenv

# Run Tasks

test-lint:
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
	carthage build --no-skip-current
	ls Carthage/build/Mac/Mapper.framework
	ls Carthage/build/iOS/Mapper.framework
	ls Carthage/build/tvOS/Mapper.framework
	ls Carthage/build/watchOS/Mapper.framework

test-oss-osx: $(TEST_SRCS)
	. ~/.swiftenv/init && swift build

test-linux: $(TEST_SRCS)
	. ~/.swiftenv/init && \
		swift build && \
		$(TEST_COMMAND) && \
		./run-tests

# BUILT_PRODUCTS_DIR=/Users/ksmiley/dev/oss-swift/swift-corelibs-xctest/.build/debug
# test-oss-osx: $(TEST_SRCS)
# 	swift build && \
# 		$(TEST_COMMAND) \
# 		-sdk "$(shell xcrun --sdk macosx --show-sdk-path)" \
# 		-target x86_64-apple-macosx10.11 \
# 		-I$(BUILT_PRODUCTS_DIR) \
# 		-Xlinker $(BUILT_PRODUCTS_DIR)/XCTest.a && \
# 		./run-tests
