//
//  ViewController.swift
//  Project5
//
//  Created by Jinwoo Kim on 2/10/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var language: UISegmentedControl!
    @IBOutlet var words: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let vc = segue.destination as? GameViewController else {
            return
        }
        vc.targetLanguage = language.titleForSegment(at: language.selectedSegmentIndex)!.lowercased()
        vc.wordType = words.titleForSegment(at: words.selectedSegmentIndex)!.lowercased()
    }
}

