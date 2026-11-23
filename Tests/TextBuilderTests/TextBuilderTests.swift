import CustomDump
import SwiftUI
import Testing
import TextBuilder

@Suite
struct TextBuilderTests {
	@Test func empty() {
		@TextBuilder
		func sut() -> Text {
			// empty
		}

		expectNoDifference(
			sut(),
			Text(verbatim: ""),
		)
	}

	@Test func `default text builder`() {
		@TextBuilder
		func sut() -> Text {
			Text("Lorem").underline().foregroundColor(.blue)
			Text("ipsum dolor")
			Text("sit").bold()
			Text("amet, consectetur")
		}

		expectNoDifference(
			sut(),
			Text("Lorem").underline().foregroundColor(.blue) +
				Text("ipsum dolor") +
				Text("sit").bold() +
				Text("amet, consectetur"),
		)
	}

	@Test func `spaced text builder`() {
		@TextBuilder(separator: " ")
		func sut() -> Text {
			Text("Lorem").underline().foregroundColor(.blue)
			Text("ipsum dolor")
			Text("sit").bold()
			Text("amet, consectetur")
		}

		expectNoDifference(
			sut(),
			Text("Lorem").underline().foregroundColor(.blue) +
				Text(verbatim: " ") +
				Text("ipsum dolor") +
				Text(verbatim: " ") +
				Text("sit").bold() +
				Text(verbatim: " ") +
				Text("amet, consectetur"),
		)
	}

	@Test func `multiline text builder`() {
		@TextBuilder(separator: "\n")
		func sut() -> Text {
			Text("Lorem").underline().foregroundColor(.blue)
			Text("ipsum dolor")
			Text("sit").bold()
			Text("amet, consectetur")
		}

		expectNoDifference(
			sut(),
			Text("Lorem").underline().foregroundColor(.blue) +
				Text(verbatim: "\n") +
				Text("ipsum dolor") +
				Text(verbatim: "\n") +
				Text("sit").bold() +
				Text(verbatim: "\n") +
				Text("amet, consectetur"),
		)
	}

	@Test func `custom text builder`() {
		@TextBuilder(separator: " 👏 ")
		func sut() -> Text {
			Text("Lorem").underline().foregroundColor(.blue)
			Text("ipsum dolor")
			Text("sit").bold()
			Text("amet, consectetur")
		}

		expectNoDifference(
			sut(),
			Text("Lorem").underline().foregroundColor(.blue) +
				Text(verbatim: " 👏 ") +
				Text("ipsum dolor") +
				Text(verbatim: " 👏 ") +
				Text("sit").bold() +
				Text(verbatim: " 👏 ") +
				Text("amet, consectetur"),
		)
	}

	@Test func `complex text builder`() {
		@TextBuilder(separator: " ")
		func sut() -> Text {
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

		expectNoDifference(
			sut(),
			Text(verbatim: "Lorem").underline().foregroundColor(.blue) +
				Text(verbatim: " ") +
				Text(verbatim: "sit").bold() +
				Text(verbatim: " ") +
				Text(verbatim: "amet, consectetur") +
				Text(verbatim: " ") +
				Text(verbatim: "1") +
				Text(verbatim: " ") +
				Text(verbatim: "2") +
				Text(verbatim: " ") +
				Text(verbatim: "3"),
		)
	}

	@Test func `string literals are localized`() {
		@TextBuilder(separator: " ")
		var sut: Text {
			"Hello"
			"world"
		}

		expectNoDifference(
			sut,
			Text("Hello", bundle: #bundle) +
				Text(verbatim: " ") +
				Text("world", bundle: #bundle),
		)
	}

	@Test func `string interpolations are localized`() {
		let count = 3

		@TextBuilder
		var sut: Text {
			"\(count) items"
		}

		// Localized interpolations don't compare equal, so compare their dumps instead.
		expectNoDifference(
			String(customDumping: sut),
			String(customDumping: Text("\(count) items", bundle: #bundle)),
		)
	}

	@Test func `string literals are localized in the given bundle`() {
		let bundle = Bundle(for: BundleToken.self)

		@TextBuilder(separator: " ", bundle: bundle)
		var sut: Text {
			"Hello"
			Text("world")
		}

		expectNoDifference(
			sut,
			Text("Hello", bundle: bundle) +
				Text(verbatim: " ") +
				Text("world"),
		)
	}

	@Test func `string literals are localized in the main bundle when bundle is nil`() {
		@TextBuilder(bundle: nil)
		var sut: Text {
			"Hello"
		}

		expectNoDifference(sut, Text("Hello"))
	}

	@Test func `string values are verbatim`() {
		let greeting = "Hello"

		@TextBuilder(separator: " ")
		var sut: Text {
			greeting
			greeting.dropLast()
		}

		expectNoDifference(
			sut,
			Text(verbatim: "Hello") +
				Text(verbatim: " ") +
				Text(verbatim: "Hell"),
		)
	}

	@Test func `computed property text builder`() {
		@TextBuilder(separator: " ")
		var sut: Text {
			Text(verbatim: "Lorem").underline().foregroundColor(.blue)
			if false {
				"ipsum dolor"
			}
			Text(verbatim: "sit").bold()
		}

		expectNoDifference(
			sut,
			Text(verbatim: "Lorem").underline().foregroundColor(.blue) +
				Text(verbatim: " ") +
				Text(verbatim: "sit").bold(),
		)
	}

	@Test func `getter text builder`() {
		var sut: Text {
			@TextBuilder(separator: " ")
			get {
				Text(verbatim: "Lorem").underline().foregroundColor(.blue)
				if false {
					"ipsum dolor"
				}
				Text(verbatim: "sit").bold()
			}
		}

		expectNoDifference(
			sut,
			Text(verbatim: "Lorem").underline().foregroundColor(.blue) +
				Text(verbatim: " ") +
				Text(verbatim: "sit").bold(),
		)
	}
}

final class BundleToken {}
