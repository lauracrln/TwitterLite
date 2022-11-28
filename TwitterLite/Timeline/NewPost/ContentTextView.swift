//
//  ContentTextView.swift
//  TwitterLite
//
//  Created by Laura Caroline K on 27/11/22.
//

import Foundation
import UIKit

class ContentTextView: UITextView {
    
    let placeHolderLabel: UILabel = {
        let placeHolder = UILabel()
        placeHolder.backgroundColor = .white
        placeHolder.text = "What's happening?"
        placeHolder.font = UIFont.systemFont(ofSize: 16)
        placeHolder.textColor = .gray
        return placeHolder
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        backgroundColor = .white
        textColor = .black
        addSubview(placeHolderLabel)
        placeHolderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        placeHolderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
        placeHolderLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        placeHolderLabel.widthAnchor.constraint(equalToConstant: 18).isActive = true
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        isEditable = true
        isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleTextInputChange() {
        placeHolderLabel.isHidden = !text.isEmpty
    }
}
