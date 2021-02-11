//
//  GameViewController.swift
//  Project5
//
//  Created by Jinwoo Kim on 2/10/21.
//

import UIKit

class GameViewController: UICollectionViewController {
    var targetLanguage = "english"
    var wordType = ""
    var words: [JSON]!
    var cells = [Int: CardCell]()
    
    var first: CardCell?
    var second: CardCell?
    
    var numCorrect = 0
    
    func checkAnswer() {
        // 1: Make sure both first and second are set
        guard let firstCard = first, let secondCard = second else { return }
        
        // 2: Check the word property of both cards matches
        if firstCard.word == secondCard.word {
            // 3: Clear the word property of both cards so the player can't them again
            firstCard.word = ""
            secondCard.word = ""
            
            // 4: Make both cards flash yellow
            firstCard.card.image = UIImage(named: "cardFrontHighlighted")
            secondCard.card.image = UIImage(named: "cardFrontHighlighted")
            
            // 5: Wait 0.1 seconds then make both cards animate to a green image
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIView.transition(with: firstCard.card, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    firstCard.card.image = UIImage(named: "cardFrontCorrect")
                })
                
                UIView.transition(with: secondCard.card, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    secondCard.card.image = UIImage(named: "cardFrontCorrect")
                })
                
                // 6: Add 1 to their score, and check if we need to. end the game
                self.numCorrect += 1
                
                if self.numCorrect == 9 {
                    self.gameOver()
                }
            }
        } else {
            // 7: The two cards don't match - flip them back
            firstCard.flip(to: "cardBack", hideContents: true)
            secondCard.flip(to: "cardBack", hideContents: true)
        }
        
        // clear first and second, then re-enable user interaction
        first = nil
        second = nil
        view.isUserInteractionEnabled = true
    }
    
    func gameOver() {
        // create a new image view and add it, but make it hidden
        let imageView = UIImageView(image: UIImage(named: "youWin"))
        imageView.center = view.center
        imageView.alpha = 0
        imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        view.addSubview(imageView)
        
        // use a spring animation to show the image view
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: [],
                       animations: {
                        imageView.alpha = 1
                        imageView.transform = .identity
                       })
        
        // go back to the menu after two seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let wordsPath = Bundle.main.url(forResource: wordType, withExtension: "json") else { return }
        guard let contents = try? Data(contentsOf: wordsPath) else { return }
        words = JSON(contents).arrayValue
        
        // 1: Create an array the numbers 0 through 17
        var cellNumbers = Array(0 ..< 18)
        
        // 2: Shuffle the array
        cellNumbers.shuffle()
        
        // 3: Loop from 0 through 8, which is the number of cells we have divided by 2
        for i in 0 ..< 9 {
            // 4: Remove two numbers: one for the picture and one for the word
            let pictureNumber = cellNumbers.removeLast()
            let wordNumber = cellNumbers.removeLast()
            
            // 5: Create index paths from those numbers and cells from the index paths
            let pictureIndexPath = IndexPath(item: pictureNumber, section: 0)
            let wordIndexPath = IndexPath(item: wordNumber, section: 0)
            
            guard let wordCell = collectionView?.dequeueReusableCell(withReuseIdentifier: "Cell", for: wordIndexPath) as? CardCell else {
                return
            }
            guard let pictureCell = collectionView?.dequeueReusableCell(withReuseIdentifier: "Cell", for: pictureIndexPath) as? CardCell else {
                return
            }
            
            // 6: Tell the first cell its work, and give it the correct foreign language word for its label
            wordCell.word = words[i]["english"].stringValue
            wordCell.textLabel.text = words[i][targetLanguage].stringValue
            
            // 7: Tell the second cell the same word, but this time give it the correct image
            pictureCell.word = wordCell.word
            pictureCell.contents.image = UIImage(named: pictureCell.word)
            
            // 8: Store both cells in our dictionary so we can use them later
            cells[pictureNumber] = pictureCell
            cells[wordNumber] = wordCell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 18
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cells[indexPath.row]!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else {
            return
        }
        
        if first == nil {
            // they flipped their first card
            first = cell
        } else if second == nil && cell != first {
            // they flipped their second card
            second = cell
            
            // stop them from flipping more cards
            view.isUserInteractionEnabled = false
            
            // wait a little, then check their answer
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.checkAnswer()
            }
        } else {
            // they are trying to flip a third card - exit!
            return
        }
        
        // preform the flip transition
        cell.flip(to: "cardFrontNormal", hideContents: false)
    }
    
    // Focus 됐을 때 커지는 효과를 System 기본 대신, 1.2배로 설정할 수 있다.
    override func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            if let previous = context.previouslyFocusedView {
                previous.transform = .identity
            }
            
            if let next = context.nextFocusedView {
                next.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        })
    }
    
    // 이미 정답을 맞췄으면 선택 안 되게
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CardCell else {
            return false
        }
        return !cell.word.isEmpty
    }
}
