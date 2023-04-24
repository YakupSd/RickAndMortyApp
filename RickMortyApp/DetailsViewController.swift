//
//  DetailsViewController.swift
//  RickMortyApp
//
//  Created by Yakup Suda on 24.04.2023.
//

import UIKit
import Kingfisher

class DetailsViewController: UIViewController {

    var secilenKarakter : Results!
    
    @IBOutlet weak var createdDetay: UILabel!
    @IBOutlet weak var episodeDetay: UILabel!
    @IBOutlet weak var locationDetay: UILabel!
    @IBOutlet weak var originDetay: UILabel!
    @IBOutlet weak var genderDetay: UILabel!
    @IBOutlet weak var specyDetay: UILabel!
    @IBOutlet weak var statusDetay: UILabel!
    @IBOutlet weak var imageDetay: UIImageView!
    var episodeString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let title =  UILabel()
        title.text = secilenKarakter.name!
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 22)
        title.textColor = .black
        title.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        navigationItem.titleView = title
        
        //navigationController?.navigationBar.prefersLargeTitles = true
        
        
        self.imageDetay.layer.cornerRadius = 25
        
        if let url = URL(string: secilenKarakter.image!){
            imageDetay.kf.setImage(with: url)
        }
        
        statusDetay.text = secilenKarakter.status
        specyDetay.text = secilenKarakter.species
        genderDetay.text = secilenKarakter.gender
        originDetay.text = secilenKarakter.origin.name
        locationDetay.text = secilenKarakter.location.name
        
        for episode in secilenKarakter.episode{
            let episodeNumber = episode.split(separator: "/").last ?? ""
            episodeString += "\(episodeNumber), "
        }
        episodeString = String(episodeString.dropLast(2))//boşlukları ve virgülü silmek için
        episodeDetay.text = episodeString
        createdDetay.text = secilenKarakter.created
    }
    



}
