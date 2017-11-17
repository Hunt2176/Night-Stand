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
    @IBOutlet weak var SecondsSwitch: UISwitch!
    @IBOutlet weak var lightSwitch: UISwitch!
    
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
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func SetupKeys(){
        HourSwitch.isOn = settings.bool(forKey: "use24")
        lightSwitch.isOn = settings.bool(forKey: "useFlash")
        SecondsSwitch.isOn = settings.bool(forKey: "useSec")
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
    }
    @IBAction func SecondsSwitch(_ sender: Any) {
        settings.set(SecondsSwitch.isOn, forKey: "useSec")
    }
    @IBAction func lightSwitch(_ sender: Any) {
        settings.set(lightSwitch.isOn, forKey: "useFlash")
    }
    
}

