//
//  Array+Chunked.swift
//  
//
//  Created by Florent Morin on 05/02/2021.
//

import Foundation

extension Array {
    
    /// Chunk an array into elements of specified size
    ///
    /// - parameter size: Size of each sub-array
    ///
    /// Thanks to [Paul Hudson](https://www.hackingwithswift.com/example-code/language/how-to-split-an-array-into-chunks)
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
