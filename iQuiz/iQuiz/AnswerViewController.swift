//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Yilin Chen on 5/15/22.
//

import UIKit

class AnswerViewController: UIViewController {
    @IBOutlet weak var Correctness: UILabel!
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var CorrectAnswerLabel: UILabel!
    @IBOutlet weak var NextButton: UIButton!
    
    var quiz : [QuizClass] = []
    var categoryIndex : Int = -1
    var currentQuestionIndex : Int = -1
    
    var selectedAnswer : Int = -1
    //var currentAnswered : Int = 0
    var currentScore : Int = 0
    var completedQuiz : Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
//        if let rootVC = navigationController?.viewControllers.first {
//            self.navigationController?.viewControllers = [rootVC, self]
//        }
//        
        let currQuestion : QuestionClass = quiz[categoryIndex].questions[currentQuestionIndex]
        let answerIndex : Int = Int(currQuestion.answer)! - 1
        
        currentQuestionIndex += 1
        //currentAnswered += 1
        if selectedAnswer == answerIndex {
            Correctness.text = "Correct!"
            Correctness.textColor = UIColor.systemGreen
            currentScore += 1
        } else {
            Correctness.text = "Incorrect!"
            Correctness.textColor = UIColor.systemRed
        }
        
        if currentQuestionIndex == quiz[categoryIndex].questions.count {
            NextButton.setTitle("Check your results", for: .normal)
            completedQuiz = true
        }
        
        QuestionLabel.text = currQuestion.text
        CorrectAnswerLabel.text = currQuestion.answers[answerIndex]
        
        print("Got \(currentScore) correct")
    }
    
    @IBAction func SubmitTouched(_ sender: Any) {
        if completedQuiz {
            performSegue(withIdentifier: "AnswertoFinished", sender: self)
        } else { // not complete
            // performSegue(withIdentifier: "AnswerToQuestion", sender: self)
            movingBack()
        }
    }
    
    
    func movingBack() {
        if let controller = navigationController?.viewController(class: QuestionViewController.self) {
            controller.quiz = quiz
            controller.categoryIndex = categoryIndex

            controller.currentQuestionIndex = currentQuestionIndex
            controller.currentScore = currentScore
        }

        
        self.navigationController?.popViewController(animated: false)

        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AnswertoFinished" {
            let resultsView = segue.destination as! FinishedViewController
            resultsView.totalQuestion = currentQuestionIndex
            resultsView.finalScore = currentScore
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

extension UINavigationController {
    func viewController<T: UIViewController>(class: T.Type) -> T? {
        return viewControllers.filter({$0 is T}).first as? T
    }
}

