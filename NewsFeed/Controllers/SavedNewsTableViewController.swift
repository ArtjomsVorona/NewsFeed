//
//  SavedNewsTableViewController.swift
//  NewsFeed
//
//  Created by Artjoms Vorona on 26/11/2019.
//  Copyright © 2019 Artjoms Vorona. All rights reserved.
//

import CoreData
import UIKit

class SavedNewsTableViewController: UITableViewController {
    
    var savedItems = [Items]()
    var context: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext

        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    //MARK: Core Data methods
    func loadData() {
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        
        do {
            savedItems = try (context?.fetch(request))!
        } catch  {
            basicAlert(title: "Error!", message: error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func saveData() {
        do {
            try context?.save()
        } catch  {
            basicAlert(title: "Error!", message: error.localizedDescription)
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedNewsCell", for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }

        let item = savedItems[indexPath.row]
        
        if let image = UIImage(data: item.image!) {
            cell.newsImageView.image = image
        }

        cell.newsTitleLabel.text = item.newsTitle
        cell.newsTitleLabel.numberOfLines = 0

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = self.savedItems[indexPath.row]
            self.savedItems.remove(at: indexPath.row)
            self.context?.delete(item)
            self.saveData()
        }
    }
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let webViewVC = storyboard.instantiateViewController(withIdentifier: "WebViewSBID") as? WebViewViewController else { return }
        
        webViewVC.newsUrl = savedItems[indexPath.row].url!
        present(webViewVC, animated: true, completion: nil)
    }
   

}//end class
