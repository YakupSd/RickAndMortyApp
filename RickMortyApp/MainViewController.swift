//
//  ViewController.swift
//  RickMortyApp
//
//  Created by Yakup Suda on 17.04.2023.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var collectionViewLocation: UICollectionView!
    
    var selectedCharacter : Results!
    var locationNames = [DenemeLocation]()
    var characters: [Results] = []
    var allCharacters = [Results]()
    var locationUrlArray = [String]()
    var characterArray = [Results]()
    
    private let KarakterURL = "https://rickandmortyapi.com/api/character/"
    private let LokasyonURL = "https://rickandmortyapi.com/api/location"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewLocation.delegate = self
        collectionViewLocation.dataSource = self
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        fetchLocations()
        fetchCharactersFromUrls()
        
    }
    
    func fetchLocations() {
        let urlString = LokasyonURL
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let locationResponse = try decoder.decode(LocationResponse.self, from: data)
                self.locationNames = locationResponse.results
                DispatchQueue.main.async {
                    self.collectionViewLocation.reloadData()
                }
            } catch let err {
                print(err)
            }
        }.resume()
    }
    
    func fetchCharactersFromUrls() {
        let group = DispatchGroup()
        
        for url in locationUrlArray {
            group.enter()
            
            guard let apiUrl = URL(string: url) else {
                group.leave()
                continue
            }
            
            URLSession.shared.dataTask(with: apiUrl) { [weak self] (data, response, error) in
                defer { group.leave() }
                
                guard let self = self, let data = data else { return }
                
                do {
                    let character = try JSONDecoder().decode(Results.self, from: data)
                    self.characterArray.append(character)
                } catch {
                    print(error)
                }
            }.resume()
        }
        group.notify(queue: .main) {
            // Tüm istekler tamamlandıktan sonra table view'i güncelle
            self.mainTableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "maincell", for: indexPath) as! MainCell
        let characterViewModel = characterArray[indexPath.row]
        cell.mainNameLabel.text = characterViewModel.name
        let url = URL(string: characterViewModel.image!)
        cell.mainImage.kf.setImage(with: url)
        if characterViewModel.gender == "Male" {
            cell.gender.image = UIImage(named: "erkek.png")
        } else if characterViewModel.gender == "Female"{
            cell.gender.image = UIImage(named: "kadın.png")
        } else if characterViewModel.gender == "unknown"{
            cell.gender.image = UIImage(named: "soru.png")
        }
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCharacter = characterArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC"{
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.secilenKarakter = selectedCharacter
        }
    }
    
    func refreshTableView() {
        locationUrlArray.removeAll()
        mainTableView.reloadData()
    }
    
    
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationNames.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationCell", for: indexPath) as! CellLocation
        let lokasyon = locationNames[indexPath.row]
        cell.locationLabel.text =  lokasyon.name
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.backgroundColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 10
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.backgroundColor = UIColor.white.cgColor
        cell?.layer.cornerRadius = 10
        cell?.layer.borderColor = UIColor.black.cgColor
        cell?.layer.borderWidth = 1.0
        
        for otherIndexPath in collectionView.indexPathsForVisibleItems {
            if otherIndexPath != indexPath {
                let otherCell = collectionView.cellForItem(at: otherIndexPath)
                otherCell?.layer.borderColor = UIColor.black.cgColor
                otherCell?.layer.backgroundColor = UIColor.lightGray.cgColor
                otherCell?.layer.cornerRadius = 10
                
            }
        }
        
        locationUrlArray.removeAll()
        characterArray.removeAll()
        let lokasyon = locationNames[indexPath.row]
        locationUrlArray.append(contentsOf: lokasyon.residents)
        
        //print("Lokasyon : \(locationUrlArray.count)")
        //print("Lokasyonlar : \(locationUrlArray)")
        fetchCharactersFromUrls()
    }
}
