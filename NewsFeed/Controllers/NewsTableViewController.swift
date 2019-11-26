//
//  NewsTableViewController.swift
//  NewsFeed
//
//  Created by Artjoms Vorona on 25/11/2019.
//  Copyright © 2019 Artjoms Vorona. All rights reserved.
//

import Gloss
import UIKit

class NewsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var news = [News]()
    
    let newsApiUrl = Api.url
    let apiKey = Api.apiKey
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var newsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "LV headlines"
        activityIndicatorView.isHidden = true
        activityIndicatorView.style = .large
    }
    
    //MARK: IBActions
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        handleGetData()
    }
    
    //MARK: functions
    func handleGetData() {
        activityIndicator(animate: true)
        
        let jsonUrl = newsApiUrl + apiKey
        
        guard let url = URL(string: jsonUrl) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: urlRequest) { (data, urlResponse, taskError) in
            
            if let error = taskError {
                print(error.localizedDescription)
                self.basicAlert(title: "Error!", message: error.localizedDescription)
                self.activityIndicator(animate: false)
            }
            
            guard let data = data else {
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

        self.activityIndicator(animate: false)
    }
    
    func activityIndicator(animate: Bool) {
        DispatchQueue.main.async {
            if animate {
                self.newsTableView.isHidden = true
                self.activityIndicatorView.isHidden = false
                self.activityIndicatorView.startAnimating()
            } else {
                self.newsTableView.isHidden = false
                self.activityIndicatorView.isHidden = true
                self.activityIndicatorView.stopAnimating()
            }
            self.updateTableView()
        }
    }
    
    func updateTableView() {
        newsTableView.reloadData()
        if news.count > 0 {
            newsTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        }
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }

        let item = news[indexPath.row]
        
        if let image = item.image {
            cell.newsImageView.image = image
        }

        cell.newsTitleLabel.text = item.title
        cell.newsTitleLabel.numberOfLines = 0

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailNewsSBID") as? DetailNewsViewController else { return }
        
        let item = news[indexPath.row]
        detailVC.newsTitle = item.title
        detailVC.newsDescription = item.description
        detailVC.url = item.url
        detailVC.newsImage = item.image
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

}//end class
