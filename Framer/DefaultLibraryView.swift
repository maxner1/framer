//
//  DefaultLibraryView.swift
//  Framer
//
//  Created by Anthony Ng on 3/11/21.
//

import Foundation
import UIKit

class DefaultLibraryView: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    //var images = [UIImage]()
    
    
    override func viewDidLoad() {
        /*
        images = [#imageLiteral(resourceName: "keyboard")]
        
        for i in 0..<images.count {
            let imageView = UIImageView()
            let x = self.view.frame.size.width * CGFloat(i)
            imageView.frame = CGRect(x: x, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            imageView.contentMode = .scaleAspectFit
            imageView.image = images[i]
                    
            scrollView.contentSize.width = scrollView.frame.size.width * CGFloat(i + 1)
            scrollView.addSubview(imageView)
        }
        */
        super.viewDidLoad()
    }
}
