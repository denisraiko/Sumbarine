//
//  ViewController.swift
//  Sumbarine
//
//  Created by Denis Raiko on 15.02.24.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    // MARK: IBOutlet
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var boatImageView: UIImageView!
    @IBOutlet weak var firstFishImage: UIImageView!
    @IBOutlet weak var secondFishImage: UIImageView!
    @IBOutlet weak var crabImage: UIImageView!
    @IBOutlet weak var oxygenLevel: UIProgressView!
    @IBOutlet weak var submarineImage: UIImageView!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    let topHeight: CGFloat = 60
    let bottomHeight: CGFloat = 310
    
    var fishImages = [UIImageView]()
    
    
    var oxygenTimer = Timer()
    
    var isGamePaused = false
    
    let startSubmarinePositionY: CGFloat = 151.0
    let startBoatPositionY: CGFloat = 24.0
    let startFirstFishPositionY: CGFloat = 79.0
    let startSecondFishPositionY: CGFloat = 210.0
    let startCrabPositionY: CGFloat = 311.0
    let startOxygenLevelY: CGFloat = 140.0
    
    
    let startSubmarinePositionX: CGFloat = 227.0
    let startBoatPositionX: CGFloat = 694.0
    let startFirstFishPositionX: CGFloat = 466.0
    let startSecondFishPositionX: CGFloat = 706.0
    let startCrabPositionX: CGFloat = 466.0
    let startOxygenLevelX: CGFloat = 227.0
    
    var scoreTimer = Timer()
    var score = 0
    var bestScore = 0
    
    var selectedImage: UIImage?
    
    var userName = ""
    
    
    var scoreInfoArray = [String]()

    
    // MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.insertSubview(boatImageView, belowSubview: controlView)
        self.view.insertSubview(firstFishImage, belowSubview: controlView)
        self.view.insertSubview(secondFishImage, belowSubview: controlView)
        self.view.insertSubview(crabImage, belowSubview: controlView)
        self.view.insertSubview(submarineImage, belowSubview: controlView)
        
        
        self.fishImages.append(self.firstFishImage)
        self.fishImages.append(self.secondFishImage)
        
        
        moveBoat()
        moveFish()
        moveCrab()
        
        oxygenLevel.setProgress(0.5, animated: true)
        oxygenLevel.tintColor = .green
        
        changeOxygenLevel()
        
        self.scoreLabel.text = "Score:\(self.score)"
        
        
        
        submarineImage.image = self.selectedImage
        
        dateLabel.text = createCurrentDate()
        
        
        self.startTimer()
        
    }
    
    // MARK: functions
    
    
    func createCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
    
    func saveScore(_ bestScore: Int) {
        UserDefaults.standard.set(bestScore, forKey: "bestScore")
        
    }
    
    func loadScore() -> Int  {
        return UserDefaults.standard.integer(forKey: "bestScore")
    }
    
    
    
    func startTimer() {
        scoreTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateScore), userInfo: nil, repeats: true)
        
    }
    
    func resetTimer() {
        score = 0
        self.scoreLabel.text = "Score: \(self.score)"
    }
    
    @objc func updateScore() {
        self.score += 1
        self.scoreLabel.text = "Score: \(score)"
    }
    
    func moveBoat() {
        UIView.animate(withDuration: 0.01) {
            self.boatImageView.frame.origin.x -= 2
            if self.boatImageView.frame.maxX <= 0 {
                self.boatImageView.frame.origin.x = self.view.frame.width
            }
        } completion: { _ in
            if !self.isGamePaused {
                self.moveBoat()
                self.checkCollision()
            }
        }
    }
    
    func moveFish() {
        UIView.animate(withDuration: 0.01) {
            for fishImage in self.fishImages {
                fishImage.frame.origin.x -= 2
                
                if fishImage.frame.maxX <= 0 {
                    fishImage.frame.origin.x = self.view.frame.width
                }
            }
        } completion: { _ in
            if !self.isGamePaused {
                self.moveFish()
                self.checkCollision()
            }
        }
    }
    
    func moveCrab() {
        UIView.animate(withDuration: 0.02) {
            self.crabImage.frame.origin.x -= 2
            if self.crabImage.frame.maxX <= 0 {
                self.crabImage.frame.origin.x = self.view.frame.width
            }
        } completion: { _ in
            if !self.isGamePaused {
                self.moveCrab()
                self.checkCollision()
            }
        }
    }
    
    func changeOxygenLevel() {
        oxygenTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { _ in
            if !self.isGamePaused {
                if self.oxygenLevel.progress != 1 && self.submarineImage.frame.origin.y <= self.topHeight {
                    self.oxygenLevel.progress += 0.005
                } else {
                    self.oxygenLevel.progress -= 0.001
                }
            }
        })
    }
    
    func checkCollision() {
        // Проверяем, пересекается ли субмарина с другими объектами (например, с fishImages)
        for fishImage in fishImages {
            if submarineImage.frame.intersects(fishImage.frame) {
                // Если субмарина пересекается с рыбкой, показываем всплывающее окно "Game over"
                showGameOverAlert()
                isGamePaused = true
                break // Прерываем цикл, если найдено пересечение
            }
        }
        if submarineImage.frame.intersects(boatImageView.frame) {
            showGameOverAlert()
            isGamePaused = true
        }
        if submarineImage.frame.intersects(crabImage.frame) {
            showGameOverAlert()
            isGamePaused = true
        }
    }
    
    func showGameOverAlert() {
        scoreTimer.invalidate()
        let currentBestScore = loadScore()
        if score > currentBestScore {
            saveScore(score)
        }
        let alertController = UIAlertController(title: "Game over \(self.userName)", message: "Your \(self.scoreLabel.text ?? ""). Best score: \(loadScore())", preferredStyle: .alert)
        
        let titleFont = [NSAttributedString.Key.font: UIFont(name: "abosanova", size: 25), NSAttributedString.Key.foregroundColor: UIColor.red]
        let messageFont = [NSAttributedString.Key.font: UIFont(name: "abosanova", size: 15), NSAttributedString.Key.foregroundColor: UIColor.red]
        
        let attributedTitle = NSAttributedString(string: "Game over \(self.userName)", attributes: titleFont as [NSAttributedString.Key : Any])
        let attributedMessage = NSAttributedString(string: "Your \(self.scoreLabel.text ?? ""). Best score: \(loadScore())", attributes: messageFont as [NSAttributedString.Key : Any])
        
        alertController.setValue(attributedTitle, forKey: "attributedTitle")
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.resetTimer()
            self.startTimer()
            self.resetGame()
            
        }
        let mainMenuAction = UIAlertAction(title: "Main menu", style: .default) { _ in
            guard let startVC = self.storyboard?.instantiateViewController(withIdentifier: "StartViewController") as? StartViewController else { return }
            startVC.modalPresentationStyle = .fullScreen
            self.present(startVC, animated: true, completion: nil)
        }
        let scoreMenuAction = UIAlertAction(title: "Score", style: .default) { _ in
            guard let scoreVC = self.storyboard?.instantiateViewController(withIdentifier: "ScoreViewController") as? ScoreViewController else { return }
            let currentDate = self.createCurrentDate()
            let gameResult = "\(currentDate), Score: \(self.score)"
            scoreVC.scoreInfoArray.append(gameResult)
            scoreVC.delegate = self
            UserDefaults.standard.setValue(scoreVC.scoreInfoArray, forKey: "scoreInfoArray")
            self.present(scoreVC, animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        alertController.addAction(mainMenuAction)
        alertController.addAction(scoreMenuAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    func resetGame() {
        score = 0
        self.scoreLabel.text = "Score: \(self.score)"
        
        oxygenLevel.progress = 0.5
        
        submarineImage.frame.origin.y = startSubmarinePositionY
        boatImageView.frame.origin.y = startBoatPositionY
        firstFishImage.frame.origin.y = startFirstFishPositionY
        secondFishImage.frame.origin.y = startSecondFishPositionY
        crabImage.frame.origin.y = startCrabPositionY
        oxygenLevel.frame.origin.y = startOxygenLevelY
        
        submarineImage.frame.origin.x = startSubmarinePositionX
        boatImageView.frame.origin.x = startBoatPositionX
        firstFishImage.frame.origin.x = startFirstFishPositionX
        firstFishImage.frame.origin.x = startSecondFishPositionX
        crabImage.frame.origin.x = startCrabPositionX
        oxygenLevel.frame.origin.x = startOxygenLevelX
        
        isGamePaused = false
        
        moveBoat()
        moveFish()
        moveCrab()
        changeOxygenLevel()
    }
    
    // MARK: IBAction
    
    
    @IBAction func upButtonPressed(_ sender: UIButton) {
        let distanceYBetweenOxygenLevelAndSubmarineImage = abs(oxygenLevel.frame.origin.y - submarineImage.frame.origin.y)
        UIView.animate(withDuration: 0.5) {
            if self.submarineImage.frame.origin.y < self.topHeight {
                self.submarineImage.frame.origin.y = self.topHeight + distanceYBetweenOxygenLevelAndSubmarineImage
                self.oxygenLevel.frame.origin.y = self.topHeight
            }
            self.oxygenLevel.frame.origin.y -= 30
            self.submarineImage.frame.origin.y -= 30
        }
    }
    
    @IBAction func downButtonPressed(_ sender: UIButton) {
        let distanceYBetweenOxygenLevelAndSubmarineImage = abs(oxygenLevel.frame.origin.y - submarineImage.frame.origin.y)
        UIView.animate(withDuration: 0.5) {
            if self.submarineImage.frame.origin.y > self.bottomHeight {
                self.submarineImage.frame.origin.y = self.bottomHeight
                self.oxygenLevel.frame.origin.y = self.submarineImage.frame.origin.y - distanceYBetweenOxygenLevelAndSubmarineImage
            }
            self.oxygenLevel.frame.origin.y += 30
            self.submarineImage.frame.origin.y += 30
        }
    }
}

extension ViewController: ScoreViewControllerDelegate {
    func addScoreResult(_ result: String) {
        scoreInfoArray.append(result)
    }
    
    
}
