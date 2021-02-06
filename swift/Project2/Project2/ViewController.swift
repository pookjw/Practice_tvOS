//
//  ViewController.swift
//  Project2
//
//  Created by Jinwoo Kim on 2/7/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var result: UIImageView!
    
    var activeCells = [IndexPath]()
    var flashSequence = [IndexPath]()
    var levelCounter = 0
    let levels = [
        [6, 7, 8], // 3 lights
        [1, 3, 11, 13], // 4
        [5, 6, 7, 8, 9], // 5
        [0, 4, 5, 9, 10, 14], // 6
        [1, 2, 3, 7, 11, 12, 13], // 7
        [0, 2, 4, 5, 9, 10, 12, 14], // 8
        [1, 2, 3, 6, 7, 8, 11, 12, 13], // 9
        [0, 1, 2, 3, 4, 10, 11, 12, 13, 14], // 10
        [1, 2, 3, 5, 6, 7, 8, 9, 11, 12, 13], // 11
        [0, 1, 3, 4, 5, 6, 8, 9, 10, 11, 13, 14], // 12
        [0, 1, 2, 3, 4, 6, 7, 8, 10, 11, 12, 13, 14], // 13
        [0, 1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14], // 14
        [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], // 15
    ]
    var flashSpeed = 0.25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func createLevel() {
        // 1
        guard levelCounter < levels.count else { return }
        result.alpha = 0
        
        /*
         현재 선택된 cell(item = 0)이 hidden 처리가 될 경우 리모컨을 통한 이동이 불가능해진다. 따라서 아래와 같은 코드를 실행해주면 된다.
         setNeedsFocusUpdate()
         */
        collectionView.visibleCells.forEach { $0.isHidden = true }
        activeCells.removeAll()
        
        // 2
        for item in levels[levelCounter] {
            let indexPath = IndexPath(item: item, section: 0)
            activeCells.append(indexPath)
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.isHidden = false
        }
        
        // 3
        activeCells.shuffle()
        flashSequence = Array(activeCells.dropFirst())
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.flashLight()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createLevel()
    }
    
    func flashLight() {
        // try to remove an item from the flash sequence
        if let indexPath = flashSequence.popLast() {
            // pull out the light at that position
            guard let cell = collectionView.cellForItem(at: indexPath) else { return }
            
            // find its image
            guard let imageView = cell.contentView.subviews.first as? UIImageView else { return }
            
            // give it a green light
            imageView.image = UIImage(named: "greenLight")
            
            // make it slightly smaller
            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            
            // start our animation
            UIView.animate(withDuration: flashSpeed, animations: {
                // make it return to normal size
                cell.transform = .identity
            }) { _ in
                // once the animation finishes make the light red again
                imageView.image = UIImage(named: "redLight")
                
                // wait a tiny amount of time
                DispatchQueue.main.asyncAfter(deadline: .now() + self.flashSpeed) {
                    // call ourselves again
                    self.flashLight()
                }
            }
        } else {
            // player need to guess
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.view.isUserInteractionEnabled = true
                self.setNeedsFocusUpdate()
            }
        }
    }
    
    func gameOver() {
        let alert = UIAlertController(title: "Game over!", message: "You made it to level \(levelCounter)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Start Again", style: .default) { _ in
            self.levelCounter = 1
            self.createLevel()
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1: disable user interaction on our view
        view.isUserInteractionEnabled = false
        
        // 2: make the result image appear
        result.alpha = 1
        
        // 3: if the user chose the correct answer
        if indexPath == activeCells[0] {
            // 4: make result show the "correct" image, add 1 to levelCounter, then call createLevel()
            result.image = UIImage(named: "correct")
            levelCounter += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.createLevel()
            }
        } else {
            // 5: otherwise the user chose wrongly, so show the "wrong" image then call gameOver()
            result.image = UIImage(named: "wrong")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.gameOver()
            }
        }
    }
}
