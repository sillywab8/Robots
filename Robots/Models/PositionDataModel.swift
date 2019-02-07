//
//  PositionDataModel.swift
//  Robots
//
//  Created by Mervyn B. Sharaf on 2/3/19.
//  Copyright © 2019 Mervyn Sharaf. All rights reserved.
//

// Stores position data.

import Foundation

struct PositionDataModel: Equatable {
    var section: Int
    var row: Int
    
    init(section: Int, row: Int) {
        self.section = section
        self.row = row
    }
    
    static func == (lhs: PositionDataModel, rhs: PositionDataModel) -> Bool {
        return (lhs.section == rhs.section && rhs.row == rhs.row)
    }
}
