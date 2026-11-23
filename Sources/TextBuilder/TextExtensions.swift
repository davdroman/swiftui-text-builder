public import Foundation
public import SwiftUI

extension Sequence<Text> {
	/// Returns a new `Text` by concatenating the elements of the sequence.
	///
	/// If the sequence is empty, it returns nil.
	///
	/// The following example shows how an array of `Text` views can be joined to a
	/// single `Text` view with comma-separated string:
	///
	///     let cast = [Text("Vivien"), Text("Marlon"), Text("Kim")]
	///     let list = cast.joined(separator: Text(", "))
	///     // Gives Text("Vivien, Marlon, Kim")
	///
	/// - Parameter separator: A `Text` view to insert between each of the elements
	///   in this sequence. By default there is no separator.
	/// - Returns: A single, concatenated `Text` view, or `nil` if the sequence
	///   is empty.
	public func joined(separator: Text? = nil) -> Text? {
		reduce(nil) { accumulated, next in
			guard let accumulated else {
				return next
			}
			guard let separator else {
				return accumulated + next
			}
			return accumulated + separator + next
		}
	}
}

/// A segment of text collected by ``TextSegmentBuilder``.
///
/// Localized segments are resolved against the bundle passed to `Text(separator:default:bundle:content:)` when the
/// text is built.
public struct TextSegment {
	@usableFromInline
	enum Storage {
		case text(Text)
		case localized(LocalizedStringKey)
	}

	@usableFromInline
	let storage: Storage

	@inlinable
	init(_ storage: Storage) {
		self.storage = storage
	}

	@inlinable
	func text(bundle: Bundle?) -> Text {
		switch storage {
		case let .text(text):
			text
		case let .localized(key):
			Text(key, bundle: bundle)
		}
	}
}

/// A result builder that collects text segments from `Text` values, strings, attributed strings, and images.
///
/// String literals, including interpolated ones, become localized text, like `Text("…")`. String values become
/// verbatim text, like `Text(someString)`. Attributed strings, localized string resources, and images become text as
/// the matching `Text` initializers make them.
@resultBuilder
public enum TextSegmentBuilder {
	@inlinable
	public static func buildExpression(_ text: Text) -> [TextSegment] {
		[TextSegment(.text(text))]
	}

	@inlinable
	public static func buildExpression(_ texts: [Text]) -> [TextSegment] {
		texts.map { TextSegment(.text($0)) }
	}

	@inlinable
	public static func buildExpression(_ key: LocalizedStringKey) -> [TextSegment] {
		[TextSegment(.localized(key))]
	}

	@_disfavoredOverload
	@inlinable
	public static func buildExpression(_ string: some StringProtocol) -> [TextSegment] {
		[TextSegment(.text(Text(string)))]
	}

	@_disfavoredOverload
	@inlinable
	public static func buildExpression(_ attributedString: AttributedString) -> [TextSegment] {
		[TextSegment(.text(Text(attributedString)))]
	}

	/// Turns a localized string resource into text. The resource is looked up in its own bundle, not the one passed to
	/// `Text(separator:default:bundle:content:)`.
	@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
	@_disfavoredOverload
	@inlinable
	public static func buildExpression(_ resource: LocalizedStringResource) -> [TextSegment] {
		[TextSegment(.text(Text(resource)))]
	}

	@inlinable
	public static func buildExpression(_ image: Image) -> [TextSegment] {
		[TextSegment(.text(Text(image)))]
	}

	@inlinable
	public static func buildBlock() -> [TextSegment] {
		[]
	}

	@inlinable
	public static func buildPartialBlock(first: [TextSegment]) -> [TextSegment] {
		first
	}

	@inlinable
	public static func buildPartialBlock(accumulated: [TextSegment], next: [TextSegment]) -> [TextSegment] {
		accumulated + next
	}

	@inlinable
	public static func buildOptional(_ component: [TextSegment]?) -> [TextSegment] {
		component ?? []
	}

	@inlinable
	public static func buildEither(first component: [TextSegment]) -> [TextSegment] {
		component
	}

	@inlinable
	public static func buildEither(second component: [TextSegment]) -> [TextSegment] {
		component
	}

	@inlinable
	public static func buildArray(_ components: [[TextSegment]]) -> [TextSegment] {
		components.flatMap(\.self)
	}

	@inlinable
	public static func buildLimitedAvailability(_ component: [TextSegment]) -> [TextSegment] {
		component
	}
}

extension Text {
	/// Creates a combined text view based on the given `content` by inserting
	/// `separator` text views between each received text component.
	///
	/// - Parameters:
	///   - separator: The text to use as a separator between received text components.
	///     By default there is no separator.
	///   - default: The text to use when `content` produces no components.
	///   - bundle: The bundle to look up localized string literals in. By default, the bundle that contains the
	///     resources of the calling code, as `#bundle` gives.
	///   - content: A text segment builder that creates text components.
	public init(
		separator: Text? = nil,
		default: Text = Text(verbatim: ""),
		bundle: Bundle? = #bundle,
		@TextSegmentBuilder content: () -> [TextSegment],
	) {
		self = content().map { $0.text(bundle: bundle) }.joined(separator: separator) ?? `default`
	}

	/// Creates a combined text view based on the given `content` by inserting
	/// `separator` string between each received text component.
	///
	/// - Parameters:
	///   - separator: The string to use as a separator between received text components.
	///   - default: The text to use when `content` produces no components.
	///   - bundle: The bundle to look up localized string literals in. By default, the bundle that contains the
	///     resources of the calling code, as `#bundle` gives.
	///   - content: A text segment builder that creates text components.
	@inlinable
	public init(
		separator: some StringProtocol,
		default: Text = Text(verbatim: ""),
		bundle: Bundle? = #bundle,
		@TextSegmentBuilder content: () -> [TextSegment],
	) {
		self.init(separator: Text(separator), default: `default`, bundle: bundle, content: content)
	}
}
