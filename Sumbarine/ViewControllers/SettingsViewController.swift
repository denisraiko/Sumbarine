//
//  SettingsViewController.swift
//  Sumbarine
//
//  Created by Denis Raiko on 12.03.24.
//

import UIKit

class SettingsViewController: UIViewController {
    
    
    
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var mainMenuButton: UIButton!
    @IBOutlet weak var submarineColorLabel: UILabel!
    @IBOutlet weak var enemyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var redButton: UIButton!
    
    @IBOutlet weak var blueButton: UIButton!
    
    @IBOutlet weak var scoreButton: UIButton!
    
    let submarines = ["redSubmarine", "blueSubmarine"]
    var selectedImage: UIImage?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainMenuButton.titleLabel?.text = "Main menu".localize()
        settingsLabel.text = "Settings".localize()
        submarineColorLabel.text = "Select submarine color".localize()
        enemyLabel.text = "Select enemy".localize()
        nameLabel.text = "Name".localize()
        scoreButton.titleLabel?.text = "Score".localize()
        redButton.titleLabel?.text = "Red".localize()
        blueButton.titleLabel?.text = "Blue".localize()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if let font = UIFont(name: "abosanova", size: 35) {
            settingsLabel.font = font
        
        }
        settingsLabel.textAlignment = .center
        
        if let font = UIFont(name: "abosanova", size: 15) {
            mainMenuButton.titleLabel?.font = font
        }
        mainMenuButton.titleLabel?.textAlignment = .center
        
        if let font = UIFont(name: "abosanova", size: 20) {
            scoreButton.titleLabel?.font = font
        }
       
        if let font = UIFont(name: "abosanova", size: 20) {
            submarineColorLabel.font = font
        }
        if let font = UIFont(name: "abosanova", size: 20) {
            enemyLabel.font = font
        }
        if let font = UIFont(name: "abosanova", size: 20) {
            nameLabel.font = font
        }
        
        
        
        
        
    }
    
    
    
    
    
    @IBAction func redButtonPressed(_ sender: UIButton) {
        let imageName = "redSubmarine"
            UserDefaults.standard.setValue(imageName, forKey: "selectedSubmarineImage")
            guard let startVC = storyboard?.instantiateViewController(withIdentifier: "StartViewController") as? StartViewController else { return }
            startVC.selectedImage = UIImage(named: imageName)
    }
    
    @IBAction func blueButtonPressed(_ sender: UIButton) {
        let imageName = "blueSubmarine"
        UserDefaults.standard.setValue(imageName, forKey: "selectedSubmarineImage")
        guard let startVC = storyboard?.instantiateViewController(withIdentifier: "StartViewController") as? StartViewController else { return }
        startVC.selectedImage = UIImage(named: imageName)

    }
    
    @IBAction func mainMenuButtonPressed(_ sender: UIButton) {
        let savedText = nameTextField.text
        UserDefaults.standard.setValue(savedText, forKey: "text")
        guard let loadedText = UserDefaults.standard.value(forKey: "text") as? String else { return }
        guard let startVC = storyboard?.instantiateViewController(withIdentifier: "StartViewController") as? StartViewController else { return }
        startVC.userName = loadedText
        if redButton.isEnabled {
            startVC.selectedImage = selectedImage
        }
        if blueButton.isEnabled {
            startVC.selectedImage = selectedImage
        }
        present(startVC, animated: true, completion: nil)
    }
    
    @IBAction func scoreButtonPressed(_ sender: UIButton) {
        guard let scoreVC = storyboard?.instantiateViewController(withIdentifier: "ScoreViewController") as? ScoreViewController else { return }
        scoreVC.modalPresentationStyle = .fullScreen
        present(scoreVC, animated: true, completion: nil)
    }
    
    
    
    
}



