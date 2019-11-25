//
//  NewsTableViewController.swift
//  NewsFeed
//
//  Created by Artjoms Vorona on 25/11/2019.
//  Copyright © 2019 Artjoms Vorona. All rights reserved.
//

import Gloss
import UIKit

class NewsTableViewController: UITableViewController {
    
    var news = [News]()
    let newApiUrl = "https://newsapi.org/v2/top-headlines?country=lv&apiKey="
    let apiKey = Api.apiKey

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "LV news"
    }
    
    //MARK: IBActions
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        handleGetData()
    }

    
    //MARK: functions
    
    func handleGetData() {
        let jsonUrl = newApiUrl + apiKey
        
        guard let url = URL(string: jsonUrl) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: urlRequest) { (data, urlResponse, taskError) in
            
            if let error = taskError {
                print(error.localizedDescription)
            }
            
            guard let data = data else {
                print("Data error")
                return
            }
            
            do {
                if let dictData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    self.populateData(dictData)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }//end handleGetData
    
    func populateData(_ dict: [String: Any]) {
        guard let responseDict = dict["articles"] as? [Gloss.JSON] else { return }
        
        news = [News].from(jsonArray: responseDict) ?? []
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }

        let item = news[indexPath.row]
        
        if let image = item.image {
            cell.newsImageView.image = image
        }

        cell.newsTitleLabel.text = item.title
        cell.newsTitleLabel.numberOfLines = 0

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailNewsSBID") as? DetailNewsViewController else { return }
        
        let item = news[indexPath.row]
        detailVC.newsTitle = item.title
        detailVC.newsDescription = item.description
        detailVC.url = item.url
        detailVC.urlToImage = item.urlToImage
        detailVC.newsImage = item.image
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

}
