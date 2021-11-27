//
//  UIImageView.swift
//  TodayNews
//
//  Created by Manish Kumar on 27/11/21.
//  Copyright © 2021 Manish Kumar. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func loadImage(_ imgURL: String?) {
                
        guard let imageURLString: String = imgURL else {
            self.image = UIImage(named: "placeholder")
            return
        }
        if imageURLString == "" {
            self.image = UIImage(named: "placeholder")
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            let data = try? Data(contentsOf: URL(string: imageURLString)!)
            DispatchQueue.main.async {
                self?.image = data != nil ? UIImage(data: data!) : UIImage(named: "placeholder")
            }
        }
    }
}
