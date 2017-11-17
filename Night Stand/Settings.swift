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
    
    @IBOutlet weak var whiteLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var orangeLabel: UILabel!
    
    @IBOutlet weak var whiteCell: UITableViewCell!
    @IBOutlet weak var blueCell: UITableViewCell!
    @IBOutlet weak var redCell: UITableViewCell!
    @IBOutlet weak var orangeCell: UITableViewCell!
    
    
    var settings = UserDefaults.standard
    var center = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector (Dismiss)), animated: true)
        
        self.navigationItem.title = "Settings"
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.orange
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.backgroundColor = UIColor.black
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.barStyle = .black
        
        whiteLabel.textColor = .white
        blueLabel.textColor = .blue
        redLabel.textColor = .red
        orangeLabel.textColor = .orange
        
        whiteCell.backgroundColor = .black
        blueCell.backgroundColor = .black
        redCell.backgroundColor = .black
        orangeCell.backgroundColor = .black
        
        let white = UITapGestureRecognizer(target: self, action: #selector(whiteColor))
        let blue = UITapGestureRecognizer(target: self, action: #selector(blueColor))
        let red = UITapGestureRecognizer(target: self, action: #selector(redColor))
        let orange = UITapGestureRecognizer(target: self, action: #selector(orangeColor))
        
        whiteCell.addGestureRecognizer(white)
        blueCell.addGestureRecognizer(blue)
        redCell.addGestureRecognizer(red)
        orangeCell.addGestureRecognizer(orange)
        
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
        
        switch settings.integer(forKey: "color"){
        case 0:
            whiteCell.accessoryType = .checkmark
        case 1:
            blueCell.accessoryType = .checkmark
        case 2:
            redCell.accessoryType = .checkmark
        case 3:
            orangeCell.accessoryType = .checkmark
        default:
            whiteCell.accessoryType = .checkmark
        }
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
    
    @objc func whiteColor() {
        whiteCell.accessoryType = .checkmark
        blueCell.accessoryType = .none
        redCell.accessoryType = .none
        orangeCell.accessoryType = .none
        settings.set(0, forKey: "color")
    }
    
    @objc func blueColor() {
        whiteCell.accessoryType = .none
        blueCell.accessoryType = .checkmark
        redCell.accessoryType = .none
        orangeCell.accessoryType = .none
        settings.set(1, forKey: "color")
    }
    
    @objc func redColor() {
        whiteCell.accessoryType = .none
        blueCell.accessoryType = .none
        redCell.accessoryType = .checkmark
        orangeCell.accessoryType = .none
        settings.set(2, forKey: "color")
    }
    
    @objc func orangeColor() {
        whiteCell.accessoryType = .none
        blueCell.accessoryType = .none
        redCell.accessoryType = .none
        orangeCell.accessoryType = .checkmark
        settings.set(3, forKey: "color")
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

