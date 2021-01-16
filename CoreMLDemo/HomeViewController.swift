//
//  HomeViewController.swift
//  CoreMLDemo
//
//  Created by Sambit Das on 17/01/21.
//

import UIKit

class HomeViewController: UIViewController {
   
    //MARK:- Outlets & properties
    @IBOutlet weak var tableViewCelll: UITableView!
    var cellTitle = ["Object Detection", "Speech Recognization"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        tableViewCelll.delegate = self
        tableViewCelll.dataSource = self
    }
}

//MARK:- UITableViewDataSource
extension HomeViewController:  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewCelll.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.sectionName.text = cellTitle[indexPath.row]
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 2
        cell.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return cell
    }
}

//MARK:- UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            navigateToImageDetectScreen()
        case 1:
            navigateToSpeechScreen()
        default:
            print("default")
        }
    }

    private func navigateToImageDetectScreen() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ObjectDetectViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToSpeechScreen() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SpeechViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
