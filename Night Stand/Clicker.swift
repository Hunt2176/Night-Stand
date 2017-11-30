//
//  Clicker.swift
//  Night Stand
//
//  Created by Hunter Forbus on 11/30/17.
//  Copyright © 2017 Hunter Forbus. All rights reserved.
//

import Foundation

class Clicker {
    var fireAt : Int
    var continuous : Bool
    var clicks = 0
    var autoReset = true
    
    init(FireRate a : Int, continuous b : Bool = true) {
        fireAt = a
        continuous = b
    }
    
    func reset(){
        clicks = 0
    }
    
    func click(numberOf a : Int = 1) -> Bool {
        clicks += a
        if clicks >= fireAt && continuous {
            return true
        }
        else if clicks >= fireAt {
            if autoReset {
                reset()
            }
            return true
        }
        else {
            return false
        }
    }
    
}
