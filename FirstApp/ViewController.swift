//
//  ViewController.swift
//  FirstApp
//
//  Created by Sergey Dimitriev on 13/05/2019.
//  Copyright © 2019 Sergey Dimitriev. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var detailLabel: UILabel!
    
    var realm: Realm { return try! Realm() }
    var postId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let realPostId = postId else {
            return
        }
        
        let post = realm.object(ofType: News.self, forPrimaryKey: realPostId)
        detailLabel.text = post?.title
        
        //if (fact?.favorite == 0) {
            //button.setTitle("Добавить в избранное", for: .normal)
        //} else {
            //button.setTitle("Удалить из избранного", for: .normal)
        //}
    }


}

