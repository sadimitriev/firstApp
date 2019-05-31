//
//  SourceCollection.swift
//  FirstApp
//
//  Created by Sergey Dimitriev on 29/05/2019.
//  Copyright © 2019 Sergey Dimitriev. All rights reserved.
//

import UIKit
import RealmSwift

class SourceCollection: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelUrl: UILabel!
    
    var realm: Realm { return try! Realm() }
    var SourceId: String?
    var PostId: String?
    
    lazy var news: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let realSourceId = SourceId else {
            return
        }
        let source = realm.object(ofType: Source.self, forPrimaryKey: realSourceId)
        
        labelName.numberOfLines = 0
        labelName.lineBreakMode = .byWordWrapping
        labelName.text = source?.name
        labelName.sizeToFit()
        
        labelUrl.numberOfLines = 0
        labelUrl.lineBreakMode = .byWordWrapping
        labelUrl.text = source?.url
        labelUrl.sizeToFit()
        
        let news1 = realm.objects(News.self).filter("source == '\(realSourceId)'")

        if news1.count < 1 {
            let alert = UIAlertController(title: "Статей не найдено", message: "Попробуйте другое.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: { action in

                _ = self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        if news1.isEmpty {} else {
            let newsCount: Int = news1.count
            for i in 0 ..< newsCount {
                self.news.append(news1[i])
            }
        }
        
        self.collectionView?.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionViewCell
        
        cell.titleField!.text = news[indexPath.row].title
        cell.contentField!.text = news[indexPath.row].content
        cell.dateField!.text = news[indexPath.row].publishedAt
        
        let url = URL(string: (news[indexPath.row].urlToImage) ?? "")
        if (url != nil) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url!){
                    DispatchQueue.main.async {
                        cell.ImageField.image = UIImage(data: data)
                        cell.ImageField.contentMode = .scaleAspectFit
                    }
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let selectedPost = news[indexPath.row]
        PostId = selectedPost.id
        
        performSegue(withIdentifier: "SourceToPost", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ViewController else {
            return
        }
        vc.postId = PostId
    }
}
