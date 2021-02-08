//
//  ViewController.swift
//  Project3
//
//  Created by Jinwoo Kim on 2/7/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldTip: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    var focusGuide: UIFocusGuide!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        focusGuide = UIFocusGuide()
        view.addLayoutGuide(focusGuide)
        
        focusGuide.topAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
        focusGuide.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        focusGuide.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        /*
         nextButton이 Focus인 상태에서 눌러서 showAlert(_:)가 실행되고 다시 돌아올 경우, 아래 값이 true이면 nextButton으로 Focus를 다시 둔다.
         하지만 false이면 Focus를 다시 기본값 (preferredFocusEnvironments)으로 리셋시킨다.
         */
        restoresFocusAfterTransition = false
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        
        // if the user is moving towards the text field
        if context.nextFocusedView == textField {
            // tell the focus guide to redirect to the next button
            focusGuide.preferredFocusEnvironments = [nextButton]
        } else if context.nextFocusedView == nextButton {
            // otherwise tell the focus guide to redirect to the text field
            focusGuide.preferredFocusEnvironments = [textField]
        }
        
        if context.nextFocusedView == textField {
            // we're moving to the text field - animate in the tip label
            coordinator.addCoordinatedAnimations({
                self.textFieldTip.alpha = 1
            })
        } else if context.previouslyFocusedView == textField {
            // we're moving away from the text field - animate out the tip label
            coordinator.addCoordinatedAnimations({
                self.textFieldTip.alpha = 0
            })
        }
    }
    
    // Default Focus View
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [textField]
    }
    
    @IBAction func showAlert(_ sender: UIButton) {
        let ac = UIAlertController(title: "Hello", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
}

