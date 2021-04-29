//
//  ViewController.swift
//  Breathify
//
//  Created by Hannatassja Hardjadinata on 27/04/21.
//

import UIKit
import Foundation
import AVFoundation

class ViewController: UIViewController {

    
    @IBOutlet weak var TimerLabel: UILabel!
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    let shapeLayer = CAShapeLayer()
    let label = UILabel()
    
    var seconds = 60
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    
    var player: AVAudioPlayer?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProgressBar()
        
        let stringValue = TimerLabel.text
        let attrString = NSMutableAttributedString(string: stringValue!)
        attrString.addAttribute(NSAttributedString.Key.kern, value: 5, range: NSMakeRange(0, attrString.length))
        TimerLabel.attributedText = attrString
        
        
        instructionLabel.isHidden = true;
        
        //settingButton.setImage(UIImage(named: "Settings.png"), for: .normal)

    }
    
    
    @IBAction func startTimer(_ sender: Any) {
        
        
        if (isTimerRunning == false && resumeTapped == false){
            UIView.animate(withDuration: 1) {
                self.TimerLabel.frame = CGRect(x: 0, y: 250, width: 390, height: 86)
                self.TimerLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }
            
            UIView.transition(with: instructionLabel, duration: 1,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.instructionLabel.isHidden = false
                          })
            startCountDown()
            animate()
            isTimerRunning = true;
            startButton.setTitle("Pause", for: .normal)
            cancelButton.isEnabled = true;
        } else {
            if(resumeTapped == true){
                resumeTapped = false
                isTimerRunning = true
                startCountDown()
                startButton.setTitle("Pause", for: .normal)
                resumeAnimation()
                return
            }   
            isTimerRunning = false;
            resumeTapped =  true;
            timer.invalidate()
            startButton.setTitle("Resume", for: .normal)
            pauseAnimation()
 
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        timer.invalidate()
        seconds = 60
        TimerLabel.text = timeString(time: TimeInterval(seconds))
        
        isTimerRunning = false
        
        UIView.animate(withDuration: 1) {
            self.TimerLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.TimerLabel.frame = CGRect(x: 0, y: 324, width: 390, height: 86)
        }
        
        UIView.transition(with: instructionLabel, duration: 1,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.instructionLabel.isHidden = true
                      })
        
        shapeLayer.removeAnimation(forKey: "urBasic")
    }
    
    func playSound(){
        
    }
    
    func timeString(time:TimeInterval)-> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func startButtonTap(){
        
    }
    
    func startCountDown(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func setUpProgressBar() {
        let circularPath = UIBezierPath(arcCenter: view.center, radius: 147, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi * 2, clockwise: true)
        let trackLayer = CAShapeLayer()
        
        //bagian abu2 atau belakangnya
        trackLayer.path = circularPath.cgPath
        view.layer.addSublayer(trackLayer)
        trackLayer.strokeColor = #colorLiteral(red: 0.7803921569, green: 0.8392156863, blue: 0.8784313725, alpha: 1)
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 20
        
        trackLayer.position = CGPoint(x: 0 , y: -50)
        
        shapeLayer.path = circularPath.cgPath
        
        view.layer.addSublayer(shapeLayer)

        //bagian warnanya
        shapeLayer.strokeColor = #colorLiteral(red: 0.2117647059, green: 0.3137254902, blue: 0.4235294118, alpha: 1)
        shapeLayer.strokeEnd = 0
        shapeLayer.lineWidth = 20
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        
        shapeLayer.position = CGPoint(x: 0 , y: -50)   
    }

    
    private func animate(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = TimeInterval(seconds)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urBasic")
    }
    
    func pauseAnimation(){
        let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0.0
        shapeLayer.timeOffset = pausedTime
    }
    
    func resumeAnimation(){
        let pausedTime = shapeLayer.timeOffset
        shapeLayer.speed = 1.0
        shapeLayer.timeOffset = 0.0
        shapeLayer.beginTime = 0.0
        let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shapeLayer.beginTime = timeSincePause
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            print("done")
            startButton.setTitle("Start", for: .normal)
            isTimerRunning = false
            TimerLabel.text = timeString(time: TimeInterval(60))
            return
        }
        seconds -= 1
        TimerLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    
    
    

    


}

