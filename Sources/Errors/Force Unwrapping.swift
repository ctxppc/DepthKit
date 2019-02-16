// DepthKit © 2017–2019 Constantino Tsarouhas

infix operator !! : NilCoalescingPrecedence

public func !!<T>(optionalValue: T?, errorMessage: String) -> T {
	guard let value = optionalValue else { fatalError(errorMessage) }
	return value
}
