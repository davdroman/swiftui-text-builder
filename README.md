# TextBuilder

[![CI](https://github.com/davdroman/swiftui-text-builder/actions/workflows/ci.yml/badge.svg)](https://github.com/davdroman/swiftui-text-builder/actions/workflows/ci.yml)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fdavdroman%2Fswiftui-text-builder%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/davdroman/swiftui-text-builder)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fdavdroman%2Fswiftui-text-builder%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/davdroman/swiftui-text-builder)
[![](https://img.shields.io/badge/Documentation-gray?logo=swift&logoColor=white)](https://swiftpackageindex.com/davdroman/swiftui-text-builder/main/documentation/textbuilder)

## Introduction

`Text` composition in SwiftUI can often be cumbersome, especially when there's logic affecting its format and content.

TextBuilder leverages the power of Swift [Macros](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/macros/) to solve this problem. The `@TextBuilder` macro transforms computed properties into builder-style closures, making text composition intuitive and readable.

## Installation

Add `TextBuilder` to your Swift Package Manager dependencies:

```swift
.package(url: "https://github.com/davdroman/swiftui-text-builder", from: "5.0.0"),
```

Then, add the dependency to your desired target:

```swift
.product(name: "TextBuilder", package: "swiftui-text-builder"),
```

## Usage

### Basic Usage

Apply `@TextBuilder` to computed properties that return `Text`. The macro will transform the property body into a builder-style closure that concatenates text segments.

```swift
@TextBuilder
var loremIpsum: Text {
    Text("Lorem").underline().foregroundColor(.blue)
    Text("ipsum dolor")
    Text("sit").bold()
    Text("amet, consectetur")
}
```

This creates a concatenated `Text` without any separators between segments.

`@TextBuilder` can also be applied to a property's getter or to a function:

```swift
var loremIpsum: Text {
    @TextBuilder get {
        Text("Lorem").underline().foregroundColor(.blue)
        Text("ipsum dolor")
    }
}

@TextBuilder
func loremIpsum() -> Text {
    Text("Lorem").underline().foregroundColor(.blue)
    Text("ipsum dolor")
}
```

### With Separators

You can specify a separator to be inserted between text segments:

```swift
@TextBuilder(separator: " ")
var spacedText: Text {
    Text("Lorem").underline().foregroundColor(.blue)
    Text("ipsum dolor")
    Text("sit").bold()
    Text("amet, consectetur")
}
```

For multiline text:

```swift
@TextBuilder(separator: "\n")
var multilineText: Text {
    Text("Lorem").underline().foregroundColor(.blue)
    Text("ipsum dolor")
    Text("sit").bold()
    Text("amet, consectetur")
}
```

### String Support ✨

TextBuilder accepts `String` types directly as verbatim text:

```swift
@TextBuilder(separator: " ")
var mixedText: Text {
    "Hello"  // String literal becomes verbatim Text
    Text(verbatim: "world").bold()  // Use Text for chaining modifiers
    String(2025)  // Any StringProtocol works
}
```

### Control Flow

TextBuilder supports Swift's control flow statements:

```swift
@TextBuilder(separator: " ")
var conditionalText: Text {
    "Hello"

    if showDetails {
        "with details"
    } else {
        "basic"
    }

    if let name = userName {
        Text(name).italic()
    }

    for i in 1...3 {
        String(i)
    }
}
```

### Alternative API

If you prefer not to use macros, you can use the underlying `Text` initializer directly:

```swift
var body: some View {
    Text(separator: " 👏 ") {
        Text(verbatim: "Lorem").underline().foregroundColor(.blue)
        "ipsum dolor"
        Text(verbatim: "sit").bold()
        "amet, consectetur"
    }
}
```

This is useful if you simply want to insert some rich text into a view body without defining a separate property.

## Development

Install [Mise](https://mise.jdx.dev/), then install the project tools and Git hooks:

```sh
mise install
mise exec -- hk install --mise
```
