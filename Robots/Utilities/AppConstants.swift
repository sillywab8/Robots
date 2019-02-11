//
//  AppConstants.swift
//  Robots
//
//  Created by Mervyn B. Sharaf on 2/3/19.
//  Copyright © 2019 Mervyn Sharaf. All rights reserved.
//

/// Constants used in the app.

import UIKit

struct StoryboardIDs {
    static let mainStoryboard = "Main"
    static let gameViewControllerID = "robot_picker_vc"
    static let summaryViewControllerID = "summary_vc"
}

struct IPhone5EConstants {
    static let topConstraint: CGFloat = 35.0
    static let gameBoardTopConstraint: CGFloat = 5.0
    static let yAdjustmentValue: CGFloat = 50.0
}

struct AppLayoutDims {
    static let titleOffsetConstantPlayersMoreThanPlayers2: CGFloat = 70.0
    static let titleOffsetConstantPlayers2: CGFloat = 150.0
}

struct StringLiterals {
    static let twoPlayers = "robots_2"
    static let threePlayers = "robots_3"
    static let fourPlayers = "robots_4"
    static let stopGameString = "Stop Game?"
    static let endGameString = "Do you want to end the game?"
    static let yesString = "Yes"
    static let noString = "No"
    static let nobodyWonString = "Sorry %@, nobody won."
    static let drawSituationString = "It's a DRAW! %@, you had the highest score but you are not the only one."
    static let youWonString = "Congrats %@, YOU WON!"
    static let loseString = "Sorry %@, you didn't win. Better luck next time."
    static let playerWonString = "%@ won!"
    static let nobodyWonKeepPlayingString = "Nobody won. Keep playing."

}

struct AssetImages {
    static let titleImageView = UIImage(named: "robotsTitle")!
}
