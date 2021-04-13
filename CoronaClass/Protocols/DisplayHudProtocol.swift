//
//  DisplayHudProtocol.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 10.4.21.
//

import Foundation
import JGProgressHUD
import UIKit

protocol DisplayHudProtocol: AnyObject {
    var hud: JGProgressHUD? { get set }
    func displayHud(_ shouldDisplay: Bool)
}

extension DisplayHudProtocol where Self: UIViewController {
    func displayHud(_ shouldDisplay: Bool) {
        
        if shouldDisplay {
            if hud == nil {
                setDefaultHud()
            }
            hud?.show(in: view)
        } else {
            hud?.dismiss()
        }
    }
    
    func setDefaultHud() {
        hud = JGProgressHUD(style: .dark)
    }
}
