//
//  Quiz.swift
//  iQuiz
//
//  Created by Yilin Chen on 5/15/22.
//

import Foundation
import UIKit

class QuizClass {
    init(title: String, desc: String, questions: [QuestionClass]) {
        self.title = title
        self.desc = desc
        self.img = #imageLiteral(resourceName: "math")
        self.questions = questions
    }
    
    var title = ""
    var desc = ""
    var img = UIImage()
    var questions : [QuestionClass] = []
}
