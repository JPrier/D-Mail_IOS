//
//  PopTableViewController.swift
//  D-Mail
//
//  Created by Josh Prier on 7/12/17.
//  Copyright © 2017 Prier. All rights reserved.
//

import UIKit

protocol popTableDelegate {
    func finishPassing(string: [String])
}

class PopTableViewController: UITableViewController {
    
    var delegate: popTableDelegate?
    
    struct Objects {
        var sectionName : String!
        var sectionObjects : [String]!
    }
    
    var array = [Objects]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        array = [Objects(sectionName: "Consultation Level", sectionObjects: ["C1 - Focused", "C2 - Expanded", "C3 - Low Complexity", "C4 - Moderate Complexity", "C5 - High Complexity"]), Objects(sectionName: "Hospital Care Level", sectionObjects: ["1 - Low Complexity", "2 - Moderate Complexity", "3 - High Complexity", "4 - Low Complexity (subsequent)", "5 - Moderate Complexity (subsequent)", "6 - High Complexity (subsequent)", "D - Discharge", "DI - Discharge Extended"])]
    }
    
    @IBAction func closePopTable(_ sender: Any) {
        
        //Get index of selection
        let indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow! as NSIndexPath
        //Pass selection to ViewController
        delegate?.finishPassing(string: ["con", array[indexPath.section].sectionObjects[indexPath.row]])
        //Change the button name to represent the selection
        
        //dismiss the popover 
        dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return array.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return array[section].sectionObjects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }

        cell?.textLabel!.text = self.array[indexPath.section].sectionObjects[indexPath.row]

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        closePopTable(self)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return array[section].sectionName
    }

}
