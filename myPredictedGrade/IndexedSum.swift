/*
 * ==---------------------------------------------------------------------------------==
 *
 *  File            :   IndexedSum.swift
 *  Author          :   ALEXIS AUBRY RADANOVIC
 *
 *  License         :   The MIT License (MIT)
 *
 * ==---------------------------------------------------------------------------------==
 *
 *    The MIT License (MIT)
 *    Copyright (c) 2016 ALEXIS AUBRY RADANOVIC
 *
 *    Permission is hereby granted, free of charge, to any person obtaining a copy of
 *    this software and associated documentation files (the "Software"), to deal in
 *    the Software without restriction, including without limitation the rights to
 *    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 *    the Software, and to permit persons to whom the Software is furnished to do so,
 *    subject to the following conditions:
 *
 *    The above copyright notice and this permission notice shall be included in all
 *    copies or substantial portions of the Software.
 *
 *    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 *    FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 *    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 *    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 *    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ==---------------------------------------------------------------------------------==
 */

// MARK: - Protocols

/// A protocol for objects that can be constructed with a default value.
public protocol DefaultValueable {
    init()
}

/// A protocol for objects whose sum can be computed.
public protocol Addable {
    static func + (lhs: Self, rhs: Self) -> Self
}

/// A generic protocol for numbers.
public protocol Number: DefaultValueable, Addable {
    init(_ value: Int)
}

// MARK: - Extensions

extension Float: Number {}
extension Double: Number {}
extension Int: Number {}
extension Int8: Number {}
extension UInt8: Number {}
extension Int16: Number {}
extension UInt16: Number {}
extension Int32: Number {}
extension UInt32: Number {}
extension Int64: Number {}
extension UInt64: Number {}

extension Array where Element: Number {
    
    /// Computes the sum of every number stored in the array.
    public func sum() -> Element {
        return self.reduce(Element()) { $0 + $1 }
    }
    
}

// MARK: - Sum

///
/// Performs an indexed summation.
///
/// This function is equivalent to the [Capital-sigma notation](https://en.m.wikipedia.org/wiki/Summation#Capital-sigma_notation) for sums.
///
/// The index of summation, `i`, will be incremented by 1 for each successive term in startIndex...endIndex.
///
/// Example: computing the sum of the squares of numbers between 3 and 6.
///
/// ```
/// let squares: Double = sum(startIndex: 3, endIndex: 6) { i in 
///     return pow(i, 2) 
/// }
/// // squares = 3^2 + 4^2 + 5^2 + 6^2 = 86
/// ```
///
/// - parameter startIndex: The lower bound of summation.
/// - parameter endIndex: The upper bound of summation.
/// - parameter expression: The function mapping a summation index to a real number.
/// - parameter index: The current summation index.
///

func sum<T: Number>(startIndex: Int, endIndex: Int, expression: @escaping (_ index: T)->T) -> T {
    let summationIndexes = startIndex...endIndex
    return summationIndexes.map { expression( T($0) ) }.sum()
}
