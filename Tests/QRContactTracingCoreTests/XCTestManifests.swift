import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ArrayChuckedTests.allTests),
        testCase(UUIDDataTests.allTests),
        testCase(CodeTests.allTests),
        testCase(LocalContentTests.allTests),
        testCase(TransportableContentTests.allTests),
    ]
}
#endif
