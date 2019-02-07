//
//  ViewController.swift
//  Robots
//
//  Created by Mervyn B. Sharaf on 2/1/19.
//  Copyright © 2019 Mervyn Sharaf. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    // MARK:- Declarations
    
    // Managers
    var gameManager = GameManager()
    var robotManager: RobotManager!  // Forced unwrap so not needed to unwrap on every usage.  Safe to
                                     // force unwrap because robot manager is loaded from modal in beginning
    
    // Other vars
    private var shouldStopGame = false
    private var continuousModeTimer: DispatchSourceTimer?
    private var currentRobotIndex: Int = 0  
    
    // Collection IBOutlets
    @IBOutlet var robotViewCollection: [UIView]!
    @IBOutlet var robotImageViewCollection: [UIImageView]!
    @IBOutlet var robotColorViewCollection: [UIView]!
    @IBOutlet var robotScoreLabelCollection:[UILabel]!
    
    // Game board collection view
    @IBOutlet weak var gameBoardCollectionView: UICollectionView!
    
    // MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getRobotPlayers()
    }
    
    // MARK: Helper Methods
    
    /// Stops game timer.
    ///
    /// - Tag: StopGameTimer.
    func stopGameTimer() {
        self.continuousModeTimer?.cancel()
        self.continuousModeTimer = nil
    }

    /// Starts game in continuous mode.
    ///
    /// - Tag: StarGame.
    func startGame() {
        self.continuousModeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        self.continuousModeTimer?.schedule(deadline: .now(), repeating: .milliseconds(500) )
        self.continuousModeTimer?.setEventHandler(handler: { [weak self] in
            self?.handleNextRobotMove()
        })
        
        self.continuousModeTimer?.resume()
    }
    
    /// Handles the next robot's move.
    ///
    /// - Tag: HandleNextRobotMove.
    @objc
    func handleNextRobotMove() {
        if robotManager.isStaleMate() {
            robotManager.resetRobots()
            gameManager.resetGame(robotManager: robotManager)
            return
        }
        
        // Advance to next robot
        currentRobotIndex += 1
        if currentRobotIndex >= robotManager.robots.count {
            currentRobotIndex = 0  // Reset to beginning robot
        }
        
        let robot = robotManager.robots[currentRobotIndex]
        if robot.status == .playing {
            robot.queue.sync {
                self.robotManager.moveRobot(self.gameManager, self.currentRobotIndex)
            }
        }
    }
    
    /// Initialized game.
    ///
    /// - Tag: InitializeGame
    func initializeGame() {
        gameManager.delegate = self
        gameManager.resetGame(robotManager: robotManager)
    }
    
    /// Gets game players from separate modal view
    ///
    /// - Tag: GetRobotPlayers
    private func getRobotPlayers() {
        guard let vc = UIStoryboard(name: StoryboardIDs.mainStoryboard, bundle: nil).instantiateViewController(withIdentifier: StoryboardIDs.gameViewControllerID) as? RobotPickerViewController else { return }
        
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext

        present(vc, animated: true, completion: nil)
    }
    
    /// Updates robot score.
    ///
    /// - Parameter robotIndex: Index of robot whose score will be updated.
    ///
    /// - Tag: UpdateRobotScore.
    func updateRobotScore(_ robotIndex: Int) {
        let robot = robotManager.robots[robotIndex]
        DispatchQueue.main.async {
            self.robotScoreLabelCollection[robotIndex].text = "\(robot.score)"
        }
    }
    
    /// Restarts game.
    ///
    /// - Tag: Restart Game.
    func restartGame() {
        stopGameTimer()
        robotManager.resetRobots()
        gameManager.resetGame(robotManager: robotManager)
    }
}
