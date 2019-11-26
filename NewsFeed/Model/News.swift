//
//  News.swift
//  NewsFeed
//
//  Created by Artjoms Vorona on 25/11/2019.
//  Copyright © 2019 Artjoms Vorona. All rights reserved.
//

import Gloss
import UIKit

class News: JSONDecodable {
    var title: String
    var description: String = ""
    var url: String = ""
    var urlToImage: String = ""
    var image: UIImage?

    required init?(json: JSON) {
        self.title = "title" <~~ json ?? ""
        self.description = "description" <~~ json ?? ""
        self.url = "url" <~~ json ?? ""
        self.urlToImage = "urlToImage" <~~ json ?? ""
        DispatchQueue.main.async {
            self.image = self.loadImage()
        }
    }
    
    init(title: String, description: String, url: String, urlToImage: String) {
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
    }
    
    init(title: String, description: String, url: String, image: UIImage?) {
        self.title = title
        self.description = description
        self.url = url
        self.image = image
    }
    
    private func loadImage() -> UIImage? {
        var returnImage: UIImage?
        
        guard let url = URL(string: urlToImage) else {
            return returnImage
        }
        
        if let data = try? Data(contentsOf: url) {
            if let image = UIImage(data: data) {
                returnImage = image
            }
        }
        
        return returnImage
    }
    
}
