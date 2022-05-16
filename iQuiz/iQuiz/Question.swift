//
//  Question.swift
//  iQuiz
//
//  Created by Yilin Chen on 5/15/22.
//
import Foundation

class QuestionClass {
    init(text: String, answer: String, answers: [String]) {
        self.text = text
        self.answer = answer
        self.answers = answers
    }
    
    var text = ""
    var answer = ""
    var answers : [String] = []
}
