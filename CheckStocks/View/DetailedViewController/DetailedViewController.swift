//
//  DetailedViewController.swift
//  CheckStocks
//
//  Created by Александр Кузьминов on 29.11.23.
//

import UIKit

class DetailedViewController: UIViewController {

    lazy var tickerLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var nameLabel:UILabel = {
        let label = UILabel()
        return label
    }()
      
    lazy var favouriteButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Star"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func configUI(){
        view.addSubview(tickerLabel)
        view.addSubview(nameLabel)
        view.addSubview(favouriteButton)
    }
    
    func configLayout(){
        NSLayoutConstraint.activate([
        
            tickerLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 20),
            tickerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 138),
            tickerLabel.widthAnchor.constraint(equalToConstant: 52),
            tickerLabel.heightAnchor.constraint(equalToConstant: 24),
            
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 40),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 133),
            nameLabel.widthAnchor.constraint(equalToConstant: 62),
            nameLabel.heightAnchor.constraint(equalToConstant: 16),
            
            favouriteButton.topAnchor.constraint(equalTo: view.topAnchor,constant: 40),
            favouriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 280),
            favouriteButton.widthAnchor.constraint(equalToConstant: 48),
            favouriteButton.heightAnchor.constraint(equalToConstant: 48)
            
        ])
    }

}
