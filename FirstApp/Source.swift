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
    @objc dynamic var name: String = ""
    @objc dynamic var detailText: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var favorite: Int = 0
    
    
    func decode(from dictionary: Dictionary<String, Any>) {
        
        id         = dictionary["id"]! as? String
        name       = dictionary["name"]! as! String
        detailText = dictionary["url"]! as! String
        url        = dictionary["url"]! as! String
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
