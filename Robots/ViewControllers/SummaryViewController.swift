//
//  SummaryViewController.swift
//  Robots
//
//  Created by Mervyn B. Sharaf on 2/10/19.
//  Copyright © 2019 Mervyn Sharaf. All rights reserved.
//

/// Displays summary of game.

import UIKit

protocol SummaryViewControllerDelegate {
    func finishedViewingSummary()
}

class SummaryViewController: UIViewController {

    // MARK:- Declarations
    
    var robotManager: RobotManager!
    var delegate: SummaryViewControllerDelegate?
    
    // MARK:- IBOutlets
    
    @IBOutlet var robotViewCollection: [UIView]!
    @IBOutlet var robotCommentLabelViewCollection: [UILabel]!
    @IBOutlet var robotScoreLabelViewCollection: [UILabel]!
    
    
    // MARK:- Actions
    
    @IBAction func doneButtonTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.finishedViewingSummary()
    }
    
    // MARK:- View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayScoreStats()
    }
    
    // MARK: - Helper Methods.
    
    /// Displays stats.
    ///
    /// - Tag: DisplayScoreStats
    private func displayScoreStats() {
        let maxScorePlayer = robotManager.robots.max { first, second in first.score < second.score }
        let indicesWithMaxScore = robotManager.robots.indices.filter { robotManager.robots[$0].score == maxScorePlayer?.score }
        
        for (index, robot) in robotManager.robots.enumerated() {
            robotViewCollection[index].isHidden = false
            robotScoreLabelViewCollection[index].text = String(robot.score)
            if maxScorePlayer?.score == 0 {
                robotCommentLabelViewCollection[index].text = String(format: StringLiterals.nobodyWonString, robot.robotName)
            } else if indicesWithMaxScore.count > 1 && robot.score == maxScorePlayer?.score {
                robotCommentLabelViewCollection[index].text = String(format: StringLiterals.drawSituationString, robot.robotName)
            } else if robot.score == maxScorePlayer?.score {
                
                robotCommentLabelViewCollection[index].text = String(format: StringLiterals.youWonString, robot.robotName)
            } else {
                robotCommentLabelViewCollection[index].text = String(format: StringLiterals.loseString, robot.robotName)
            }
        }
    }
    
}
