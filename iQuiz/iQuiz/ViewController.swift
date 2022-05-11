//
//  ViewController.swift
//  iQuiz
//
//  Created by Yilin Chen on 5/10/22.
//

import UIKit

//struct TopicData: Decodable {
//    let title: String
//    let desc: String
//}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var TopicTableView: UITableView!
    let myTitle = ["Mathematics", "Marvel Super Heroes", "Science"]
    let myDesc = ["Did you pass the third grade?", "Avengers, Assemble!", "Because SCIENCE!"]
    let myImg = ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUsmn-k5q0jZxNu5rius3CCEVtvYSmqVOsWQ&usqp=CAU", "https://pbs.twimg.com/profile_images/573984336271122432/k8vEBoCW_400x400.jpeg", "https://static.theprint.in/wp-content/uploads/2019/11/science.jpg"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let nib = UINib(nibName: "TopicCell", bundle: nil)
        TopicTableView.register(nib, forCellReuseIdentifier: "TopicCell")
        TopicTableView.delegate = self
        TopicTableView.dataSource = self

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath) as! TopicCell
        cell.TopicTitle.text = myTitle[indexPath.row]
        cell.TopicDesc.text = myDesc[indexPath.row]
        cell.TopicImg.downloaded(from: myImg[indexPath.row])
        
        
        return cell
    }
    


    
    @IBAction func SettingTouchedUp(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in return }))
        
        self.present(alert, animated: true, completion: nil)
    }
    

}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
