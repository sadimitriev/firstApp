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
    
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailContent: UILabel!
    @IBOutlet weak var detailDate: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailFavorite: UIButton!
    
    var realm: Realm { return try! Realm() }
    var postId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let realPostId = postId else {
            return
        }
        
        let post = realm.object(ofType: News.self, forPrimaryKey: realPostId)
    
        detailTitle.numberOfLines = 0
        detailTitle.lineBreakMode = .byWordWrapping
        detailTitle.text = post?.title
        detailTitle.sizeToFit()
        
        detailDate.text = post?.publishedAt
        
        detailContent.numberOfLines = 0
        detailContent.lineBreakMode = .byWordWrapping
        detailContent.text = post?.content
        detailContent.sizeToFit()
        
        let url = URL(string: post?.urlToImage ?? "")
        if (url != nil) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url!){
                    DispatchQueue.main.async {
                        self.detailImage.image = UIImage(data: data)
                        self.detailImage.contentMode = .scaleAspectFit
                    }
                }
            }
        }
        
        if (post?.favorite == 0) {
            detailFavorite.setBackgroundImage(UIImage(named: "f-blue.png"), for: UIControl.State.normal)
        } else {
            detailFavorite.setBackgroundImage(UIImage(named: "f-gold.png"), for: UIControl.State.normal)
        }
    }
    @IBAction func detailButtonClick(_ sender: Any) {
        
        let singlePost = realm.object(ofType: News.self, forPrimaryKey: postId)
        
        if (singlePost?.favorite == 0) {
            detailFavorite.setBackgroundImage(UIImage(named: "f-gold.png"), for: UIControl.State.normal)
            try! realm.write {singlePost?.favorite = 1}
        } else {
            detailFavorite.setBackgroundImage(UIImage(named: "f-blue.png"), for: UIControl.State.normal)
            try! realm.write {singlePost?.favorite = 0}
        }
    }

}
