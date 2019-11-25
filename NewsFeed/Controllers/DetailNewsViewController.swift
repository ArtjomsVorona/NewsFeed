//
//  DetailNewsViewController.swift
//  NewsFeed
//
//  Created by Artjoms Vorona on 25/11/2019.
//  Copyright © 2019 Artjoms Vorona. All rights reserved.
//

import UIKit

class DetailNewsViewController: UIViewController {
    
    var newsTitle: String = ""
    var newsDescription: String = ""
    var sourceName: String = ""
    var url: String = ""
    var urlToImage: String = ""
    var newsImage: UIImage?
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    @IBAction func readFullArticleTapped(_ sender: UIButton) {
        print(url)
    }
    
    func updateView() {
        newsTitleLabel.text = newsTitle
        newsDescriptionLabel.text = newsDescription
        newsImageView.image = newsImage
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let webViewVC = segue.destination as? WebViewViewController else { return }
        
        webViewVC.newsUrl = url 
    }

}
