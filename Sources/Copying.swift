// DepthKit © 2017 Constantino Tsarouhas

/// Returns a mutated copy of some value.
///
/// - Warning: This function is meant for use with non-object values; it mutates objects in-place.
///
/// - Parameters:
///		- subject: The value whose copy to mutate and return.
///		- mutator: A closure that performs mutation.
///
/// - Returns: A copy of `subject` after being mutated by `mutator`.
public func withCopy<S>(of subject: S, mutator: (inout S) throws -> Any) rethrows -> S {
	var subject = subject
	_ = try mutator(&subject)
	return subject
}

/// Returns a mutated copy of some value.
///
/// - Warning: This function is meant for use with non-object values; it mutates objects in-place.
///
/// - Parameters:
///		- subject: The value whose copy to mutate and return.
///		- mutator: A closure that performs mutation.
///		- argument: The argument to the subject-qualified mutator.
///
/// - Returns: A copy of `subject` after being mutated by `mutator`.
public func withCopy<S, A>(of subject: S, mutator: (inout S) throws -> (A) -> Any, argument: A) rethrows -> S {
	var subject = subject
	_ = try mutator(&subject)(argument)
	return subject
}

/// Returns a mutated copy of some value.
///
/// - Warning: This function is meant for use with non-object values; it mutates objects in-place.
///
/// - Parameters:
///		- subject: The value whose copy to mutate and return.
///		- mutator: A closure that performs mutation.
///		- firstArgument: The first argument to the subject-qualified mutator.
///		- secondArgument: The second argument to the subject-qualified mutator.
///
/// - Returns: A copy of `subject` after being mutated by `mutator`.
public func withCopy<S, A, B>(of subject: S, mutator: (inout S) throws -> (A, B) -> Any, arguments firstArgument: A, _ secondArgument: B) rethrows -> S {
	var subject = subject
	_ = try mutator(&subject)(firstArgument, secondArgument)
	return subject
}

/// Returns a mutated copy of some value.
///
/// - Warning: This function is meant for use with non-object values; it mutates objects in-place.
///
/// - Parameters:
///		- subject: The value whose copy to mutate and return.
///		- mutator: A closure that performs mutation.
///		- firstArgument: The first argument to the subject-qualified mutator.
///		- secondArgument: The second argument to the subject-qualified mutator.
///		- thirdArgument: The third argument to the subject-qualified mutator.
///
/// - Returns: A copy of `subject` after being mutated by `mutator`.
public func withCopy<S, A, B, C>(of subject: S, mutator: (inout S) throws -> (A, B, C) -> Any, arguments firstArgument: A, _ secondArgument: B, _ thirdArgument: C) rethrows -> S {
	var subject = subject
	_ = try mutator(&subject)(firstArgument, secondArgument, thirdArgument)
	return subject
}
