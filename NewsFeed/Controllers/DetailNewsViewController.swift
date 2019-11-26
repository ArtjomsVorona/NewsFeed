//
//  DetailNewsViewController.swift
//  NewsFeed
//
//  Created by Artjoms Vorona on 25/11/2019.
//  Copyright © 2019 Artjoms Vorona. All rights reserved.
//

import CoreData
import UIKit

class DetailNewsViewController: UIViewController {
    
    var savedItems = [Items]()
    var context: NSManagedObjectContext?
    
    var newsTitle: String = ""
    var newsDescription: String = ""
    var url: String = ""
    var newsImage: UIImage?
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    //MARK: IBActions
    @IBAction func savedButtonTapped(_ sender: UIButton) {
        let newItem = Items(context: self.context!)
        newItem.newsTitle = newsTitle
        newItem.newsDescription = newsDescription
        newItem.url = url
        let imageData: Data = (newsImage?.pngData())!
        newItem.image = imageData
        
        self.savedItems.append(newItem)
        self.saveData()
    }
    
    //MARK: Core Data method
    func saveData() {
        do {
            try context?.save()
        } catch {
            basicAlert(title: "Error!", message: error.localizedDescription)
        }
    }
    
    func updateView() {
        newsTitleLabel.text = newsTitle
        newsDescriptionLabel.text = newsDescription
        newsImageView.image = newsImage
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let webViewVC = segue.destination as? WebViewViewController else { return }
        
        webViewVC.newsUrl = url 
    }

}
