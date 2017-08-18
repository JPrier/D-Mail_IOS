//
//  HosTableViewController.swift
//  D-Mail
//
//  Created by Josh Prier on 7/12/17.
//  Copyright © 2017 Prier. All rights reserved.
//

import UIKit

protocol HosTableDelegate {
    func finishPassing(string: [String])
}

class HosTableViewController: UITableViewController {
    
    var delegate: HosTableDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func closePopup(_ sender: Any) {
        
        //Get index of selection
        let indexPath : NSIndexPath = self.tableView.indexPathForSelectedRow! as NSIndexPath
        //Pass selection to ViewController
        delegate?.finishPassing(string: ["hos", array[indexPath.row]])
        //dismiss the popover
        dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    var array = ["1 - Low Complexity", "2 - Moderate Complexity", "3 - High Complexity", "4 - Low Complexity (subsequent)", "5 - Moderate Complexity (subsequent)", "6 - High Complexity (subsequent)", "D - Discharge", "DI - Discharge Extended"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel!.text = self.array[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        closePopup(self)
    }

}
