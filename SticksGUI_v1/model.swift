//
//  model.swift
//  SticksGUI_v1
//
//  Created by Pavel Grigorev on 04.10.2022.
//

import UIKit

var sticksCount: Int = 9
let maxCount = 26
let minCount = 7
var startCount = 0
var moves = 0
var char: String = "🌼"
var sticks: [String] = []
var isGaming = false
var player1Choise = true
var hideMenu = true
let emojis: [String] = ["🌼", "🦋", "🌕", "🍋", "🥖", "⎮", "🧷", "❌", "🟢", "♦︎"]
let colors: [String] = ["🟦", "🟨", "🟩", "⬜️"]
