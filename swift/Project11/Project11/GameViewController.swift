//
//  GameViewController.swift
//  Project11
//
//  Created by Jinwoo Kim on 2/18/21.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var greenTurnMarker: UIView!
    @IBOutlet weak var greenScoreLabel: UILabel!
    @IBOutlet weak var redTurnMarker: UIView!
    @IBOutlet weak var redScoreLabel: UILabel!
    var grid = [[Bacteria]]()
    let moveHighlight = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    var lastSelected = [UIColor: Bacteria]()
    var bacteriaBeingInfected = 0
    
    var currentPlayer = UIColor.green {
        didSet {
            if currentPlayer == .green {
                greenScoreLabel.textColor = .yellow
                greenTurnMarker.alpha = 1
                redScoreLabel.textColor = .white
                redTurnMarker.alpha = 0
            } else {
                greenScoreLabel.textColor = .white
                greenTurnMarker.alpha = 0
                redScoreLabel.textColor = .yellow
                redTurnMarker.alpha = 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1: Set up our sizes
        let xOffset = 90
        let yOffset = 140
        let gridSize = 80
        let buttonSize = 70
        
        // 2: Loop from 0 to 10 and create a new array of Bacteria
        for row in 0..<11 {
            var rowArray = [Bacteria]()
            
            // 3: Loop from 0 to 21 and create new individual Bacteria
            for col in 0..<22 {
                let btn = Bacteria(type: .custom)
                btn.addConnection()
                
                // 4: Give the new bacteria some basic properties
                btn.frame = CGRect(x: xOffset + (col * gridSize),
                                   y: yOffset + (row * gridSize),
                                   width: buttonSize,
                                   height: buttonSize)
//                btn.setImage(UIImage(named: "arrowGray"), for: .normal)
                btn.color = .gray
                btn.row = row
                btn.col = col
                btn.addTarget(self, action: #selector(buttonTapped(sender:)), for: .primaryActionTriggered)
                
                // 5: Add it to our view and to its row array
                view.addSubview(btn)
                rowArray.append(btn)
                
                if row <= 5 {
                    // pick a semi-random direction
                    if btn.row == 0 && btn.col == 0 {
                        // make sure the player starts pointing away from anything
                        btn.direction = .north
                    } else if btn.row == 0 && btn.col == 1 {
                        // make sure nothing points to the player
                        btn.direction = .east
                    } else if btn.row == 1 && btn.col == 0 {
                        // make sure nothing points to the player
                        btn.direction = .south
                    } else {
                        // all other pieces are random
                        switch Int.random(in: 0...3) {
                        case 1:
                            btn.direction = .north
                        case 2:
                            btn.direction = .south
                        case 3:
                            btn.direction = .east
                        default:
                            btn.direction = .west
                        }
                    }
                } else {
                    // use the reverse direction of our opposite
                    if let opposite = bacteria(atRow: 10 - btn.row, col: 21 - btn.col) {
                        switch opposite.direction {
                        case .north:
                            btn.direction = .south
                        case .south:
                            btn.direction = .north
                        case .east:
                            btn.direction = .west
                        case .west:
                            btn.direction = .east
                        }
                    }
                }
            }
            
            grid.append(rowArray)
        }
        
        grid[0][0].color = .green
        grid[10][21].color = .red
        
        currentPlayer = .green
        
        lastSelected[.green] = grid[0][0]
        lastSelected[.red] = grid[10][21]
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        if let bacteria = lastSelected[currentPlayer] {
            return [bacteria]
        } else {
            return super.preferredFocusEnvironments
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        moveHighlight.backgroundColor = .clear
        moveHighlight.layer.borderWidth = 12
        moveHighlight.layer.borderColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1).cgColor
        moveHighlight.alpha = 0
        view.addSubview(moveHighlight)
        
        UIView.animate(withDuration: 5,
                       delay: 0,
                       options: [.repeat, .curveLinear],
                       animations: {
                        self.moveHighlight.transform = CGAffineTransform(rotationAngle: .pi)
                       })
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let next = context.nextFocusedView as? Bacteria {
            moveHighlight.center = next.center
            moveHighlight.alpha = 1
        } else {
            moveHighlight.alpha = 0
        }
    }
    
    @objc func buttonTapped(sender: Bacteria) {
        if sender.color == currentPlayer {
            sender.rotate()
//            changePlayer()
            infect(from: sender)
        }
    }
    
    func changePlayer() {
        if currentPlayer == .green {
            currentPlayer = .red
        } else {
            currentPlayer = .green
        }
        setNeedsFocusUpdate()
    }
    
    func bacteria(atRow row: Int, col: Int) -> Bacteria? {
        guard row >= 0 else { return nil }
        guard row < grid.count else { return nil }
        guard col >= 0 else { return nil }
        guard col < grid[0].count else { return nil }
        return grid[row][col]
    }
    
    func infect(from: Bacteria) {
        // create an array of bacteria that might need to be infected
        var bacteriaToInfect = [Bacteria?]()
        
        // find bacteria we point to direct infection
        switch from.direction {
        case .north:
            bacteriaToInfect.append(bacteria(atRow: from.row - 1, col: from.col))
        case .south:
            bacteriaToInfect.append(bacteria(atRow: from.row + 1, col: from.col))
        case .east:
            bacteriaToInfect.append(bacteria(atRow: from.row, col: from.col + 1))
        case .west:
            bacteriaToInfect.append(bacteria(atRow: from.row, col: from.col - 1))
        }
        
        // find bacteria that points to us
        // indirect infection from above
        if let indirect = bacteria(atRow: from.row - 1, col: from.col) {
            if indirect.direction == .south {
                bacteriaToInfect.append(indirect)
            }
        }
        
        // indirect infection from below
        if let indirect = bacteria(atRow: from.row + 1, col: from.col) {
            if indirect.direction == .north {
                bacteriaToInfect.append(indirect)
            }
        }
        
        // indirect infection from left
        if let indirect = bacteria(atRow: from.row, col: from.col - 1) {
            if indirect.direction == .east {
                bacteriaToInfect.append(indirect)
            }
        }
        
        // indirect infection from right
        if let indirect = bacteria(atRow: from.row, col: from.col + 1) {
            if indirect.direction == .west {
                bacteriaToInfect.append(indirect)
            }
        }
        
        // ?가 붙어 있으면 Optional Binding이 된다.
        for case let bacteria? in bacteriaToInfect {
            if bacteria.color != from.color {
                bacteriaBeingInfected += 1
                let startTransform = bacteria.transform
                bacteria.transform = bacteria.transform.scaledBy(x: 1.2, y: 1.2)
                
                UIView.animate(withDuration: 0.1, animations: {
                    bacteria.color = from.color
                    bacteria.transform = startTransform
                }) { _ in
                    self.bacteriaBeingInfected -= 1
                    self.infect(from: bacteria)
                }
            }
        }
        
        updateScores()
    }
    
    func endGame(message: String) {
        let alert = UIAlertController(title: "Game over", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Continue", style: .default) { _ in
            self.dismiss(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func updateScores() {
        // 1: Create variables we can use to count player bacteria
        var greenBacteria = 0
        var redBacteria = 0
        
        // 2: Loop over every row and column, counting the player bacteria
        for row in grid {
            for col in row {
                if col.color == .green {
                    greenBacteria += 1
                } else if col.color == .red {
                    redBacteria += 1
                }
            }
        }
        
        // 3: Update the score labels
        greenScoreLabel.text = "GREEN: \(greenBacteria)"
        redScoreLabel.text = "RED: \(redBacteria)"
        
        // 4: Check if all infections have finished
        if bacteriaBeingInfected == 0 {
            // 5: Either end the game or change player
            if redBacteria == 0 {
                endGame(message: "Green wins!")
            } else if greenBacteria == 0 {
                endGame(message: "Red wins!")
            } else {
                changePlayer()
            }
        }
    }
}
