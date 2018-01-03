//
//  ViewController.swift
//  sirvive
//
//  Created by JAMES GOT GAME 07 on 2/7/17.
//  Copyright © 2017 Hamaste. All rights reserved.
//  Wave, percentage, number of kills

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private let backgroundMusic =  Bundle.main.url(forResource: "Survival_Loop", withExtension: "wav")!
    private var musicPlayer = AVAudioPlayer()
    
    private let font = "Helicopta"
    private var control: Int = 1
    
    private let background: UIColor = .rgb(106/4, 0, 252/4)
    private let overlay: UIColor = .rgb(255/4 ,14/4, 147/4)
    private let flashColor: UIColor = .rgb(255 ,14, 147)
    
    private var width: CGFloat!
    private var height: CGFloat!
    
    private let backView = UIView()
    private let overlayView = UIView()
    
    private let waveCounter = UILabel()
    private var wave: Int = 0
    
    private var endlessMode: Bool = false
    private var endlessTimer = Timer()
    private var endlessTime: CGFloat = 0
    
    private var combo: Int = 0
    private let comboLabel = UILabel()
    
    private let strokeAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.strokeColor.rawValue) : UIColor.black, NSAttributedStringKey.strokeWidth : -1.0] as [NSAttributedStringKey : Any]
    private let playerHealthPoints: Int = 1000
    private var playerSpeed: CGFloat = 5
    private var playerRadius: CGFloat = 0
    private let playerFill: UIColor = .rgb(255,161,12)
    private let player = PlayerClass()
    private var progress: Int = 0
    
    private var fingerLocation: CGPoint!
    private var fingerOnScreen: Bool = false
    private let joystickRadius: CGFloat = 50
    private let joystick = JoystickClass()
    
    private var enemiesDestroyed: Int = 0
    private var waveDestroyed: Int = 0
    
    private let enemyDamage: Int = 100
    private var enemyRadius: CGFloat = 0
    private var enemySpeed: CGFloat = 1
    private let enemyFill: UIColor = .rgb(255,5,157)
    private var enemies = [EnemyClass]()
    private var deadEnemies = [Int]()
    private let enemyFills = [
        UIColor.rgb(255,5,157),
        UIColor.rgb(255,67,96),
        UIColor.rgb(255,14,147)]
    
    private var bossType: String = ""
    private var bossPath: String = ""
    private var bossSpawn: Int = 0
    
    private var bossTimer = Timer()
    private var playerTimer = Timer()
    private var enemyTimer = Timer()
    
    private let flashOverlay = UIView()
    private var flashPosition: Int = 0
    private var flashTimer = Timer()
    
    private var delay = Timer()
    
    private let bottom = UIColor(red: 1, green: 0, blue: 0, alpha: 0.25)
    private let gradient = CAGradientLayer()
    
    private let homeScreen = UIView()
    private let killsButton = ButttonClass()
    private let killsHighlightButton = ButttonClass()
    private let highscoreButton = ButttonClass()
    private let waveButton = ButttonClass()
    private let endlessButton = ButttonClass()
    private let tutorialButton = ButttonClass()
    
    private let tutorial = UILabel()
    private var tutorialEnabled: Bool = false
    private var tutorialInt: Int = 0
    private let tutorialText = ["Drag player around to avoid enemies.", "Keep finger on screen to charge pulse.", "Release when indicator is blinking\n to kill enemies nearby"]
    
    public var credits = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOf: backgroundMusic)
        } catch {
            print("error")
        }
        
        musicPlayer.prepareToPlay()
        musicPlayer.numberOfLoops = -1
        
        //set up general variables
        width = view.frame.width
        height = view.frame.height
        
        // set background colour
        view.backgroundColor = background
        view.layer.borderColor = UIColor.white.cgColor
        
        // set up gradient background
        gradient.frame = view.frame
        gradient.colors = [ background.cgColor, background.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
        
        // set up wave counter
        waveCounter.frame = view.frame
        waveCounter.textColor = UIColor.black
        waveCounter.textAlignment = .center
        waveCounter.baselineAdjustment = .alignCenters
        waveCounter.alpha = 0.25
        waveCounter.numberOfLines = 1
        waveCounter.minimumScaleFactor = 0.1
        waveCounter.adjustsFontSizeToFitWidth = true
        waveCounter.font = UIFont(name: font, size: 400)
        waveCounter.attributedText = NSMutableAttributedString(string: String(wave), attributes: strokeAttributes)
        view.addSubview(waveCounter)
        
        flashOverlay.frame = view.frame
        flashOverlay.backgroundColor = flashColor
        flashOverlay.alpha = 0
        view.addSubview(flashOverlay)
        
        // set up player
        playerRadius = height/25
        enemyRadius = playerRadius
        player.setup(r: playerRadius, f: playerFill, origin: view.center, h: playerHealthPoints)
        view.addSubview(player)
        
        // set up joystick
        joystick.setup(r: joystickRadius, f: .white)
        joystick.locate(CGPoint(x: joystickRadius * 2, y: height - joystickRadius * 2))
        view.addSubview(joystick)
        
        // set up view for health indication
        backView.frame = view.frame
        backView.backgroundColor = .clear
        refreshHealthView()
        
        overlayView.backgroundColor = .black
        backView.addSubview(overlayView)
        
        waveCounter.textColor = UIColor(patternImage: UIImage(view: backView))
        
        // set up tutorial label
        tutorial.frame = CGRect(x: 0, y: height/10 * 8, width: width, height: height/10 * 2)
        tutorial.text = tutorialText[tutorialInt]
        tutorial.textAlignment = .center
        tutorial.textColor = .white
        tutorial.font = UIFont(name: "Futura", size: 20)
        tutorial.isHidden = !tutorialEnabled
        tutorial.numberOfLines = 0
        view.addSubview(tutorial)
        
        // set up home screen
        homeScreen.frame = view.frame
        homeScreen.backgroundColor = .black
        homeScreen.alpha = 0.9
        view.addSubview(homeScreen)
        
        killsHighlightButton.setup("Cirvive", view.frame, 50, n: 0, font: font, h: height/5 * 2)
        killsHighlightButton.titleLabel?.attributedText = NSMutableAttributedString(string: "Cirvive", attributes: [ NSAttributedStringKey.strokeColor : enemyFill, NSAttributedStringKey.strokeWidth : -1.0 ])
        killsHighlightButton.titleLabel?.font = UIFont(name: font, size: 75)
        killsHighlightButton.setTitleColor(.clear, for: .normal)
        killsHighlightButton.center.x -= 5
        killsHighlightButton.center.y += 5
        homeScreen.addSubview(killsHighlightButton)
        
        // set up points
        killsButton.setup("Cirvive", view.frame, 50, n: 0, font: font, h: height/5 * 2)
        killsButton.titleLabel?.font = UIFont(name: font, size: 75)
        killsButton.setTitleColor(enemyFill, for: .normal)
        homeScreen.addSubview(killsButton)
        
        // set up highscore
        highscoreButton.setup("Lasted " + String(UserDefaults.standard.float(forKey: "time")) + "s", view.frame, 50, n: 2, font: font, h: height/5 * 1.5)
        highscoreButton.titleLabel?.numberOfLines = 0
        highscoreButton.titleLabel?.font = UIFont(name: font, size: 25)
        highscoreButton.alpha = 0.75
        homeScreen.addSubview(highscoreButton)
        
        waveButton.setup("Start wave " + "\(UserDefaults.standard.integer(forKey: "wave"))", view.frame, 50, n: 4, font: font, h: height/5)
        waveButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        homeScreen.addSubview(waveButton)
        
        endlessButton.setup("Endless", view.frame, 50, n: 5, font: font, h: height/5)
        endlessButton.addTarget(self, action: #selector(endless), for: .touchUpInside)
        homeScreen.addSubview(endlessButton)
        
        // set up tutorial button
        tutorialButton.setup("Tutorial", view.frame, 50, n: 6, font: font, h: height/5)
        tutorialButton.addTarget(self, action: #selector(enableTutorial), for: .touchUpInside)
        homeScreen.addSubview(tutorialButton)
        
        // set up credits button
        
        // set up credits
        credits.frame = homeScreen.frame
        credits.text = "DEVELOPED BY\nJAMES LIM\n\nAUDIO BY\nT0UCHP0RTAL"
        credits.textColor = .white
        credits.textAlignment = .center
        credits.font = UIFont(name: font, size: 40)
        credits.numberOfLines = 0
        credits.isHidden = true
        credits.alpha = 0
        credits.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        homeScreen.addSubview(credits)
        let tap = UITapGestureRecognizer(target: self, action: #selector(endCredits))
        credits.addGestureRecognizer(tap)
        credits.isUserInteractionEnabled = true
        
        comboLabel.frame.size = view.frame.size
        comboLabel.textColor = .white
        comboLabel.textAlignment = .center
        comboLabel.alpha = 0
        comboLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        comboLabel.layer.shadowColor = overlay.cgColor
        comboLabel.layer.shadowOpacity = 1
        view.addSubview(comboLabel)
    }
    
    // randomise enemy location
    @objc private func randomisePosition(_ require: Int) -> CGPoint {
        var x = CGFloat()
        var y = CGFloat()
        switch require {
        case 0:
            switch arc4random_uniform(4) {
            case 0:
                x = CGFloat(arc4random_uniform(UInt32(width)))
                y = -enemyRadius
            case 1:
                x = width + enemyRadius
                y = CGFloat(arc4random_uniform(UInt32(height)))
            case 2:
                x = CGFloat(arc4random_uniform(UInt32(width)))
                y = height + enemyRadius
            case 3:
                x = -enemyRadius
                y = CGFloat(arc4random_uniform(UInt32(height)))
            default:
                break
            }
        case 1:
            x = CGFloat(arc4random_uniform(UInt32(width/2))) + width/4
            switch arc4random_uniform(2) {
            case 0:
                y = -enemyRadius
            case 1:
                y = height + enemyRadius
            default:
                break
            }
        case 2:
            y = CGFloat(arc4random_uniform(UInt32(height/2))) + height/4
            switch arc4random_uniform(2) {
            case 0:
                x = width + enemyRadius
                
            case 1:
                x = -enemyRadius
            default:
                break
            }
        case 10:
            return enemies[0].center
        default:
            break
        }
        return CGPoint(x: x, y: y)
    }
    
    @objc private func createSpecificEnemy() {
        if homeScreen.isHidden {
            let enemy = EnemyClass()
            let name = bossType
            var face = 0
            let pathing = bossPath
            var target = player.center
            var speed = enemySpeed
            var damage = enemyDamage
            var radius = enemyRadius
            var fill = enemyFills[2]
            var lives = 1
            let position = randomisePosition(bossSpawn)
            switch name {
            case "barrier":
                lives = 2
                speed = enemySpeed * 3/4
            case "fast":
                speed = enemySpeed * 2
                damage = enemyDamage/2
                radius = enemyRadius/2
                fill = enemyFills[0]
            case "splitter":
                speed = enemySpeed/2
                damage = 0
                radius = enemyRadius
                fill = enemyFills[0]
            case "damage":
                speed = enemySpeed/2
                damage = enemyDamage * 2
                radius = enemyRadius * 2
                fill = enemyFills[1]
            default:
                break
            }
            
            switch pathing {
            case "still":
                face = 1
            case "random":
                face = 2
                let x = CGFloat(arc4random_uniform(UInt32(width)))
                let y = CGFloat(arc4random_uniform(UInt32(height)))
                target = CGPoint(x: x, y: y)
            case "dash":
                face = 3
                speed = speed * 1.5
            case "vertical":
                face = 4
            case "horizontal":
                face = 4
            default:
                break
            }
            
            enemy.setup(name, pathing, r: radius, f: fill, o: position, d: damage, s: speed, l: lives, size: enemyRadius, face)
            enemy.target = target
            enemy.alpha = 0
            
            view.addSubview(enemy)
            enemies.append(enemy)
            
            UIView.animate(withDuration: 1, animations: {
                enemy.alpha = 1
            })
        }
    }
    
    @objc private func createEnemy() {
        if homeScreen.isHidden {
            let enemy = EnemyClass()
            var name = "normal"
            var pathing = "normal"
            var face = 0
            var target = player.center
            var speed = enemySpeed
            var damage = enemyDamage
            var radius = enemyRadius
            var fill = enemyFills[2]
            var lives = 1
            var position = randomisePosition(0)
            let x  = arc4random_uniform(100)
            if x >= 40 && x < 50 && wave >= 30 {
                name = "barrier"
                lives = 2
                speed = enemySpeed * 3/4
            } else if x >= 50 && x < 65 && wave >= 20 {
                name = "fast"
                speed = enemySpeed * 2
                damage = enemyDamage/2
                radius = enemyRadius/2
                fill = enemyFills[0]
            } else if x >= 65 && x < 75 && wave >= 40 {
                name = "splitter"
                speed = enemySpeed/2
                damage = 0
                radius = enemyRadius
                fill = enemyFills[0]
            } else if x >= 75 && wave >= 10 {
                name = "damage"
                speed = enemySpeed/2
                damage = enemyDamage * 2
                radius = enemyRadius * 2
                fill = enemyFills[1]
            }
            
            if x < 10 && wave >= 5 {
                face = 1
                pathing = "still"
                position = randomisePosition(0)
            } else if x >= 10 && x < 20 && wave >= 10 {
                face = 2
                pathing = "random"
                position = randomisePosition(0)
                let x = CGFloat(arc4random_uniform(UInt32(width)))
                let y = CGFloat(arc4random_uniform(UInt32(height)))
                target = CGPoint(x: x, y: y)
            } else if x >= 20 && x < 30 && wave >= 15 {
                face = 3
                pathing = "dash"
                position = randomisePosition(0)
                speed = speed * 1.5
            } else if x >= 40 && x < 50 && wave >= 20 {
                face = 4
                pathing = "vertical"
                position = randomisePosition(1)
            } else if x >= 50 && x < 60 && wave >= 20 {
                face = 4
                pathing = "horizontal"
                position = randomisePosition(2)
            }
        
            enemy.setup(name, pathing, r: radius, f: fill, o: position, d: damage, s: speed, l: lives, size: enemyRadius, face)
            enemy.target = target
            enemy.alpha = 0
            
            view.addSubview(enemy)
            enemies.append(enemy)
            
            UIView.animate(withDuration: 1, animations: {
                enemy.alpha = 1
            })
        }
    }
    
    private func enemyPathing(path: String, target: CGPoint, center: CGPoint, radius: CGFloat) -> CGPoint {
        var x = center.x
        var y = center.y
        switch path {
        case "normal":
            x = player.center.x
            y = player.center.y
        case "vertical":
            if y < 0 {
                x = center.x
                y = height + radius
            } else if y > height {
                x = center.x
                y = -radius
            } else {
                x = target.x
                y = target.y
            }
        case "horizontal":
            if x < 0 {
                x = width + radius
                y = center.y
            } else if x > width {
                x = -radius
                y = center.y
            } else {
                x = target.x
                y = target.y
            }
        case "random":
            if distance(CGPoint(x:x, y:y), target) < 10 {
                x = CGFloat(arc4random_uniform(UInt32(width)))
                y = CGFloat(arc4random_uniform(UInt32(height)))
            } else {
                x = target.x
                y = target.y
            }
        case "still":
            x = target.x
            y = target.y
        case "dash":
            if distance(CGPoint(x:x, y:y), target) < 10 {
                x = player.center.x
                y = player.center.y
            } else {
                x = target.x
                y = target.y
            }
        default:
            break
        }
        
        return CGPoint(x: x, y: y)
    }
    
    func createBoss() {
        if wave == 9 {
            let e = EnemyClass()
            e.setup("boss", "random", r: enemyRadius*4, f: enemyFills[0], o: randomisePosition(0), d: enemyDamage, s: enemySpeed/4, l: 5, size: enemyRadius, 0)
            let x = CGFloat(arc4random_uniform(UInt32(width)))
            let y = CGFloat(arc4random_uniform(UInt32(height)))
            e.target = CGPoint(x: x, y: y)
            e.maxLives = 5
            e.font = UIFont(name: font, size: enemyRadius*4)
            view.addSubview(e)
            enemies.append(e)
            bossSpawn = 10
            bossType = "normal"
            bossPath = "normal"
            bossTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(createSpecificEnemy), userInfo: nil, repeats: true)
        } else if wave == 19 {
            let e = EnemyClass()
            e.setup("boss", "dash", r: enemyRadius*8, f: enemyFills[1], o: randomisePosition(0), d: enemyDamage * 4, s: enemySpeed, l: 10, size: enemyRadius, 0)
            let x = CGFloat(arc4random_uniform(UInt32(width)))
            let y = CGFloat(arc4random_uniform(UInt32(height)))
            e.target = CGPoint(x: x, y: y)
            e.maxLives = 10
            e.font = UIFont(name: font, size: enemyRadius*4)
            view.addSubview(e)
            enemies.append(e)
        } else if wave == 29 {
            let e = EnemyClass()
            e.setup("boss", "random", r: enemyRadius*4, f: enemyFills[2], o: randomisePosition(0), d: enemyDamage * 4, s: enemySpeed, l: 10, size: enemyRadius, 0)
            let x = CGFloat(arc4random_uniform(UInt32(width)))
            let y = CGFloat(arc4random_uniform(UInt32(height)))
            e.target = CGPoint(x: x, y: y)
            e.maxLives = 10
            e.font = UIFont(name: font, size: enemyRadius*4)
            view.addSubview(e)
            enemies.append(e)
            bossSpawn = 10
            bossType = "fast"
            bossPath = "dash"
            bossTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(createSpecificEnemy), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func refreshEnemy() {
        if endlessMode {
            endlessTime += 0.01
            tutorial.text = "\(Double(round(100*endlessTime)/100))"
        }
        
        if fingerOnScreen {
            movePlayer(fingerLocation)
        }
        
        if player.healthPoints < 0 {
            enemyTimer.invalidate()
            enemySpeed = 1
            for e in enemies {
                e.lives = 0
                e.destroy()
            }
            enemies = []
            deadEnemies = []
            end()
            return
        }
        
        if enemies.count == 0 {
            wave += 1
            UserDefaults.standard.set(wave, forKey: "wave")
            enemySpeed = 1 + (CGFloat(wave) - 1) * 0.01
            waveCounter.attributedText = !endlessMode ? NSMutableAttributedString(string: String(wave), attributes: strokeAttributes) : NSMutableAttributedString(string: "|||", attributes: strokeAttributes)
            waveDestroyed = 0
            if wave == 9 {
                let e = EnemyClass()
                e.setup("boss", "random", r: enemyRadius*4, f: enemyFills[0], o: randomisePosition(0), d: enemyDamage, s: enemySpeed/4, l: 5, size: enemyRadius, 0)
                let x = CGFloat(arc4random_uniform(UInt32(width)))
                let y = CGFloat(arc4random_uniform(UInt32(height)))
                e.target = CGPoint(x: x, y: y)
                e.maxLives = 5
                e.font = UIFont(name: font, size: enemyRadius*4)
                view.addSubview(e)
                enemies.append(e)
                bossSpawn = 10
                bossType = "normal"
                bossPath = "normal"
                bossTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(createSpecificEnemy), userInfo: nil, repeats: true)
            } else if wave == 19 {
                let e = EnemyClass()
                e.setup("boss", "dash", r: enemyRadius*8, f: enemyFills[1], o: randomisePosition(0), d: enemyDamage * 4, s: enemySpeed, l: 10, size: enemyRadius, 0)
                let x = CGFloat(arc4random_uniform(UInt32(width)))
                let y = CGFloat(arc4random_uniform(UInt32(height)))
                e.target = CGPoint(x: x, y: y)
                e.maxLives = 10
                e.font = UIFont(name: font, size: enemyRadius*4)
                view.addSubview(e)
                enemies.append(e)
            } else if wave == 29 {
                let e = EnemyClass()
                e.setup("boss", "random", r: enemyRadius*4, f: enemyFills[2], o: randomisePosition(0), d: enemyDamage * 4, s: enemySpeed, l: 10, size: enemyRadius, 0)
                let x = CGFloat(arc4random_uniform(UInt32(width)))
                let y = CGFloat(arc4random_uniform(UInt32(height)))
                e.target = CGPoint(x: x, y: y)
                e.maxLives = 10
                e.font = UIFont(name: font, size: enemyRadius*4)
                view.addSubview(e)
                enemies.append(e)
                bossSpawn = 10
                bossType = "fast"
                bossPath = "dash"
                bossTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(createSpecificEnemy), userInfo: nil, repeats: true)
            }
            for _ in 1...4*wave + 10 {
                let _ = Timer.scheduledTimer(timeInterval: TimeInterval(arc4random_uniform(UInt32(wave*200))/50), target: self, selector: #selector(createEnemy), userInfo: nil, repeats: false)
            }
        }
        
        for e in enemies {
            e.chase(point: enemyPathing(path: e.pathing, target: e.target, center: e.center, radius: e.getRadius()))
            e.target = enemyPathing(path: e.pathing, target: e.target, center: e.center, radius: e.getRadius())
            let r = player.pulsing ? playerRadius*7 + e.getRadius() : playerRadius + e.getRadius()
            if e.checkCollision(point: player.center, radius: r) && e.lives != 0 {
                if e.hit == false {
                    e.lives -= 1
                    e.hit = true
                    if e.type == "splitter" {
                        let radius = e.getRadius()
                        let speed = e.speed*2
                        let lives = 1
                        let fill = enemyFills[0]
                        let c = e.center
                        let points = [CGPoint(x: c.x - radius, y: c.y + radius),
                                      CGPoint(x: c.x + radius, y: c.y + radius),
                                      CGPoint(x: c.x - radius, y: c.y - radius),
                                      CGPoint(x: c.x - radius, y: c.y - radius)]
                        for i in 0...3 {
                            let enemy = EnemyClass()
                            enemy.hit = true
                            enemy.setup("normal", "normal", r: radius, f: fill, o: points[i], d: 0, s: speed, l: lives, size: enemyRadius, 0)
                            view.addSubview(enemy)
                            UIView.animate(withDuration: 1, animations: {
                                e.alpha = 0
                            }, completion: { (Bool) in
                                self.enemies.append(enemy)
                            })
                        }
                    }
                    e.destroy()
                }
                if e.lives == 0 {
                    if e.type == "boss" {
                        bossTimer.invalidate()
                    }
                    enemyDeath(e.center, e.getRadius(), colour: e.backgroundColor!)
                    enemies.remove(at: enemies.index(of: e)!)
                    view.center.x += 10
                    UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                        self.view.center.x -= 10
                    }, completion: nil)
                    if player.pulsing != true {
                        player.healthPoints -= e.damage
                        health()
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    } else {
                        enemiesDestroyed += 1
                        waveDestroyed += 1
                        combo += 1
                        
                        if (combo > 9 && !endlessMode) || (combo > 19 && endlessMode) {
                            comboLabel.text = "x\(combo) COMBO"
                            comboLabel.center = CGPoint(x: e.center.x, y: e.center.y + 10)
                            let size = endlessMode ? CGFloat(15 + combo/2) : CGFloat(15 + combo*3/2)
                            comboLabel.font = UIFont(name: font, size: size)
                            comboLabel.alpha = 1
                            
                            UIView.animate(withDuration: 1, animations: {
                                self.comboLabel.alpha = 0
                                self.comboLabel.center.y += 10
                            })
                        }
                        
                        if combo % 10 == 0 {
                            if player.healthPoints + enemyDamage * 2 < playerHealthPoints {
                                player.healthPoints += enemyDamage * 2
                            } else {
                                player.healthPoints = playerHealthPoints
                            }
                            health()
                            regen()
                        }
                        
                        if e.getRadius() > enemyRadius {
                            if player.healthPoints + enemyDamage/2 < playerHealthPoints {
                                player.healthPoints += enemyDamage/2
                            } else {
                                player.healthPoints = playerHealthPoints
                            }
                            health()
                            regen()
                        }
                        
                        if e.getRadius() < enemyRadius {
                            playerSpeed += 0.1
                        }
                    }
                }
            }
        }
        
    }
    
    private func rndCenter(_ p: CGPoint) -> CGPoint {
        let x = arc4random_uniform(2) == 0 ? CGFloat(arc4random_uniform(50)) : -CGFloat(arc4random_uniform(50))
        let y = arc4random_uniform(2) == 0 ? CGFloat(arc4random_uniform(50)) : -CGFloat(arc4random_uniform(50))
        
        return CGPoint(x: p.x + x, y: p.y + y)
    }
    
    private func regen() {
        for i in 0...10 {
            let health = UILabel()
            health.frame.size = CGSize(width: 100, height: 100)
            health.center = rndCenter(player.center)
            health.font = UIFont(name: font, size: 25)
            health.text = "+"
            health.textAlignment = .center
            health.textColor = .green
            health.alpha = 0.5
            view.addSubview(health)
            
            UIView.animate(withDuration: 0.5, delay: TimeInterval(i)/20, options: [], animations: {
                health.center.y -= 10
                health.alpha = 0
            }, completion: { (Bool) in
                health.removeFromSuperview()
            })
        }
    }
    
    private func enemyDeath(_ c: CGPoint, _ r: CGFloat, colour: UIColor) {
        let feel = DeathClass()
        feel.setup(r: r, c: c, f: .clear, b: colour.cgColor)
        feel.alpha = 1
        view.addSubview(feel)
        UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: {
            feel.transform = CGAffineTransform(scaleX: 5, y: 5)
            feel.alpha = 0
        }) { (Bool) in
            feel.removeFromSuperview()
        }
    }
    
    @objc private func powerReady() {
        if progress == 3 {
            player.setReady()
            if tutorialEnabled && tutorialInt == 1 {
                tutorialInt = 2
                tutorial.text = tutorialText[tutorialInt]
            }
        } else {
            progress += 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = (touches.first?.location(in: view))! as CGPoint
        progress = 0
        if homeScreen.isHidden {
            playerTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(powerReady), userInfo: nil, repeats: true)
        }
        fingerOnScreen = true
        combo = 0
        loadPulse()
        movePlayer(location)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = (touches.first?.location(in: view))! as CGPoint
        movePlayer(location)
        if tutorialEnabled && tutorialInt == 0 {
            tutorialInt = 1
            tutorial.text = tutorialText[tutorialInt]
        }
    }
    
    private func movePlayer(_ location: CGPoint) {
        fingerLocation = location
        var center = CGPoint()
        var speed = playerSpeed
        if control == 0 {
            center = joystick.center
            speed = playerSpeed/2
        } else if control == 1 {
            center = player.center
        }
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.player.center = self.joystick.movePlayer(center, self.fingerLocation, self.player.center, viewFrame: self.view.frame, r: self.playerRadius, speed: speed)
        }, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        fingerOnScreen = false
        playerTimer.invalidate()
        progress = 0
        if player.isReady() {
            player.activatePower()
            player.pulsing = true
            delay = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(endPulse), userInfo: nil, repeats: false)
        } else {
            player.notRady()
        }
        resetAnim()
        if homeScreen.isHidden {
            playerTimer.invalidate()
            progress = 0
        }
        
        if control == 0 {
            UIView.animate(withDuration: 0.25, animations: {
                self.joystick.alpha = 0.25
            })
        }
        
        if tutorialEnabled && tutorialInt == 2 {
            disableTutorial()
        }
    }
    
    @objc private func loadPulse() {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            if self.fingerOnScreen {
                self.animSecondHalf()
            }
        }
        
        let fromColors = gradient.colors
        let toColors: [AnyObject] = [ background.cgColor, overlay.cgColor]
        
        gradient.colors = toColors
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = 3
        
        gradient.add(animation, forKey:"animateGradient")
        CATransaction.commit()
    }
    
    @objc private func animSecondHalf(){
        let fromColors = gradient.colors
        let toColors: [AnyObject] = [ overlay.cgColor, overlay.cgColor]
        
        gradient.colors = toColors
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = 3
        
        gradient.add(animation, forKey:"animateGradient")
    }
    
    @objc private func resetAnim() {
        let fromColors = gradient.colors
        let toColors: [AnyObject] = [ background.cgColor, background.cgColor]
        
        gradient.colors = toColors
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = 1
        
        gradient.add(animation, forKey:"animateGradient")
    }
    
    @objc private func endPulse() {
        player.pulsing = false
        for e in enemies {
            e.hit = false
        }
    }
    
    @objc private func health() {
        refreshHealthView()
        waveCounter.textColor = UIColor(patternImage: UIImage(view: backView))
    }
    
    @objc private func refreshHealthView() {
        let h = CGFloat(self.player.healthPoints)/CGFloat(playerHealthPoints) * height
        UIView.animate(withDuration: 0.5, animations: {
            self.overlayView.frame = CGRect(x: 0, y: self.height - h, width: self.width, height: h)
        })
    }
    
    private func setup() {
        musicPlayer.currentTime = 0
        musicPlayer.play()
        musicPlayer.volume = 1
        progress = 0
        wave = endlessMode ? 1 : UserDefaults.standard.integer(forKey: "wave")
        flash()
        flashTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(flash), userInfo: nil, repeats: true)
        if tutorialEnabled { joystick.alpha = 1 }
        if control == 1 { joystick.alpha = 0 }
        joystick.locate(CGPoint(x: joystickRadius * 2, y: height - joystickRadius * 2))
        resetAnim()
        player.center = view.center
        tutorialInt = 0
        player.pulseTimer.invalidate()
    }
    
    @objc private func start() {
        setup()
        waveCounter.attributedText = NSMutableAttributedString(string: String(self.wave), attributes: self.strokeAttributes)
        tutorial.text = tutorialText[tutorialInt]
        tutorial.font = UIFont(name: "futura", size: 20)
        UIView.animate(withDuration: 1, animations: {
            self.homeScreen.alpha = 0
        }) { (Bool) in
            self.homeScreen.isHidden = true
            self.player.healthPoints = 1000
            self.health()
            
            self.createEnemy()
            self.createBoss()
            for _ in 1...4*self.wave + 10 {
                let _ = Timer.scheduledTimer(timeInterval: TimeInterval(arc4random_uniform(UInt32(self.wave*200))/50), target: self, selector: #selector(self.createEnemy), userInfo: nil, repeats: false)
            }
            
            self.enemyTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.refreshEnemy), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func endless() {
        endlessMode = true
        setup()
        waveCounter.attributedText = NSMutableAttributedString(string: "|||", attributes: self.strokeAttributes)
        tutorial.text = "0.00"
        tutorial.font = UIFont(name: font, size: 25)
        tutorial.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.homeScreen.alpha = 0
        }) { (Bool) in
            self.homeScreen.isHidden = true
            self.player.healthPoints = 1000
            self.health()
            
            self.spawn()
            self.endlessTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.spawn), userInfo: nil, repeats: true)
            self.enemyTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.refreshEnemy), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func spawn() {
        for _ in 1...(self.wave/2) + 4 {
            let _ = Timer.scheduledTimer(timeInterval: TimeInterval(arc4random_uniform(UInt32(self.wave + 10))) * 0.4, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: false)
        }
        wave += 1
    }
    
    @objc private func end() {
        musicPlayer.stop()
        endlessTimer.invalidate()
        homeScreen.isHidden = false
        disableTutorial()
        flashTimer.invalidate()
        killsButton.setup("Cirvive", view.frame, 50, n: 0, font: font, h: height/5 * 2)
        killsButton.titleLabel?.font = UIFont(name: font, size: 75)
        killsButton.setTitleColor(enemyFill, for: .normal)
        
        var new = false
        if UserDefaults.standard.integer(forKey: "wave") < wave && !endlessMode {
            UserDefaults.standard.set(wave, forKey: "wave")
            new = true
        }
        
        if CGFloat(UserDefaults.standard.float(forKey: "time")) < endlessTime && endlessMode {
            UserDefaults.standard.set(endlessTime, forKey: "time")
            new = true
        }
        
        endlessTime = 0
        endlessMode = false
        
        waveButton.setup("Start wave " + "\(UserDefaults.standard.integer(forKey: "wave"))", view.frame, 50, n: 4, font: font, h: height/5)
        highscoreButton.setup("Lasted " + String(UserDefaults.standard.float(forKey: "time")) + "s", view.frame, 50, n: 2, font: font, h: height/5 * 1.5)
        highscoreButton.titleLabel?.numberOfLines = 0
        highscoreButton.titleLabel?.font = UIFont(name: font, size: 25)
        highscoreButton.alpha = 0.75
        if new { highscoreButton.setTitleColor(playerFill, for: .normal) }
        
        enemiesDestroyed = 0
        waveDestroyed = 0
        UIView.animate(withDuration: 1, animations: {
            self.homeScreen.alpha = 0.9
        }) { (Bool) in
            
        }
    }
    
    @objc private func flash() {
        var alpha: CGFloat = player.isReady() ? 0.2 : 0
        var expand: CGFloat = 1
        switch flashPosition {
        case 0:
            flashPosition = 1
            alpha += 0.06
            expand = 1.3
        case 1:
            flashPosition = 2
            alpha += 0.02
            expand = 1.1
        case 2:
            flashPosition = 3
            alpha += 0.12
            expand = 1.6
        case 3:
            flashPosition = 0
            alpha += 0.02
            expand = 1.1
        default:
            break
        }
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.75, options: .curveEaseIn, animations: {
            self.flashOverlay.alpha = alpha
            for i in self.enemies { i.transform = CGAffineTransform(scaleX: expand, y: expand) }
        }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.2, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.75, options: .curveEaseOut, animations: {
            self.flashOverlay.alpha = 0
            for i in self.enemies { i.transform = CGAffineTransform(scaleX: 1, y: 1) }
        }, completion:  nil)
    }
    
    @objc private func enableTutorial() {
        tutorialEnabled = true
        tutorial.isHidden = !tutorialEnabled
        start()
    }
    
    @objc private func disableTutorial() {
        tutorialEnabled = false
        tutorialInt = 0
        tutorial.isHidden = !tutorialEnabled
    }
    
    @objc private func startCredits() {
        credits.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.credits.alpha = 1
        })
    }
    
    @objc private func endCredits() {
        UIView.animate(withDuration: 1, animations: {
            self.credits.alpha = 0
        }) { (Bool) in
            self.credits.isHidden = true
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func distance(_ from: CGPoint, _ to: CGPoint) -> CGFloat {
        return sqrt((from.x-to.x)*(from.x-to.x) + (from.y-to.y)*(from.y-to.y))
    }

}
