import XCTest
@testable import RealtyFeedSDK

final class RealtyFeedSDKTests: XCTestCase {
    
    func testPreview() throws{
        RealtyFeedSDK.initial("YOUR-API-KEY")
        RealtyFeedSDK.API.instance.getPreview("P_5dba1fb94aa4055b9f29691f", receiver: { data, error in
            if let data = data, let res = String(data: data, encoding: String.Encoding.utf8) {
                XCTAssertTrue(res.count > 0, "data is not nil")
                print(res)
                return
            }

            XCTFail("request faild!")
        })
    }

    func testListings() throws {
        RealtyFeedSDK.initial("YOUR-API-KEY")
        RealtyFeedSDK.API.instance.getListings(receiver: { data, error in
            if let data = data, let res = String(data: data, encoding: String.Encoding.utf8) {
                XCTAssertTrue(res.count > 0, "data is not nil")
                print(res)
                return
            }
           
            XCTFail("request faild!")
        })
    }
}
