//
//  ViewController.swift
//  CheckStocks
//
//  Created by Александр Кузьминов on 18.09.23.
//

import UIKit


protocol StocksMainViewProtocol: AnyObject {
    func reloadData()
    func openSearchVC(vc: UIViewController)
    //func openDetailedVC(vc: UIViewController)
    
}

class ViewController: UIViewController,StocksMainViewProtocol {
  
    var currentIndex: Int = 0
    var presenter:StocksMainPresenterProtocol?
    
    private var refreshControl = UIRefreshControl()
    private let primaryMenu = PrimaryMenu()
    private let searchController = UISearchController(searchResultsController: nil)
    
    lazy var tableViewStocks:UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    //MARK: DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configLayout()
        setPrimaryMenuConstraints()
        presenter?.didLoadStocks()
        createGestureRecognizer()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detectedCurrentIndex()
    }
    
   
    //MARK: CONSTRAINTS UI
    
    private func setPrimaryMenuConstraints() {
        NSLayoutConstraint.activate([
//            primaryMenu.topAnchor.constraint(equalTo: view.topAnchor, constant: 65),
            
            primaryMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            primaryMenu.heightAnchor.constraint(equalToConstant: 25),
            primaryMenu.bottomAnchor.constraint(equalTo: tableViewStocks.topAnchor, constant: -25),
        ])
        
    }
    
    func setupUI() {
        view.backgroundColor = .white

        primaryMenu.backgroundColor = .white
        primaryMenu.delegate = self
        primaryMenu.configure(with: ["Stocks", "Favorite"])
        view.addSubview(primaryMenu)

        searchController.searchBar.delegate = self
        searchController.delegate = self
        navigationItem.searchController = searchController

        tableViewStocks.register(StocksTableViewCell.self, forCellReuseIdentifier: "table")
        tableViewStocks.delegate = self
        tableViewStocks.dataSource = self
        view.addSubview(tableViewStocks)

        tableViewStocks.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
    }

   
    func configLayout(){
        NSLayoutConstraint.activate([
            tableViewStocks.topAnchor.constraint(equalTo: view.topAnchor,constant: 220),
            tableViewStocks.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 15),
            tableViewStocks.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -15),
            tableViewStocks.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -50),
        ])
    }
    
    //MARK: SERACH BAR
    
    private func configSearchBar() {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Montserrat-SemiBold", size: 16) as Any
        ]
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchController.searchBar.searchTextField.layer.cornerRadius = 18
        searchController.searchBar.searchTextField.layer.masksToBounds = true
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.searchTextField.borderStyle = .none
        searchController.searchBar.searchTextField.layer.borderWidth = 1
        searchController.searchBar.searchTextField.layer.borderColor = UIColor.black.cgColor
        searchController.searchBar.searchTextField.tintColor = .black
        searchController.searchBar.searchTextField.textColor = .black
        searchController.searchBar.tintColor = .black
        searchController.searchBar.setImage(UIImage(named: "searchLeftImage"), for: .search, state: .normal)
        searchController.searchBar.setImage(UIImage(named: "searchRightImage"), for: .clear, state: .normal)
//        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Find company or ticker", attributes: attributes)
        searchController.searchBar.searchTextField.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        searchController.searchBar.backgroundColor = .white
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.clearsContextBeforeDrawing = true
        
        navigationItem.titleView?.backgroundColor = .white
        navigationItem.searchController?.searchBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.barStyle = UIBarStyle.default
        navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    func openSearchVC(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: SWIPE RECOGNIZER
    
    private func createGestureRecognizer() {
            let swipeleft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe))
            swipeleft.direction = .left
            self.view.addGestureRecognizer(swipeleft)
            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe))
            swipeRight.direction = .right
            self.view.addGestureRecognizer(swipeRight)
            
            let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe))
            swipeUp.direction = .up
            self.view.addGestureRecognizer(swipeUp)
            
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe))
            swipeDown.direction = .up
            self.view.addGestureRecognizer(swipeDown)
        
    }
    
    @objc private func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            presenter?.changeMenu(index: 1)
            currentIndex = 1
            primaryMenu.forceUpdatePosition(1)
        } else {
            presenter?.changeMenu(index: 0)
            currentIndex = 0
            primaryMenu.forceUpdatePosition(0)
        }
    }
    
  
    
    //MARK: CHANGE MENU METHODS
    
    private func detectedCurrentIndex() {
        if currentIndex == 0 {
            presenter?.didLoadStocks()
        } else {
            presenter?.favoriteModels = []
            presenter?.didTapFavoriteMenuItem()
        }
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

//MARK: TABLE VIEW STOCKS DELEGATE

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

//MARK: FAVOURITE EXTENSIONS

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

extension ViewController:UISearchBarDelegate,UISearchControllerDelegate{
    
}

extension ViewController{
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        presenter?.openSearchVC()
        return false
    }
}
