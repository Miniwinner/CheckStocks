//
//  RecentTableViewCell.swift
//  CheckStocks
//
//  Created by Александр Кузьминов on 11.10.23.
//

import UIKit

class RecentCollectionViewCell: UICollectionViewCell {

   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var labelRecent:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.backgroundColor = .red
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    func setupColor(color: UIColor) {
        self.backgroundColor = color
    }
    
    func configData(with model:String){
        labelRecent.text = model
    }
    
    func setupUI(){
        self.addSubview(labelRecent)
    }
    
    func configLayout(){
        NSLayoutConstraint.activate([
            labelRecent.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 5),
            labelRecent.heightAnchor.constraint(equalToConstant:35),
            labelRecent.topAnchor.constraint(equalTo: self.topAnchor,constant: 5),
            labelRecent.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -5)
        ])
    }
    
}
