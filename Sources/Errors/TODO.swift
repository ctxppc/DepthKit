// DepthKit © 2017 Constantino Tsarouhas

/// A bottom type that represents a missing type.
///
/// As a theoretical bottom type, this type could be used anywhere a type is expected.
///
/// The type is named as such to make finding occurrences of it through codebases easier.
public enum TODO {
	
	/// Asserts that a function (or part thereof) is unimplemented.
	///
	/// Use of this value silences the compiler's definite initialisation analyser and causes a fatal error at runtime. For example, this does not produce a build-time error:
	///
	///		func doingSomething() -> Something {
	///			TODO.unimplemented
	///		}
	public static var unimplemented: Never {
		fatalError("Unimplemented function or code path")
	}
	
}
