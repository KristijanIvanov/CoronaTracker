//
//  DisplayHudProtocol.swift
//  CoronaClass
//
//  Created by Igor Parnadjiev on 9.4.21.
//

import Foundation
import UIKit
import JGProgressHUD

protocol DisplayHudProtocol: AnyObject {
    var hud: JGProgressHUD? {get set}
    
    func displayHud(_ shouldDisplay: Bool)
}

//extension DisplayHudProtocol {
//    func displayHud(_ shouldDisplay: Bool) {
//        print("Default for eveyone")
//    }
//}

extension DisplayHudProtocol where Self: UIViewController {
    func displayHud(_ shouldDisplay: Bool) {
        print("Print for UIViewController")
        if shouldDisplay {
            if hud == nil {
                setDefaultHud()
            }
            hud?.show(in: view)
        } else {
            hud?.dismiss()
        }
        //ONLY FOR SET Property
//            guard let hud = self.hud else {getDeafultHud().show(in: view)
//                return
//            }
//            hud.show(in: view)
//        } else {
//            guard let hud = self.hud else {
//                getDeafultHud().dismiss()
//                return
//            }
//            hud.dismiss()
//        }
    }
    
//    private func getDeafultHud() -> JGProgressHUD {
//        return JGProgressHUD(style: .dark)
//     }
    
    private func setDefaultHud() {
        hud = JGProgressHUD(style: .dark)
    }
}
