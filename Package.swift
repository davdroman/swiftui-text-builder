// swift-tools-version: 6.4

import CompilerPluginSupport
import PackageDescription

let package = Package(
	name: "swiftui-text-builder",
	platforms: [
		.iOS(.v15),
		.macCatalyst(.v15),
		.macOS(.v12),
		.tvOS(.v15),
		.visionOS(.v1),
		.watchOS(.v8),
	],
	products: [
		.library(name: "TextBuilder", targets: ["TextBuilder"]),
	],
	targets: [
		.target(name: "TextBuilder", dependencies: [
			"TextBuilderMacro",
		]),
		.testTarget(name: "TextBuilderTests", dependencies: [
			.product(name: "CustomDump", package: "swift-custom-dump"),
			.target(name: "TextBuilder"),
		]),

		.macro(name: "TextBuilderMacro", dependencies: [
			.product(name: "SwiftSyntax", package: "swift-syntax"),
			.product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
			.product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
		]),
		.testTarget(name: "TextBuilderMacroTests", dependencies: [
			"TextBuilderMacro",
			.product(name: "MacroTesting", package: "swift-macro-testing", condition: .when(platforms: [.macOS])),
		]),
	],
)

package.dependencies += [
	.package(url: "https://github.com/pointfreeco/swift-custom-dump", from: "1.0.0"),
	.package(url: "https://github.com/pointfreeco/swift-macro-testing", from: "0.7.0"),
	.package(url: "https://github.com/swiftlang/swift-syntax", "604.0.0"..<"605.0.0"),
]

for target in package.targets {
	target.swiftSettings = target.swiftSettings ?? []
	target.swiftSettings? += [
		.enableUpcomingFeature("ExistentialAny"),
		.enableUpcomingFeature("InternalImportsByDefault"),
		.enableUpcomingFeature("MemberImportVisibility"),
	]
}
