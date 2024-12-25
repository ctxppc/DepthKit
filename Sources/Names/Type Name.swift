// DepthKit © 2017–2024 Constantino Tsarouhas

/// A collective name that may be based on a Swift type's name.
public protocol TypeName : Sendable, ExpressibleByStringInterpolation where StringLiteralType == String {
	
	/// Creates a name with given already validated source.
	///
	/// - Note: This method does not perform validation. Prefer using `init(stringLiteral:)` and `init(type:)` instead.
	init(validatedSource: TypeNameSource)
	
	/// The source of the name.
	var source: TypeNameSource { get }
	
	/// The pattern that names of this type conform to.
	static var pattern: Regex<Substring> { get }
	
}

public enum TypeNameSource : Sendable {
	case literal(String)
	case typeName(String)
}

extension TypeName {
	
	/// Creates a type name.
	///
	/// - Requires: `name` is a valid name, i.e., matches `Self.pattern`.
	public init(stringLiteral name: String) {
		precondition(try! Self.pattern.wholeMatch(in: name) != nil, "'\(name)' is not a valid \(Self.self)")
		self.init(validatedSource: .literal(name))
	}
	
	/// Creates a name based on a given type.
	public init<T>(type: T.Type) {
		self.init(validatedSource: .typeName("\(type)"))
	}
	
	/// Returns the encoded name.
	public func encoded(transform: NameTransform) -> String {
		switch source {
			case .literal(let name):	name
			case .typeName(let name):	transform(name)
		}
	}
	
}
