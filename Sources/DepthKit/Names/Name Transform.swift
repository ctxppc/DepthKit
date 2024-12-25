// DepthKit © 2017–2024 Constantino Tsarouhas

/// A function that transforms a name.
public protocol NameTransform {
	
	/// Transforms given name.
	func callAsFunction(_ original: String) -> String
	
}

extension NameTransform {
	
	/// Returns a transform that doesn't change names.
	public static func identity() -> Self where Self == IdentityNameTransform {
		.init()
	}
	
	/// Returns a transform which removes given suffix (for names that consist of a non-empty prefix and given suffix), then converts names to snake-case, i.e., lower-cased with (originally titlecased) words connected by underscores.
	public static func snakecase(suffix: String = "") -> Self where Self == JoinedWordsNameTransform {
		.init(uppercased: false, joiner: "_", suffix: suffix)
	}
	
	/// Returns a transform which removes given suffix (for names that consist of a non-empty prefix and given suffix), then converts names to kebab-case, i.e., lower-cased with (originally titlecased) words connected by hyphens.
	public static func kebabcase(suffix: String = "") -> Self where Self == JoinedWordsNameTransform {
		.init(uppercased: false, joiner: "-", suffix: suffix)
	}
	
	/// Returns a transform defined by a given function.
	public static func custom(_ transform: @escaping Self.Transform) -> Self where Self == CustomNameTransform {
		.init(transform: transform)
	}
	
}

public struct IdentityNameTransform : NameTransform {
	
	// See protocol.
	public func callAsFunction(_ original: String) -> String {
		original
	}
	
}

public struct JoinedWordsNameTransform : NameTransform {
	
	/// A Boolean value indicating whether the words in the result are uppercased (as opposed to lowercased).
	public var uppercased: Bool
	
	/// The string to interject between words.
	public var joiner: String
	
	/// The suffix to remove from the result.
	public var suffix: String
	
	// See protocol.
	public func callAsFunction(_ original: String) -> String {
		
		var trimmed = original
		if !suffix.isEmpty, original.hasSuffix(suffix) {
			trimmed.removeLast(suffix.count)
			if trimmed.isEmpty {
				trimmed = original
			}
		}
		
		return trimmed
			.splitByTitlecasedWords()
			.map { uppercased ? $0.uppercased() : $0.lowercased() }
			.joined(separator: joiner)
		
	}
	
}

public struct CustomNameTransform : NameTransform {
	
	/// A function to transforms a name.
	public let transform: Transform
	public typealias Transform = (String) -> String
	
	// See protocol.
	public func callAsFunction(_ original: String) -> String {
		transform(original)
	}
	
}
