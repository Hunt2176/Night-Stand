//
//  Night Stand.swift
//  Night Stand
//
//  Created by Hunter Forbus on 9/26/17.
//  Copyright © 2017 Hunter Forbus. All rights reserved.
//

import UIKit
import AVFoundation

class Night_Stand: UIViewController, UIPopoverControllerDelegate {

    
    
    @IBOutlet weak var TimeOutput: UILabel!
    @IBOutlet weak var FirstLaunch: UILabel!
    
    var vDirection : slideway = .up
    var hDirection : slideway = .left
    
    var clicker = Clicker(FireRate: 2, continuous: false)
    
    let calendar = Calendar.current
    var date = Date()
    var currentLabel = 1
    
    var updateTimer = Timer()
    var torchTimer = Timer()
    
    var settings = UserDefaults.standard
    var center = NotificationCenter.default
    
    var torchTap = UITapGestureRecognizer()
    
    var animationType = 0
    var refreshRate = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ToHide()
        
        UpdateTime()
        
        torchTap = UITapGestureRecognizer(target: self, action: #selector(TorchTap))
        torchTap.numberOfTapsRequired = 1
        
        TimeOutput.isUserInteractionEnabled = true
        TimeOutput.addGestureRecognizer(torchTap)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DoubleTap))
        tap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func DoubleTap(){
        let board = UIStoryboard(name: "Main", bundle: nil)
        let newView = board.instantiateViewController(withIdentifier: "settings")
        let vc = UINavigationController(rootViewController: newView)
        vc.modalPresentationStyle = .popover
        
        present(vc, animated: true, completion: nil)
        
    }
    
    @objc func TorchTap() {
        let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: nil, position: .back)
        if settings.bool(forKey: "useFlash") == false {
            return
        }
        
        do {
        try device?.lockForConfiguration()
            if device?.torchMode == AVCaptureDevice.TorchMode.on {
                device?.torchMode = .off
                self.torchTimer.invalidate()
            }
            else {
                device?.torchMode = .on
                self.torchTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: false, block: {
                    Void in
                    do {
                    try device?.lockForConfiguration()
                        device?.torchMode = .off
                        device?.unlockForConfiguration()
                    } catch {}
                    self.torchTimer.invalidate()
                })
            }
            device?.unlockForConfiguration()
        } catch {
            print("Torch not able")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !updateTimer.isValid {
            UpdateTime()
        }
        switch settings.integer(forKey: "color") {
        case 0:
            TimeOutput.textColor = .white
        case 1:
            TimeOutput.textColor = .blue
        case 2:
            TimeOutput.textColor = .red
        case 3:
            TimeOutput.textColor = .orange
        case 4:
            TimeOutput.textColor = .green
        case 5:
            if settings.array(forKey: "customColor") != nil {
                let custom : [CGFloat] = settings.array(forKey: "customColor") as! [CGFloat]
                TimeOutput.textColor = UIColor(red: CGFloat(custom[0]/255), green: CGFloat(custom[1]/255), blue: CGFloat(custom[2]/255), alpha: 1)
            }
            else {
                TimeOutput.textColor = .white
            }
        default:
            TimeOutput.textColor = .white
        }
        
        if settings.bool(forKey: "useSec"){
            clicker.fireAt = 60*refreshRate
        }
        else {
            clicker.fireAt = refreshRate
        }
        
        if settings.integer(forKey: "animationType") != nil {
            animationType = settings.integer(forKey: "animationType")
        }
        else {
            animationType = 0
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        TimeOutput.removeConstraints(TimeOutput.constraints)
        TimeOutput.translatesAutoresizingMaskIntoConstraints = true
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("pausing timers")
        updateTimer.invalidate()
        torchTimer.invalidate()
        torchTimer.fire()
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        return true
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func SetTimer(){
        if !settings.bool(forKey: "useSec"){
            updateTimer = Timer.scheduledTimer(withTimeInterval: (TimeInterval(60 - (calendar.component(.second, from: date)))), repeats: false, block: {
                (Timer) in
                self.UpdateTime(willNeedAnim: true)
            })
        }
        else {
            updateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {
            void in
            self.UpdateTime(willNeedAnim: true)
            })
        }
        print("Timer Set " + TimeOutput.text!)
    }
    
    func UpdateTime(willNeedAnim a : Bool = false){
        self.date = Date()
        
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
        else if calendar.component(.hour, from: date) <= 12 && calendar.component(.hour, from: date) != 0 {
            isAM = true
            hour = String(calendar.component(.hour, from: date))
        }
        else if calendar.component(.hour, from: date) == 0 {
            hour = String(calendar.component(.hour, from: date) + 12)
        }
            
        
        
        if calendar.component(.minute, from: date) < 10 {
            minute = "0" + String(calendar.component(.minute, from: date))
        }
        else {
            minute = String(calendar.component(.minute, from: date))
        }
        
        if settings.bool(forKey: "useSec"){
            if calendar.component(.second, from: date) < 10 {
                minute += ":" + "0" + String(calendar.component(.second, from: date))
            }
            else {
                minute += ":" + String(calendar.component(.second, from: date))
            }
        }
//        if !settings.bool(forKey: "use24") {
//
//            if isAM {
//                newTime = NSMutableAttributedString(string: hour + ":" + minute)
//                newTime.append(NSAttributedString(string: "am", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 30)]))
//            }
//            else {
//                newTime = NSMutableAttributedString(string: hour + ":" + minute)
//                newTime.append(NSAttributedString(string: "pm", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 30)]))
//            }
//
//        }
//        else {
//            newTime = NSMutableAttributedString(string: hour + ":" + minute)
//        }
        
        newTime = NSMutableAttributedString(string: hour + ":" + minute)
        
        if a {
            if clicker.click() {
                FadeSlide(newText: newTime)
            }
            else {
                TimeOutput.attributedText = newTime
            }
        }
        else {
            TimeOutput.attributedText = newTime
        }
        SetTimer()
    }
    
    func ToHide(){
        UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
            self.FirstLaunch.alpha = 0.0
            }, completion: nil)
    }
    
    func SlideBounce(){
        var test : CGRect = TimeOutput.frame
        
        switch vDirection {
        case .up:
            test.origin.y -= 10
            if self.view.safeAreaLayoutGuide.layoutFrame.contains(test){
                
                switch hDirection {
                case .left:
                    test.origin.x -= 10
                    if self.view.safeAreaLayoutGuide.layoutFrame.contains(test){
                        AnimateSlide(label: TimeOutput, newRect: test)
                    }
                    else{
                        print("switching to right")
                        hDirection = .right
                        SlideBounce()
                    }
                case .right:
                    test.origin.x += 10
                    if self.view.safeAreaLayoutGuide.layoutFrame.contains(test){
                        AnimateSlide(label: TimeOutput, newRect: test)
                    }
                    else{
                        print("switching to left")
                        hDirection = .left
                        SlideBounce()
                    }
                default:
                    return
                }
                
            }
            else {
                print("Switching to down")
                vDirection = .down
                SlideBounce()
            }
        case .down:
            test.origin.y += 10
            if self.view.safeAreaLayoutGuide.layoutFrame.contains(test){
                switch hDirection {
                case .left:
                    test.origin.x -= 10
                    if self.view.safeAreaLayoutGuide.layoutFrame.contains(test){
                        AnimateSlide(label: TimeOutput, newRect: test)
                    }
                    else{
                        print("switching to right")
                        hDirection = .right
                        SlideBounce()
                    }
                case .right:
                    test.origin.x += 10
                    if self.view.safeAreaLayoutGuide.layoutFrame.contains(test){
                        AnimateSlide(label: TimeOutput, newRect: test)
                    }
                    else{
                        print("switching to left")
                        hDirection = .left
                        SlideBounce()
                    }
                default:
                    return
                }
            }
            else {
                print("Switching to up")
                vDirection = .up
                SlideBounce()
            }
        default:
            return
        }
        
    }
    
    func FadeSlide(newText a : NSMutableAttributedString? = nil){
        var test : CGRect = TimeOutput.frame

        switch vDirection {
        case .up:
            test.origin.y -= 70
            if self.view.safeAreaLayoutGuide.layoutFrame.contains(test){
                switch animationType {
                case 0:
                    FadeToLocation(label: TimeOutput, newRect: test, newText: a)
                case 1:
                    SlideToLocation(label: TimeOutput, newRect: test, newText: a)
                default:
                    FadeToLocation(label: TimeOutput, newRect: test, newText: a)
                }
                
            }
            else {
                vDirection = .down
                FadeSlide(newText: a)
            }
        case .down:
            test.origin.y += 70
            if self.view.safeAreaLayoutGuide.layoutFrame.contains(test){
                switch animationType {
                case 0:
                    FadeToLocation(label: TimeOutput, newRect: test, newText: a)
                case 1:
                    SlideToLocation(label: TimeOutput, newRect: test, newText: a)
                default:
                    FadeToLocation(label: TimeOutput, newRect: test, newText: a)
                }
            }
            else {
                vDirection = .up
                FadeSlide(newText: a)
            }
        default:
            return
        }
    }
    
    func AnimateSlide(label:UILabel, newRect g: CGRect){
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
            label.frame = g
        })
    }
    
    func FadeToLocation(label:UILabel, newRect g: CGRect, newText a : NSMutableAttributedString? = nil){
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
            label.alpha = 0
        }, completion: {(_ : Bool) in
            label.frame = g
            if a != nil {
                label.attributedText = a
            }
            UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseOut, animations: {
                label.alpha = 1
            }, completion: nil)
        })
    }
    
    func SlideToLocation(label:UILabel, newRect g: CGRect, newText a : NSMutableAttributedString? = nil){
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
            label.frame = g
            label.attributedText = a
        }, completion: nil)
    }
    
    func UpdateLabel(label:UILabel, new: NSAttributedString){
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            label.attributedText = new
        }, completion: nil)
    }
    

}

enum slideway {
    case up
    case down
    case left
    case right
}
