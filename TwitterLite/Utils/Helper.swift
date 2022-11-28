//
//  Helper.swift
//  TwitterLite
//
//  Created by Laura Caroline K on 28/11/22.
//

import Foundation
import UIKit

struct Helper {
    func getLabelHeight(text: String, width: CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byCharWrapping
            label.text = text
            label.sizeToFit()
        
            return label.frame.height
    }
}
