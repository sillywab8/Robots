//
//  BoardSpaceModel.swift
//  Robots
//
//  Created by Mervyn B. Sharaf on 2/6/19.
//  Copyright © 2019 Mervyn Sharaf. All rights reserved.
//

import UIKit

class BoardSpaceModel {
    
    enum SpaceType {
        case robot
        case visited
        case prize
    }
    
    var color: UIColor
    var spaceType: SpaceType
    var position: PositionDataModel
    var uid: String
    
    init(color: UIColor, type: SpaceType, position: PositionDataModel) {
        self.color = color
        self.spaceType = type
        self.position = position
        self.uid = UUID().uuidString
    }
    
    // MARK:- Convenience methods.
    
    /// Creates prize board space.
    ///
    /// - Parameter position: Position where to create the prize.
    /// - Returns: Prize board space.
    ///
    /// - Tag: CreatePrizeSpace.
    static func createPrizeSpace(position: PositionDataModel) -> BoardSpaceModel {
        return BoardSpaceModel(color: .green, type: .prize, position: position)
    }
    
    /// Creates visited board space.
    ///
    /// - Parameters:
    ///      - color: Color of the board space.
    ///      - position: Position where of visited board space.
    ///
    /// - Tag: CreateVisitedSpace.
    static func createVisitedSpace(color: UIColor, position: PositionDataModel) -> BoardSpaceModel {
        return BoardSpaceModel(color: color, type: .visited, position: position)
    }
    
}
