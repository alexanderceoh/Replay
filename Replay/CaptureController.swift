//
//  CaptureViewController.swift
//  Replay
//
//  Created by alex oh on 11/12/15.
//  Copyright © 2015 Alex Oh. All rights reserved.
//

import UIKit
import MobileCoreServices

class CaptureController: UIViewController{
    
    @IBOutlet weak var liveView: UIView!
    
    @IBOutlet weak var recordStatusView: RecordStatus!
    
    @IBOutlet weak var captureProgressView: CaptureProgress!
    
    @IBOutlet weak var progressTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var progressLeftConstraint: NSLayoutConstraint!
    
    
    let picker = UIImagePickerController()
    
    var captureTimer: NSTimer?
    
    let hasCamera = UIImagePickerController.isSourceTypeAvailable(.Camera)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This is to work on the project without a phone and camera functions
        guard hasCamera else { return }

        picker.sourceType = .Camera
        picker.showsCameraControls = false
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.delegate = self
        
        liveView.addSubview(picker.view)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        // Needed to update something to trigger constraints

        picker.view.frame = liveView.frame
//        print(picker.view.frame)
        
    }
    
    var captureTime: Double = 0.0
    let maxCaptureTime: Double = 10.0
    
    func updateCaptureTime() {
        
        captureTime += 0.05
        
        captureProgressView.progressAmount = CGFloat(captureTime / maxCaptureTime) * 100
        
        if captureTime >= maxCaptureTime {
            
            endCapture()
            
        }
        
    }
    
    var isCapturing: Bool = false
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if captureTime < 1 { captureTime = 0 } else { return }
        
        moveProgress(touches)
        
        isCapturing = true
        
        captureTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "updateCaptureTime", userInfo: nil, repeats: true)
        
        recordStatusView.isRecording = true
        
        
        
        guard hasCamera else { return }
        

        picker.startVideoCapture()
        
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        moveProgress(touches)
    
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        captureProgressView.hidden = true
        endCapture()
        
    }
    
    func moveProgress(touches: Set<UITouch>) {
        
        guard let touch = touches.first else { return }
        
        captureProgressView.hidden = false
        
        let point = touch.locationInView(view)
        
        progressLeftConstraint.constant = point.x - captureProgressView.frame.width / 2
        progressTopConstraint.constant = point.y - captureProgressView.frame.height / 2
        
        
    }
    
    func endCapture() {
        
        // keep from firing more than once per recording
        guard isCapturing else { return }
        isCapturing = false

        captureTimer?.invalidate()
        captureTimer = nil
        
        recordStatusView.isRecording = false
//        recordStatusView.backgroundColor = UIColor.lightGrayColor()
        
        
        guard hasCamera else { return }

        
        picker.stopVideoCapture()
        
    }
}

extension CaptureController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        guard captureTime > 1 else { return }
        
        // don't have to dismiss the PickerController because we didn't present anything
        
        // collect the file path for the video that was captured
        guard let url = info[UIImagePickerControllerMediaURL] as? NSURL else { return }
        
        guard let replayVC = storyboard?.instantiateViewControllerWithIdentifier("ReplayVC") as? ReplayController else { return }
        
        // pass the nsurl to the replay view controller
        replayVC.url = url
        
        // push to the replay view controller
        navigationController?.pushViewController(replayVC, animated: true)
        
    }
    
}











