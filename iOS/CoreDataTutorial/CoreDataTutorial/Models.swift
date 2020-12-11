//
//  Models.swift
//  CoreDataTutorial
//
//  Created by Ravi Vooda on 11/19/20.
//  Copyright © 2020 Ravi Vooda. All rights reserved.
//

import Foundation
import UIKit

class Item {
    let text:String
    let image:UIImage
    
    init(text:String, image:UIImage) {
        self.text = text
        self.image = image
    }
}
