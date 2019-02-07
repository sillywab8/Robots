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
    
    init(robotName: String, robotColor: UIColor, position: PositionDataModel) {
        self.robotName = robotName
        self.robotColor = robotColor
        self.queue = DispatchQueue(label: UUID().uuidString, attributes: .concurrent)

        self.score = 0
        self.status = .playing
        
        super.init(color: robotColor, type: .robot, position: position)
    }
    
}
