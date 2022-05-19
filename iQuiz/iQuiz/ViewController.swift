//
//  ViewController.swift
//  iQuiz
//
//  Created by Yilin Chen on 5/10/22.
//

import UIKit
import SystemConfiguration

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
    let userDefaults = UserDefaults.standard
    var jsonUrl: String = UserDefaults().object(forKey: "fetchUrl") as? String ?? "https://tednewardsandbox.site44.com/questions.json"
    
    var quizRepo : QuizRepository = (UIApplication.shared.delegate as! AppDelegate).quizRepository

    
    @IBOutlet weak var TopicTableView: UITableView!

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("User selected row at \(indexPath)")
        let cell = tableView.cellForRow(at: indexPath)
        guard cell is TopicCell else { return }
        self.performSegue(withIdentifier: "MainToQuestion", sender: Any?.self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = TopicTableView.indexPathForSelectedRow {
            let questionView = segue.destination as! QuestionViewController
            questionView.quiz = quiz
            questionView.categoryIndex = indexPath.row
            questionView.currentQuestionIndex = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(jsonUrl)
        if verifyUrl(urlString: URL(string: jsonUrl)) {
            fetchJsonData(jsonUrl)
        } else {
            let data = UserDefaults().object(forKey: "data") as! Data
            let categories = try! JSONDecoder().decode([Topic].self, from: data)
            let fetchedQuizzes : [QuizClass] = self.convertJsonToQuizzes(categories)
            
            DispatchQueue.main.async{
                print(fetchedQuizzes)
                self.quiz = fetchedQuizzes
                self.dataSource = QuizDataSource(self.quiz)
                self.TopicTableView.dataSource = self.dataSource
                self.TopicTableView.reloadData()
            }
        }
        
        
        let nib = UINib(nibName: "TopicCell", bundle: nil)
        TopicTableView.register(nib, forCellReuseIdentifier: "TopicCell")
        quiz = quizRepo.getQuizzes()
        dataSource = QuizDataSource(
            
            quiz)
        TopicTableView.dataSource = dataSource
        TopicTableView.delegate = self
        
        TopicTableView.refreshControl = UIRefreshControl()
        TopicTableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }

    @objc private func didPullToRefresh(_ sender : Any) {
        print("start refresh")
        jsonUrl = UserDefaults().object(forKey: "fetchUrl") as? String ?? "https://tednewardsandbox.site44.com/questions.json"
        if !Reachability.isConnectedToNetwork(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.TopicTableView.refreshControl?.endRefreshing()
                self.showDownloadFailed()
            }
        } else {
            fetchJsonData(jsonUrl)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if Reachability.isConnectedToNetwork() {
            print("Has Internet")
        } else {
            if UserDefaults().object(forKey: "data") == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.showDownloadFailed()
                    self.fetchLocalFile(file: "questions")
                }
            } else {
                // using local data
                self.showUsingLocal()
                // Get data from saved userdefaults
                let data = UserDefaults().object(forKey: "data") as! Data
                let categories = try! JSONDecoder().decode([Topic].self, from: data)
                let fetchedQuizzes : [QuizClass] = self.convertJsonToQuizzes(categories)
                
                DispatchQueue.main.async {
                    print(fetchedQuizzes)
                    self.quiz = fetchedQuizzes
                    self.dataSource = QuizDataSource(self.quiz)
                    self.TopicTableView.dataSource = self.dataSource
                    self.TopicTableView.reloadData()
                }
            }
        }
    }
    
    
    func verifyUrl (urlString: URL?) -> Bool {
        if let urlString = urlString {
                return UIApplication.shared.canOpenURL(urlString as URL)
            }
        return false
    }
    
    func fetchJsonData(_ fetchUrl: String){
        let url = URL(string: fetchUrl)
        if url == nil || !verifyUrl(urlString: url) {
            print("1")
            self.TopicTableView.refreshControl?.endRefreshing()
            self.showURLFailed();
            return
        } else {
            let session = URLSession.shared.dataTask(with: url!) { [self] (data, res, err) in
                guard let data = data else {
                    print("2")
                    DispatchQueue.main.async{
                        self.TopicTableView.refreshControl?.endRefreshing()
                        self.showDownloadFailed()
                    }
                        return
                    
                }
                
                UserDefaults.standard.set(data, forKey: "data") // for offline
                UserDefaults.standard.set(url, forKey: "fetchUrl") // save new quiz bank
                
                
                do {
                    let categories = try JSONDecoder().decode([Topic].self, from: data)
                    let fetchedQuizzes : [QuizClass] = self.convertJsonToQuizzes(categories)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.quiz = fetchedQuizzes
                        self.dataSource = QuizDataSource(self.quiz)
                        self.TopicTableView.dataSource = self.dataSource
                        self.TopicTableView.reloadData()
                        print("new data!")
                        self.TopicTableView.refreshControl?.endRefreshing()
                    }
                } catch {
                    DispatchQueue.main.async{
                        self.showURLFailed()
                    }
                }
            }
            session.resume()
        }
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
        let alert = UIAlertController(title: "Settings", message: "Check from your own URL", preferredStyle: .alert)
        alert.addTextField { (textField) in textField.placeholder = "Enter URL" }
        alert.addAction(UIAlertAction(title: "Check now", style: .default, handler: { [weak alert] (_) in
            self.fetchJsonData(alert!.textFields![0].text!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in return }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    // Alerts
    func showURLFailed() {
        let alert = UIAlertController(title: "Download Fail", message: "Please check the URL is a valid quiz database", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDownloadFailed() {
        let alert = UIAlertController(title: "Download Failed", message: "No internet connection", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showUsingLocal() {
        let alert = UIAlertController(title: "No internet connection", message: "Using previously downloaded data", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    

    func fetchLocalFile(file: String){
            if let file = Bundle.main.url(forResource: "\(file)", withExtension: "json") {
                guard let data = try? Data(contentsOf: file) else {
                    self.showUsingLocal()
                    return
                }
                
                guard let categories = try? JSONDecoder().decode([Topic].self, from: data) else {
                    print("6")
                    self.showUsingLocal()
                    return
                }
                
                let fetchedQuizzes : [QuizClass] = self.convertJsonToQuizzes(categories)
                
                DispatchQueue.main.async{
                    self.quiz = fetchedQuizzes
                    self.dataSource = QuizDataSource(self.quiz)
                    self.TopicTableView.dataSource = self.dataSource
                    self.TopicTableView.reloadData()
                    print("local data!")
                }
                
            } else {
                print("no file")
            }
        
    }
    

    
}
