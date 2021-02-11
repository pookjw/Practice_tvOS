//
//  CardCell.swift
//  Project5
//
//  Created by Jinwoo Kim on 2/10/21.
//

import UIKit

class CardCell: UICollectionViewCell {
    @IBOutlet var card: UIImageView!
    @IBOutlet var contents: UIImageView!
    @IBOutlet var textLabel: UILabel!
    
    var word = "?"
    
    func flip(to image: String, hideContents: Bool) {
        UIView.transition(with: self, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            self.card.image = UIImage(named: image)
            self.contents.isHidden = hideContents
            self.textLabel.isHidden = hideContents
        })
    }
}
