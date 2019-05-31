//
//  FavoriteTableViewController.swift
//  FirstApp
//
//  Created by Sergey Dimitriev on 19/05/2019.
//  Copyright © 2019 Sergey Dimitriev. All rights reserved.
//


import UIKit
import RealmSwift

class FavorireTableViewController: UITableViewController {
    
    var realm: Realm { return try! Realm() }
    var selectedPostId: String?
    lazy var news: Results<News> = realm.objects(News.self).sorted(byKeyPath: "publishedAt", ascending: false).filter("favorite == 1")

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        news = realm.objects(News.self).sorted(byKeyPath: "publishedAt", ascending: false).filter("favorite == 1")
        self.tableView.reloadData()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! TableTableViewCell

        cell.cellTitle!.text = news[indexPath.row].title
        cell.celldate!.text = news[indexPath.row].publishedAt
        
        let url = URL(string: (news[indexPath.row].urlToImage) ?? "")
        if (url != nil) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url!){
                    DispatchQueue.main.async {
                        cell.cellImage.image = UIImage(data: data)
                        cell.cellImage.contentMode = .scaleAspectFit
                    }
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = news[indexPath.row]
        selectedPostId = selectedPost.id
        
        performSegue(withIdentifier: "GoToFavoriteViewController", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ViewController else {
            return
        }
        vc.postId = selectedPostId
    }
}
