//
//  AppUtilities.swift
//  Robots
//
//  Created by Mervyn B. Sharaf on 2/8/19.
//  Copyright © 2019 Mervyn Sharaf. All rights reserved.
//

import UIKit

/// Determines if current device is an iPhone SE or not
///
/// - Returns: True if the current device is an iPhone SE, false otherwise.
///
/// - Tag: IsIPhoneSE.
func isIPhoneSE() -> Bool {
    return UIDevice.modelName.contains("iPhone SE")
}

/// Show's toast.
///
/// - Parameters:
///      - view: View to display toast on.
///      - message: Toast message to display.
///      - size: Size of font (defaults to 16 if nothing is specified).
///      - duration: Length of time to display toast (defaults to 3 if nothing is specified).
///      - numberOfLines: How many lines of toast message (defaults to 1 if nothing is specified).
///
/// - Tag: ShowToast.
func showToast(view: UIView, message: String, size: CGFloat = 16, duration: Double = 3.0, numberOfLines: Int = 1) {
    let top: CGFloat = UIDevice.current.userInterfaceIdiom ==  UIUserInterfaceIdiom.pad ? view.frame.size.height/1.5 : 125
    DispatchQueue.main.async {
        let toastLabel = UILabel()
        
        
        if numberOfLines == 2 {
            toastLabel.frame = CGRect(x: (view.frame.size.width/2)-125, y: top, width: 250, height: 35)
        } else {
            toastLabel.frame = CGRect(x: (view.frame.size.width/2)-125, y: top, width: 250, height: 95)
        }
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: "Helvetica", size: size)
        toastLabel.text = message
        toastLabel.adjustsFontSizeToFitWidth = true
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = numberOfLines
        let window = UIWindow(frame: view.frame)
        window.rootViewController = UIViewController()
        
        window.backgroundColor = UIColor.clear
        window.isUserInteractionEnabled = false
        window.rootViewController?.view.addSubview(toastLabel)
        window.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + abs(duration - 1.0)) {
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
                window.isHidden = true
                window.rootViewController = nil
                window.resignKey()
                window.removeFromSuperview()
            })
        }
    }
}
