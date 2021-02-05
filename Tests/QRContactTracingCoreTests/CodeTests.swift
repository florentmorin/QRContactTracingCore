import XCTest

final class CodeTests: XCTestCase {
    
    let goodURLs = [
        URL(string: "https://qrcode.tousanticovid.gouv.fr/A50BE4E6-AD20-44A5-BF87-8648B5C75637?type=house&capacity=20")!,
        URL(string: "https://qrcode.tousanticovid.gouv.fr/A50BE4E6-AD20-44A5-BF87-8648B5C75637?capacity=20")!,
        URL(string: "https://qrcode.tousanticovid.gouv.fr/A50BE4E6-AD20-44A5-BF87-8648B5C75637?type=house")!,
        URL(string: "https://qrcode.tousanticovid.gouv.fr/A50BE4E6-AD20-44A5-BF87-8648B5C75637")!
    ]
    
    let badURLs = [
        URL(string: "https://qrcode.tousanticovid.gouv.fr/A50BE4E6-AD20-445-BF87-8648B5C756370")!,
        URL(string: "https://qrcode.tousanticoid.gouv.fr/A50BE4E6-AD20-44A5-BF87-8648B5C75637")!,
        URL(string: "http://qrcode.tousanticovid.gouv.fr/A50BE4E6-AD20-44A5-BF87-8648B5C75637")!,
        URL(string: "https://qrcode.tousanticovid.gouv.fr/A50BE4E6-AD20-44A5-BF87-8648B5C75637/d")!
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
