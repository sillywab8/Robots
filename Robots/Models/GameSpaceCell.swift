//
//  GameSpaceCell.swift
//  Robots
//
//  Created by Mervyn B. Sharaf on 2/2/19.
//  Copyright © 2019 Mervyn Sharaf. All rights reserved.
//

// Game space view model.

import UIKit

class GameSpaceCell: UICollectionViewCell {
    struct CellDims {
        static let width: CGFloat = 38.0
        static let height: CGFloat = 38.0
        
        static let sectionInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)
    }
    
    static let reuseIdentifier = "game_cell_reuse_id"
    
    static let gameCellView: UIView = {
        let v = UIView(frame: CGRect(x: 0,
                                     y: 0,
                                     width: GameSpaceCell.CellDims.width,
                                     height: GameSpaceCell.CellDims.height))
        
        v.backgroundColor = .lightGray
        return v
    }()
    
    @IBOutlet weak var gameSpaceImageView: UIImageView!
        
}
