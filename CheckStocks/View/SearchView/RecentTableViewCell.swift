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
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var labelRecent:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    func setupColor(color: UIColor) {
        self.backgroundColor = color
    }
    
    func configData(with model:PropertyRowStockModel){
        labelRecent.text = model.name
    }
    
    func configLayout(){
        NSLayoutConstraint.activate([
            labelRecent.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            labelRecent.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 10)
            
        ])
    }
    
}
