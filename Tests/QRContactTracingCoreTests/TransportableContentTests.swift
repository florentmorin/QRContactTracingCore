//
//  TransportableContentTests.swift
//  
//
//  Created by Florent Morin on 05/02/2021.
//

import XCTest
import QRContactTracingCore

final class TransportableContentTests: XCTestCase {
    
    func testInitialization() {
        let localContent = LocalContent(code: MyCode(id: UUID()))
        let data = "Hello World!".data(using: .utf8)!
        
        let sentContent = TransportableContent(localContent: localContent, clearData: data)
        
        XCTAssertNotNil(sentContent)
    }
    
    func testEncryptDecrypt() {
        let id = UUID()
        
        let senderDate = Date()
        let senderCode = MyCode(id: id)
        let senderLocalContent = LocalContent(code: senderCode, date: senderDate)
        
        let receiverDate = Date().addingTimeInterval(10)
        let receiverCode = MyCode(id: id)
        let receiverLocalContent = LocalContent(code: receiverCode, date: receiverDate)
        
        let data = "Hello World!".data(using: .utf8)!
        let sentContent = TransportableContent(localContent: senderLocalContent, clearData: data)
        
        let encryptedData = sentContent!.encryptedData
        let key = sentContent!.key
        
        let receivedContent = TransportableContent(key: key, encryptedData: encryptedData)
        
        XCTAssertEqual(senderCode.id, receiverCode.id)
        XCTAssertEqual(sentContent?.id, receivedContent.id)
        XCTAssertEqual(senderLocalContent.id, receiverLocalContent.id)
        XCTAssertNotEqual(senderLocalContent.date, receiverLocalContent.date)
        
        let clearData = receivedContent.decryptData(localContent: receiverLocalContent)
        
        XCTAssertEqual(clearData, data)
    }
    
    static var allTests = [
        ("testInitialization", testInitialization),
        ("testEncryptDecrypt", testEncryptDecrypt)
    ]
}
