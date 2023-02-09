
import Foundation

public struct RealtyFeedSDK {
    internal static var xApiKey: String = ""
    internal static var rapidApiKey: String = ""
    
    public static func initial(_ apiKey: String, _ rapidApiKey: String) {
        RealtyFeedSDK.xApiKey = apiKey
        RealtyFeedSDK.rapidApiKey = rapidApiKey
    }
}
