//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Yilin Chen on 5/14/22.
//

import UIKit

class QuestionViewController: UIViewController {
    @IBOutlet weak var A0: UIButton!
    @IBOutlet weak var A1: UIButton!
    @IBOutlet weak var A2: UIButton!
    @IBOutlet weak var A3: UIButton!
    
    @IBOutlet weak var QuestionTextLabel: UILabel!
    
    var quiz : [QuizClass] = []
    var answerButtons : [UIButton] = []
    var categoryIndex : Int = -1
    var currentQuestionIndex : Int = -1
    
    var selectedAnswer : Int = -1
    //var currentAnswer : Int = 0
    var currentScore : Int = 0

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let answerView = segue.destination as! AnswerViewController
        answerView.quiz = quiz
        answerView.categoryIndex = categoryIndex

        answerView.currentQuestionIndex = currentQuestionIndex
        answerView.selectedAnswer = selectedAnswer
        //answerView.currentAnswered = currentAnswered
        answerView.currentScore = currentScore
    }
    
    func selectAnswer(_ answerButton : UIButton, selected : Bool) {
        if selected {
            answerButton.backgroundColor = UIColor.systemFill
            answerButton.setTitleColor(UIColor.black, for: .normal)
        } else {
            answerButton.backgroundColor = UIColor.white
            answerButton.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    func deselectAnswer() {
        for ans in answerButtons { selectAnswer(ans, selected: false) }
    }
    
    
    @IBAction func AnswerButtonTouched(_ sender: UIButton) {
        deselectAnswer()
        selectAnswer(answerButtons[sender.tag], selected: true)
        selectedAnswer = sender.tag
    }
    
    
    
    @IBAction func SubmitTouched(_ sender: Any) {
        if selectedAnswer == -1 {
            let alert = UIAlertController(title: "No answer selected", message: "Please select an answer to move on", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            // perform segue
            performSegue(withIdentifier: "QuestionToAnswer", sender: self)
        }
        selectedAnswer = -1 //reset empty status 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerButtons = [A0, A1, A2, A3]
        
        let currQuestion : QuestionClass = quiz[categoryIndex].questions[currentQuestionIndex]
        QuestionTextLabel.text = currQuestion.text
        
        for i in 0..<answerButtons.count {
            selectAnswer(answerButtons[i], selected: false) // Reset style
            answerButtons[i].setTitle(currQuestion.answers[i], for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        answerButtons = [A0, A1, A2, A3]
        
        let currQuestion : QuestionClass = quiz[categoryIndex].questions[currentQuestionIndex]
        QuestionTextLabel.text = currQuestion.text
        
        for i in 0..<answerButtons.count {
            selectAnswer(answerButtons[i], selected: false) // Reset style
            answerButtons[i].setTitle(currQuestion.answers[i], for: .normal)
        }
    }
    
}
