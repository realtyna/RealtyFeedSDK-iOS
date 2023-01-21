
import Foundation

public struct RealtyFeedSDK {
    internal static var xApiKey: String = ""
    
    public static func initial(_ apiKey: String) {
        RealtyFeedSDK.xApiKey = apiKey
    }
}
