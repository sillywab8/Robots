//
//  ViewController.swift
//  Robots
//
//  Created by Mervyn B. Sharaf on 2/1/19.
//  Copyright © 2019 Mervyn Sharaf. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {

    // MARK:- Declarations
    
    // Managers
    var titleImageView = UIImageView.init(image: Assets.titleImageView)
    var gameManager = GameManager()
    var robotManager: RobotManager!  // Forced unwrap so not needed to unwrap on every usage.  Safe to
                                     // force unwrap because robot manager is loaded from modal in beginning
    
    // Other vars
    var audioPlayer: AVAudioPlayer?
    private var shouldStopGame = false
    
    // Collection IBOutlets
    @IBOutlet var robotViewCollection: [UIView]!
    @IBOutlet var robotImageViewCollection: [UIImageView]!
    @IBOutlet var robotColorViewCollection: [UIView]!
    @IBOutlet var robotScoreLabelCollection:[UILabel]!
    @IBOutlet var robotNameLabelCollection: [UILabel]!
    
    // Game board collection view
    @IBOutlet weak var gameBoardCollectionView: UICollectionView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var gameBoardTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var playerSeparatorView: UIView!
    
    // MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
    
        initializeGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getRobotPlayers()
    }
    
}
