//
//  SourseTableViewController.swift
//  FirstApp
//
//  Created by Sergey Dimitriev on 28/05/2019.
//  Copyright © 2019 Sergey Dimitriev. All rights reserved.
//

import UIKit
import RealmSwift

class SourceTableViewController: UITableViewController {
    
    var realm: Realm { return try! Realm() }
    var selectedSourceId: String?
    
    lazy var news: Results<Source> = realm.objects(Source.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string:"https://newsapi.org/v2/sources?apiKey=022b8292fe494a14b9aea96682f12bec")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: handleResponse)
        task.resume()
    }
    
    func handleResponse(data: Data?, response: URLResponse?, error: Error?) {
        do {
            let values = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, Any>
            if values["status"] as! String == "ok" {
                let jsonNews = values["sources"] as! Array<Any>
                let newPosts = mapNews(jsonNews: jsonNews)
                
                DispatchQueue.main.async {
                    self.addToRealm(news: newPosts)
                    self.tableView.reloadData()
                }
            }
        } catch { print("Что-то пошло не так") }
    }
    
    func mapNews(jsonNews: Array<Any>) -> [Source] {
        var newPosts = Array<Source>()
        
        let firstPullPosts = jsonNews//.prefix(20)
        for jsonPost in firstPullPosts {
            let post = Source()
            post.decode(from: jsonPost as! Dictionary<String, Any>)
            
            let test = realm.object(ofType: Source.self, forPrimaryKey: post.id)
            
            post.favorite = test?.favorite as Int? ?? 0
            newPosts.append(post)
        }
        return newPosts
    }
    
    func addToRealm(news: [Source]) {
        do {
            try realm.write {
                realm.add(news, update: true)
            }
        } catch { print(error) }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? SourceCollection else {
            return
        }
        vc.SourceId = selectedSourceId
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SourceCell", for: indexPath) as! SourceTableViewCell

        cell.cellTitle!.text = news[indexPath.row].name
        cell.cellDetail!.text = news[indexPath.row].detailText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = news[indexPath.row]
        selectedSourceId = selectedPost.id
        
        performSegue(withIdentifier: "GoToSourceController", sender: self)
    }    
}
