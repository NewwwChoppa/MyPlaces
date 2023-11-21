//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Андрей on 14.11.2023.
//

import UIKit
import RealmSwift

class MainViewController: UITableViewController {
    
    var places: Results<Place>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
    }
    
//     MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
                let place = places[indexPath.row]
        
                cell.nameLabel.text = "\(place.name)"
                cell.locationLabel.text = "\(place.location!)"
                cell.typeLabel.text = "\(place.type!)"
        
                var imageData = Data()
        
                if place.imageData != nil {
                    imageData = place.imageData!
                } else {
                    imageData = UIImage(named: "photo.on.ractangle")!.pngData()!
                }
        
                cell.imageOfPlace.image = UIImage(data: imageData)
        
                cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.height / 2
                cell.imageOfPlace.clipsToBounds = true
        
                return cell
    }
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
        func unwindSegue(_ segue: UIStoryboardSegue) {
            guard let newPlaceVC = segue.source as? NewPlaceViewController else { return }
            newPlaceVC.saveNewPlace()
            tableView.reloadData()
        }
        
    }
