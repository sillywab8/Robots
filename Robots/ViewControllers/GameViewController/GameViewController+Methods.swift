//
//  GameViewController+Methods.swift
//  Robots
//
//  Created by Mervyn B. Sharaf on 2/9/19.
//  Copyright © 2019 Mervyn Sharaf. All rights reserved.
//

// Contains helper methods for GameViewController

import UIKit
import AVFoundation

extension GameViewController {
    
    /// Adjusts view for iPhone 5E size screen.
    ///
    /// - Tag: AdjustViewForIPhone5E().
    func adjustViewForIPhone5E() {
        topConstraint.constant = IPhone5EConstants.topConstraint
        gameBoardTopConstraint.constant = IPhone5EConstants.gameBoardTopConstraint
        self.view.layoutIfNeeded()
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
    func getRobotPlayers() {
        let storyboard = UIStoryboard(name: StoryboardIDs.mainStoryboard, bundle: nil)
        let gameVC = storyboard.instantiateViewController(withIdentifier: StoryboardIDs.gameViewControllerID)
        guard let vc = gameVC as? RobotPickerViewController else { return }
        
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        
        present(vc, animated: true, completion: nil)
    }
    
    /// Loads view to show summary of the game.
    ///
    /// - Tag: ShowSummary.
    func showSummary() {
        let storyboard = UIStoryboard(name: StoryboardIDs.mainStoryboard, bundle: nil)
        let summaryVC = storyboard.instantiateViewController(withIdentifier: StoryboardIDs.summaryViewControllerID)
        guard let vc = summaryVC as? SummaryViewController else { return }
        vc.robotManager = robotManager
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        
        present(vc, animated: true, completion: nil)
    }
    
    /// Shows pause alert when screen is tapped.
    ///
    /// - Tag: ShowPauseAlert.
    func showPauseAlert() {
        while robotImageViewCollection[robotManager.currentRobotIndex].isAnimating {}
        gameManager.stopGameTimer()
        gameManager.pauseTimer?.cancel()
        gameManager.pauseTimer = nil


        let alert = UIAlertController(title: StringLiterals.stopGameString, message: StringLiterals.endGameString, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: StringLiterals.yesString, style: .destructive) { (_) in
            self.showSummary()
             //TODO: Animate win, lose, stale
             //TODO: Player image assets board
        }
        let noAction = UIAlertAction(title: StringLiterals.noString, style: .cancel) { (_) in
            self.gameManager.startGame(self.robotManager)
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
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
        gameManager.stopGameTimer()
        robotManager.resetRobots()
        gameManager.resetGame(robotManager: robotManager)
    }
    
    /// Sets up view after players are chosen.
    ///
    /// - Tag: SetupView.
    func setupView() {
        // Initialize view items
        robotViewCollection.forEach {view in view.isHidden = true }
        robotScoreLabelCollection.forEach { label in label.text = "0"}
        
        // Add title to view. Place based on how many players and make adjustments for iPhone 5E.
        topConstraint.constant = isIPhoneSE() ? IPhone5EConstants.topConstraint : AllDeviceConstants.topConstraint
        gameBoardTopConstraint.constant = isIPhoneSE() ? IPhone5EConstants.gameBoardTopConstraint : AllDeviceConstants.gameBoardTopConstraint
        let yOffsetValue: CGFloat = robotManager.robots.count > 2 ? AppLayoutDims.titleOffsetConstantPlayersMoreThanPlayers2 : AppLayoutDims.titleOffsetConstantPlayers2
        let yAdjustmentValueForIPhone5E = isIPhoneSE() ? IPhone5EConstants.yAdjustmentValue : AllDeviceConstants.yAdjustmentValue
        titleImageView.frame = CGRect(x: (UIScreen.main.bounds.width-Assets.titleImageView.size.width/2)/2,
                                      y: yOffsetValue-yAdjustmentValueForIPhone5E,
                                      width:Assets.titleImageView.size.width/2,
                                      height: Assets.titleImageView.size.height/2)
        self.view.addSubview(titleImageView)
        
        // Show separator if more than 2 players
        playerSeparatorView.isHidden = robotManager.robots.count > 2 ? false : true
        
        // Set player views
        for (index, robot) in robotManager.robots.enumerated() {
            robotViewCollection[index].isHidden = false
            robotNameLabelCollection[index].text = robot.robotName
            robotImageViewCollection[index].image = robot.robotImage
        }
    }
    
    /// Handles when the screen is tapped.
    ///
    /// - Parameter sender: Tap gesture.
    ///
    /// - Tag: DidTapView.
    @objc
    func didTapView(_ sender: UITapGestureRecognizer? = nil) {
        showPauseAlert()
    }
    
    /// Handle's winning tasks.
    ///
    /// - Parameter winnerIndex: Index of the winning robot.
    ///
    /// - Tag: winnerIndex
    func handleWinning(_ winnerIndex: Int) {
        let winnerRobot = robotManager.robots[winnerIndex]
        winnerRobot.status = .winner
        robotManager.bumpScore(winnerIndex)
        updateRobotScore(winnerIndex)
        playWinningSound()
        
        // Show toast of winner
        showToast(view: self.view, message: String(format: StringLiterals.playerWonString, winnerRobot.robotName))
        
        // Show animation of winning robot jumping up and down
        DispatchQueue.main.async {
            self.robotImageViewCollection[winnerIndex].animationImages = winnerRobot.animatedImages
            self.robotImageViewCollection[winnerIndex].animationDuration = 0.25
            self.robotImageViewCollection[winnerIndex].animationRepeatCount = 0
            self.robotImageViewCollection[winnerIndex].startAnimating()
        }
        
        // Wait till animation has been displayed for 2 seconds then reset the game and continue
        gameManager.pauseTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        gameManager.pauseTimer?.schedule(deadline: .now() + .milliseconds(2000))
        gameManager.pauseTimer?.setEventHandler(handler: { [weak self] in
            DispatchQueue.main.async {
                self?.robotImageViewCollection[winnerIndex].stopAnimating()
                self?.robotImageViewCollection[winnerIndex].image = winnerRobot.robotImage
            }
            self?.robotManager.resetRobots()
            self?.gameManager.resetGame(robotManager: self?.robotManager)
        })
        self.gameManager.pauseTimer?.resume()
    }
    
    /// Handle's stale mate situation.
    ///
    /// - Tag: HandleStaleMate.
    func handleStaleMate() {
        showToast(view: self.view, message: StringLiterals.nobodyWonKeepPlayingString)
        gameManager.pauseTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        self.gameManager.pauseTimer?.schedule(deadline: .now() + .milliseconds(1000))
        self.gameManager.pauseTimer?.setEventHandler(handler: { [weak self] in
            self?.robotManager.resetRobots()
            self?.gameManager.resetGame(robotManager: self?.robotManager)
        })
        
        self.gameManager.pauseTimer?.resume()
    }
    
    /// Plays winning sound - cha-ching.
    ///
    /// - Tag: PlayWinningSound.
    private func playWinningSound() {
        guard let url = Bundle.main.url(forResource: Assets.chaChingSoundFileName, withExtension: Assets.mp3Extension) else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            guard let player = audioPlayer else { return }
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    
}
