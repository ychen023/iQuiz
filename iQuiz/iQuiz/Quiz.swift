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
        self.img = [#imageLiteral(resourceName: "question")]
        self.questions = questions
    }
    
    var title = ""
    var desc = ""
    var img = [UIImage]()
    var questions : [QuestionClass] = []
}

protocol QuizRepository {
    func getQuizzes() -> [QuizClass]
}

class SimpleQuizRepository : QuizRepository {
    private static var _repo : QuizRepository? = nil
    
    static var theInstance : QuizRepository {
        get {
            if _repo == nil { _repo = SimpleQuizRepository() }
            return _repo!
        }
    }
    
    let localTestingData : [QuizClass] = []
    
    
    func getQuizzes() -> [QuizClass] {
        return localTestingData
    }
}
