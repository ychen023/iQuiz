//
//  QuizDataSource.swift
//  iQuiz
//
//  Created by Yilin Chen on 5/15/22.
//

import UIKit

class QuizDataSource: NSObject, UITableViewDataSource {
    var data : [QuizClass] = []
    init(_ elements : [QuizClass]) {
        data = elements
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell") as! TopicCell
        
        let currData = data[indexPath.row]
        cell.TopicTitle.text = currData.title
        cell.TopicDesc.text = currData.desc
        cell.TopicImg.image = currData.img[0]
        
        return cell
    }

}
