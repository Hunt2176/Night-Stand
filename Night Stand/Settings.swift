//
//  Settings.swift
//  Night Stand
//
//  Created by Hunter Forbus on 10/3/17.
//  Copyright © 2017 Hunter Forbus. All rights reserved.
//

import UIKit

class Settings: UITableViewController {
    
    @IBOutlet var tableview: UITableView!
    
    
    @IBOutlet weak var HourSwitch: UISwitch!
    @IBOutlet weak var SecondsSwitch: UISwitch!
    @IBOutlet weak var lightSwitch: UISwitch!
    
    @IBOutlet weak var animationCell: UITableViewCell!
    @IBOutlet weak var animationChooser: UISegmentedControl!
    
    @IBOutlet weak var refreshSlider: UISlider!
    @IBOutlet weak var refreshOutput: UILabel!
    
    @IBOutlet weak var whiteLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var orangeLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var customLabel: UILabel!
    
    @IBOutlet weak var whiteCell: UITableViewCell!
    @IBOutlet weak var blueCell: UITableViewCell!
    @IBOutlet weak var redCell: UITableViewCell!
    @IBOutlet weak var orangeCell: UITableViewCell!
    @IBOutlet weak var greenCell: UITableViewCell!
    @IBOutlet weak var customCell: UITableViewCell!
    
    
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
        greenLabel.textColor = .green
        
        
        whiteCell.backgroundColor = .black
        blueCell.backgroundColor = .black
        redCell.backgroundColor = .black
        orangeCell.backgroundColor = .black
        greenCell.backgroundColor = .black
        customCell.backgroundColor = .black
        
        let white = UITapGestureRecognizer(target: self, action: #selector(whiteColor))
        let blue = UITapGestureRecognizer(target: self, action: #selector(blueColor))
        let red = UITapGestureRecognizer(target: self, action: #selector(redColor))
        let orange = UITapGestureRecognizer(target: self, action: #selector(orangeColor))
        let green = UITapGestureRecognizer(target: self, action: #selector(greenColor))
        let custom = UITapGestureRecognizer(target: self, action: #selector(UserInputColor))
        
        
        whiteCell.addGestureRecognizer(white)
        blueCell.addGestureRecognizer(blue)
        redCell.addGestureRecognizer(red)
        orangeCell.addGestureRecognizer(orange)
        greenCell.addGestureRecognizer(green)
        customCell.addGestureRecognizer(custom)
        
        
        
        SetupKeys()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func SetupKeys(){
        HourSwitch.isOn = settings.bool(forKey: "use24")
        lightSwitch.isOn = settings.bool(forKey: "useFlash")
        SecondsSwitch.isOn = settings.bool(forKey: "useSec")
        refreshSlider.value = settings.float(forKey: "refresh")
        refreshOutput.text = String(String(Int(refreshSlider.value)) + " minutes")
        SetColor(toSetOn: settings.integer(forKey: "color"))
        if settings.integer(forKey: "animationType") != nil {
            animationChooser.selectedSegmentIndex = settings.integer(forKey: "animationType")
        }
        else {
            animationChooser.selectedSegmentIndex = 0
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
    
    func SetColor(toSetOn on: Int){
        whiteCell.accessoryType = .none
        blueCell.accessoryType = .none
        redCell.accessoryType = .none
        orangeCell.accessoryType = .none
        greenCell.accessoryType = .none
        customCell.accessoryType = .none
        
        if settings.array(forKey: "customColor") != nil {
            let custom : [CGFloat] = settings.array(forKey: "customColor") as! [CGFloat]
            customLabel.textColor = UIColor(red: CGFloat(custom[0]/255), green: CGFloat(custom[1]/255), blue: CGFloat(custom[2]/255), alpha: 1)
        }
        
        switch on {
        case 0:
            whiteCell.accessoryType = .checkmark
        case 1:
            blueCell.accessoryType = .checkmark
        case 2:
            redCell.accessoryType = .checkmark
        case 3:
            orangeCell.accessoryType = .checkmark
        case 4:
            greenCell.accessoryType = .checkmark
        case 5:
            customCell.accessoryType = .checkmark
        default:
            whiteCell.accessoryType = .checkmark
            settings.set(0, forKey: "color")
            return
        }
        
        settings.set(on, forKey: "color")
        
    }
    
    @objc func whiteColor() {
        SetColor(toSetOn: 0)
    }
    
    @objc func blueColor() {
        SetColor(toSetOn: 1)
    }
    
    @objc func redColor() {
        SetColor(toSetOn: 2)
    }
    
    @objc func orangeColor() {
        SetColor(toSetOn: 3)
    }
    
    @objc func greenColor() {
        SetColor(toSetOn: 4)
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
    
    @IBAction func animationChooser(_ sender: Any) {
        settings.set(animationChooser.selectedSegmentIndex, forKey: "animationType")
    }
    @IBAction func refreshSlider(_ sender: Any) {
        refreshSlider.value = round(refreshSlider.value)
        refreshOutput.text = String(String(Int(refreshSlider.value)) + " minutes")
        settings.set(refreshSlider.value, forKey: "refresh")
    }
    
    
    @objc func UserInputColor(){
        let alert = UIAlertController(title: "Custom Color", message: "Insert Custom Color Values Below", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(UITextField) in
            UITextField.placeholder = "Red 0-255"
            UITextField.keyboardType = .numberPad
        })
        alert.addTextField(configurationHandler: {(UITextField) in
            UITextField.placeholder = "Green 0-255"
            UITextField.keyboardType = .numberPad
        })
        alert.addTextField(configurationHandler: {(UITextField) in
            UITextField.placeholder = "Blue 0-255"
            UITextField.keyboardType = .numberPad
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {
            (ACTION) -> Void in
            var red : CGFloat = 0
            var green : CGFloat = 0
            var blue : CGFloat = 0
            let rgbRange = 0...255
            for i in alert.textFields! {
                if !i.text!.isEmpty {
                    if (i.placeholder?.contains("d"))!{
                        if i.text!.isNumber {
                            red = CGFloat(i.text!.intValue!)
                        }
                        else {
                            return
                        }
                    }
                    else if (i.placeholder?.contains("G"))!{
                        if i.text!.isNumber {
                            green = CGFloat(i.text!.intValue!)
                        }
                        else {
                            return
                        }
                    }
                    else if (i.placeholder?.contains("B"))!{
                        if i.text!.isNumber {
                            blue = CGFloat(i.text!.intValue!)
                        }
                        else {
                            return
                        }
                    }
                }
                else {
                    return
                }
            }
            print(red/255,green/255,blue/255)
            if rgbRange.contains(Int(red)) && rgbRange.contains(Int(green)) && rgbRange.contains(Int(blue)) {
                self.customLabel.textColor = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
                let custom = [Int(red),Int(green),Int(blue)]
                self.settings.set(custom, forKey: "customColor")
                self.SetColor(toSetOn: 5)
            }
        }))
        if settings.array(forKey: "customColor") != nil {
            let custom : [CGFloat] = settings.array(forKey: "customColor") as! [CGFloat]
            for i in 0...2 {
                alert.textFields![i].text = String(describing: Int(custom[i]))
            }
        }
        present(alert, animated: true, completion: nil)
    }
    
}



extension String {
    var isNumber: Bool {
        if Int(self) == nil {
            return false
        } else {
            return true
        }
    }
    var intValue: Int? {
        if !isNumber {
            return nil
        } else {
            return Int(self)
        }
    }
}
