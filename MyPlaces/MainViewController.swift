//
//  MainViewController.swift
//  MyPlaces
//
//  Created by Андрей on 14.11.2023.
//

import UIKit

class MainViewController: UITableViewController {
    
    let restaurantNames = ["Бургер Кинг", "Вкусно и точка", "Совок", "Еица на углях", "Ростикс"]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        
        content.text = "\(indexPath.row + 1). \(restaurantNames[indexPath.row])"
        content.image = UIImage(named: restaurantNames[indexPath.row])
        content.imageProperties.maximumSize = CGSize(width: 40, height: 40)
        content.imageProperties.cornerRadius = 20
        
        
        cell.contentConfiguration = content
        
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
