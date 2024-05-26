//
//  StartViewController.swift
//  Sumbarine
//
//  Created by Denis Raiko on 22.02.24.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var scoreButton: UIButton!
    
    var selectedImage: UIImage?
    var userName = ""
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startButton.titleLabel?.text = "Start Game".localize()
        settingsButton.titleLabel?.text = "Settings".localize()
        scoreButton.titleLabel?.text = "Score".localize()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let font = UIFont(name: "abosanova", size: 15) {
            startButton.titleLabel?.font = font
            settingsButton.titleLabel?.font = font
            scoreButton.titleLabel?.font = font
        }
        startButton.titleLabel?.textAlignment = .center
        settingsButton.titleLabel?.textAlignment = .center
        scoreButton.titleLabel?.textAlignment = .center
        
    }
    
    
    
    
    
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        guard let gameVC = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return }
            gameVC.modalPresentationStyle = .fullScreen
            gameVC.userName = self.userName
            guard let imageName = UserDefaults.standard.string(forKey: "selectedSubmarineImage") else { return }
            selectedImage = UIImage(named: imageName)
            gameVC.selectedImage = selectedImage
            present(gameVC, animated: true, completion: nil)
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        guard let settingsVC = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else { return }
        settingsVC.modalPresentationStyle = .fullScreen
        present(settingsVC, animated: true, completion: nil)
    }
    
    @IBAction func scoreButtonPressed(_ sender: UIButton) {
        guard let scoreVC = storyboard?.instantiateViewController(withIdentifier: "ScoreViewController") as? ScoreViewController else { return }
        scoreVC.modalPresentationStyle = .fullScreen
        present(scoreVC, animated: true, completion: nil)
    }
    
    
}
