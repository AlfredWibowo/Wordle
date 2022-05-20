//
//  ViewController.swift
//  UTS_iOS_C14190016
//
//  Created by iOS on 02/04/22.
//

import UIKit

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension UIViewController {

    func showToast(message : String, font: UIFont, color: UIColor) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height/2, width: 170, height: 55))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = color
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 7.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }

class ViewController: UIViewController {
    
    let _arrBankSoal = ["APPLE", "PLANE", "HOUSE", "CHAIR", "TABLE", "GLASS", "PHONE", "SAUCE", "LEMON", "MELON"]
    let _truePosColor = UIColor.green
    let _wrongPosColor = UIColor.orange
    let _defaultColor = UIColor.darkGray
    let _wrongColor = UIColor.red
    
    @IBOutlet var _arrLabelWordle: [UILabel]!
    @IBOutlet weak var _labelTimer: UILabel!
    @IBOutlet var _arrBtnKeyboard: [UIButton]!
    
    var rightGuess: String! = ""
    var currentGuess: String! = ""
    var guessRemaining: Int! = 5
    
    var timer: Timer! = Timer()
    var timeInSec: Int! = 0
    
    var counter: Int! = 0
    
    var isWin: Bool! = false
    var isLose: Bool! = false
    var stopTyping: Bool! = false
    var correctGuessCount: Int! = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        rightGuess = _arrBankSoal[Int.random(in: 0..._arrBankSoal.count-1)]
        print(rightGuess!)
        
        for btn in _arrBtnKeyboard {
            btn.titleLabel!.numberOfLines = 1
            btn.titleLabel!.adjustsFontSizeToFitWidth = true
            btn.titleLabel!.lineBreakMode = .byClipping
        }
        
        startTimer()
    }
    
    @IBAction func btnKeyboardAction(_ sender: UIButton) {
        
        if !isLose || !isWin {
            let letter = sender.titleLabel!.text!
            switch letter {
            case "⌫":
                if currentGuess.count > 0 {
                    counter -= 1
                    _arrLabelWordle[counter].text = ""
                    currentGuess.removeLast()
                    
                    if stopTyping {
                        stopTyping = false
                    }
                }
                
            case "↵":
                if currentGuess.count == 5 {
                    
                    var cnt = counter - 5
                    for i in rightGuess.indices {
                        if currentGuess[i] == rightGuess [i] {
                            _arrLabelWordle[cnt].backgroundColor = _truePosColor
                            correctGuessCount += 1
                        }
                        else {
                            if rightGuess.contains(currentGuess[i]) {
                                _arrLabelWordle[cnt].backgroundColor = _wrongPosColor
                            }
                            else {
                                _arrLabelWordle[cnt].backgroundColor = _wrongColor
                            }
                        }
                        cnt += 1
                    }
                    
                    if correctGuessCount == 5 {
                        isWin = true
                        self.showToast(message: "You Win!!!", font: .systemFont(ofSize: 30.0), color: UIColor.green)
                        stopTimer()
                    }
                    else {
                        guessRemaining -= 1
                        stopTyping = false
                        currentGuess = ""
                        correctGuessCount = 0
                        
                        if guessRemaining == 0 {
                            isLose = true
                            self.showToast(message: "You Lose!!!", font: .systemFont(ofSize: 30.0), color: UIColor.red)
                            stopTimer()
                        }
                    }
                }
                
            default:
                if !stopTyping {
                    if counter < _arrLabelWordle.count {
                        _arrLabelWordle[counter].text = letter
                        currentGuess += letter
                        counter += 1
                    }
                    
                    if currentGuess.count == 5 {
                        stopTyping = true
                    }
                }
            }
        }
        
    }
    
    @IBAction func btnNewGameAction(_ sender: UIButton) {
        newGame()
    }
    
    func clearLabelWordle() {
        for label in _arrLabelWordle {
            label.text = ""
            label.backgroundColor = _defaultColor
        }
    }
    
    func newGame() {
        clearLabelWordle()
        rightGuess = _arrBankSoal[Int.random(in: 0..._arrBankSoal.count-1)]
        print(rightGuess!)
        _labelTimer.text = "00:00:00"
        currentGuess = ""
        stopTimer()
        timer = Timer()
        startTimer()
        timeInSec = 0
        counter = 0
        isWin = false
        isLose = false
        stopTyping = false
        correctGuessCount = 0
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func getTimeString(seconds: Int) -> String {
        let hours =  timeInSec / 3600
        let minutes = (timeInSec % 3600) / 60
        let seconds = timeInSec % 3600 % 60
        
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += ":"
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        
        return timeString
    }
    
    @objc func updateTimer() {
        timeInSec += 1
        
        _labelTimer.text = getTimeString(seconds: timeInSec)
        
        if timeInSec == 24 * 3600 {
            timeInSec = 0
        }
    }
}

