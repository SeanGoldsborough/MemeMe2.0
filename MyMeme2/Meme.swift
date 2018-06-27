//
//  Meme.swift
//  MemeMe1.0Attempt1
//
//  Created by Sean Goldsborough on 8/16/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
    
    init(_ topText: String, _ bottomText: String, _ originalImage: UIImage, _ memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
    
    
    
}
