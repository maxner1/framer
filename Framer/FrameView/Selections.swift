//
//  Selections.swift
//  Framer
//
//  Created by Elise Miller on 4/11/21.
//

import Foundation
import UIKit

class Selections {
    var list: [Selection] = []
}

struct Selection {
    var photo: UIImage?
    var photoW: CGFloat?
    var photoH: CGFloat?
    var frameIndex: Int?
    var frameW: CGFloat?
    var framH: CGFloat?
    static let nFields = 6
    
}
