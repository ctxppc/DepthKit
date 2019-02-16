// DepthKit © 2017–2019 Constantino Tsarouhas

/// A value that indicates whether an operation has succeeded or failed.
///
/// Use `Result` values to store the result of a `_ throws -> Value` function, e.g., as a property on a task object or as an argument to a completion handler. Use the more conventional error throwing machinery when possible.
public enum Result<Value> {
	
	/// Creates a result value with the result of performing given function.
	///
	/// If `function` returns a value `v`, `self` is equal to `.value(v)`. If `function` throws an error `e`, `self` is equal to `.error(e)`.
	///
	/// This initialiser bridges functions using the Swift error throwing machinery to result values.
	///
	/// - Parameter function: A throwing function.
	public init(from function: () throws -> Value) {
		do {
			self = .value(try function())
		} catch {
			self = .error(error)
		}
	}
	
	/// A result representing a successful completion of an operation.
	///
	/// - Parameter 1: The value returned during the operation.
	case value(Value)
	
	/// A result representing an unsuccessful completion of an operation.
	///
	/// - Parameter 1: The error thrown during the operation.
	case error(Error)
	
	/// Returns the value if the result represents a successful completion of an operation or throws an error if the result represents an unsuccessful completion of an operation.
	///
	/// This method bridges result values to functions using the Swift error throwing machinery.
	///
	/// - Returns: The value.
	///
	/// - Throws: The error in `self` if `self` represents an unsuccessful completion of an operation.
	public func value() throws -> Value {
		switch self {
			case .value(let value):	return value
			case .error(let error):	throw error
		}
	}
	
}
