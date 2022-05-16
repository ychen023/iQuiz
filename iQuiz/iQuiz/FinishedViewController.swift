//
//  FinishedViewController.swift
//  iQuiz
//
//  Created by Yilin Chen on 5/15/22.
//

import UIKit

class FinishedViewController: UIViewController {
    @IBOutlet weak var FinishedMessage: UILabel!
    @IBOutlet weak var Score: UILabel!
    
    var totalQuestion : Int = 0
    var finalScore : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let rootVC = navigationController?.viewControllers.first {
            navigationController?.viewControllers = [rootVC, self]
        }
        
        Score.text = "\(finalScore) of \(totalQuestion)"
        
        switch totalQuestion - finalScore {
        case 0: FinishedMessage.text = "Perfect!"
        default: FinishedMessage.text = "You can do better!"
        }

        
    }
    
    @IBAction func EndQuizTouched(_ sender: Any) {
        navigationController?.popToViewController(ofClass: ViewController.self)

    }
    
}

extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}
