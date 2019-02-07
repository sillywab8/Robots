//
//  RobotPickerViewController.swift
//  Robots
//
//  Created by Mervyn B. Sharaf on 2/3/19.
//  Copyright © 2019 Mervyn Sharaf. All rights reserved.
//

import UIKit

protocol RobotPickerViewControllerDelegate {
    func didFinishPickingNumberOfPlayers(_ numberOfPlayers: Int)
}

class RobotPickerViewController: UIViewController {
    
    private var numberOfPlayers = 2
    
    var delegate: RobotPickerViewControllerDelegate?
    
    @IBAction func doneButtonSelected(_ sender: Any) {
        delegate?.didFinishPickingNumberOfPlayers(numberOfPlayers)
        dismiss(animated: true, completion: nil)
    }
    
    let players = [UIImage(named: StringLiterals.twoPlayers)!,
                   UIImage(named: StringLiterals.threePlayers)!,
                   UIImage(named: StringLiterals.fourPlayers)!]
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension RobotPickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numberOfPlayers = row
    }
    
}

extension RobotPickerViewController: UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
        
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let playerImageView = UIImageView(image: players[row])
        return playerImageView
    }
    
    
}
