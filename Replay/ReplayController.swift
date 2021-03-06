//
//  ReplayController.swift
//  Replay
//
//  Created by alex oh on 11/12/15.
//  Copyright © 2015 Alex Oh. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ReplayController: UIViewController {

    var url: NSURL!
    
    var videoPlayer = AVPlayerViewController()
    
    override func viewDidAppear(animated: Bool) {
        
        guard url != nil else { return print("URL Not Set!!!") }
        
        view.addSubview(videoPlayer.view)
        videoPlayer.view.frame = view.frame
        
        videoPlayer.player = AVPlayer(URL: url)
        
    }
    
}
