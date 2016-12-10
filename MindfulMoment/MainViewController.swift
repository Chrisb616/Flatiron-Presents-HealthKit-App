//
//  ViewController.swift
//  Flatiron Presents Health Kit App
//
//  Created by Christopher Boynton on 10/24/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import HealthKit
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let healthStore = HealthManager.healthStore
    let store = DataStore.sharedInstance
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    let startButtonTapGesture = UIGestureRecognizer()
    
    @IBOutlet weak var pastButton: UIButton!
    @IBOutlet weak var pastMindfulnessSessionLabel: UILabel!
    
    let timerLabel = UILabel()
    let meditationSavedLabel = UILabel()
    
    var countIsActive = false
    
    var timer = Timer()
    var secondsInTime = 0
    
    var startTime = Date()
    var endTime = Date()
    
    @IBOutlet weak var mountain: UIImageView!
    @IBOutlet weak var mountain2: UIImageView!
    @IBOutlet weak var mountain3: UIImageView!
    @IBOutlet weak var openingMoon: UIImageView!
    
    var sessions = [Session]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        moveMountain()
        
        let queue = OperationQueue()
        
        queue.addOperation {
            HealthManager.setUpHealthStore()
        }
        
        print("View Did load")
        
        self.view.layoutIfNeeded()
        
        store.getMeditationsFromHeath {}
    }
    
    
    func setUpViews() {
        print(startButton.allTargets)
        startButton.layer.cornerRadius = 10
        startButton.layer.borderColor = UIColor.purpleMountain.cgColor
        startButton.layer.borderWidth = 3
        startButton.layer.shadowColor = UIColor.black.cgColor
        startButton.layer.shadowOpacity = 1
        startButton.layer.shadowOffset = CGSize(width: 2, height: 5)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        print(startButton.allTargets)
        startButton.addSubview(startLabel)
        
        
        self.view.addSubview(timerLabel)
        timerLabel.text = "00:00"
        timerLabel.textAlignment = .center
        timerLabel.textColor = UIColor.greenYellow
        timerLabel.font = UIFont.timerLabelFont
        timerLabel.frame = CGRect(x: 0, y: self.view.frame.midY * 1.25, width: self.view.frame.width, height: self.view.frame.height * 0.2)
        timerLabel.alpha = 0
        
        self.view.addSubview(meditationSavedLabel)
        meditationSavedLabel.text = "Session Saved"
        meditationSavedLabel.textAlignment = .center
        meditationSavedLabel.textColor = UIColor.greenYellow
        meditationSavedLabel.font = UIFont.smallTextFont
        meditationSavedLabel.frame = CGRect(x: 0, y: self.view.frame.midY * 1.35, width: self.view.frame.width, height: self.view.frame.height * 0.2)
        meditationSavedLabel.alpha = 0
        
        pastButton.layer.cornerRadius = 10
        pastButton.layer.borderColor = UIColor.purpleMountain.cgColor
        pastButton.layer.borderWidth = 3
        pastButton.layer.shadowColor = UIColor.black.cgColor
        pastButton.layer.shadowOpacity = 1
        pastButton.layer.shadowOffset = CGSize(width: 2, height: 5)
        pastButton.addSubview(pastMindfulnessSessionLabel)
        pastButton.addTarget(self, action: #selector(pastButtonTapped), for: .touchUpInside)
    }
    
    func moveMountain(){
        UIView.animate(withDuration: 5) {
            self.mountain.transform = CGAffineTransform(translationX: 0, y: 150)
            self.mountain2.transform = CGAffineTransform(translationX: 0, y: 200)
            self.mountain3.transform = CGAffineTransform(translationX: 0, y: 200)
            self.openingMoon.transform = CGAffineTransform(translationX: 0, y: -20)
        }
    }
    
    func startButtonTapped(_ sender: UIButton) {
        if countIsActive {
            countIsActive = false
            
            print("Stop Button Tapped")
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            startLabel.text = "Start"
            
            UIView.animate(withDuration: 0.5, animations: {
                sender.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.pastButton.alpha = 1
                self.view.layoutIfNeeded()
            })
            
            
            endTimer()
            HealthManager.saveMeditation(start: startTime, end: endTime)
            
        } else {
            print("Start Button Tapped")
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            startLabel.text = "Stop"
            
            UIView.animate(withDuration: 0.5, animations: {
                sender.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.pastButton.alpha = 0
                self.view.layoutIfNeeded()
            })
            
            countIsActive = true
            startTimer()
        }
        
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        startTime = Date()
        timerLabel.text = "00:00"
        meditationSavedLabel.alpha = 0
        
        
        UIView.animateKeyframes(withDuration: 5, delay: 0, options: [.calculationModeCubic], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 2/5, animations: {
                self.timerLabel.alpha = 1
                self.timerLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            })
            UIView.addKeyframe(withRelativeStartTime: 3/5, relativeDuration: 2/5, animations: {
                self.timerLabel.alpha = 0
            })
        })
    }
    func endTimer() {
        timer.invalidate()
        endTime = Date()
        secondsInTime = 0
        timerLabel.alpha = 1
        meditationSavedLabel.alpha = 1
        
        UIView.animateKeyframes(withDuration: 5, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 4/5, relativeDuration: 1/5, animations: {
                self.timerLabel.alpha = 0
            })
        })
    }
    func updateTime(_ sender: Timer) {
        secondsInTime += 1
        timerLabel.text = secondsInTime.convertedToTime
    }
    func pastButtonTapped() {
        print("Past Button Tapped")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sessionCell", for: indexPath)
        
        return cell
    }
}

extension Int {
    var convertedToTime: String {
        let seconds = self % 60
        let minutes = (self - seconds)/60
        
        return "\(minutes.forceTwoDigits):\(seconds.forceTwoDigits)"
    }
    var forceTwoDigits: String {
        if self < 10 {
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
}

    
    
    