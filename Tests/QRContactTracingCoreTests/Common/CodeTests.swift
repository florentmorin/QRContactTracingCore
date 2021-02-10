import XCTest

#if canImport(CoreServices)
import CoreServices
#endif

#if canImport(MobileCoreServices)
import MobileCoreServices
#endif

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

#if canImport(SwiftUI)
import SwiftUI
#endif

import QRContactTracingCore

final class CodeTests: XCTestCase {
    
    let goodURLs = [
        URL(string: "https://z2z.fr/pQvk5q0gRKW_h4ZItcdWNw?t=h&c=20")!,
        URL(string: "https://z2z.fr/pQvk5q0gRKW_h4ZItcdWNw?c=20")!,
        URL(string: "https://z2z.fr/pQvk5q0gRKW_h4ZItcdWNw?t=h")!,
        URL(string: "https://z2z.fr/pQvk5q0gRKW_h4ZItcdWNw")!
    ]
    
    let badURLs = [
        URL(string: "https://z2z.fr/pQvk5q0gRSW_h4ZItcdWNws")!,
        URL(string: "https://z3z.fr/pQvk5q0gRKW_h4ZItcdWNw")!,
        URL(string: "http://z2z.fr/pQvk5q0gRKW_h4ZItcdWNw")!,
        URL(string: "https://z2z.fr/pQvk5q0gRKW_h4ZItcdWNw/d")!
    ]
    
    func testInitializationFromGoodURLs() {
        for goodURL in goodURLs {
            let code = MyCode(url: goodURL)
            
            XCTAssertNotNil(code)
        }
        
        let goodURL = goodURLs.first!
        let code = MyCode(url: goodURL)
        
        XCTAssertEqual(code?.capacity, 20)
        XCTAssertEqual(code?.type, MyCode.CodeType.house)
        XCTAssertEqual(code?.id, UUID(uuidString: "A50BE4E6-AD20-44A5-BF87-8648B5C75637"))
        
        #if canImport(CoreImage)
        XCTAssertNotNil(code?.pngData())
        
        if let data = code?.pngData() {
            let att = XCTAttachment(data: data, uniformTypeIdentifier: kUTTypePNG as String)

            att.name = "Code image data"
            att.lifetime = .keepAlways
            
            add(att)
        }
        
        #if canImport(UIKit)
        XCTAssertNotNil(code?.uiImage)
        
        if let data = code?.uiImage()?.pngData() {
            let att = XCTAttachment(data: data, uniformTypeIdentifier: kUTTypePNG as String)

            att.name = "Code UIImage data"
            att.lifetime = .keepAlways
            
            add(att)
        }
        #endif
        
        #if canImport(AppKit)
        XCTAssertNotNil(code?.nsImage)
        
        if let data = code?.nsImage()?.tiffRepresentation {
            let att = XCTAttachment(data: data, uniformTypeIdentifier: kUTTypeTIFF as String)

            att.name = "Code NSImage data"
            att.lifetime = .keepAlways
            
            add(att)
        }
        #endif
        
        #if (arch(arm64) || arch(x86_64))
        #if canImport(SwiftUI)
        if #available(iOS 13.0, macOS 10.15, watchOS 6.0, tvOS 13.0, *) {
            XCTAssertNotNil(code?.image())
        }
        #endif
        #endif
        
        #endif
    }
    
    func testInitializationFromBadURLs() {
        for badURL in badURLs {
            XCTAssertNil(MyCode(url: badURL))
        }
    }

    static var allTests = [
        ("testInitializationFromGoodURLs", testInitializationFromGoodURLs),
        ("testInitializationFromBadURLs", testInitializationFromBadURLs),
    ]
}
