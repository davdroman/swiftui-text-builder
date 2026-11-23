import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

struct TextBuilderMacro: BodyMacro {
	static func expansion(
		of node: AttributeSyntax,
		providingBodyFor declaration: some DeclSyntaxProtocol & WithOptionalCodeBlockSyntax,
		in context: some MacroExpansionContext,
	) throws -> [CodeBlockItemSyntax] {
		let arguments: LabeledExprListSyntax =
			if case let .argumentList(list) = node.arguments {
				list
			} else {
				[]
			}

		let separatorExpr =
			arguments.first { $0.label?.text == "separator" }?.expression
				?? ExprSyntax(NilLiteralExprSyntax())

		// When `bundle:` is omitted, `Text(separator:bundle:content:)` defaults it to `#bundle` at the expansion
		// site, which resolves to the bundle of the code the macro is applied in.
		let bundleArgument: ExprSyntax? = arguments.first { $0.label?.text == "bundle" }?.expression

		let statements = declaration.body?.statements ?? []

		if let bundleArgument {
			return [
				"""
				Text(separator: \(separatorExpr), bundle: \(bundleArgument)) { \(statements) }
				""",
			]
		} else {
			return [
				"""
				Text(separator: \(separatorExpr)) { \(statements) }
				""",
			]
		}
	}
}
