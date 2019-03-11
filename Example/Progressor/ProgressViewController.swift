//
//  ViewController.swift
//  Progressor
//
//  Created by sathishvgs on 03/10/2019.
//  Copyright (c) 2019 sathishvgs. All rights reserved.
//

import UIKit
import Progressor

class ProgressViewController: UIViewController, DidTapButtonAction {
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        
        
        let x = (self.view.frame.width / 2) - (300 / 2)
        let y = (self.view.frame.height / 2) - (100 / 2)
        let frame = CGRect(x: x, y: y, width: 300, height: 120)
        
        let progressContainerView = ProgressorView(frame: frame)
        progressContainerView.cornerRadius = 8.0
        progressContainerView.progressValue = 0.00
        progressContainerView.uploadingFiles = "Uploading 34 files"
        progressContainerView.totalSecs = 60
        progressContainerView.delegate = self
        
        self.view.addSubview(progressContainerView)
        
        var progressValue: Double = 0.0 {
            didSet {
                if progressValue > 1.0 {
                    self.timer?.invalidate()
                    self.timer = nil
                }
            }
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { (_) in
            progressValue = progressValue + 0.01
            progressContainerView.progressValue = progressValue
        })
    }
    
    
    func closeButtonTapped(_ sender: UIButton) {
        print("CLOSE *** Button Tapped")
    }
    
    func pauseButtonTapped(_ sender: UIButton) {
        print("PAUSE *** Button Tapped")
    }
}
