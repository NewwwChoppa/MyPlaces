//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Андрей on 14.11.2023.
//

import UIKit

class MainViewController: UITableViewController {
    
    let places = [Place(name: "Бургер Кинг", location: "Нижний Новгород", type: "Фастфуд", image: "Бургер Кинг"),
                  Place(name: "Вкусно и точка", location: "Нижний Новгород", type: "Фастфуд", image: "Вкусно и точка"),
                  Place(name: "Совок", location: "Нижний Новгород", type: "Лапшичная", image: "Совок"),
                  Place(name: "Еица на углях", location: "Нижний Новгород", type: "Шаурма", image: "Еица на углях"),
                  Place(name: "Ростикс", location: "Нижний Новгород", type: "Фастфуд", image: "Ростикс")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        cell.nameLabel.text = "\(places[indexPath.row].name)"
        cell.locationLabel.text = "\(places[indexPath.row].location)"
        cell.typeLabel.text = "\(places[indexPath.row].type)"
        cell.imageOfPlace.image = UIImage(named: places[indexPath.row].image)
        
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
    
}
