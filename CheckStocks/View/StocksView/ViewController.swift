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
    private let primaryMenu = PrimaryMenu()

    
    lazy var tableViewStocks:UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableViewStocks.register(StocksTableViewCell.self, forCellReuseIdentifier: "table")
       
        
        tableViewStocks.delegate = self
        tableViewStocks.dataSource = self
        view.addSubview(tableViewStocks)
        
        primaryMenu.backgroundColor = .white
        primaryMenu.delegate = self
        primaryMenu.configure(with: ["Stocks", "Favorite"])
        
        view.addSubview(primaryMenu)
       
        setupUI()
        configLayout()
        setPrimaryMenuConstraints()
        presenter?.didLoadStocks()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detectedCurrentIndex()
    }
    
    private func detectedCurrentIndex() {
        if currentIndex == 0 {
            presenter?.didLoadStocks()
        } else {
            presenter?.favoriteModels = []
            presenter?.didTapFavoriteMenuItem()
        }
    }
    
    private func setPrimaryMenuConstraints() {
        NSLayoutConstraint.activate([
            primaryMenu.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
            primaryMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            //primaryMenu.heightAnchor.constraint(equalToConstant: 25),
            primaryMenu.bottomAnchor.constraint(equalTo: tableViewStocks.topAnchor, constant: -25),
        ])
        
    }
    
    func setupUI(){
        tableViewStocks.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
    }
   
    func configLayout(){
        NSLayoutConstraint.activate([
            tableViewStocks.topAnchor.constraint(equalTo: view.topAnchor,constant: 140),
            tableViewStocks.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 15),
            tableViewStocks.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -15),
            tableViewStocks.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -50),
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
        } else {
            presenter?.refreshFavoriteMenu()
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
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
}


extension ViewController: TapProtocol {
    func didTap(bool: Bool, name: String) {
        presenter?.changeIsFavorite(bool: bool, ticker: name)
    }
}

extension ViewController: MenuStackDelegate {
    func changeMenu(index: Int) {
        self.currentIndex = index
        presenter?.changeMenu(index: index)
    }
}
