//
//  ViewController.swift
//  SticksGUI_v1
//
//  Created by Pavel Grigorev on 30.09.2022.
//

import UIKit

var sticksCount: Int = 9
let char: Character = "🌼"
var sticks: [Character] = []
var isGaming = false
var player1Choise = true

class ViewController: UIViewController {

    @IBOutlet weak var sticksLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!

    @IBOutlet weak var startButtonPl1: UIButton!
    @IBOutlet weak var startButtonPl2: UIButton!

    @IBOutlet weak var pl1Stack: UIStackView!
    @IBOutlet weak var pl2Stack: UIStackView!

    @IBOutlet var number3: [UIButton]!

    @IBOutlet var number2_3: [UIButton]!


    override func viewDidLoad() {
        super.viewDidLoad()

        plusButton.layer.cornerRadius = 25
        minusButton.layer.cornerRadius = 25

        startButtonPl2.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        pl2Stack.transform = CGAffineTransform(rotationAngle: CGFloat.pi)

        welcome()

    }

    @IBAction func plusButtonAction(_ sender: UIButton) {
        guard sticksCount < 25 else { return }
        sticksCount += 1
        sticks = Array(repeating: char, count: sticksCount)
        sticksLabel.text = String(sticks)
    }

    @IBAction func minusButtonAction(_ sender: UIButton) {
        guard sticksCount > 5 else { return }
        sticksCount -= 1
        sticks = Array(repeating: char, count: sticksCount)
        sticksLabel.text = String(sticks)
    }

    func welcome() {
//        guard !isGaming else {return}
        sticksCount = 21
        sticks = Array(repeating: char, count: sticksCount)
        sticksLabel.text = String(sticks)

        pl1Stack.isHidden = true
        pl2Stack.isHidden = true
        pl1Stack.layer.cornerRadius = 10
        pl2Stack.layer.cornerRadius = 10
        pl1Stack.layer.borderWidth = 1
        pl2Stack.layer.borderWidth = 1

        startButtonPl1.isEnabled = true
        startButtonPl2.isEnabled = true
        plusButton.isEnabled = true
        minusButton.isEnabled = true
        plusButton.alpha = 1
        minusButton.alpha = 1
        plusButton.layer.borderWidth = 1
        minusButton.layer.borderWidth = 1

        for nums in number2_3 {nums.isEnabled = true}
        for nums in number3 {nums.isEnabled = true}
    }

    func gameStart(player: UIButton) {
        isGaming = true
        startButtonPl1.isEnabled = false
        startButtonPl2.isEnabled = false
        plusButton.isEnabled = false
        minusButton.isEnabled = false
        plusButton.alpha = 0.3
        minusButton.alpha = 0.3
        if player.tag == 1 {
            pl1Stack.isHidden = false
            pl2Stack.isHidden = true

        } else if player.tag == 2 {
            pl1Stack.isHidden = true
            pl2Stack.isHidden = false
        }
    }

    func check() {
        switch sticksCount {
        case 0: gameover()
        case 1: for nums in number2_3 {nums.isEnabled = false}
        case 2: for nums in number3 {nums.isEnabled = false}
        default: break
        }
    }
    func gameover () {
        isGaming = false
        let looser = player1Choise ? 1 : 2
        let gameoverAlert = UIAlertController(title: "GameOver", message: "Player \(looser) lost", preferredStyle: .alert)
        let okbtn = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        gameoverAlert.addAction(okbtn)
        if looser == 1 {
            present(gameoverAlert, animated: true)
        } else {
            present(gameoverAlert, animated: true,  completion: {() -> Void in
                gameoverAlert.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi)})
        }

        welcome()
    }

    func changePlayer() {
        guard isGaming else { return }
        player1Choise.toggle()
//        pl1Stack.isHidden.toggle()
//        pl2Stack.isHidden.toggle()
        if player1Choise {
            pl1Stack.isHidden = false
            pl2Stack.isHidden = true
        } else {
            pl1Stack.isHidden = true
            pl2Stack.isHidden = false
        }
    }

    @IBAction func pl1Start(_ sender: UIButton) {
        gameStart(player: sender)
        player1Choise = true
    }
    @IBAction func pl2Start(_ sender: UIButton) {
        gameStart(player: sender)
        player1Choise = false
    }


    @IBAction func pl1choice(_ sender: UIButton) {
        guard isGaming else {return}
        sticksCount -= Int((sender.titleLabel?.text)!)!
        sticks = Array(repeating: char, count: sticksCount)
        sticksLabel.text = String(sticks)
        check()
        changePlayer()
    }


    @IBAction func pl2choice(_ sender: UIButton) {
        guard isGaming else {return}
        sticksCount -= Int((sender.titleLabel?.text)!)!
        sticks = Array(repeating: char, count: sticksCount)
        sticksLabel.text = String(sticks)
        check()
        changePlayer()
    }


}

