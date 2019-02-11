//
//  RobotManager.swift
//  Robots
//
//  Created by Mervyn B. Sharaf on 2/2/19.
//  Copyright © 2019 Mervyn Sharaf. All rights reserved.
//

/// Handles robot(s) tasks.

import UIKit

protocol RobotManagerDelegate {
    func hasFoundAWinner(_ robotIndex: Int)
    func didEncounterStaleMate()
    func didFinishMovingRobot()
}

class RobotManager {
    
    struct Defaults {
        static let positions = [PositionDataModel(section: 0, row: 6),
                                PositionDataModel(section: 6, row: 0),
                                PositionDataModel(section: 0, row: 0),
                                PositionDataModel(section: 6, row: 6)]
        
        static let colors = [UIColor.red, UIColor.yellow, UIColor.green, UIColor.blue]
        static let robotAssetNames = ["robotImage1", "robotImage2", "robotImage3", "robotImage4"]
        static let namesV1 = ["Jenny", "Alex", "Mervyn", "Nike"]
        static let namesV2 = ["Meg", "Jake", "Rick", "Mervyn"]
        static let namesV3 = ["Tira", "Mervyn", "Fifi", "Woof"]
        
    }
    
    var robots = [RobotModel]()
    var numberOfPlayers: Int
    var currentRobotIndex: Int = 0
    
    var delegate: RobotManagerDelegate?
    
    init(numberOfPlayers: Int) {
        self.numberOfPlayers = numberOfPlayers
        initializePlayers()
    }
    
    /// Handles the next robot's move.
    ///
    /// - Tag: HandleNextRobotMove.
    @objc
    func handleNextRobotMove(_ gameManager: GameManager?) {
        guard let gameManager = gameManager else { return }
        
        if isStaleMate() {
            delegate?.didEncounterStaleMate()
            return
        }
        
        // Advance to next robot
        currentRobotIndex += 1
        if currentRobotIndex >= robots.count {
            currentRobotIndex = 0  // Reset to beginning robot
        }
        
        let robot = robots[currentRobotIndex]
        if robot.status == .playing {
            robot.queue.sync {
                moveRobot(gameManager, self.currentRobotIndex)
            }
        }
    }
    
    /// Initializes players.
    ///
    /// - Tag: InitializesPlayers.
    private func initializePlayers() {
        for index in 0 ..< numberOfPlayers {
            let robot = RobotModel(robotName: Defaults.namesV3[index], robotColor: Defaults.colors[index], assetName: Defaults.robotAssetNames[index], position: Defaults.positions[index])
            robots.append(robot)
        }
    }
    
    /// Increments robots score by 1.
    ///
    /// - Parameter robotIndex: Index of robot in the game.
    ///
    /// - Tag: BumpScore.
    func bumpScore(_ robotIndex:Int) {
        robots[robotIndex].score += 1
    }
    
    /// Moves a particular robot.
    ///
    /// - Parameter robot Index: Which robot in the game.
    ///
    /// - Tag: MoveRobot.
    func moveRobot(_ gameManager: GameManager, _ robotIndex: Int) {

        let robot = robots[robotIndex]
        let currentPos = robot.position
        let nextPositionData = gameManager.findNextAvailablePosition(currentPos)
        if isDone(robotIndex, nextPositionData) {
            return
        }
        let nextPosition = nextPositionData.position
        
        let boardSpace = gameManager.getLocationOnGameBoard(for: robot)
        guard let space = boardSpace else { print("robot not found"); return }
        let position = space.position
        
        let visitedSpace = BoardSpaceModel.createVisitedSpace(color: robot.color, position: position)
        visitedSpace.spaceType = .visited
        gameManager.setGameBoardSpace(position, visitedSpace)
        
        guard let nextPos = nextPosition else {
            return
        }
        
        gameManager.gameBoard[nextPos.section][nextPos.row].boardSpace = robot
        robot.position = nextPosition!
        delegate?.didFinishMovingRobot()
    }
    
    /// Checks if a stalemate situation has occurred.
    ///
    /// Returns: True if stalemate situation occurred, false otherwise.
    func isStaleMate() -> Bool {
        let loserCount = robots.filter {$0.status == .loser}.count
        return loserCount == robots.count
    }
    
    /// Determines if robot is done playing the game or not. Done could be because the robot
    /// won or that it has no more moves left i.e. blocked in.
    ///
    /// - Parameters:
    ///      - robot: The current robot.
    ///      - positionData: Position data.
    private func isDone(_ robotIndex: Int, _ positionData: (PositionDataModel?, Bool)) -> Bool {
        let robot = robots[robotIndex]
        guard let _ = positionData.0 else {
            let isPrizeFound = positionData.1
            guard isPrizeFound else {
                // Awww sorry robot!, maybe better luck next time. Keep your metal chin up.
                robot.status = .loser
                return true
            }
            
            // We have a winner!
            delegate?.hasFoundAWinner(robotIndex)
            return true
        }
        return false
    }
    
    /// Resets robots.
    ///
    /// Tag:- ResetRobots.
    func resetRobots() {
        robots = robots.enumerated().map { (index, robot) in
            robot.position = Defaults.positions[index]
            robot.status = .playing
            return robot
        }
    }
    
}
