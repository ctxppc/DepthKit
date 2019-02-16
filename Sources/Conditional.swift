// DepthKit © 2017–2019 Constantino Tsarouhas

infix operator --> : TernaryPrecedence

/// Performs `effect` if `condition` is true.
///
/// This is shorthand notation for `if condition { effect }`. Using this shorthand for more than one statement (via an explicit closure) or for statements better expressed using `guard` is discouraged.
///
/// - Parameter condition: The condition to test for.
/// - Parameter effect: A autoclosure that is evaluated if `condition` evaluates to `true`.
public func --> (condition: Bool, effect: @autoclosure () -> ()) {
	if condition {
		effect()
	}
}

/// Returns a Boolean value indicating whether the consequent is true if the antecedent is also true, i.e., `antecedent` ⇒ `consequent` where ⇒ is the material conditional.
///
/// - SeeAlso: https://en.wikipedia.org/wiki/Material_conditional
///
/// - Parameter antecedent: The antecedent.
/// - Parameter consequent: The consequent (only evaluated if `antecedent` is `true`).
///
/// - Returns: A Boolean value evaluating to `antecedent` ⇒ `consequent`, or equivalently to ¬`antecedent` ∨ `consequent`.
public func --> (antecedent: Bool, consequent: @autoclosure () -> Bool) -> Bool {
	return !antecedent || consequent()
}
