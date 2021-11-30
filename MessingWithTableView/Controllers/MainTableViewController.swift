//
//  MainTableViewController.swift
//  MessingWithTableView
//
//  Created by Ravil on 27.11.2021.
//

import UIKit
import RealmSwift

class MainTableViewController: UITableViewController {

    var cafes: Results<Cafe>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cafes = realm.objects(Cafe.self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cafes.isEmpty ? 0 : cafes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        // var content = cell.contentConfiguration
        // let cafe = cafeNames[indexPath.row]
        let place = cafes[indexPath.row]

        cell.nameOfCafeLabel.text = place.name
        cell.locationOfCafeLabel.text = place.location
        cell.typeOfCafeLabel.text = place.type
        cell.imageOfCafe.image = UIImage(data: place.imageData!)

        cell.imageOfCafe.layer.cornerRadius = cell.imageOfCafe.frame.size.height / 2

        // cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
         
        let cafe = cafes[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { _, _ in
            
            StorageManager.deleteObject(cafe)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return [deleteAction]
    }
    
    
    // MARK: - Navigation
    
    // передача данных на экран "редактировать"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            
            // создаем объект, который можно передать на AddCafeTVC, а там экземпляр
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let cafe = cafes[indexPath.row]
            
            // создаем экземпляр AddCafeTVC
            let addCafeTVC = segue.destination as! AddCafeTableViewController
            
            // обращаемся к экземпляру и его свойству currentCafe
            addCafeTVC.currentCafe = cafe
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let addCafeVC = segue.source as? AddCafeTableViewController else { return }
        
        addCafeVC.saveCafe()
        tableView.reloadData()
    }
}
