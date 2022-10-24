//
//  Game.swift
//  SticksGUI_v1
//
//  Created by Pavel Grigorev on 22.10.2022.
//

import Foundation

struct Game {
    var sticksCount: Int = 21
    let maxCount = 26
    let minCount = 7
    var startCount = 0
    var moves = 0
    var char: String = "🌼"
    var sticks: [String] = []
    var player1Choise = true
    var player1AI = false
    var player2AI = false
    var maxAI = 3
    var aiTimer = 1//Int.random(in: 0...1)
}
