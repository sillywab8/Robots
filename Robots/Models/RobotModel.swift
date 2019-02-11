//
//  RobotModel.swift
//  Robots
//
//  Created by Mervyn B. Sharaf on 2/2/19.
//  Copyright © 2019 Mervyn Sharaf. All rights reserved.
//

/// Robot Model.

import UIKit

class RobotModel: BoardSpaceModel {
        
    enum Status {
        case playing
        case winner
        case loser
    }
    
    var robotName: String
    var robotColor: UIColor
    var status: Status
    var queue: DispatchQueue
    var score: Int
    var robotImage: UIImage?
    var animatedImages = [UIImage]()
    
    init(robotName: String, robotColor: UIColor, assetName: String, position: PositionDataModel) {
        self.robotName = robotName
        self.robotColor = robotColor
        self.queue = DispatchQueue(label: UUID().uuidString, attributes: .concurrent)

        self.score = 0
        self.status = .playing
        self.robotImage = UIImage(named: assetName)
        for frameIndex in 1 ... 2 {
            if let image = UIImage(named: String(format: "%@_%d", assetName, frameIndex)) {
                self.animatedImages.append(image)
            }
        }
        
        super.init(color: robotColor, type: .robot, position: position)
    }
    
}
