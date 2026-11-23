public import Foundation
public import SwiftUI

/// A body macro that lets you build a single `SwiftUI.Text` from multiple parts using a builder-style closure. Write
/// `Text` fragments and string-like values across multiple lines, and they will be concatenated into one `Text`,
/// optionally inserting a separator between items.
///
/// ## Behavior
/// - Empty bodies produce `Text(verbatim: "")`.
/// - You can mix `Text` values and string-like values. String literals, including interpolated ones, are localized
///   like `Text("…")`. String values (e.g., a `String` variable or the result of `String(i)`) are treated as verbatim
///   text.
/// - `AttributedString`, `LocalizedStringResource`, and `Image` values become text as the matching `Text`
///   initializers make them.
/// - Control flow is supported: `if`/`else`, `if let`, and `for` loops can conditionally emit or repeat parts.
/// - Modifiers applied to individual segments (e.g., `.bold()`, `.underline()`, `.foregroundColor(_:)`) are preserved
///   for those segments.
/// - When a separator is provided, it is inserted between emitted segments, not before the first or after the last one.
///
/// ## Example
/// ```swift
/// @TextBuilder(separator: " ")
/// var message: Text {
///     Text("Hello").bold()
///     "world, the year is"
///     String(2025)
/// }
/// ```
///
/// ## Localization
/// String literals are looked up in the bundle that contains the resources of the code they're written in, as
/// `#bundle` gives: the app's bundle in an app, or the resource bundle of a framework or Swift package target. Pass
/// `bundle:` to look them up somewhere else.
///
/// A Swift package target without resources has no bundle of its own, so `#bundle` fails to compile there with "No
/// resource bundle is available for this module". Pass the bundle that holds its strings instead, or `nil` for the
/// main bundle.
///
/// ## Notes
/// - The expansion relies on the ``Text.init(separator:default:bundle:content:)-(Text?,_,_,_)`` builder-style API
///   that is included as part of this package, which performs concatenation and separator insertion.
/// - Apply `@TextBuilder` to computed properties, getters, or functions that return `Text`.
@attached(body)
public macro TextBuilder(separator: Text? = nil, bundle: Bundle? = #bundle) = #externalMacro(
	module: "TextBuilderMacro",
	type: "TextBuilderMacro",
)

/// Convenience overload that accepts any `StringProtocol` as the separator, which is treated as verbatim text
/// (equivalent to `Text(verbatim: separator)`).
@attached(body)
public macro TextBuilder<Separator: StringProtocol>(separator: Separator, bundle: Bundle? = #bundle) = #externalMacro(
	module: "TextBuilderMacro",
	type: "TextBuilderMacro",
)
