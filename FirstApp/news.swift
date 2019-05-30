//
//  news.swift
//  FirstApp
//
//  Created by Sergey Dimitriev on 13/05/2019.
//  Copyright © 2019 Sergey Dimitriev. All rights reserved.
//


import Foundation
import RealmSwift
import CommonCrypto

class News: Object {

    @objc dynamic var id: String? = ""
    @objc dynamic var author: String = ""
    @objc dynamic var source: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var urlToImage: String = ""
    @objc dynamic var publishedAt: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var favorite: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    func decode(from dictionary: Dictionary<String, Any>) {
        
        
        if (dictionary["title"] == nil) {
            return
        }
        
        let dateAsString = dictionary["publishedAt"] as! String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateAsString)!
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        publishedAt = dateFormatter.string(from: date)
        title       = dictionary["title"]! as! String
        id          = MD5(title+dateAsString)
        //author      = dictionary["author"]! as? String ?? ""
        //url         = dictionary["url"]! as? String ?? ""
        urlToImage  = dictionary["urlToImage"] as? String ?? ""
        content     = dictionary["content"] as? String ?? ""
        
        let test = convertAnyObjectToJSONString(from: dictionary["source"])
        let dict = test?.toJSON() as? [String:AnyObject]
        source = dict?["id"] as? String ?? ""
    }
    
    func convertAnyObjectToJSONString(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func MD5(_ string: String) -> String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        
        if let d = string.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }
        
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }

}
extension String {
    func toJSON() -> Any? {
        guard
            let data = self.data(using: .utf8, allowLossyConversion: false)
        else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
