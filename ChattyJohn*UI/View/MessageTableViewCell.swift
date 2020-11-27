//
//  MessageTableViewCell.swift
//  ChattyJohn*UI
//
//  Created by Zhaoyang Li on 11/26/20.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    @IBOutlet private weak var chatMessageTextView: UITextView!
    @IBOutlet private weak var thumbImageImageView: UIImageView!
    @IBOutlet private weak var chatMessageHeight: NSLayoutConstraint!
    @IBOutlet private weak var chatMessageWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbImageImageView.layer.cornerRadius = thumbImageImageView.frame.size.width / 2
        thumbImageImageView.layer.borderWidth = 2.0
        thumbImageImageView.layer.borderColor = UIColor.white.cgColor
        
        chatMessageTextView.layer.cornerRadius = 10
    }
    
    func configureCell(message: String) {
        chatMessageTextView.text = message
        
        chatMessageWidth.constant = chatMessageTextView.contentSize.width + 5
        chatMessageHeight.constant = chatMessageTextView.contentSize.height + 15
    }
}
