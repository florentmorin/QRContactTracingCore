//
//  ArrayChuckedTests.swift
//  
//
//  Created by Florent Morin on 08/02/2021.
//

import Foundation
import XCTest

@testable import QRContactTracingCore

final class ArrayChuckedTests: XCTestCase {
    
    let emptyArray = [Int]()
    let oneItemArray = [0]
    let twoItemsArray = [0,1]
    let threeItemsArray = [0,1,2]
    let fourItemsArray = [0,1,2,3]
    let fiveItemsArray = [0,1,2,3,4]
    
    func testEmptyArray() {
        let chunked = emptyArray.chunked(into: 2)
        XCTAssertEqual(chunked.count, 0)
    }
    
    func testZeroEmptyArray() {
        let chunked = emptyArray.chunked(into: 0)
        XCTAssertEqual(chunked.count, 0)
    }
    
    func testZeroOneItemArray() {
        let chunked = oneItemArray.chunked(into: 0)
        XCTAssertEqual(chunked.count, 1)
    }
    
    func testOneItemArray() {
        let chunked = oneItemArray.chunked(into: 2)
        XCTAssertEqual(chunked.count, 1)
        XCTAssertEqual(chunked[0].count, 1)
        XCTAssertEqual(chunked[0][0], 0)
    }
    
    func testTwoItemsArray() {
        let chunked = twoItemsArray.chunked(into: 2)
        XCTAssertEqual(chunked.count, 1)
        XCTAssertEqual(chunked[0].count, 2)
        XCTAssertEqual(chunked[0][0], 0)
        XCTAssertEqual(chunked[0][1], 1)
    }
    
    func testThreeItemsArray() {
        let chunked = threeItemsArray.chunked(into: 2)
        XCTAssertEqual(chunked.count, 2)
        XCTAssertEqual(chunked[0].count, 2)
        XCTAssertEqual(chunked[1].count, 1)
        XCTAssertEqual(chunked[0][0], 0)
        XCTAssertEqual(chunked[0][1], 1)
        XCTAssertEqual(chunked[1][0], 2)
    }
    
    func testFourItemsArray() {
        let chunked = fourItemsArray.chunked(into: 2)
        XCTAssertEqual(chunked.count, 2)
        XCTAssertEqual(chunked[0].count, 2)
        XCTAssertEqual(chunked[1].count, 2)
        XCTAssertEqual(chunked[0][0], 0)
        XCTAssertEqual(chunked[0][1], 1)
        XCTAssertEqual(chunked[1][0], 2)
        XCTAssertEqual(chunked[1][1], 3)
    }
    
    func testFiveItemsArray() {
        let chunked = fiveItemsArray.chunked(into: 2)
        XCTAssertEqual(chunked.count, 3)
        XCTAssertEqual(chunked[0].count, 2)
        XCTAssertEqual(chunked[1].count, 2)
        XCTAssertEqual(chunked[2].count, 1)
        XCTAssertEqual(chunked[0][0], 0)
        XCTAssertEqual(chunked[0][1], 1)
        XCTAssertEqual(chunked[1][0], 2)
        XCTAssertEqual(chunked[1][1], 3)
        XCTAssertEqual(chunked[2][0], 4)
    }
    
    static var allTests = [
        ("testEmptyArray", testEmptyArray),
        ("testZeroEmptyArray", testZeroEmptyArray),
        ("testZeroOneItemArray", testZeroOneItemArray),
        ("testOneItemArray", testOneItemArray),
        ("testTwoItemsArray", testTwoItemsArray),
        ("testThreeItemsArray", testThreeItemsArray),
        ("testFourItemsArray", testFourItemsArray),
        ("testFiveItemsArray", testFiveItemsArray),
    ]
}

