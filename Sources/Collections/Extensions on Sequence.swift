// DepthKit © 2017–2021 Constantino Tsarouhas

extension Sequence where Element : Comparable {
	
	/// Returns a Boolean value indicating whether the sequence precedes another sequence in a lexicographical ordering, ordering a shorter sequence after the longer one when the short sequence is a prefix of the longer sequence.
	///
	/// - Parameter other: A sequence to compare to this sequence.
	/// - Parameter orderingShorterSequencesAfter: The unit value.
	
	/// - Returns: `true` if `self` precedes `self` in a lexicographical ordering and `self` is longer than `other`; otherwise, `false`.
	internal func lexicographicallyPrecedes<OtherSequence : Sequence>(_ other: OtherSequence, orderingShorterSequencesAfter: ()) -> Bool where OtherSequence.Element == Element {
		
		var elementsOfFirstSequence = self.makeIterator()
		var elementsOfSecondSequence = other.makeIterator()
		
		while let elementOfFirstSequence = elementsOfFirstSequence.next() {
			
			guard let elementOfSecondSequence = elementsOfSecondSequence.next() else { return true }
			
			if elementOfFirstSequence < elementOfSecondSequence {
				return true
			} else if elementOfFirstSequence > elementOfSecondSequence {
				return false
			}
			
		}
		
		return false
		
	}
	
}
