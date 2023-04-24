//
//  MainCell.swift
//  RickMortyApp
//
//  Created by Yakup Suda on 17.04.2023.
//

import UIKit

class MainCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBOutlet weak var gender: UIImageView!
    @IBOutlet weak var mainNameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
