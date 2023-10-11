//
//  StocksTableViewCell.swift
//  CheckStocks
//
//  Created by Александр Кузьминов on 18.09.23.
//

import UIKit

protocol TapProtocol{
    func didTap(bool:Bool,name:String)
}


class StocksTableViewCell: UITableViewCell {

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configUI()
        configLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var delegate: TapProtocol?
    
    lazy var labelPrice:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    lazy var labelDayDelta:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    
    lazy var labelDayDeltaPercent:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    
    lazy var labelTicker:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
    lazy var labelName:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 7)
        label.textColor = .black
        return label
    }()
    
    lazy var isFavouriteButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = true
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(favoriteButtonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var imageSymbol:CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        return image
    }()
    
    func setupColor(color: UIColor) {
        self.backgroundColor = color
    }
    
    func configUI(){
        contentView.addSubview(isFavouriteButton)
        self.addSubview(labelName)
        self.addSubview(imageSymbol)
        self.addSubview(labelPrice)
        self.addSubview(labelTicker)
        self.addSubview(labelDayDelta)
        self.addSubview(labelDayDeltaPercent)
        
        self.layer.cornerRadius = 12
        self.selectionStyle = .none
    }
    
    func config(with model: PropertyRowStockModel) {
        labelName.text = model.name
        imageSymbol.load(urlString: model.image)
        labelTicker.text = model.tickerName
        labelPrice.text = "$\(model.currentPrice)"
        labelDayDelta.text = "$ \(model.deltaPrice)"
        labelDayDeltaPercent.text = "(\((model.deltaProcent * 100).rounded() / 100)%)"
        rg(deltaPercent: model)
        buttonSelected(bool: model.isFavourite)
    }
    
    func buttonSelected(bool: Bool) {
        bool ? isFavouriteButton.setImage(UIImage(named: "Star1"), for: .normal) : isFavouriteButton.setImage(UIImage(named: "Star"), for: .normal)
    }
    
    @objc func favoriteButtonAction() {
        if isFavouriteButton.imageView?.image == UIImage(named: "Star1")  {
            buttonSelected(bool: false)
            isFavouriteButton.isSelected = !isFavouriteButton.isSelected
            
            delegate?.didTap(bool: false, name: labelTicker.text ?? "")
        } else if isFavouriteButton.imageView?.image == UIImage(named: "Star") {
            buttonSelected(bool: true)
            isFavouriteButton.isSelected = !isFavouriteButton.isSelected
            
            delegate?.didTap(bool: true, name: labelTicker.text ?? "")
        }
    }

    func rg(deltaPercent:PropertyRowStockModel){
        if deltaPercent.deltaPrice < 0 {
            labelDayDeltaPercent.textColor = .red
            labelDayDelta.textColor = .red
        }else{
            labelDayDeltaPercent.textColor = UIColor(red: 36 / 255.0, green: 178 / 255.0, blue: 93 / 255.0, alpha: 1)
            
            labelDayDelta.textColor = UIColor(red: 36 / 255.0, green: 178 / 255.0, blue: 93 / 255.0, alpha: 1)
        }
    }
    
    func configLayout(){
        
        NSLayoutConstraint.activate([
        
            imageSymbol.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 8),
            imageSymbol.topAnchor.constraint(equalTo: self.topAnchor,constant: 8),
            imageSymbol.widthAnchor.constraint(equalToConstant: 52),
            imageSymbol.heightAnchor.constraint(equalToConstant: 52),
            
            labelName.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 72),
            labelName.topAnchor.constraint(equalTo: self.topAnchor,constant: 39),
            labelName.heightAnchor.constraint(equalToConstant: 16),
            labelName.widthAnchor.constraint(equalToConstant: 130),
            
            labelTicker.widthAnchor.constraint(equalToConstant: 76),
            labelTicker.heightAnchor.constraint(equalToConstant: 24),
            labelTicker.topAnchor.constraint(equalTo: self.topAnchor,constant: 14),
            labelTicker.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 72),
            
            labelPrice.widthAnchor.constraint(equalToConstant: 100),
            labelPrice.heightAnchor.constraint(equalToConstant: 24),
            labelPrice.topAnchor.constraint(equalTo: self.topAnchor,constant: 14),
            labelPrice.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -45),
            
            labelDayDelta.widthAnchor.constraint(equalToConstant: 50),
            labelDayDelta.heightAnchor.constraint(equalToConstant: 16),
            labelDayDelta.topAnchor.constraint(equalTo: self.topAnchor,constant: 39),
            labelDayDelta.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 210),
            
            labelDayDeltaPercent.widthAnchor.constraint(equalToConstant: 50),
            labelDayDeltaPercent.heightAnchor.constraint(equalToConstant: 16),
            labelDayDeltaPercent.topAnchor.constraint(equalTo: self.topAnchor,constant: 39),
            labelDayDeltaPercent.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 270),
            
            isFavouriteButton.topAnchor.constraint(equalTo: self.topAnchor,constant: 14),
            isFavouriteButton.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 160),
            isFavouriteButton.heightAnchor.constraint(equalToConstant: 16),
            isFavouriteButton.widthAnchor.constraint(equalToConstant: 16),
            
            
            
        ])
    }
}
