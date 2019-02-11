//
//  GameManager.swift
//  Robots
//
//  Created by Mervyn B. Sharaf on 2/2/19.
//  Copyright © 2019 Mervyn Sharaf. All rights reserved.
//

/// Handles game related tasks

import UIKit

protocol GameManagerDelegate {
    func didFinishResettingGame()
}

class GameManager: NSObject {
    
    // MARK:- Declarations
    
    static let sectionOrRowsGameSpaces = 7
    typealias GameBoard = Array<[GameBoardSpaceModel]>
    var gameBoard: GameBoard!
    var delegate: GameManagerDelegate?
    var continuousModeTimer: DispatchSourceTimer?
    var pauseTimer: DispatchSourceTimer?
    
    // MARK:- Convenience methods.
    
    /// Stops game timer.
    ///
    /// - Tag: StopGameTimer.
    func stopGameTimer() {
        continuousModeTimer?.cancel()
        continuousModeTimer = nil
    }
    
    /// Starts game in continuous mode.
    ///
    /// - Tag: StarGame.
    func startGame(_ robotManager: RobotManager) {
        continuousModeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        continuousModeTimer?.schedule(deadline: .now(), repeating: .milliseconds(500) )
        continuousModeTimer?.setEventHandler(handler: { [weak self] in
            robotManager.handleNextRobotMove(self)
        })
        
        self.continuousModeTimer?.resume()
    }
    
    /// Resets Game.
    ///
    /// - Tag: ResetGame.
    func resetGame(robotManager: RobotManager?) {
        createGameBoard()
        addPrizeToBoard()

        if let robotManager = robotManager {
            addRobotsToBoard(robotManager)
        }
        
        delegate?.didFinishResettingGame()
    }
    
    /// Adds robots to game board.
    ///
    /// - Parameter robotManager: Robot manager.
    ///
    /// - Tag: AddRobotsToBoard.
    private func addRobotsToBoard(_ robotManager: RobotManager) {
        for (index, robot) in robotManager.robots.enumerated() {
            let position = RobotManager.Defaults.positions[index]
            gameBoard[position.section][position.row].boardSpace = robot
        }
    }
    
    /// Creates game board.
    ///
    /// - Tag: CreateGameBoard.
    func createGameBoard() {
        gameBoard = nil

        let boardSpace = GameBoardSpaceModel(boardSpace: nil)
        let columnValues = Array.init(repeating: boardSpace, count: 7)
        gameBoard = Array.init(repeating: columnValues, count: 7)
    }
    
    /// Adds prize to board.
    ///
    /// - Tag: AddPrizeToBoard.
    private func addPrizeToBoard() {
        let prizeLocation = findAvailableLocationForPrizeSpace()
        let prizeSection = prizeLocation.section
        let prizeRow = prizeLocation.row
        let prize = BoardSpaceModel.createPrizeSpace(position: prizeLocation)
        gameBoard[prizeSection][prizeRow].boardSpace = prize
    }
    
    /// Finds available space for placing prize
    ///
    /// - Returns: Dictionary value of section and row.
    ///
    /// - Tag: FindAvailableLocationForPrizeSpace.
    func findAvailableLocationForPrizeSpace() -> PositionDataModel {
        var freeLocation: PositionDataModel? = nil
        
        while freeLocation == nil {
            let randomPosition = getRandomPositionOnBoard()

            // Check if position is available
            guard
                isBoardSpaceAvailabie(gameBoard[randomPosition.section][randomPosition.row]),
                isPositionAvailble(randomPosition) else { continue }
            
            freeLocation = randomPosition
        }
        
        return freeLocation!  // Safe to force unwrap because while loop ensures safety
    }
    
    /// Get's random position on board.
    ///
    // Returns: Random position.
    ///
    /// - Tag: GetRandomPositionOnBoard.
    private func getRandomPositionOnBoard() -> PositionDataModel {
        let randomSection = Int(Float.random(in: 0 ..< Float(GameManager.sectionOrRowsGameSpaces)))
        let randomRow = Int(Float.random(in: 0 ..< Float(GameManager.sectionOrRowsGameSpaces)))
        return PositionDataModel(section: randomSection, row: randomRow)
    }
    
    /// Checks if a space on the board is available or not.
    ///
    /// - Parameter gameBoardApce: Space on the board to check.
    /// - Returns: True if the space is available, false otherwise.
    ///
    /// - Tag: IsBoardSpaceAvailabie.
    private func isBoardSpaceAvailabie(_ gameBoardSpace: GameBoardSpaceModel) -> Bool {
        guard let _ = gameBoardSpace.boardSpace else { return true }
        return false
    }
    
    /// Checks if position is available.
    ///
    /// - Parameter position: Position to check.
    /// - Returns: True if the position is available, false otherwise.
    ///
    /// - Tag: IsPositionAvailble.
    private func isPositionAvailble(_ position: PositionDataModel) -> Bool {
        if let _ = RobotManager.Defaults.positions.firstIndex(of: position) {
            return false
        }
        return true
    }
    
    /// Set's a board space on the game board at a particular position.
    ///
    /// - Parameters:
    ///      - position: Position where the game board will have the board space.
    ///      - boardSpace: The space to set on the game board.
    ///
    /// - Tag: SetGameBoardSpace
    func setGameBoardSpace(_ position: PositionDataModel, _ boardSpace: BoardSpaceModel) {
        gameBoard[position.section][position.row].boardSpace = boardSpace
    }
    
    /// Finds next available position.
    ///
    /// - Parameter currentPosition: Current position.
    /// - Returns: Position value of next available location, and true if the prize was
    ///             found, false otherwise.
    ///
    /// - Tag: FindNextAvailablePosition.
    func findNextAvailablePosition(_ currentPosition: PositionDataModel) -> (position: PositionDataModel?, foundPrize: Bool) {
        let posSect = currentPosition.section
        let posRow = currentPosition.row
        
        var possiblePositions = [PositionDataModel]()
        
        let positionsToCheck = [PositionDataModel(section: posSect+1, row: posRow),
                                PositionDataModel(section: posSect-1, row: posRow),
                                PositionDataModel(section: posSect, row: posRow+1),
                                PositionDataModel(section: posSect, row: posRow-1)]
        
        for position in positionsToCheck {
            if isValidPositonOnBoard(position) {
                let item = gameBoard[position.section][position.row]
                if let boardSpace = item.boardSpace {
                    // Is this position where the prize is?
                    if boardSpace.spaceType == .prize {
                        return (nil, true)
                    }
                } else {
                    possiblePositions.append(PositionDataModel(section: position.section, row: position.row))
                }
            }
        }
        
        if possiblePositions.count == 0 { return (nil, false) }
        
        // Randomly pick which possible positions were found
        let indexToReturn = Int(Float.random(in: 0 ..< Float(possiblePositions.count)))
        
        return (possiblePositions[indexToReturn], false)
    }
    
    /// Determines if the location is a valid position on board.
    ///
    /// - Parameter position: Position on board.
    ///
    /// - Returns: True if it's a valid location, false otherwise.
    ///
    /// - Tag: IsValidPositonOnBoard.
    private func isValidPositonOnBoard(_ position: PositionDataModel) -> Bool {
        if position.section < GameManager.sectionOrRowsGameSpaces && position.section >= 0,
            position.row < GameManager.sectionOrRowsGameSpaces && position.row >= 0 {
            return true
        }
        return false
    }
 
    /// Find's robot's location on game board.
    ///
    /// - Parameter robot: The robot whose position needs to be located.
    /// - Returns: Board space location where robot is located.
    ///
    /// - Tag: GetLocationOnGameBoard.
    func getLocationOnGameBoard(for robot: RobotModel) -> BoardSpaceModel? {
        for gameCol in gameBoard {
            for gameRow in gameCol {
                guard let space = gameRow.boardSpace, space.uid == robot.uid else { continue }
                return space
            }
        }
        return nil
    }
    
}
