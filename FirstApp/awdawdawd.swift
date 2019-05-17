//
//  awdawdawd.swift
//  FirstApp
//
//  Created by Sergey Dimitriev on 15/05/2019.
//  Copyright © 2019 Sergey Dimitriev. All rights reserved.
//

import UIKit

class ViewControllerTable: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    var name : [String] = []
    var discount_text : [String] = []
    var avatar :[UIImage] = []
    var avatar_n :[String] = []
    var img:UIImage = UIImage()
    var id:Int = 0
    var nameAkc = ""
    var akc: [Akc] = []
    var fetchResultController: NSFetchedResultsController!
    var items: [Int] = []
    var refreshControl : UIRefreshControl!
    var count = 0
    @IBOutlet weak var TableView: UITableView!
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Возвращает количество строк
        return items.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "IDCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        //Конфиг ячейки
        cell.textLabel!.text = akc[indexPath.row].name
        cell.detailTextLabel!.text = akc[indexPath.row].discount_text
        var index = indexPath.row
        if avatar.count > index{
            cell.imageView?.image = avatar[indexPath.row]
            TableView.reloadData()
        }
        /*if avatar[indexPath.row] != UIImage() {
         cell.imageView?.image = avatar[indexPath.row]
         }*/
        if indexPath.row == items.count - 1 {
            //appendItems()
        }
        return cell
    }
    func refresh() {
        items = []
        items = newItems()
        TableView.reloadData()
        refreshControl.endRefreshing()
    }
    private func newItems() -> [Int] {
        var items: [Int] = []
        for i in 0..<5{
            var last = 0
            if !self.items.isEmpty {
                last = self.items.last! + 1
                count = count-1
            }
            items.append(i + last)
        }
        return items
    }
    private func appendItems() {
        items += newItems()
        TableView.reloadData()
    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        items = newItems()
//        refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(refresh), forControlEvents: .ValueChanged)
//        TableView.addSubview(refreshControl)
//        let fetchRequest = NSFetchRequest(entityName: "Akc")
//        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        if let managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
//            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
//            fetchResultController.delegate = self
//            do {
//                try fetchResultController.performFetch()
//                akc = fetchResultController.fetchedObjects as! [Akc]
//                self.TableView.reloadData()
//            } catch {
//                print(error)
//            }
//        }
//        print(akc.count)
//        count=akc.count
//    }
    func getImage(av_n:String){
        // taking the URL , then request image data, then assigne UIImage(data: responseData)
        let imgURL: NSURL = NSURL(string: "http://(av_n)&width=40&height=40&type=scale&blur=0")!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {
            (data,response,error) -> Void in
            if ( error == nil && data != nil ) {
                func display_image() {
                    // imageView.post.image = your UIImage
                    //self.imageViewPost.image = UIImage(data: data!)
                    self.img = UIImage(data: data!)!
                    self.avatar.append(UIImage(data: data!)!)
                    self.TableView.reloadData()
                    print(self.avatar.count)
                    print(self.img)
                }
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
        }
        task.resume()
        // end of loading img
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(nameAkc)
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("Akc") as! AkcViewController2
        vc.Vtitle = "Горячие акции"
        vc.Rtitle = akc[indexPath.row].name!
        vc.detail = akc[indexPath.row].discount_text!
        self.presentViewController(vc, animated: true , completion: nil)
    }
    /* func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     nameAkc = name[indexPath.row]
     }*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     var destinationVC: AkcViewController2 = segue.destinationViewController as! AkcViewController2
     let index = TableView.indexPathForSelectedRow
     print("ID \(String(index?.row))")
     // destinationVC.label.text = name[index?.row]
     }*/
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
