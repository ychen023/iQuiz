//
//  ViewController.swift
//  iQuiz
//
//  Created by Yilin Chen on 5/10/22.
//

import UIKit

struct Topic: Decodable {
    let title: String
    let desc: String
    let questions: [Question]
}

struct Question: Decodable {
    let text: String
    let answer: String
    let answers: [String]
}

class ViewController: UIViewController, UITableViewDelegate {
    
    var quiz : [QuizClass] = []
    var dataSource : QuizDataSource? = nil

    @IBOutlet weak var TopicTableView: UITableView!
//    let myTitle = ["Mathematics", "Marvel Super Heroes", "Science"]
//    let myDesc = ["Did you pass the third grade?", "Avengers, Assemble!", "Because SCIENCE!"]
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("User selected row at \(indexPath)")
        let cell = tableView.cellForRow(at: indexPath)
        guard cell is TopicCell else { return }
        self.performSegue(withIdentifier: "MainToQuestion", sender: Any?.self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = TopicTableView.indexPathForSelectedRow {
            let questionView = segue.destination as! QuestionViewController
            questionView.quiz = quiz
            questionView.categoryIndex = indexPath.row
            questionView.currentQuestionIndex = 0
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let identifier = segue.identifier
//        if identifier == "Question" {
//            let destViewController = segue.destination as! QuestionViewController
//            let selectedIndex = sender as! Int
//            destViewController.quiz = quiz
//            destViewController.categoryIndex = selectedIndex
//            destViewController.currentQuestionIndex = 0
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchJsonData()

        // Do any additional setup after loading the view.

        let nib = UINib(nibName: "TopicCell", bundle: nil)
        TopicTableView.register(nib, forCellReuseIdentifier: "TopicCell")
        TopicTableView.delegate = self
        dataSource = QuizDataSource(quiz)
        TopicTableView.dataSource = dataSource
    }

    
    func fetchJsonData(){
        let url = URL(string: "https://tednewardsandbox.site44.com/questions.json")
        let session = URLSession.shared.dataTask(with: url!) { (data, res, err) in

            guard let data = data else {
                return
            }
                        
            print(data)
            
            guard let categories = try? JSONDecoder().decode([Topic].self, from: data) else {
                // Couldn't decode data into a Topic
                return
            }
            
            let fetchedQuizzes : [QuizClass] = self.convertJsonToQuizzes(categories)
            
            
            DispatchQueue.main.async{
                self.quiz = fetchedQuizzes
                self.dataSource = QuizDataSource(self.quiz)
                self.TopicTableView.dataSource = self.dataSource
                self.TopicTableView.reloadData()
            }
        }
        session.resume()
    }
    
    func convertJsonToQuizzes (_ cat : [Topic]) -> [QuizClass] {
        var returnQuizzes : [QuizClass] = []
        for c in cat {
            var questionList : [QuestionClass] = []
            for q in c.questions {
                questionList.append(QuestionClass(text: q.text, answer: q.answer, answers: q.answers))
            }
            returnQuizzes.append(QuizClass(title: c.title, desc: c.desc, questions: questionList))
        }
        return returnQuizzes
    }
    

 
    
    @IBAction func SettingTouchedUp(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in return }))
        
        self.present(alert, animated: true, completion: nil)
    }
    

}


//extension UIImageView {
//    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() { [weak self] in
//                self?.image = image
//            }
//        }.resume()
//    }
//    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloaded(from: url, contentMode: mode)
//    }
//}
