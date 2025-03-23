// DepthKit © 2017–2025 Constantino Tsarouhas

public protocol OptionalProtocol : ~Copyable, ExpressibleByNilLiteral {
	
	/// A wrapped value.
	associatedtype Wrapped
	
	/// Creates an optional containing a given value.
	init(_ some: consuming Wrapped)
	
	/// The unwrapped value, or `nil` if `self` represents `nil`.
	var unwrapped: Wrapped? { get }
	
	/// Returns the wrapped value (or `nil` if absent) and sets `self` to `nil`.
	mutating func take() -> Wrapped?
	
}

extension Optional : OptionalProtocol {
	public var unwrapped: Wrapped? { self }
}
