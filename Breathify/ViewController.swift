//
//  ViewController.swift
//  Breathify
//
//  Created by Hannatassja Hardjadinata on 27/04/21.
//

import UIKit
import Foundation
import AVFoundation
import AudioToolbox


class ViewController: UIViewController {

    
    @IBOutlet weak var TimerLabel: UILabel!
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    let shapeLayer = CAShapeLayer()
    
    var seconds = 124
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    var instruction : [Instruction] = []
    var currIndex = 0
    var duration = 0
    
    var player: AVAudioPlayer?
    
    
    let defaults = UserDefaults.standard
    let synthesizer = AVSpeechSynthesizer()
    
    var isSound = true;
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProgressBar()
        let stringValue = TimerLabel.text
        let attrString = NSMutableAttributedString(string: stringValue!)
        attrString.addAttribute(NSAttributedString.Key.kern, value: 5, range: NSMakeRange(0, attrString.length))
        TimerLabel.attributedText = attrString
        TimerLabel.text = timeString(time: TimeInterval(seconds))
        
        let instructionString = instructionLabel.text
        let attrInstruction = NSMutableAttributedString(string: instructionString!)
        attrInstruction.addAttribute(NSAttributedString.Key.kern, value: 7, range: NSMakeRange(0, attrInstruction.length))
        instructionLabel.attributedText = attrInstruction
        
        instructionLabel.isHidden = true;
        
        instructionLabel.numberOfLines = 0
        
       instruction = [
        Instruction(instructionText: "Keep your back straight", instructionDuration: 5),
        Instruction(instructionText: "Lower your \nchin toward your chest", instructionDuration: 10),
        Instruction(instructionText: "Slowly lift \nyour head back up", instructionDuration: 5),
        Instruction(instructionText: "Tilt your chin \nup toward the ceiling", instructionDuration: 5),
        Instruction(instructionText: "Bring the \nbase of your skull toward your back", instructionDuration: 10),
        Instruction(instructionText: "Lower your \nhead to \na normal \nposition", instructionDuration: 5),
        Instruction(instructionText: "Inhale slowly through your nose", instructionDuration: 10),
        Instruction(instructionText: "Keep your mouth close", instructionDuration: 3),
        Instruction(instructionText: "Pucker \nyour lips", instructionDuration: 5),
        Instruction(instructionText: "Exhale slowly and gently through your pursed lips", instructionDuration: 10),
        Instruction(instructionText: "Inhale slowly through your nose", instructionDuration: 10),
        Instruction(instructionText: "Keep your mouth close", instructionDuration: 3),
        Instruction(instructionText: "Pucker \nyour lips", instructionDuration: 5),
        Instruction(instructionText: "Exhale slowly and gently through your pursed lips", instructionDuration: 10),
        Instruction(instructionText: "Inhale slowly through your nose", instructionDuration: 10),
        Instruction(instructionText: "Keep your mouth close", instructionDuration: 3),
        Instruction(instructionText: "Pucker \nyour lips", instructionDuration: 5),
        Instruction(instructionText: "Exhale slowly and gently through your pursed lips", instructionDuration: 10),
       ]
        
//        defaults.removeObject(forKey: "soundSwitch")
//        print("data setting", defaults.object(forKey: "soundSwitch"))

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
                
                
                
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.startCountDown()
                self.animate()
                self.isTimerRunning = true;
                self.resumeTapped = false;
                self.cancelButton.isEnabled = true;
                self.startButton.setImage(UIImage(named: "pauseButton.png"), for: .normal)
                
                let utterance = self.isSound == true  ? AVSpeechUtterance(string: self.instruction[self.currIndex].instructionText ?? "") : AVSpeechUtterance(string: "")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                utterance.rate = 0.4
                
                self.synthesizer.speak(utterance)
                self.instructionLabel.text = self.instruction[self.currIndex].instructionText
                
                self.duration = self.instruction[self.currIndex].instructionDuration!
            }
        } else {
            if(resumeTapped == true){
                resumeTapped = false
                isTimerRunning = true
                startCountDown()
                startButton.setImage(UIImage(named: "pauseButton.png"), for: .normal)
                resumeAnimation()
                synthesizer.continueSpeaking();
                return
            }   
            isTimerRunning = false;
            resumeTapped =  true;
            timer.invalidate()
            startButton.setImage(UIImage(named: "resumeButton.png"), for: .normal)
            pauseAnimation()
            synthesizer.pauseSpeaking(at: AVSpeechBoundary.immediate)
 
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        let alert = UIAlertController(title: "Do you want to stop the timer?", message: "You cannot undo this action", preferredStyle: UIAlertController.Style.alert)

                // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.destructive, handler: {action in  self.resetTimer() }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

                // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func resetTimer(){
        timer.invalidate()
        seconds = 124
        currIndex = 0
        TimerLabel.text = timeString(time: TimeInterval(seconds))
        
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        
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
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        //jangan dihapus ya, kepake untuk segue back ke main
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(defaults.object(forKey: "soundSwitch") != nil){
            isSound = UserDefaults.standard.bool(forKey: "soundSwitch")
            print("sound nil",isSound)
        }
        
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
        basicAnimation.duration = 158
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
        
        duration -= 1
        print("index", currIndex)
        
        
        if duration == 0  && currIndex < instruction.count-1 {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            duration = instruction[currIndex].instructionDuration!
            currIndex += 1
            let utterance = isSound == true  ? AVSpeechUtterance(string: instruction[currIndex].instructionText ?? "") : AVSpeechUtterance(string: "")
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.4
            
            synthesizer.speak(utterance)
            
            instructionLabel.text = instruction[currIndex].instructionText
            
            
            
        }
        
//        print("duration", instruction[currIndex].instructionDuration)

        
        seconds -= 1
        TimerLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    
    
    

    


}

