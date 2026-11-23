import CustomDump
import SwiftUI
import Testing
import TextBuilder

@Suite struct TextExtensionsTests {
	@Test func `joined without separator`() {
		expectNoDifference(
			textArray.joined(),
			Text("Lorem").underline().foregroundColor(.blue) +
				Text("ipsum dolor") +
				Text("sit").bold() +
				Text("amet, consectetur"),
		)
	}

	@Test func `joined with space separator`() {
		expectNoDifference(
			textArray.joined(separator: Text(" ")),
			Text("Lorem").underline().foregroundColor(.blue) +
				Text(" ") +
				Text("ipsum dolor") +
				Text(" ") +
				Text("sit").bold() +
				Text(" ") +
				Text("amet, consectetur"),
		)
	}

	@Test func `joined with formatted separator`() {
		expectNoDifference(
			textArray.joined(separator: Text(" ** ").italic().foregroundColor(.green)),
			Text("Lorem").underline().foregroundColor(.blue) +
				Text(" ** ").italic().foregroundColor(.green) +
				Text("ipsum dolor") +
				Text(" ** ").italic().foregroundColor(.green) +
				Text("sit").bold() +
				Text(" ** ").italic().foregroundColor(.green) +
				Text("amet, consectetur"),
		)
	}

	@Test func `init without separator`() {
		expectNoDifference(
			Text(content: textSegments),
			Text("Lorem").underline().foregroundColor(.blue) +
				Text("ipsum dolor") +
				Text("sit").bold() +
				Text("amet, consectetur"),
		)
		expectNoDifference(
			Text(separator: nil, content: textSegments),
			Text("Lorem").underline().foregroundColor(.blue) +
				Text("ipsum dolor") +
				Text("sit").bold() +
				Text("amet, consectetur"),
		)
	}

	@Test func `init with blank separator`() {
		expectNoDifference(
			Text(separator: Text(""), content: textSegments),
			Text("Lorem").underline().foregroundColor(.blue) +
				Text("") +
				Text("ipsum dolor") +
				Text("") +
				Text("sit").bold() +
				Text("") +
				Text("amet, consectetur"),
		)
		expectNoDifference(
			Text(separator: "", content: textSegments),
			Text("Lorem").underline().foregroundColor(.blue) +
				Text(verbatim: "") +
				Text("ipsum dolor") +
				Text(verbatim: "") +
				Text("sit").bold() +
				Text(verbatim: "") +
				Text("amet, consectetur"),
		)
	}

	@Test func `init with space separator`() {
		expectNoDifference(
			Text(separator: Text(" "), content: textSegments),
			Text("Lorem").underline().foregroundColor(.blue) +
				Text(" ") +
				Text("ipsum dolor") +
				Text(" ") +
				Text("sit").bold() +
				Text(" ") +
				Text("amet, consectetur"),
		)
		expectNoDifference(
			Text(separator: " ", content: textSegments),
			Text("Lorem").underline().foregroundColor(.blue) +
				Text(verbatim: " ") +
				Text("ipsum dolor") +
				Text(verbatim: " ") +
				Text("sit").bold() +
				Text(verbatim: " ") +
				Text("amet, consectetur"),
		)
	}

	@Test func `init with newline separator`() {
		expectNoDifference(
			Text(separator: Text("\n"), content: textSegments),
			Text("Lorem").underline().foregroundColor(.blue) +
				Text("\n") +
				Text("ipsum dolor") +
				Text("\n") +
				Text("sit").bold() +
				Text("\n") +
				Text("amet, consectetur"),
		)
		expectNoDifference(
			Text(separator: "\n", content: textSegments),
			Text("Lorem").underline().foregroundColor(.blue) +
				Text(verbatim: "\n") +
				Text("ipsum dolor") +
				Text(verbatim: "\n") +
				Text("sit").bold() +
				Text(verbatim: "\n") +
				Text("amet, consectetur"),
		)
	}

	@Test func `init localizes string literals in the given bundle`() {
		let bundle = Bundle(for: BundleToken.self)

		expectNoDifference(
			Text(separator: " ", bundle: bundle) {
				"Lorem"
				Text("ipsum")
			},
			Text("Lorem", bundle: bundle) +
				Text(verbatim: " ") +
				Text("ipsum"),
		)
	}

	@Test func `init with string separator uses default when empty`() {
		expectNoDifference(
			Text(separator: " ", default: Text(verbatim: "Empty")) {},
			Text(verbatim: "Empty"),
		)
	}
}

extension TextExtensionsTests {
	private var textArray: [Text] {
		[
			Text("Lorem").underline().foregroundColor(.blue),
			Text("ipsum dolor"),
			Text("sit").bold(),
			Text("amet, consectetur"),
		]
	}

	@TextSegmentBuilder
	private func textSegments() -> [TextSegment] {
		Text("Lorem").underline().foregroundColor(.blue)
		Text("ipsum dolor")
		Text("sit").bold()
		Text("amet, consectetur")
	}
}
