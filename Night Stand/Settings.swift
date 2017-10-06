//
//  Settings.swift
//  Night Stand
//
//  Created by Hunter Forbus on 10/3/17.
//  Copyright © 2017 Hunter Forbus. All rights reserved.
//

import UIKit

class Settings: UITableViewController{

    @IBOutlet var tableview: UITableView!
    
    @IBOutlet weak var HourSwitch: UISwitch!
    
    var settings = UserDefaults.standard
    var center = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector (Dismiss)), animated: true)
        self.navigationItem.title = "Settings"
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.orange
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.barStyle = .black
        
        SetupKeys()
        print("Loaded")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Now you see me")
        
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    func SetupKeys(){
        HourSwitch.isOn = settings.bool(forKey: "use24")
    }

    @objc func Dismiss(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    
    @IBAction func HourSwitch(_ sender: Any) {
        settings.set(HourSwitch.isOn, forKey: "use24")
        center.post(name: NSNotification.Name(rawValue: "UpdateView"), object: nil)
    }
    
}

