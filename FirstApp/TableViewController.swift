//
//  TableViewController.swift
//  FirstApp
//
//  Created by Sergey Dimitriev on 13/05/2019.
//  Copyright © 2019 Sergey Dimitriev. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewController: UITableViewController {
    
    var realm: Realm { return try! Realm() }
    var selectedPostId: String?
    var pageId: Int = 1
    var limit: Int = 20
    
    lazy var news: Results<News> = realm.objects(News.self).sorted(byKeyPath: "publishedAt", ascending: false)
    //lazy var news: [News] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //limitNews(allNews: self.results)
        
//        let url = URL(string:"https://newsapi.org/v2/everything?q=bitcoin&apiKey=022b8292fe494a14b9aea96682f12bec&sortBy=publishedAt")!//&to=2019-05-15
//
//        let task = URLSession.shared.dataTask(with: url, completionHandler: handleResponse)
//        task.resume()
        var postUrl = URL(string: "https://newsapi.org/v2/everything?q=bitcoin&apiKey=022b8292fe494a14b9aea96682f12bec&sortBy=publishedAt")!
        
        var request = URLRequest(url: postUrl)
        request.httpMethod = "GET"
        request.httpBody = Data()
        request.addValue("contentType", forHTTPHeaderField: "Application/JSON")
        
        let newTask = URLSession.shared.dataTask(with: postUrl) { [weak self] data, response, error in
            if error == nil {
                do {
                    let values = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, Any>
                    
                    if values["status"] as! String == "ok" {
                        let jsonNews = values["articles"] as! Array<Any>
                        let newPosts = self?.mapNews(jsonNews: jsonNews)
                        
                        DispatchQueue.main.async {
                            self?.addToRealm(news: newPosts!)
                            self?.tableView.reloadData()
                        }
                    }
                } catch {
                    print(error)
                }
            } else {
                print(error)
            }
        }
        newTask.resume()
        
        
        let instance: String?
    }
    
    func handleResponse(data: Data?, response: URLResponse?, error: Error?) {
        do {
            let values = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, Any>
            
            if values["status"] as! String == "ok" {
                let jsonNews = values["articles"] as! Array<Any>
                let newPosts = mapNews(jsonNews: jsonNews)
                
                DispatchQueue.main.async {
                    self.addToRealm(news: newPosts)
                    self.tableView.reloadData()
                }
            }
        } catch { print("Что-то пошло не так") }
    }
    
    func limitNews(allNews: Results<News>) {
        if allNews.isEmpty {} else {
            let newsCount: Int = allNews.count
            if newsCount < limit {
                limit = newsCount
            }
            
//            for i in 0 ..< limit {
//                //self.news.append(allNews[i])
//            }
        }
    }
    
    func mapNews(jsonNews: Array<Any>) -> [News] {
        var newPosts = Array<News>()
        
        let firstPullPosts = jsonNews//.prefix(20)
        for jsonPost in firstPullPosts {
            let post = News()
            post.decode(from: jsonPost as! Dictionary<String, Any>)
            
            let test = realm.object(ofType: News.self, forPrimaryKey: post.id)
            
            post.favorite = test?.favorite as Int? ?? 0            
            newPosts.append(post)
        }
        return newPosts
    }
    
    func addToRealm(news: [News]) {
        do {
            try realm.write {
                realm.add(news, update: true)
            }
        } catch { print(error) }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ViewController else {
            return
        }
        vc.postId = selectedPostId
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! TableTableViewCell
        
        if news.count == indexPath.row+1 {
            self.fetchNews(ofIndex: indexPath.row)
        }
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
        
        performSegue(withIdentifier: "GoToViewController", sender: self)
    }
    
    func fetchNews(ofIndex index: Int) {
        
        self.pageId += 1
        
        let postUrl = URL(string:"https://newsapi.org/v2/everything?q=bitcoin&apiKey=022b8292fe494a14b9aea96682f12bec&sortBy=publishedAt&page=\(self.pageId)")!
        
        var request = URLRequest(url: postUrl)
        request.httpMethod = "GET"
        request.httpBody = Data()
        request.addValue("contentType", forHTTPHeaderField: "Application/JSON")
        
        let newTask = URLSession.shared.dataTask(with: postUrl) { [weak self] data, response, error in
            if error == nil {
                do {
                    let values = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, Any>
                    
                    if values["status"] as! String == "ok" {
                        let jsonNews = values["articles"] as! Array<Any>
                        let newPosts = self?.mapNews(jsonNews: jsonNews)
                        
                        DispatchQueue.main.async {
                            self?.addToRealm(news: newPosts!)
                            self?.tableView.reloadData()
                        }
                    }
                } catch {
                    print(error)
                }
            } else {
                print(error)
            }
        }
        newTask.resume()
    }
}
extension URLSession {
    func synchronousDataTask(with url: URL) -> (Data?, URLResponse?, Error?) {
        var data: Data?
        var response: URLResponse?
        var error: Error?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataTask = self.dataTask(with: url) {
            data = $0
            response = $1
            error = $2
            
            semaphore.signal()
        }
        dataTask.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        return (data, response, error)
    }
}
