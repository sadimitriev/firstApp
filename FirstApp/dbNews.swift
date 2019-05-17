//
//  dbNews.swift
//  FirstApp
//
//  Created by Sergey Dimitriev on 13/05/2019.
//  Copyright © 2019 Sergey Dimitriev. All rights reserved.
//

import Foundation
import RealmSwift

class Fact: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var favorite: Int = 0
    
    func decode(from dictionary: Dictionary<String, Any>) {
        id = dictionary["_id"]! as! String
        text = dictionary["text"]! as! String
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
