//
//  ViewController.swift
//  CheckStocks
//
//  Created by Александр Кузьминов on 18.09.23.
//

import UIKit


protocol StocksMainViewProtocol: AnyObject {
    func reloadData()
    //func openSearchVC(vc: UIViewController)
    //func openDetailedVC(vc: UIViewController)
}

class ViewController: UIViewController,StocksMainViewProtocol {
    var currentIndex: Int = 0
    var presenter:StocksMainPresenterProtocol?
    
    private var refreshControl = UIRefreshControl()
    
    
    lazy var tableViewStocks:UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    lazy var buttonStocks:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Stocks", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .gray
        

        return button
    }()
    
    lazy var buttonFavourite:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Favourite", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .gray
        
        return button
    }()
    
    lazy var stackViewStocks:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .black
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableViewStocks.register(StocksTableViewCell.self, forCellReuseIdentifier: "table")
        
        tableViewStocks.delegate = self
        tableViewStocks.dataSource = self
        
        stackViewStocks.addArrangedSubview(buttonStocks)
        stackViewStocks.addArrangedSubview(buttonFavourite)
        
        view.addSubview(tableViewStocks)
        view.addSubview(stackViewStocks)
        presenter?.didLoadStocks()
        configLayout()
        setupUI()
    }
       
    func setupUI(){
        tableViewStocks.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshTable(_:)), for: .valueChanged)

    }
    
    
    func configLayout(){
        NSLayoutConstraint.activate([
            tableViewStocks.topAnchor.constraint(equalTo: view.topAnchor,constant: 240),
            tableViewStocks.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 15),
            tableViewStocks.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -15),
            tableViewStocks.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -50),
            
            stackViewStocks.heightAnchor.constraint(equalToConstant: 50),
            stackViewStocks.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            stackViewStocks.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -80),
            stackViewStocks.bottomAnchor.constraint(equalTo: tableViewStocks.topAnchor,constant: -5)
        ])
        
    }
    
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableViewStocks.reloadData()
        }
    }
    
    @objc private func refreshTable(_ sender: AnyObject) {
        if currentIndex == 0 {
            presenter?.didLoadStocks()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableViewStocks.contentInset = UIEdgeInsets(top: self.refreshControl.frame.height, left: 0, bottom: 0, right: 0)
            self.refreshControl.endRefreshing()
            self.tableViewStocks.contentInset = .zero
        }
    }
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.currentList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewStocks.dequeueReusableCell(withIdentifier: "table") as! StocksTableViewCell
        
        if indexPath.section % 2 != 0 {
            cell.setupColor(color: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00))
        } else {
            cell.setupColor(color: UIColor(red: 0.94, green: 0.96, blue: 0.97, alpha: 1.00))
        }
        
        guard let model = self.presenter?.currentList else { return UITableViewCell() }

        cell.config(with: model[indexPath.section])
        
        
        
        return cell
    }
    

    
}
