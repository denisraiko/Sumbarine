//
//  ScoreViewController.swift
//  Sumbarine
//
//  Created by Denis Raiko on 30.03.24.
//

import UIKit

protocol ScoreViewControllerDelegate: AnyObject {
    func addScoreResult(_ result: String)
}

class ScoreViewController: UIViewController {
    
    weak var delegate: ScoreViewControllerDelegate?

    
    
    @IBOutlet weak var mainMenuButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var currentDate: String?
    var score: Int?
    
    var scoreInfoArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let savedScoreInfoArray = UserDefaults.standard.array(forKey: "scoreInfoArray") as? [String] {
                scoreInfoArray = savedScoreInfoArray
            }

        if let font = UIFont(name: "abosanova", size: 35) {
            scoreLabel.font = font
        
        }
        scoreLabel.textAlignment = .center
        
        if let font = UIFont(name: "abosanova", size: 15) {
            mainMenuButton.titleLabel?.font = font
        }
        mainMenuButton.titleLabel?.textAlignment = .center
        
    }
    
   

    @IBAction func mainMenuButtonPressed(_ sender: UIButton) {
        delegate?.addScoreResult("\(currentDate ?? ""), Score: \(score ?? 0)")
           }
}

extension ScoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreInfoArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.scoreInfo.text = scoreInfoArray[indexPath.row]

        return cell
    }
}

