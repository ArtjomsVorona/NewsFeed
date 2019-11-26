//
//  SavedNewsTableViewController.swift
//  NewsFeed
//
//  Created by Artjoms Vorona on 26/11/2019.
//  Copyright © 2019 Artjoms Vorona. All rights reserved.
//

import UIKit

class SavedNewsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SavedNews.news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedNewsCell", for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }

        let item = SavedNews.news[indexPath.row]
        
        if let image = item.image {
            cell.newsImageView.image = image
        }

        cell.newsTitleLabel.text = item.title
        cell.newsTitleLabel.numberOfLines = 0

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            SavedNews.news.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let webViewVC = storyboard.instantiateViewController(withIdentifier: "WebViewSBID") as? WebViewViewController else { return }
        
        webViewVC.newsUrl = SavedNews.news[indexPath.row].url
        present(webViewVC, animated: true, completion: nil)
    }
   

}//end class
