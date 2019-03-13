/*
 Copyright (c) 2019 sathishvgs <vgsathish1995@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 */


import UIKit
postfix operator %

postfix func % (percentage: Int) -> Double {
    return Double(percentage) / 100
}

public protocol DidTapButtonAction: class {
    func closeButtonTapped(_ sender: UIButton)
    func pauseButtonTapped(_ sender: UIButton)
}

// MARK: Progress Container View
public class ProgressorView: UIView {
    
    
    open var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    open var uploadingFiles: String = "Uploading 0 files" {
        didSet {
            self.uploadingFileLabel.text = uploadingFiles
        }
    }
    
    open var percentage: String = "0" {
        didSet {
            self.percentageLabel.text = "\(percentage) %"
        }
    }
    
    open var secondsLeft: String = "60 secs left" {
        didSet {
            self.secondsRemaining.text = secondsLeft
        }
    }
    
    open var progressValue: Double = 0.0 {
        didSet {
            progressView.loadingvalue = CGFloat(progressValue)
            let progressPercentage = progressValue * 100
            let percentageValueInInt: Int = progressPercentage >= 99 ? 100 : Int(progressPercentage)
            percentage = "\(percentageValueInInt)"
            
            seconds = totalSecs - (totalSecs * percentageValueInInt%)
        }
    }
    
    private var seconds: Double = 30 {
        didSet {
            
            var totalSecInStr = "\(seconds)"
            secondsLeft = "\(totalSecInStr.removeAfterDot()) secs left"
            
            if seconds == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.removeUploadDetailSubViews()
                }
            }
        }
    }
    
    open var totalSecs: Double = 100
    open weak var delegate: DidTapButtonAction?
    open var progressPoints = ProgressPoints()
    
    open var uploadingFileLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 22)
        return label
    }()
    
    open var percentageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.frame = CGRect(x: 0, y: 0, width: 50, height: 22)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    open var secondsRemaining: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    open var closebutton: UIButton = {
        let button = UIButton()
        let icon = ProgressorHelper.getImageFromBundle(name: "closeIcon2")
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.setImage(icon, for: .normal)
        return button
    }()
    
    open var pausebutton: UIButton = {
        
        let button = UIButton()
        let icon = ProgressorHelper.getImageFromBundle(name: "pauseIcon")
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.darkGray.cgColor
        
        button.setImage(icon, for: .normal)
        button.setImage(icon, for: .highlighted)
        button.setImage(icon, for: .selected)
        
        return button
    }()
    
    
    open let uploadDetailView = UIView()
    let progressView = ProgressView()
    
    var isFirst = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        progressView.progressPoints = progressPoints
        self.configViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configViews() {
        
        self.uploadingFileContainerUI()
        self.uploadingFileUI()
        self.progressLoadingView()
        self.closeButton()
        self.pauseButton()
        self.setButtonTargets()
        
        self.isFirst = true
    }
    
    func setButtonTargets() {
        closebutton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        pausebutton.addTarget(self, action: #selector(pauseButtonTapped), for: .touchUpInside)
    }
    
    @objc
    func closeButtonTapped() {
        delegate?.closeButtonTapped(closebutton)
    }
    
    @objc
    func pauseButtonTapped() {
        delegate?.pauseButtonTapped(pausebutton)
    }
}

// MARK: UI
extension ProgressorView {
    
    func uploadingFileContainerUI() {
        
        self.addSubview(uploadDetailView)
        uploadDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            uploadDetailView.topAnchor.constraint(equalTo: self.topAnchor, constant: progressPoints.uploadDetailViewTop),
            uploadDetailView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: progressPoints.uploadDetailViewLeading),
            uploadDetailView.widthAnchor.constraint(equalToConstant: progressPoints.uploadDetailViewWidth),
            uploadDetailView.heightAnchor.constraint(equalToConstant: progressPoints.uploadDetailViewHeight)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func uploadingFileUI() {
        
        uploadDetailView.addSubview(uploadingFileLabel)
        uploadingFileLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            uploadingFileLabel.topAnchor.constraint(equalTo: uploadDetailView.topAnchor, constant: progressPoints.uploadingFileLabelTop),
            uploadingFileLabel.leadingAnchor.constraint(equalTo: uploadDetailView.leadingAnchor, constant: progressPoints.uploadingFileLabelLeading),
            uploadingFileLabel.trailingAnchor.constraint(equalTo: uploadDetailView.trailingAnchor, constant: progressPoints.uploadingFileLabelTrailing),
            uploadingFileLabel.heightAnchor.constraint(equalToConstant: progressPoints.uploadingFileLabelHeight)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        
        uploadDetailView.addSubview(percentageLabel)
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let percentageConstraints = [
            percentageLabel.bottomAnchor.constraint(equalTo: uploadDetailView.bottomAnchor, constant: progressPoints.percentageLabelBottom),
            percentageLabel.leadingAnchor.constraint(equalTo: uploadDetailView.leadingAnchor, constant: progressPoints.uploadingFileLabelLeading),
            percentageLabel.widthAnchor.constraint(equalToConstant: progressPoints.percentageLabelWidth),
            percentageLabel.heightAnchor.constraint(equalToConstant: progressPoints.percentageLabelHeight)
        ]
        
        NSLayoutConstraint.activate(percentageConstraints)
        
        uploadDetailView.addSubview(secondsRemaining)
        secondsRemaining.translatesAutoresizingMaskIntoConstraints = false
        
        let secondsConstraints = [
            secondsRemaining.bottomAnchor.constraint(equalTo: uploadDetailView.bottomAnchor, constant: progressPoints.secondsRemainingBottom),
            secondsRemaining.trailingAnchor.constraint(equalTo: uploadDetailView.trailingAnchor, constant: progressPoints.secondsRemainingTrailing),
            secondsRemaining.widthAnchor.constraint(equalToConstant: progressPoints.secondsRemainingWidth),
            secondsRemaining.heightAnchor.constraint(equalToConstant: progressPoints.secondsRemainingHeight)
        ]
        
        NSLayoutConstraint.activate(secondsConstraints)
    }
    
    func progressLoadingView() {
        
        progressView.updateUI()
        
        self.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.layer.borderColor = UIColor.lightGray.cgColor
        progressView.layer.borderWidth = 2.0
        progressView.layer.cornerRadius = 4.0
        
        let progressConstraints = [
            progressView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: progressPoints.progressViewBottom),
            progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: progressPoints.progressViewleading),
            progressView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: progressPoints.progressViewTrailing),
            progressView.heightAnchor.constraint(equalToConstant: progressPoints.progressViewHeight)
        ]
        
        NSLayoutConstraint.activate(progressConstraints)
    }
    
    func closeButton() {
        
        self.addSubview(closebutton)
        closebutton.translatesAutoresizingMaskIntoConstraints = false
        
        let closeButtonConstraints = [
            closebutton.widthAnchor.constraint(equalToConstant: progressPoints.closebuttonWidth),
            closebutton.heightAnchor.constraint(equalToConstant: progressPoints.closebuttonHeight),
            closebutton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: progressPoints.closebuttonTrailing),
            closebutton.topAnchor.constraint(equalTo: self.topAnchor, constant: progressPoints.closebuttonTop)
        ]
        
        NSLayoutConstraint.activate(closeButtonConstraints)
        closebutton.layer.cornerRadius = progressPoints.closebuttonWidth / 2
    }
    
    func pauseButton() {
        
        self.addSubview(pausebutton)
        pausebutton.translatesAutoresizingMaskIntoConstraints = false
        
        let closeButtonConstraints = [
            pausebutton.widthAnchor.constraint(equalToConstant: progressPoints.pausebuttonWidth),
            pausebutton.heightAnchor.constraint(equalToConstant: progressPoints.pausebuttonHeight),
            pausebutton.trailingAnchor.constraint(equalTo: closebutton.leadingAnchor, constant: progressPoints.pausebuttonTrailing),
            pausebutton.topAnchor.constraint(equalTo: self.topAnchor, constant: progressPoints.pausebuttonTop)
        ]
        
        NSLayoutConstraint.activate(closeButtonConstraints)
        pausebutton.layer.cornerRadius = progressPoints.pausebuttonWidth / 2
    }
    
    func removeUploadDetailSubViews() {
        
        guard isFirst else {return}
        self.isFirst = false
        
        uploadDetailView.removeFromSuperview()
        progressView.removeFromSuperview()
        closebutton.removeFromSuperview()
        pausebutton.removeFromSuperview()
        
        uploadingFileLabel.removeConstraints(uploadingFileLabel.constraints)
        
        self.addSubview(uploadingFileLabel)
        uploadingFileLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            
            uploadingFileLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: progressPoints.uploadingFileLabelCenterX),
            uploadingFileLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            uploadingFileLabel.heightAnchor.constraint(equalToConstant: progressPoints.uploadingFileLabelHeightAnchor),
            uploadingFileLabel.widthAnchor.constraint(equalToConstant: progressPoints.uploadingFileLabelWidthAnchor)]
        
        NSLayoutConstraint.activate(constraints)
        
        self.uploadingFiles = "File Uploaded!"
        
        let width: CGFloat = self.frame.width / 1.5
        let heigth: CGFloat = self.frame.height / 2
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.frame = CGRect(x: self.frame.origin.x + 40, y: self.frame.origin.y, width: width, height: heigth)
        }, completion: nil)
    }
}

/****************************************************/

// MARK: Progress View
public class ProgressView: UIView {
    
    var loadingvalue: CGFloat = 0.0 {
        didSet {
            self.loadingvalue = max(0, min(loadingvalue, 0.99))
            self.updateUI()
        }
    }
    
    let loadingView: UIView = UIView()
    var progressPoints: ProgressPoints!
    
    func updateUI() {
        
        self.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = UIColor.darkGray
        loadingView.layer.cornerRadius = 4.0
        
        let loadingConstraints = [
            loadingView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: progressPoints.loadingViewBottom),
            loadingView.topAnchor.constraint(equalTo: self.topAnchor, constant: progressPoints.loadingViewTop),
            loadingView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: progressPoints.loadingViewLeading),
            loadingView.widthAnchor.constraint(greaterThanOrEqualTo: self.widthAnchor, multiplier: loadingvalue)
        ]
        
        NSLayoutConstraint.activate(loadingConstraints)
    }
}

/****************************************************/

// MARK: Extension
extension String {
    
    mutating func removeAfterDot() -> String {
        if let dotRange = self.rangeOfCharacter(from: CharacterSet(charactersIn: ".")) {
            self.removeSubrange(dotRange.lowerBound ..< self.endIndex  )
            return self
        }
        return self
    }
}

/****************************************************/

// MARK: ProgressorHelper
class ProgressorHelper {
    
    static func getBundle() -> Bundle? {
        
        let podBundle = Bundle(for: self)
        
        guard let bundleUrl = podBundle.url(forResource: "Progressor", withExtension: "bundle") else {
            return nil
        }
        
        guard let bundle = Bundle(url: bundleUrl) else {
            return nil
        }
        
        return bundle
    }
    
    static func getImageFromBundle(name: String = "Progressor") -> UIImage {
        
        guard let podBundle = getBundle(), let image = UIImage(named: name, in: podBundle, compatibleWith: nil) else {
            return UIImage()
        }
        return image
    }
}

/****************************************************/

// MARK: POINTS
public struct ProgressPoints {
    
    let uploadDetailViewTop: CGFloat = 10
    let uploadDetailViewLeading: CGFloat = 10
    let uploadDetailViewWidth: CGFloat = 160
    let uploadDetailViewHeight: CGFloat = 60
    
    let uploadingFileLabelTop: CGFloat = 5
    let uploadingFileLabelLeading: CGFloat = 2
    let uploadingFileLabelTrailing: CGFloat = 0
    let uploadingFileLabelHeight: CGFloat = 22
    
    let percentageLabelBottom: CGFloat = -5
    let percentageLabelLeading: CGFloat = 2
    let percentageLabelWidth: CGFloat = 55
    let percentageLabelHeight: CGFloat = 18
    
    let secondsRemainingBottom: CGFloat = -5
    let secondsRemainingTrailing: CGFloat = 0
    let secondsRemainingWidth: CGFloat = 100
    let secondsRemainingHeight: CGFloat = 18
    
    let progressViewBottom: CGFloat = -25
    let progressViewleading: CGFloat = 2
    let progressViewTrailing: CGFloat = -2
    let progressViewHeight: CGFloat = 10
    
    let closebuttonWidth: CGFloat = 40
    let closebuttonHeight: CGFloat = 40
    let closebuttonTrailing: CGFloat = -10
    let closebuttonTop: CGFloat = 25
    
    let pausebuttonWidth: CGFloat = 40
    let pausebuttonHeight: CGFloat = 40
    let pausebuttonTrailing: CGFloat = -12
    let pausebuttonTop: CGFloat = 25
    
    let loadingViewBottom: CGFloat = -2
    let loadingViewTop: CGFloat = 2
    let loadingViewLeading: CGFloat = 2
    let loadingViewWidth: CGFloat = 0.0 // declare by internal property
    
    // New Constraint for *uploadingFileLabel*
    let uploadingFileLabelCenterX: CGFloat = 20
    let uploadingFileLabelCenterY: CGFloat = 0
    let uploadingFileLabelHeightAnchor: CGFloat = 30
    let uploadingFileLabelWidthAnchor: CGFloat = 150
}
