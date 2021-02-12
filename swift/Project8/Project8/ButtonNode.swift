//
//  ButtonNode.swift
//  Project8
//
//  Created by Jinwoo Kim on 2/12/21.
//

import SpriteKit

class ButtonNode: SKSpriteNode {
    var focusedImage: SKTexture!
    var unfocusedImage: SKTexture!
    
    override var canBecomeFocused: Bool {
        return true
    }
    
    func setFocusedImage(named name: String) {
        focusedImage = SKTexture(imageNamed: name)
        unfocusedImage = self.texture!
        isUserInteractionEnabled = true
    }
    
    func didGainFocus() {
        texture = focusedImage
    }
    
    func didLoseFocus() {
        texture = unfocusedImage
    }
}
