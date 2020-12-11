//
//  UIViewExt.swift
//  ChattyJohn*UI
//
//  Created by Zhaoyang Li on 11/27/20.
//

import UIKit

extension UIView {
    func setbackGorund() {
        let imageView = UIImageView()
        imageView.frame = CGRect(origin: .zero, size: self.frame.size)
        imageView.image = UIImage(imageLiteralResourceName: "ChuyinFull")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.zPosition = -99
        self.addSubview(imageView)
    }
}
