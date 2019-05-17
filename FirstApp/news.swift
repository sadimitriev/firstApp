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
import RealmSwift

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
    
    func decode(from dictionary: Dictionary<String, Any>) {
        if (dictionary["title"] == nil) {
            return
        }
        
        title       = dictionary["title"]! as! String
        publishedAt = dictionary["publishedAt"]! as! String
        id          =  MD5(title+publishedAt)
        //author      = dictionary["author"]! as! String
        //source    = dictionary["source"]["name"]! as! String
        //url         = dictionary["url"]! as! String
        //urlToImage  = dictionary["urlToImage"]! as! String
        //content     = dictionary["content"]! as! String
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
