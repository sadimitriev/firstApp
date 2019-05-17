//
//  Source.swift
//  FirstApp
//
//  Created by Sergey Dimitriev on 14/05/2019.
//  Copyright © 2019 Sergey Dimitriev. All rights reserved.
//

import Foundation
import RealmSwift
import CommonCrypto

class Source: Object {
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
        title       = dictionary["title"]! as! String
        //id          =  MD5(title)
        //author      = dictionary["author"]! as! String
        //source    = dictionary["source"]["name"]! as! String
        url         = dictionary["url"]! as! String
        //urlToImage  = dictionary["urlToImage"]! as! String
        publishedAt = dictionary["publishedAt"]! as! String
        //content     = dictionary["content"]! as! String
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
