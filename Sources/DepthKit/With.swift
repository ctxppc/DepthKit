// DepthKit © 2017–2025 Constantino Tsarouhas

/// Modifies given initial value using given modification function, then returns the modified value.
///
/// - Parameters:
///   - initialValue: The initial value.
///   - modify: A function that modifies the initial value.
///
/// - Returns: The resulting value after executing `modify` on `initialValue`.
public func with<Value, Failure>(_ initialValue: Value, modify: (inout Value) throws(Failure) -> ()) throws(Failure) -> Value {
	var value = initialValue
	try modify(&value)
	return value
}

/// Modifies given initial value using given modification function, then returns the modified value.
///
/// - Parameters:
///   - initialValue: The initial value.
///   - modify: A function that modifies the initial value.
///
/// - Returns: The resulting value after executing `modify` on `initialValue`.
public func with<Value, Failure>(_ initialValue: Value, modify: (inout Value) async throws(Failure) -> ()) async throws(Failure) -> Value {
	var value = initialValue
	try await modify(&value)
	return value
}
