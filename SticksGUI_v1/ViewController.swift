//
//  ViewController.swift
//  SticksGUI_v1
//
//  Created by Pavel Grigorev on 30.09.2022.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var emojiPicker: UIPickerView!
    @IBOutlet weak var sticksLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!

    @IBOutlet weak var startButtonPl1: UIButton!
    @IBOutlet weak var startButtonPl2: UIButton!

    @IBOutlet weak var pl1Stack: UIStackView!
    @IBOutlet weak var pl2Stack: UIStackView!

    @IBOutlet var number3: [UIButton]!
    @IBOutlet var number2_3: [UIButton]!

    @IBOutlet weak var movingView: UIView!
    @IBOutlet weak var movingBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        plusButton.layer.cornerRadius = 25
        minusButton.layer.cornerRadius = 25
        movingView.layer.cornerRadius = 15
        movingView.layer.borderWidth = 1
        movingView.layer.shadowColor = UIColor.black.cgColor
        movingView.layer.shadowOpacity = 1
        movingView.layer.shadowOffset = .zero
        movingView.layer.shadowRadius = 4

//        emojiPicker.layer.borderWidth = 1
        emojiPicker.dataSource = self
        emojiPicker.delegate = self

        startButtonPl2.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        pl2Stack.transform = CGAffineTransform(rotationAngle: CGFloat.pi)

        welcome()

    }

    @IBAction func plusButtonAction(_ sender: UIButton) {
        guard sticksCount < maxCount else { return }
        sticksCount += 1
        labelReload()
    }

    @IBAction func minusButtonAction(_ sender: UIButton) {
        guard sticksCount > minCount else { return }
        sticksCount -= 1
        labelReload()
    }

    @IBAction func pl1Start(_ sender: UIButton) {
        gameStart(player: sender)
        player1Choise = true
        startCount = sticksCount
    }
    @IBAction func pl2Start(_ sender: UIButton) {
        gameStart(player: sender)
        player1Choise = false
        startCount = sticksCount
    }

    @IBAction func pl1choice(_ sender: UIButton) {
        guard isGaming else {return}
        sticksCount -= Int((sender.titleLabel?.text)!)!
        labelReload()
        check()
        changePlayer()
    }
    @IBAction func pl2choice(_ sender: UIButton) {
        guard isGaming else {return}
        sticksCount -= Int((sender.titleLabel?.text)!)!
        labelReload()
        check()
        changePlayer()
    }

    @IBAction func moving(_ sender: UIButton) {
        switch hideMenu {
        case true:
            movingView.transform = CGAffineTransform(translationX: -120, y: 0)
            sender.setTitle("▶︎", for: .normal)
            hideMenu.toggle()
        default:
            movingView.transform = CGAffineTransform(translationX: 0, y: 0)
            sender.setTitle("◀︎", for: .normal)
            hideMenu.toggle()
        }

    }

    func labelReload() {
        char = emojis[emojiPicker.selectedRow(inComponent: 0)]
        sticks = Array(repeating: char, count: sticksCount)
        sticksLabel.text = sticks.joined(separator: "\u{202F}")//узкий пробел
    }

    func backgoundUpd() {
        switch emojiPicker.selectedRow(inComponent: 1) {
        case 0: view.backgroundColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
        case 1: view.backgroundColor = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
        case 2: view.backgroundColor = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
        default:
            view.backgroundColor = .systemGray6
        }
    }

    func welcome() {
        //        guard !isGaming else {return}
        sticksCount = 21
        labelReload()

        emojiPicker.isHidden = false

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

        movingBtn.isEnabled = true
        movingView.alpha = 0.92

        for nums in number2_3 {nums.isEnabled = true}
        for nums in number3 {nums.isEnabled = true}
    }

    func gameStart(player: UIButton) {

        labelReload()
        emojiPicker.isHidden = true

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
        if !hideMenu { moving(movingBtn) }
        movingBtn.isEnabled = false
        movingView.alpha = 0.4
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
        let gameoverAlert = UIAlertController(title: "GameOver", message: "\nPLAYER \(looser)\n YOU LOSE!\n\n Sticks: \(startCount)\n Moves: \(moves + 1)", preferredStyle: .alert)
        let okbtn = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        gameoverAlert.addAction(okbtn)
        if looser == 1 {
            present(gameoverAlert, animated: true)
        } else {
            present(gameoverAlert, animated: true,  completion: {() -> Void in
                gameoverAlert.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi)})
        }
        moves = 0
        welcome()
    }

    func changePlayer() {
        guard isGaming else { return }
        player1Choise.toggle()
        moves += 1
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
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 2 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return emojis.count
        default:
            return colors.count
        }
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return emojis[row]
        default:
            return colors[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            labelReload()
        default:
            backgoundUpd()
        }
    }
}

