#if canImport(TextBuilderMacro)
import MacroTesting
import SnapshotTesting
import SwiftSyntax
import Testing
@testable import TextBuilderMacro

@Suite(
	.macros(
		[TextBuilderMacro.self],
		indentationWidth: .tab,
		record: .missing,
	),
)
struct TextBuilderMacroTests {
	#if canImport(SwiftSyntax604)
	@Test func `computed property without separator`() {
		assertMacro {
			"""
			@TextBuilder
			var text: Text {
				Text(verbatim: "Lorem").underline().foregroundColor(.blue)
				if false {
					"ipsum dolor"
				}
				if false {
					"sit"
				} else {
					Text(verbatim: "sit").bold()
				}
				if let string = "amet, consectetur" as String? {
					string
				}
				for i in 1...3 {
					String(i)
				}
			}
			"""
		} expansion: {
			"""
			var text: Text {
				Text(separator: nil) {
					Text(verbatim: "Lorem").underline().foregroundColor(.blue)
					if false {
						"ipsum dolor"
					}
					if false {
						"sit"
					} else {
						Text(verbatim: "sit").bold()
					}
					if let string = "amet, consectetur" as String? {
						string
					}
					for i in 1 ... 3 {
						String(i)
					}
				}
			}
			"""
		}
	}

	@Test func `computed property with literal separator`() {
		assertMacro {
			"""
			@TextBuilder(separator: " ")
			var text: Text {
				Text(verbatim: "Lorem").underline().foregroundColor(.blue)
				if false {
					"ipsum dolor"
				}
				if false {
					"sit"
				} else {
					Text(verbatim: "sit").bold()
				}
				if let string = "amet, consectetur" as String? {
					string
				}
				for i in 1...3 {
					String(i)
				}
			}
			"""
		} expansion: {
			"""
			var text: Text {
				Text(separator: " ") {
					Text(verbatim: "Lorem").underline().foregroundColor(.blue)
					if false {
						"ipsum dolor"
					}
					if false {
						"sit"
					} else {
						Text(verbatim: "sit").bold()
					}
					if let string = "amet, consectetur" as String? {
						string
					}
					for i in 1 ... 3 {
						String(i)
					}
				}
			}
			"""
		}
	}

	@Test func `computed property with non-literal separator`() {
		assertMacro {
			"""
			let separator = " "
			@TextBuilder(separator: separator)
			var text: Text {
				Text(verbatim: "Lorem").underline().foregroundColor(.blue)
				if false {
					"ipsum dolor"
				}
				if false {
					"sit"
				} else {
					Text(verbatim: "sit").bold()
				}
				if let string = "amet, consectetur" as String? {
					string
				}
				for i in 1...3 {
					String(i)
				}
			}
			"""
		} expansion: {
			"""
			let separator = " "
			var text: Text {
				Text(separator: separator) {
					Text(verbatim: "Lorem").underline().foregroundColor(.blue)
					if false {
						"ipsum dolor"
					}
					if false {
						"sit"
					} else {
						Text(verbatim: "sit").bold()
					}
					if let string = "amet, consectetur" as String? {
						string
					}
					for i in 1 ... 3 {
						String(i)
					}
				}
			}
			"""
		}
	}

	@Test func `getter with separator`() {
		assertMacro {
			"""
			var text: Text {
				@TextBuilder(separator: " ")
				get {
					Text(verbatim: "Lorem").underline().foregroundColor(.blue)
					"ipsum dolor"
				}
			}
			"""
		} expansion: {
			"""
			var text: Text {
				get {
					Text(separator: " ") {
							Text(verbatim: "Lorem").underline().foregroundColor(.blue)
							"ipsum dolor"
					}
				}
			}
			"""
		}
	}
	#endif

	@Test func `function without implementation`() {
		assertMacro {
			"""
			@TextBuilder
			func text() -> Text
			"""
		} expansion: {
			"""
			func text() -> Text {
				Text(separator: nil) {
				}
			}
			"""
		}
	}

	@Test func `function without separator`() {
		assertMacro {
			"""
			@TextBuilder
			func text() -> Text {
				Text(verbatim: "Lorem").underline().foregroundColor(.blue)
				if false {
					"ipsum dolor"
				}
				if false {
					"sit"
				} else {
					Text(verbatim: "sit").bold()
				}
				if let string = "amet, consectetur" as String? {
					string
				}
				for i in 1...3 {
					String(i)
				}
			}
			"""
		} expansion: {
			"""
			func text() -> Text {
				Text(separator: nil) {
					Text(verbatim: "Lorem").underline().foregroundColor(.blue)
					if false {
						"ipsum dolor"
					}
					if false {
						"sit"
					} else {
						Text(verbatim: "sit").bold()
					}
					if let string = "amet, consectetur" as String? {
						string
					}
					for i in 1 ... 3 {
						String(i)
					}
				}
			}
			"""
		}
	}

	@Test func `function with literal separator`() {
		assertMacro {
			"""
			@TextBuilder(separator: " ")
			func text() -> Text {
				Text(verbatim: "Lorem").underline().foregroundColor(.blue)
				if false {
					"ipsum dolor"
				}
				if false {
					"sit"
				} else {
					Text(verbatim: "sit").bold()
				}
				if let string = "amet, consectetur" as String? {
					string
				}
				for i in 1...3 {
					String(i)
				}
			}
			"""
		} expansion: {
			"""
			func text() -> Text {
				Text(separator: " ") {
					Text(verbatim: "Lorem").underline().foregroundColor(.blue)
					if false {
						"ipsum dolor"
					}
					if false {
						"sit"
					} else {
						Text(verbatim: "sit").bold()
					}
					if let string = "amet, consectetur" as String? {
						string
					}
					for i in 1 ... 3 {
						String(i)
					}
				}
			}
			"""
		}
	}

	@Test func `function with non-literal separator`() {
		assertMacro {
			"""
			let separator = " "
			@TextBuilder(separator: separator)
			func text() -> Text {
				Text(verbatim: "Lorem").underline().foregroundColor(.blue)
				if false {
					"ipsum dolor"
				}
				if false {
					"sit"
				} else {
					Text(verbatim: "sit").bold()
				}
				if let string = "amet, consectetur" as String? {
					string
				}
				for i in 1...3 {
					String(i)
				}
			}
			"""
		} expansion: {
			"""
			let separator = " "
			func text() -> Text {
				Text(separator: separator) {
					Text(verbatim: "Lorem").underline().foregroundColor(.blue)
					if false {
						"ipsum dolor"
					}
					if false {
						"sit"
					} else {
						Text(verbatim: "sit").bold()
					}
					if let string = "amet, consectetur" as String? {
						string
					}
					for i in 1 ... 3 {
						String(i)
					}
				}
			}
			"""
		}
	}
}
#endif
