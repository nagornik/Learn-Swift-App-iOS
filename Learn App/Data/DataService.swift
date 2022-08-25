//
//  DataService.swift
//  Learn App
//
//  Created by Anton Nagornyi on 19.08.2022.
//

import Foundation
import SwiftUI

class DataService {
    
    // MARK: - Cache images
    
    static var imageCache = [String : Image]()
    
    static func getImage(forKey: String) -> Image? {
        return imageCache[forKey]
    }
    
    static func setImage(image: Image, forKey: String) {
        imageCache[forKey] = image
    }
    
}
