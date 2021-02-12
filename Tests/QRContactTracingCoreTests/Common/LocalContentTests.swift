//
//  LocalContentTests.swift
//  
//
//  Created by Florent Morin on 05/02/2021.
//

import XCTest

@testable import QRContactTracingCore

final class LocalContentTests: XCTestCase {
    
    func testInitialization() {
        let identifier = UUID()
        let code = MyCode(id: identifier)
        let date = Date()
        
        let scannedContent = LocalContent(codeId: code.id, date: date)
        let key = scannedContent.transportableKey
        
        XCTAssertEqual(scannedContent.codeId, code.id)
        XCTAssertEqual(scannedContent.codeId, identifier)
        XCTAssertEqual(scannedContent.date, date)
        XCTAssertNil(scannedContent.dateOffset)
        
        let rawContent = LocalContent(codeId: identifier, date: date, transportableKey: key)
        
        XCTAssertEqual(rawContent.codeId, code.id)
        XCTAssertEqual(rawContent.codeId, identifier)
        XCTAssertEqual(rawContent.key, code.id.data)
        XCTAssertEqual(rawContent.key, rawContent.codeId.data)
        XCTAssertEqual(rawContent.date, date)
        XCTAssertNil(rawContent.dateOffset)
        XCTAssertEqual(rawContent.transportableKey, key)
        XCTAssertEqual(rawContent.transportableKey, LocalContent.buildTransportableKey(id: rawContent.codeId, date: rawContent.date))
    }
    
    func testInitializationWithOffset() {
        let identifier = UUID()
        let code = MyCode(id: identifier)
        let date = Date()
        let dateOffset = 10
        
        let scannedContent = LocalContent(codeId: code.id, date: date, dateOffset: dateOffset)
        let key = scannedContent.transportableKey
        
        XCTAssertEqual(scannedContent.codeId, code.id)
        XCTAssertEqual(scannedContent.codeId, identifier)
        XCTAssertEqual(scannedContent.date, date)
        XCTAssertEqual(scannedContent.dateOffset, dateOffset)
        
        let rawContent = LocalContent(codeId: identifier, date: date, dateOffset: dateOffset, transportableKey: key)
        
        XCTAssertEqual(rawContent.codeId, code.id)
        XCTAssertEqual(rawContent.codeId, identifier)
        XCTAssertEqual(rawContent.key, code.id.data)
        XCTAssertEqual(rawContent.key, rawContent.codeId.data)
        XCTAssertEqual(rawContent.date, date)
        XCTAssertEqual(rawContent.dateOffset, dateOffset)
        XCTAssertEqual(rawContent.transportableKey, key)
        XCTAssertEqual(rawContent.transportableKey, LocalContent.buildTransportableKey(id: rawContent.codeId, date: rawContent.date, dateOffset: dateOffset))
    }
    
    static var allTests = [
        ("testInitialization", testInitialization),
        ("testInitializationWithOffset", testInitializationWithOffset)
    ]
}
