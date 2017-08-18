//
//  MainViewController.swift
//  D-Mail
//
//  Created by Lauren Cataldo on 7/31/17.
//  Copyright © 2017 Prier. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    //sliding menu items
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    var menuShowing = false


    override func viewDidLoad() {
        super.viewDidLoad()

        menuView.layer.shadowOpacity = 1
        menuView.layer.shadowRadius = 6
    }
    
    //opens and closes the menu when the organize button is clicked by moving the menuView
    @IBAction func openMenu(_ sender: UIBarButtonItem) {
        
        if (menuShowing) {
            //moves the menu off of the current view
            leadingConstraint.constant = -150
        } else {
            //moves the menu to the edge of the view
            leadingConstraint.constant = 0
            //animates the movement so it slides onto the view
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        menuShowing = !menuShowing
    }
    
    //Hides the menu when the settings button is clicked (just a small quirk that i found annoying)
    @IBAction func hideMenu(_ sender: Any) {
        leadingConstraint.constant = -150
        menuShowing = !menuShowing
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (menuShowing) {
            hideMenu(self);
        }
    }
    
}
