//
//  Night Stand.swift
//  Night Stand
//
//  Created by Hunter Forbus on 9/26/17.
//  Copyright © 2017 Hunter Forbus. All rights reserved.
//

import UIKit

class Night_Stand: UIViewController, UIPopoverControllerDelegate {

    
    @IBOutlet var TimeOutputs: [UILabel]!
    @IBOutlet weak var FirstLaunch: UILabel!
    
    
    let calendar = Calendar.current
    var date = Date()
    var currentLabel = 0
    
    var updateTimer = Timer()
    var posTimer = Timer()
    
    var settings = UserDefaults.standard
    var center = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if settings.bool(forKey: "firstlaunch") == false {
            settings.set(false, forKey: "firstlaunch")
            _ = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {
                (Timer) in
                
                self.ToHide()
                
            })
        }
        else {
            FirstLaunch.isHidden = true
        }
    
        print(settings.bool(forKey: "firstlaunch"))
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        if self.currentLabel != self.TimeOutputs.count - 1 {
            self.currentLabel = self.currentLabel + 1
        }
        else {
            self.currentLabel = 0
        }

        for i in 0..<self.TimeOutputs.count {
            if i != self.currentLabel {
                self.TimeOutputs[i].alpha = 0
            }
            if i == self.currentLabel {
                self.TimeOutputs[i].alpha = 1
            }
        }
        
        UIApplication.shared.isIdleTimerDisabled = true
        UpdateTime()
        PositionTimer()
        
        LabelAnimations(duration: 0)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DoubleTap))
        tap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tap)
        
        
        center.addObserver(forName: NSNotification.Name(rawValue: "UpdateView"), object: nil, queue: nil, using: {
            _ in
            print("Notification Received for View Update")
            self.UpdateTime()
        })
        
        center.addObserver(forName: .UIApplicationWillResignActive, object: nil, queue: nil, using: {
            _ in
            self.viewDidDisappear(true)
        })
        
        center.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: nil, using: {
            _ in
            self.viewDidAppear(true)
        })
        
        let torchTap = UITapGestureRecognizer(target: self, action: #selector(TorchTap))
        torchTap.numberOfTapsRequired = 1
        TimeOutputs[0].addGestureRecognizer(torchTap)
        
    }
    
    @objc func DoubleTap(){
        let board = UIStoryboard(name: "Main", bundle: nil)
        let newView = board.instantiateViewController(withIdentifier: "settings")
        let vc = UINavigationController(rootViewController: newView)
        vc.modalPresentationStyle = .popover
        
        present(vc, animated: true, completion: nil)
        
    }
    
    @objc func TorchTap() {
        print("Tap Recognized")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !updateTimer.isValid {
            UpdateTime()
        }
        if !posTimer.isValid {
            print("Resuming position")
            PositionTimer()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("pausing timers")
        posTimer.invalidate()
        updateTimer.invalidate()
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func UpdateTime(){
        date = Date()
        var hour = ""
        var minute = ""
        var newTime : NSMutableAttributedString
        var isAM = false
        
        if calendar.component(.hour, from: date) > 12 {
            if settings.bool(forKey: "use24"){
                hour = String(calendar.component(.hour, from: date))
            }
            else {
                hour = String(calendar.component(.hour, from: date) - 12)
            }
        }
        else {
            if calendar.component(.hour, from: date) < 12 {
                isAM = true
            }
            hour = String(calendar.component(.hour, from: date))
        }
        
        if calendar.component(.minute, from: date) < 10 {
            minute = "0" + String(calendar.component(.minute, from: date))
        }
        else {
            minute = String(calendar.component(.minute, from: date))
        }
        
        if !settings.bool(forKey: "use24") {
        
            if isAM {
                newTime = NSMutableAttributedString(string: hour + ":" + minute)
                newTime.append(NSAttributedString(string: "am", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 30)]))
            }
            else {
                newTime = NSMutableAttributedString(string: hour + ":" + minute)
                newTime.append(NSAttributedString(string: "pm", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 30)]))
            }
            
        }
        else {
            newTime = NSMutableAttributedString(string: hour + ":" + minute)
        }
        
        for i in TimeOutputs{
            self.UpdateLabel(label: i, new: newTime)
        }
        
        SetTimer()
    }
    
    func SetTimer(){
        updateTimer = Timer.scheduledTimer(withTimeInterval: (TimeInterval(60 - (calendar.component(.second, from: date)))), repeats: false, block: {
            (Timer) in
            self.UpdateTime()
        })
        print("Timer Set")
    }
    
    func PositionTimer(){
        self.posTimer = Timer.scheduledTimer(withTimeInterval: 120, repeats: true, block: {
            (Timer) in
            if self.currentLabel != self.TimeOutputs.count - 1 {
                self.currentLabel = self.currentLabel + 1
            }
            else {
                self.currentLabel = 0
            }
            self.LabelAnimations(duration: 1)
            })
    }
    
    
    func LabelAnimations(duration:Double) {
        
        for i in 0..<self.TimeOutputs.count {
            if i != self.currentLabel {
                self.FadeToDarkness(label: self.TimeOutputs[i],duration:  duration)
            }
            if i == self.currentLabel {
                self.FadeToNormal(label: self.TimeOutputs[i])
            }
        }
    }
    
    func ToHide(){
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.FirstLaunch.alpha = 0.0
            }, completion: nil)
    }
    
    func FadeToDarkness(label:UILabel, duration:Double){
        UIView.animate(withDuration: duration, delay: 0.3, options: .curveEaseOut, animations: {
            label.alpha = 0.0
        }, completion: nil)
    }
    func FadeToNormal(label:UILabel){
        UIView.animate(withDuration: 1, delay: 1.3, options: .curveEaseOut, animations: {
            label.alpha = 1.0
        }, completion: nil)
    }
    func UpdateLabel(label:UILabel, new: NSAttributedString){
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            label.attributedText = new
        }, completion: nil)
    }
    

}
