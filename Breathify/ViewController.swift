//
//  ViewController.swift
//  Breathify
//
//  Created by Hannatassja Hardjadinata on 27/04/21.
//

import UIKit
import Foundation
import AVFoundation

class instructionSet{
    var instruction: String = ""
    var duration: Int = 0
    
//    init(){
//        self.instruction = instruction
//        self.duration = duration
//    }
}

class ViewController: UIViewController {

    
    @IBOutlet weak var TimerLabel: UILabel!
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    let shapeLayer = CAShapeLayer()
    let label = UILabel()
    
    var seconds = 10
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    var iterator = 1
    var instruction : [Instruction] = []
    var currIndex = 0
    
    var player: AVAudioPlayer?
    
    
    let defaults = UserDefaults.standard
    let synthesizer = AVSpeechSynthesizer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProgressBar()
        let stringValue = TimerLabel.text
        let attrString = NSMutableAttributedString(string: stringValue!)
        attrString.addAttribute(NSAttributedString.Key.kern, value: 5, range: NSMakeRange(0, attrString.length))
        TimerLabel.attributedText = attrString
        
        let instructionString = instructionLabel.text
        let attrInstruction = NSMutableAttributedString(string: instructionString!)
        attrInstruction.addAttribute(NSAttributedString.Key.kern, value: 10, range: NSMakeRange(0, attrInstruction.length))
        instructionLabel.attributedText = attrInstruction
        
        instructionLabel.isHidden = true;
        
        print("sound", UserDefaults.standard.string(forKey: "soundSwitch") ?? "0")
        print("notif", UserDefaults.standard.string(forKey: "notifSwitch") ?? "0")
        
       instruction = [
        Instruction(instructionText: "Cat is cute", instructionDuration: 5),
        Instruction(instructionText: "Dog is cute", instructionDuration: 5),
        Instruction(instructionText: "Cockroach is not cute", instructionDuration: 5),
       ]
        
//        let utterance = AVSpeechUtterance(string: "Hello world")
//        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//        utterance.rate = 0.4
//
//        let synthesizer = AVSpeechSynthesizer()
//        synthesizer.speak(utterance)
        
    }
    
    
    @IBAction func startTimer(_ sender: Any) {
        if (isTimerRunning == false && resumeTapped == false){
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
                
                UIView.animate(withDuration: 1) {
                    self.TimerLabel.frame = CGRect(x: 0, y: 250, width: 390, height: 86)
                    self.TimerLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }
                
                UIView.transition(with: self.instructionLabel, duration: 1,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.instructionLabel.isHidden = false
                })
                
                
                
                
                self.startCountDown()
                self.animate()
                self.textInstructionAnimate()
                self.isTimerRunning = true;
                self.resumeTapped = false;
                self.cancelButton.isEnabled = true;
                self.startButton.setImage(UIImage(named: "pauseButton.png"), for: .normal)
            }
        } else {
            if(resumeTapped == true){
                resumeTapped = false
                isTimerRunning = true
                startCountDown()
                startButton.setImage(UIImage(named: "pauseButton.png"), for: .normal)
                resumeAnimation()
                return
            }   
            isTimerRunning = false;
            resumeTapped =  true;
            timer.invalidate()
            startButton.setImage(UIImage(named: "resumeButton.png"), for: .normal)
            pauseAnimation()
 
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        resetTimer()
    }
    
    func textInstructionAnimate(){

        var instruction = [
        "Keep your back straight",
        "Lower your chin toward your chest",
        "Slowly lift your head back up",
        "Tilt your chin up toward the ceiling",
        "Bring the base of your skull toward your back",
        "Lower your head to a normal position",
        "Inhale slowly through your nose",
        "Keep your mouth close",
        "Pucker your lips",
        "Exhale slowly and gently through your pursed lips"
        ]

    }
    
    
    func resetTimer(){
        timer.invalidate()
        seconds = 10
        TimerLabel.text = timeString(time: TimeInterval(seconds))
        
        UIView.animate(withDuration: 1) {
            self.TimerLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.TimerLabel.frame = CGRect(x: 0, y: 324, width: 390, height: 86)
        }
        
        UIView.transition(with: instructionLabel, duration: 1,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.instructionLabel.isHidden = true
                      })
        
        
        isTimerRunning = false
        resumeTapped = false
        cancelButton.isEnabled = false
        
        startButton.setImage(UIImage(named: "startButton.png"), for: .normal)
        
        shapeLayer.removeAllAnimations()
    }
    
    func setUpView(){
    }
    
    func timeString(time:TimeInterval)-> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func startCountDown(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    
    //Buat Progress Bar
    func setUpProgressBar() {
        let circularPath = UIBezierPath(arcCenter: view.center, radius: 147, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi * 2, clockwise: true)
        let trackLayer = CAShapeLayer()
        
        //background
        trackLayer.path = circularPath.cgPath
        view.layer.addSublayer(trackLayer)
        trackLayer.strokeColor = #colorLiteral(red: 0.7803921569, green: 0.8392156863, blue: 0.8784313725, alpha: 1)
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 20
        
        trackLayer.position = CGPoint(x: 0 , y: -50)
        
        shapeLayer.path = circularPath.cgPath
        
        view.layer.addSublayer(shapeLayer)

        //loading
        shapeLayer.strokeColor = #colorLiteral(red: 0.2117647059, green: 0.3137254902, blue: 0.4235294118, alpha: 1)
        shapeLayer.strokeEnd = 0
        shapeLayer.lineWidth = 20
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        
        shapeLayer.position = CGPoint(x: 0 , y: -50)   
    }

    
    private func animate(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        shapeLayer.speed = 1.0
        shapeLayer.timeOffset = 0.0
        shapeLayer.beginTime = 0.0

        basicAnimation.toValue = 1
        basicAnimation.duration = 13
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
            performSegue(withIdentifier: "completeSegue", sender: nil)
            resetTimer()
            return
        }
        
        let utterance = AVSpeechUtterance(string: instruction[currIndex].instructionText ?? "no text")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.4
        
        synthesizer.speak(utterance)

        
        
        //array of instruction(durasi, object suara)
        
        //current index of instruction. duration -= 1
        //if currentindex of instruction == 0
        //update new current index of instruction
        
        //https://developer.apple.com/documentation/avfaudio/avaudioplayer/1389363-pause
        
        seconds -= 1
        TimerLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    
    
    

    


}

