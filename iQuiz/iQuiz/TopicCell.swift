//
//  TopicCell.swift
//  iQuiz
//
//  Created by Yilin Chen on 5/11/22.
//

import UIKit

class TopicCell: UITableViewCell {
    @IBOutlet weak var TopicImg: UIImageView!
    @IBOutlet weak var TopicTitle: UILabel!
    @IBOutlet weak var TopicDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
