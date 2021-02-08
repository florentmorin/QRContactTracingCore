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
        
        let rawContent = LocalContent(codeId: identifier, date: date, transportableKey: key)
        
        XCTAssertEqual(rawContent.codeId, code.id)
        XCTAssertEqual(rawContent.codeId, identifier)
        XCTAssertEqual(rawContent.key, code.id.data)
        XCTAssertEqual(rawContent.key, rawContent.codeId.data)
        XCTAssertEqual(rawContent.date, date)
        XCTAssertEqual(rawContent.transportableKey, key)
        XCTAssertEqual(rawContent.transportableKey, LocalContent.buildTransportableKey(id: rawContent.codeId, date: rawContent.date))
    }
    
    static var allTests = [
        ("testInitialization", testInitialization)
    ]
}
