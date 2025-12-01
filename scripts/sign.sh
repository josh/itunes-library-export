#!/usr/bin/env bash

set -o errexit
set -o xtrace

codesign --force \
	--sign - \
	--entitlements ./Resources/itunes-library-export.entitlements \
	--identifier "com.github.josh.itunes-library-export" \
	.build/release/itunes-library-export

otool -s __TEXT __info_plist .build/release/itunes-library-export
codesign --display --entitlements - .build/release/itunes-library-export
codesign --display --verbose .build/release/itunes-library-export
