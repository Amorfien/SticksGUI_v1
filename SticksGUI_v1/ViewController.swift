//
//  ViewController.swift
//  SticksGUI_v1
//
//  Created by Pavel Grigorev on 30.09.2022.
//

import UIKit

class ViewController: UIViewController {

    var customs = Custom()
    var game = Game()
    var labelText = ""

    @IBOutlet weak var emojiPicker: UIPickerView!
    @IBOutlet weak var sticksLabel: UILabel!

    @IBOutlet weak var minusCountLabel: UILabel!
    @IBOutlet weak var plusCountLabel: UILabel! {
        didSet {
            plusCountLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
    }

    @IBOutlet weak var plusButton: UIButton! {
        didSet {
            plusButton.layer.cornerRadius = 25
            plusButton.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var minusButton: UIButton! {
        didSet {
            minusButton.layer.cornerRadius = 25
            minusButton.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var startButtonPl1: UIButton! {
        didSet {
            startButtonPl1.layer.cornerRadius = 5
            startButtonPl1.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var startButtonPl2: UIButton! {
        didSet {
            startButtonPl2.layer.cornerRadius = 5
            startButtonPl2.layer.borderWidth = 1
            startButtonPl2.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
    }
    @IBOutlet weak var pl1Stack: UIStackView! {
        didSet {
            pl1Stack.layer.cornerRadius = 10
            pl1Stack.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var pl2Stack: UIStackView! {
        didSet {
            pl2Stack.layer.cornerRadius = 10
            pl2Stack.layer.borderWidth = 1
            pl2Stack.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
    }
    @IBOutlet var number3: [UIButton]!
    @IBOutlet var number2_3: [UIButton]!

    @IBOutlet weak var movingView: UIView!
    @IBOutlet weak var movingBtn: UIButton!

    @IBOutlet weak var ai1: UIStackView!
    @IBOutlet weak var ai2: UIStackView!
    @IBOutlet weak var ai1_switch: UISwitch!
    @IBOutlet weak var ai2_switch: UISwitch! {
        didSet {
            ai2.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
    @IBOutlet weak var movingSticks: UILabel! {
        didSet {
            movingSticks.alpha = 0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        movingView.layer.cornerRadius = 15
        movingView.layer.borderWidth = 1
        movingView.layer.shadowColor = UIColor.black.cgColor
        movingView.layer.shadowOpacity = 1
        movingView.layer.shadowOffset = .zero
        movingView.layer.shadowRadius = 4

        emojiPicker.dataSource = self
        emojiPicker.delegate = self

        welcome()
        addTap()

    }

    @IBAction func plusButtonAction(_ sender: UIButton) {
        guard game.sticksCount < game.maxCount else { return }
        game.sticksCount += 1
        labelReload()
        UIView.animate(withDuration: 1) {
            self.minusButton.titleLabel?.alpha = 0.1
            self.plusButton.titleLabel?.alpha = 0.1
            self.minusCountLabel.alpha = 1
            self.plusCountLabel.alpha = 1
        }
        UIView.animate(withDuration: 1) {
            self.minusButton.titleLabel?.alpha = 1
            self.plusButton.titleLabel?.alpha = 1
            self.minusCountLabel.alpha = 0
            self.plusCountLabel.alpha = 0
        }
    }
    @IBAction func minusButtonAction(_ sender: UIButton) {
        guard game.sticksCount > game.minCount else { return }
        game.sticksCount -= 1
        labelReload()
        UIView.animate(withDuration: 1) {
            self.minusButton.titleLabel?.alpha = 0.1
            self.plusButton.titleLabel?.alpha = 0.1
            self.minusCountLabel.alpha = 1
            self.plusCountLabel.alpha = 1
        }
        UIView.animate(withDuration: 1) {
            self.minusButton.titleLabel?.alpha = 1
            self.plusButton.titleLabel?.alpha = 1
            self.minusCountLabel.alpha = 0
            self.plusCountLabel.alpha = 0
        }
    }

    @IBAction func pl1Start(_ sender: UIButton) {
        game.player1Choise = true
        game.startCount = game.sticksCount
        gameStart(player: sender)
    }
    @IBAction func pl2Start(_ sender: UIButton) {
        game.player1Choise = false
        game.startCount = game.sticksCount
        gameStart(player: sender)
    }

    @IBAction func pl1choice(_ sender: UIButton) {
        let move: Int = Int((sender.titleLabel?.text)!)!
        game.sticksCount -= move
        labelReload()

        animateChoice(sender: sender, player: 1)

        print("Player 1 takes \(move) sticks")
        print("Походил игрок " + (game.player1Choise ? "1" : "2"))
        if !game.player2AI {
            check()
        } else {
//            Вот тут нужно принудительно перерисовывать Label -------------------------
            sticksLabel.text = labelText
            print(labelText, game.sticksCount)

//            updateFocusIfNeeded()
//            setNeedsFocusUpdate()
//            viewWillAppear(false)
//
//            DispatchQueue.main.async {
//                self.sticksLabel.text = self.labelText
//            }

//            view.backgroundColor = .red
//
//            sticksLabel.setNeedsDisplay()
//            sticksLabel.setNeedsLayout()
//            sticksLabel.layoutIfNeeded()
//            sticksLabel.layoutSubviews()
//            view.reloadInputViews()
//
//            view.setNeedsDisplay()
//            view.setNeedsLayout()
//            view.layoutIfNeeded()
//            view.layoutSubviews()

            check()
            ai2move()
        }
    }
    @IBAction func pl2choice(_ sender: UIButton) {
        let move: Int = Int((sender.titleLabel?.text)!)!
        game.sticksCount -= move
        labelReload()

        animateChoice(sender: sender, player: 2)

        print("Player 2 takes \(move) sticks")
        print("Походил игрок " + (game.player1Choise ? "1" : "2"))
        if !game.player1AI {
            check()
        } else {
            check()
            ai1move()
        }
    }

    @IBAction func movingMenuButton(_ sender: UIButton) {
        switch customs.hideMenu {
        case true:
            UIView.animate(withDuration: 0.4) {
                self.movingView.transform = CGAffineTransform(translationX: -110, y: 0)
            }
            sender.setTitle("▶︎", for: .normal)
            customs.hideMenu.toggle()
        default:
            UIView.animate(withDuration: 0.4) {
                self.movingView.transform = CGAffineTransform(translationX: 0, y: 0)

            }
            sender.setTitle("◀︎", for: .normal)
            customs.hideMenu.toggle()
        }
    }
    @IBAction func ai1Switch(_ sender: UISwitch) {
        game.player1AI.toggle()
    }
    @IBAction func ai2Switch(_ sender: UISwitch) {
        game.player2AI.toggle()
    }

    func addTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnView))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }
    @objc
    func tapOnView() {
        if !customs.hideMenu { movingMenuButton(movingBtn) }
    }


//    MARK: - WELCOME!

    func welcome() {
        game.moves = 0
        game.sticksCount = 21
        game.maxAI = 3
        game.startCount = game.sticksCount
        movingSticks.isHidden = false

        labelReload()

        emojiPicker.isHidden = false

        pl1Stack.isHidden = true
        pl2Stack.isHidden = true

        minusCountLabel.alpha = 0
        plusCountLabel.alpha = 0

        startButtonPl1.isEnabled = true
        startButtonPl2.isEnabled = true
        plusButton.isEnabled = true
        plusButton.alpha = 1
        minusButton.isEnabled = true
        minusButton.alpha = 1

        ai1.isHidden = false
        ai2.isHidden = false

        movingBtn.isEnabled = true
        movingView.alpha = 0.92

        for nums in number2_3 {nums.isEnabled = true}
        for nums in number3 {nums.isEnabled = true}

        movingSticks.alpha = 0

    }

    //    MARK: - Label Reload

    func labelReload() {
        game.char = customs.emojis[emojiPicker.selectedRow(inComponent: 0)]
        game.sticks = Array(repeating: game.char, count: game.sticksCount)
        labelText = game.sticks.joined(separator: "\u{202F}")//узкий пробел
        sticksLabel.text = labelText
        movingSticks.text = game.char
        movingSticks.transform = CGAffineTransform(translationX: 0, y: 0)
        plusCountLabel.text = String(game.sticksCount)
        minusCountLabel.text = String(game.sticksCount)
    }

    func backgoundUpd() {
        switch emojiPicker.selectedRow(inComponent: 1) {
        case 0: view.backgroundColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
        case 1: view.backgroundColor = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
        case 2: view.backgroundColor = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
        case 3: view.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        default:
            view.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        }
    }

    func gameStart(player: UIButton) {

        labelReload()
        emojiPicker.isHidden = true

        startButtonPl1.isEnabled = false
        startButtonPl2.isEnabled = false
        plusButton.isEnabled = false
        minusButton.isEnabled = false
        plusButton.alpha = 0.3
        minusButton.alpha = 0.3
        if player.tag == 1 {
            game.player1Choise = true
            if !game.player1AI {
                pl1Stack.isHidden = false
                pl2Stack.isHidden = true
            } else {
                ai1move()
                pl1Stack.isHidden = true
            }

        } else if player.tag == 2 {
            game.player1Choise = false
            if !game.player2AI {
                pl1Stack.isHidden = true
                pl2Stack.isHidden = false
            } else {
                ai2move()
                pl2Stack.isHidden = true
            }
        }

        ai1.isHidden = true
        ai2.isHidden = true

        if !customs.hideMenu { movingMenuButton(movingBtn) }
        movingBtn.isEnabled = false
        movingView.alpha = 0.4

        if game.player1AI || game.player2AI {
            movingSticks.isHidden = true
        }
    }

    //    MARK: - CHECK

    func check() {
        switch game.sticksCount {
        case 0: gameover()
        case 1: for nums in number2_3 {nums.isEnabled = false}; game.maxAI = 1
        case 2: for nums in number3 {nums.isEnabled = false}; game.maxAI = 2
        default: break
        }
        guard game.sticksCount != 0 else {return}
        game.moves += 1
        game.player1Choise.toggle()
        if !game.player1AI || !game.player2AI {
            pl1Stack.isHidden.toggle()
            pl2Stack.isHidden.toggle()
        }
    }

    //    MARK: - GameOver

    func gameover () {
        pl1Stack.isHidden = true
        pl2Stack.isHidden = true
        let looser = game.player1Choise ? 1 : 2
        print("Looser: \(looser)\n")
        let gameoverAlert = UIAlertController(title: "GameOver", message: "\nPLAYER \(looser)\n YOU LOSE!\n\n Sticks: \(game.startCount)\n Moves: \(game.moves + 1)", preferredStyle: .alert)
        let okbtn = UIAlertAction(title: "OK", style: .default) {_ in self.welcome()}
        gameoverAlert.addAction(okbtn)
        if looser == 1 {
            present(gameoverAlert, animated: true)
        } else {
            present(gameoverAlert, animated: true) {
                gameoverAlert.view.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        }
    }

    func ai1move() {
        guard game.sticksCount > 0 else { return }
        let rand = Int.random(in: 1...game.maxAI)
        game.sticksCount -= rand
        let aiTimer = UInt32.random(in: 1...3)
        sleep(aiTimer)
        labelReload()
        print("AI_1 takes \(rand) sticks")
        if game.player2AI && game.sticksCount > 0 {
            check()
            ai2move()
        } else if game.player2AI && game.sticksCount == 0 {
            gameover()
        } else {
            check()
        }
    }
    func ai2move() {
        guard game.sticksCount > 0 else { return }
        let rand = Int.random(in: 1...game.maxAI)
        game.sticksCount -= rand
        let aiTimer = UInt32.random(in: 1...3)
        sleep(aiTimer)
        labelReload()
        print("AI_2 takes \(rand) sticks")
        if game.player1AI && game.sticksCount > 0 {
            check()
            ai1move()
        } else if game.player1AI && game.sticksCount == 0 {
            gameover()
        } else {
            check()
        }
    }

    func animateChoice (sender: UIButton, player: Int){
        movingSticks.text = game.char

        let array = Array(repeating: game.char, count: Int((sender.titleLabel?.text)!)!)
        movingSticks.text = array.joined(separator: "\u{202F}")

        movingSticks.transform = CGAffineTransform(translationX: 0, y: 0)
        movingSticks.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        UILabel.animate(withDuration: 0.7){
            switch player {
            case 1:
                self.movingSticks.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height / 2.2)//203)
                self.movingSticks.alpha = 1
            case 2:
                self.movingSticks.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height / -2.2)
                self.movingSticks.alpha = 1
            default: return
            }
        }
    }
}

// MARK: - PickerView

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 2 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return customs.emojis.count
        default:
            return customs.colors.count
        }
    }
}
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return customs.emojis[row]
        default:
            return customs.colors[row]
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

