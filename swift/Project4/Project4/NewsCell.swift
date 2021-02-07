//
//  NewsCell.swift
//  Project4
//
//  Created by Jinwoo Kim on 2/8/21.
//

import UIKit

class NewsCell: UICollectionViewCell {
    @IBOutlet weak var imageView: RemoteImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    /*
     weak로 붙잡고 있을 경우, isActive가 false가 되었을 때 removeConstraint(_:)가 불린다. 따라서 reference count가 줄어 들어서, release가 되어 버린다.
     https://developer.apple.com/documentation/uikit/nslayoutconstraint/1527000-isactive
     */
    @IBOutlet var unfocusedConstraint: NSLayoutConstraint!
    var focusedConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        focusedConstraint = textLabel.topAnchor.constraint(equalTo: imageView.focusedFrameGuide.bottomAnchor, constant: 15)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        focusedConstraint.isActive = isFocused
        unfocusedConstraint.isActive = !isFocused
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        setNeedsUpdateConstraints()
        
        coordinator.addCoordinatedAnimations({
            self.layoutIfNeeded()
        })
    }
}
