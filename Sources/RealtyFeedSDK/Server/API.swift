//
//  FeedAPI.swift
//  Realtyna Platinum
//
//  Created by Kirk on 11/24/22.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension RealtyFeedSDK {
    public class API: IRFServer {
        public static let instance = API()
        
        fileprivate func post(_ route: String, parameters : [String:Any], receiver : @escaping ServerResponse) {
            Do(route, parameters: parameters, method: "post", receiver: receiver)
        }
        fileprivate func get(_ route: String, receiver : @escaping ServerResponse) {
            Do(route, parameters: nil, method: "get", receiver: receiver)
        }
        
        fileprivate func Do(_ route:String, parameters : [String:Any]?, method: String = "post", receiver : @escaping ServerResponse) {
            
            let semaphore = DispatchSemaphore (value: 0)
            
            let url:String = "https://mls-router1.p.rapidapi.com/\(route)"
            
            var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
            request.httpMethod = method.uppercased()
            request.setValue(RealtyFeedSDK.xApiKey, forHTTPHeaderField: "x-api-key")
            request.setValue("e0cfca0c1emsh097a7f39a0125a0p1ba642jsn93d74b6170c8", forHTTPHeaderField: "X-RapidAPI-Key")
            request.setValue("mls-router1.p.rapidapi.com", forHTTPHeaderField: "-RapidAPI-Host")
            
            if let params = parameters
                , params.count > 0
                , let jsonData = try? JSONSerialization.data(withJSONObject: params) {
                request.httpBody = jsonData
            }

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    receiver(nil, error)
                    semaphore.signal()
                    return
                }
                receiver(data, nil)
                semaphore.signal()
            }
            
            task.resume()
            semaphore.wait()
        }
        
        public func getListings(top: Int = 200,
                         select: String = "Latitude,Longitude,ListingId,ListPrice,ListingKey",
                         filter: [String:Any] = [:],
                         skip: String? = nil,
                         orderby: String? = nil,
                         receiver: @escaping (Data?, Error?) -> Void) {
            
            //Creating orderby parameter
            var orderByParam = ""
            if let orderByString = orderby{
                orderByParam = "&orderby=\(orderByString)"
            }
            
            //Creating skip parameter
            var skipParam = ""
            if let skipString = skip{
                skipParam = "&skip=\(skipString)"
            }
            
            //Creating filter parameters
            var filterParam = ""
            if filter.count > 0 {
                filter.forEach { obj in
                    filterParam.append("\(obj.key) \(obj.value),".replacingOccurrences(of: " ", with: "%20"))
                }
            }
            
            //Creating regoin coordinates parameter
            if filter.contains(where: { (key: String, value: Any) in
                key == "max_latitude"
            }) {
                let maxLt = filter["max_latitude"] as! String
                let maxLn = filter["max_longitude"] as! String
                let minLt = filter["min_latitude"] as! String
                let minLN = filter["min_longitude"] as! String
                let geo = "geo.intersects(Coordinates, POLYGON((\(minLN) \(minLt),\(minLN) \(maxLt),\(maxLn) \(maxLt),\(maxLn) \(minLt),\(minLN) \(minLt))))"
                filterParam.append(geo.replacingOccurrences(of: " ", with: "%20"))
            }
            
            if !filterParam.isEmpty {
                filterParam = "&filter=\(filterParam)"
            }
            
            //Creating selectable fields parameter
            let selectParam = "&select=\(select)"
            
            get("reso-api/property?top=\(top)\(skipParam)\(selectParam)\(filterParam)\(orderByParam)") { result, error in
                print("reso-api/property?top")
                guard let res = result, error == nil else {
                    DispatchQueue.main.async {
                        receiver(nil, error)
                    }
                    return
                }
                DispatchQueue.main.async {
                    receiver(res, nil)
                }
            }
        }
        
        public func getPreview(_ listingId: String, receiver: @escaping (Data?, Error?) -> Void) {
            getListings(top: 1,
                        select: "ListingId,Latitude,Longitude,ListPrice,ListingKey,BuildingAreaTotal,PropertyType,PropertySubType,Media,ListAgentCellPhone,ListAgentEmail,ListOfficeName,ListAgentFirstName,ListAgentMiddleName,ListAgentLastName,BuildingName,StreetName,UnitNumber,City,StateOrProvince,PostalCode,Country",
                        filter: ["ListingId" : "eqv \(listingId)"]) { result, error in
                guard let res = result, error == nil else {
                    DispatchQueue.main.async {
                        receiver(nil, error)
                    }
                    return
                }
                DispatchQueue.main.async {
                    receiver(res, nil)
                }

            }
  
            /// **or use bottom method**

//            get("reso-api/property/\(propertyId)") { result, error in
//                guard let res = result, error == nil else {
//                    receiver(nil, error)
//                    return
//                }
//                receiver(res, nil)
//            }
            
        }
                
        public func getProperty(_ listingId: String, receiver: @escaping (Data?, Error?) -> Void) {//RProperty
            get("reso-api/property/\(listingId)") { result, error in
                guard let res = result, error == nil else {
                    DispatchQueue.main.async {
                        receiver(nil, error)
                    }
                    return
                }
                DispatchQueue.main.async {
                    receiver(res, nil)
                }
            }
        }
    }
}
