//
//  UUIDDataTests.swift
//  
//
//  Created by Florent Morin on 08/02/2021.
//

import Foundation
import XCTest

@testable import QRContactTracingCore

final class UUIDDataTests: XCTestCase {
    
    let validUUIDString = "F78B2C36-896F-4DEC-B320-1562B3C0B97D"
    let validUUIDBytes: [UInt8] =  [
        0xF7, 0x8B, 0x2C, 0x36,
        0x89, 0x6F, 0x4D, 0xEC,
        0xB3, 0x20, 0x15, 0x62,
        0xB3, 0xC0, 0xB9, 0x7D
    ]
    
    let invalidUUIDBytes: [UInt8] =  [
        0xF7, 0x8B, 0x2C, 0x36,
        0x89, 0x6F, 0x4D, 0xEC,
        0xB3, 0x20, 0x15, 0x62,
        0xB3, 0xC0, 0xB9, 0x7D,
        0x45
    ]
    
    var validUUIDData: Data {
        Data(bytes: validUUIDBytes, count: validUUIDBytes.count)
    }
    
    var invalidUUIDData: Data {
        Data(bytes: invalidUUIDBytes, count: invalidUUIDBytes.count)
    }
    
    var validUUID: UUID {
        UUID(uuidString: validUUIDString)!
    }
    
    func testValidUUID() {
        let newUUID = UUID(data: validUUIDData)
        XCTAssertEqual(newUUID?.uuidString, validUUIDString)
        XCTAssertEqual(newUUID, validUUID)
        XCTAssertEqual(validUUID.data, validUUIDData)
    }
    
    func testInvalidUUID() {
        XCTAssertNil(UUID(data: invalidUUIDData))
    }
    
    static var allTests = [
        ("testValidUUID", testValidUUID),
        ("testInvalidUUID", testInvalidUUID),
    ]
}
