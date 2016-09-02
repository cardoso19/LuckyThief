//
//  Constants.swift
//  Run to the Mountain
//
//  Created by Matheus Cardoso kuhn on 20/05/16.
//  Copyright © 2016 Warrior Iena. All rights reserved.
//

import Foundation
import SpriteKit

let iPadAppendName = "_ipad"

// Physics Types
struct PhysicsCategory {
    static let none: UInt32 = 0 // 0
    static let player: UInt32 = 0b1 // 1
    static let enemy: UInt32 = 0b10 // 2
    static let horse: UInt32 = 0b100 // 4
    static let playerArrow: UInt32 = 0b1000 // 8
    static let enemyArrow: UInt32 = 0b10000 // 16
    static let ground: UInt32 = 0b100000 // 32
}
// Game Stats and Actions
struct GameState {
    static let Nothing: Int = 0
    static let OnInitialMenu: Int = 1
    static let OnGame: Int = 2
    static let OnPauseMenu: Int = 3
    static let OnEndGameMenu: Int = 4
    static let OnCreditsMenu: Int = 5
    static let Transition: Int = 6
}

struct GameAction {
    static let Nothing: Int = 0
    static let StartGame: Int = 1
    static let RestartGame: Int = 2
    static let GoToMenu: Int = 3
    static let GoToCredits: Int = 4
    static let BackToMenuInitial: Int = 5
    static let Pause: Int = 6
    static let Resume: Int = 7
    static let EndGame: Int = 8
    static let QuitGame: Int = 9
}
// Char Types
struct CharType {
    static let Player: Int = 0
    static let Enemy: Int = 1
}

// Score
let actionScoreName = "pontuacao"

// ZPosition
// - Game
let enemiesZposition: CGFloat = 200.0
let playerZposition: CGFloat = 100.0

// MARK: - Parallax
// - ZPosition
let parallaxZpositionCeu: CGFloat = -370.0
let parallaxZpositionMontanhas: CGFloat = -330.0
let parallaxZpositionNuvens: CGFloat = -290.0
let parallaxZpositionCastelo: CGFloat = -285.0
let parallaxZpositionChaoArvores: CGFloat = -250.0
let parallaxZpositionArvores: CGFloat = -220.0
let parallaxZpositionArbusto: CGFloat = -210.0
let parallaxZpositionChao: CGFloat = -200.0
let parallaxZpositionLogo: CGFloat = parallaxZpositionChao

// - Texture Names
let parallaxTextureNameCeu = "ceu"
let parallaxTextureNameMontanha = "montanha"
let parallaxTextureNameNuvens = "nuvem"
let parallaxTextureNameCastelo = "castelo"
let parallaxTextureNameChaoArvores = "chao_arvores"
let parallaxTextureNameArvores = "arvores"
let parallaxTextureNameArbusto = "arbusto"
let parallaxTextureNameChao = "chao"

// Damages
let playerArrowDamage = 10
let enemyArrowDamage = 5

// Sprite Names
// - Menu Inicial
let playButtonName = "Play Button"
let creditsButtonName = "Credits Button"

// - Menu PAUSE
let pauseButtonName = "Pause Button"
let restartButtonName = "Restart Button"
let menuButtonName = "Menu Button"

let continueButtonName = "Continue Button"

// - Game
let playerName = "Player"
let enemyName = "Enemy"

let knightName = "Knight"
let archerKnightName = "Archer Knight"

let arrowName = "Arrow"
let arrowDesativadaName = "Arrow Desativada"

// MARK: - Texture Names
// - Menu Inicial
let logoTextureName = "logo"

let playButtonTextureName = "play"
let creditsButtonTextureName = "credits"

// - Menu PAUSE
let buttonContinueTextureName = "continueButton"
let buttonRestartTextureName = "restartButton"
let buttonMenuTextureName = "menuButton"

let buttonPauseTextureName = "pause"
let blurBackgroundTextureName = "blur"
let backgroundPauseMenuTextureName = "backgroundPause"

// - Menu Credits
let backgroundCreditsMenuTextureName = "bandeiracredits"

// - Game
let arrowTextureName = "arrow"
let arrowGroundTextureName = "arrowOnGround"
let horseTextureName = "horse"
let knightTextureName = "knight"

let archerKnightTextureName = "aKnight"
let playerTextureName = "player"

//MARK: - Math
func round(num: Float) -> Int{
    
    let dif = num - Float(Int(num))
    
    if dif <= 0.5 {
        return 0
    }
    
    return 1
}


