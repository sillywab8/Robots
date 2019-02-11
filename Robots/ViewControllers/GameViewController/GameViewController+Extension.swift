//
//  GameViewController+Extension.swift
//  Robots
//
//  Created by Mervyn B. Sharaf on 2/3/19.
//  Copyright © 2019 Mervyn Sharaf. All rights reserved.
//

/// GameViewController extensions.
/// Contains datasource and delegate methods.

import UIKit

// MARK:- GameManagerDelegate

extension GameViewController: GameManagerDelegate {
    
    func didFinishResettingGame() {
        DispatchQueue.main.async {
            self.gameBoardCollectionView.reloadData()
        }
        guard let _ = robotManager else { return }
        gameManager.startGame(robotManager)
    }
}

// MARK:- RobotManagerDelegate

extension GameViewController: RobotManagerDelegate {
    
    func hasFoundAWinner(_ robotIndex: Int) {
        gameManager.stopGameTimer()
        handleWinning(robotIndex)
    }
    
    func didEncounterStaleMate() {
        gameManager.stopGameTimer()
        handleStaleMate()
    }
    
    func didFinishMovingRobot() {
        DispatchQueue.main.async {
            self.gameBoardCollectionView.reloadData()
        }
    }

}

// MARK:- RobotPickerViewControllerDelegate

extension GameViewController: RobotPickerViewControllerDelegate {
    func didFinishPickingNumberOfPlayers(_ numberOfPlayers: Int) {
        robotManager = RobotManager(numberOfPlayers: numberOfPlayers)
        robotManager.delegate = self
        setupView()
        
        gameManager.resetGame(robotManager: robotManager)
    }
}

// MARK:- SummaryViewControllerDelegate

extension GameViewController: SummaryViewControllerDelegate {
    func finishedViewingSummary() {
        robotManager = nil
        gameManager.createGameBoard()
        
        getRobotPlayers()
    }
}

// MARK:- UICollectionViewDataSource, UICollectionViewDelegate

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameSpaceCell.reuseIdentifier, for: indexPath) as! GameSpaceCell
        
        let gameBoardColumnValues = self.gameManager.gameBoard[indexPath.section]
        let gameBoardItemValue = gameBoardColumnValues[indexPath.item]
        
        guard let robot = gameBoardItemValue.boardSpace else {
            cell.gameSpaceImageView.image = nil
            cell.backgroundColor = .gray
            return cell
        }
        
        if robot.spaceType == .visited {
            cell.gameSpaceImageView.image = nil
            cell.backgroundColor = robot.color
            cell.alpha = 0.2
        } else if robot.spaceType == .prize {
            cell.gameSpaceImageView.image = UIImage(named: "money_prize")
            cell.backgroundColor = .lightGray
            cell.alpha = 1.0
        } else if robot.spaceType == .robot {
            cell.gameSpaceImageView.contentMode = .scaleAspectFit
            cell.gameSpaceImageView.image = (robot as? RobotModel)?.robotImage
            cell.backgroundColor = .lightGray
            cell.alpha = 1.0
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return GameManager.sectionOrRowsGameSpaces
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GameManager.sectionOrRowsGameSpaces
    }
}

// MARK:- UICollectionViewDelegateFlowLayout

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: GameSpaceCell.CellDims.width, height: GameSpaceCell.CellDims.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return GameSpaceCell.CellDims.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return GameSpaceCell.CellDims.sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return GameSpaceCell.CellDims.sectionInsets.top
    }
}
