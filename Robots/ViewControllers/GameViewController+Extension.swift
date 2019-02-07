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
        startGame()
    }
}

// MARK:- RobotManagerDelegate

extension GameViewController: RobotManagerDelegate {
    func hasFoundAWinner(_ robotIndex: Int) {
        let robot = robotManager.robots[robotIndex]
        robot.status = .winner

        stopGameTimer()
        robotManager.bumpScore(robotIndex)
        updateRobotScore(robotIndex)
        robotManager.resetRobots()
        gameManager.resetGame(robotManager: robotManager)
//        restartGame()
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
        

        // TODO:- Forcing 2 players. More thatn 2 players hasn't been tested due to time constraints.
        robotManager = RobotManager(numberOfPlayers: 2)
//        robotManager = RobotManager(numberOfPlayers: numberOfPlayers)
        robotManager.delegate = self

        robotViewCollection[0].isHidden = false
        robotViewCollection[1].isHidden = false

        gameManager.resetGame(robotManager: robotManager)
    }
}

// MARK:- UICollectionViewDataSource, UICollectionViewDelegate

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameSpaceCell.reuseIdentifier, for: indexPath) as! GameSpaceCell
        
        let gameBoardColumnValues = self.gameManager.gameBoard[indexPath.section]
        let gameBoardItemValue = gameBoardColumnValues[indexPath.item]
        
        guard let robot = gameBoardItemValue.boardSpace else {
            cell.backgroundColor = .gray
            return cell
        }
        
        if robot.spaceType == .visited {
            cell.backgroundColor = robot.color
            cell.alpha = 0.2
        } else if robot.spaceType == .prize {
            cell.backgroundColor = robot.color
        } else if robot.spaceType == .robot {
            cell.backgroundColor = robot.color
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
