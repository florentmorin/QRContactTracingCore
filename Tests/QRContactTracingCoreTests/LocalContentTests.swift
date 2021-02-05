//
//  LocalContentTests.swift
//  
//
//  Created by Florent Morin on 05/02/2021.
//

import XCTest
import QRContactTracingCore

final class LocalContentTests: XCTestCase {
    
    func testInitialization() {
        let identifier = UUID()
        let code = MyCode(id: identifier)
        let date = Date()
        
        let scannedContent = LocalContent(code: code, date: date)
        let key = scannedContent.transportableKey
        
        XCTAssertEqual(scannedContent.codeId, code.id)
        XCTAssertEqual(scannedContent.codeId, identifier)
        XCTAssertEqual(scannedContent.date, date)
        
        let rawContent = LocalContent(codeId: identifier, date: date, transportableKey: key)
        
        XCTAssertEqual(rawContent.codeId, code.id)
        XCTAssertEqual(rawContent.codeId, identifier)
        XCTAssertEqual(rawContent.date, date)
        XCTAssertEqual(rawContent.transportableKey, key)
    }
    
    static var allTests = [
        ("testInitialization", testInitialization)
    ]
}
