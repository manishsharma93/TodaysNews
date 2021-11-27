//
//  TodayNewsTableViewCell.swift
//  TodayNews
//
//  Created by Manish Kumar on 27/11/21.
//

import UIKit

class TodayNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var titleValueLabel: UILabel!
    @IBOutlet weak var authorValueLabel: UILabel!
    @IBOutlet weak var descriptionValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        newsImageView.layer.cornerRadius = 5.0
        newsImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

