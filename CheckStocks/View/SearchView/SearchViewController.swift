//
//  SearchViewController.swift
//  CheckStocks
//
//  Created by Александр Кузьминов on 11.10.23.
//

import UIKit

protocol SearchViewProtocol: AnyObject {
    func reloadData()
//    func openDetailedVC(vc: UIViewController)
}

class SearchViewController: UIViewController,SearchViewProtocol {
    
    
   
    var presenter:SearchPresenterProtocol?
    private let searchController = UISearchController(searchResultsController: nil)

    
    lazy var collectionViewRecent:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    lazy var tableViewLooked:UITableView = {
        let collection = UITableView()
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    lazy var labelRecent:UILabel = {
        let label = UILabel()
        label.text = "You have searched for this"
        label.textColor = .black
        label.backgroundColor = .clear
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configSearchBar()
        configLayout()
        collectionViewRecent.collectionViewLayout = recentCollectionLayout()
        presenter?.didLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
            self.searchController.isActive = true
        }
    }
    
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionViewRecent.reloadData()
        }
    }
    

    
    //MARK: UI CONSTRAINTS
    
    func setupUI() {
        view.backgroundColor = .white
        

        collectionViewRecent.delegate = self
        collectionViewRecent.dataSource = self
        
        tableViewLooked.delegate = self
        tableViewLooked.dataSource = self
        
        collectionViewRecent.register(RecentCollectionViewCell.self, forCellWithReuseIdentifier: "recent")
        tableViewLooked.register(LookedTableViewCell.self, forCellReuseIdentifier: "looked")
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(collectionViewRecent)
        view.addSubview(labelRecent)
        view.addSubview(tableViewLooked)
    }

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
        searchController.searchResultsUpdater = self
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
    
    func recentCollectionLayout() -> UICollectionViewCompositionalLayout {
       let size = NSCollectionLayoutSize(
           widthDimension: .absolute(90),
           heightDimension: .absolute(50)
       )
       
       let item = NSCollectionLayoutItem(layoutSize: size)
       
       let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, repeatingSubitem: item, count: 4)
       group.interItemSpacing = NSCollectionLayoutSpacing.fixed(2)
       
       let section = NSCollectionLayoutSection(group: group)
       section.interGroupSpacing = 2
       section.contentInsets = .init(
           top: 2,
           leading: 1,
           bottom: 2,
           trailing: 2
       )
       
       return UICollectionViewCompositionalLayout(section: section)
   }
    
    func  configLayout(){
        NSLayoutConstraint.activate([
            
            labelRecent.topAnchor.constraint(equalTo: view.topAnchor,constant: 331),            //271
            labelRecent.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            labelRecent.widthAnchor.constraint(equalToConstant: 300),
            labelRecent.heightAnchor.constraint(equalToConstant: 20),
            
            collectionViewRecent.topAnchor.constraint(equalTo: view.topAnchor,constant: 366), // 306
            collectionViewRecent.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            collectionViewRecent.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            collectionViewRecent.heightAnchor.constraint(equalToConstant: 200),
            
            tableViewLooked.topAnchor.constraint(equalTo: view.topAnchor,constant: 60),
            tableViewLooked.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 5),
            tableViewLooked.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -5),
            tableViewLooked.bottomAnchor.constraint(equalTo: labelRecent.topAnchor,constant: -30)
        ])
        
    }
    
}

//MARK: RECENT TABLE DELEGATE

extension SearchViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.searchHistory.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewRecent.dequeueReusableCell(withReuseIdentifier: "recent", for: indexPath) as! RecentCollectionViewCell
        
        if indexPath.section % 2 != 0 {
            cell.setupColor(color: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00))
        } else {
            cell.setupColor(color: UIColor(red: 0.94, green: 0.96, blue: 0.97, alpha: 1.00))
        }
        
        guard let model = self.presenter?.searchHistory else { return UICollectionViewCell() }

        cell.configData(with: model[indexPath.section])
        return cell
    }
    
}

extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.filteredRows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewLooked.dequeueReusableCell(withIdentifier: "looked") as! LookedTableViewCell
        
        if indexPath.section % 2 != 0 {
            cell.setupColor(color: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00))
        } else {
            cell.setupColor(color: UIColor(red: 0.94, green: 0.96, blue: 0.97, alpha: 1.00))
        }
        
        guard let model = self.presenter?.filteredRows else { return UITableViewCell() }

        cell.config(with: model[indexPath.section])
//        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
}

//MARK: - SEARCH-CONTROLLER

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        presenter?.filterContentForSearchText(text)
        
        tableViewLooked.reloadData()
    }
}

//extension SearchViewController {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        self.showTableViewOrCollectionView(searchText.isEmpty)
//        if searchText.isEmpty {
//            UIView.animate(withDuration: 0.3) {
//                self.bottomTableViewConstraint.constant = self.view.frame.height - 381
//                self.view.layoutIfNeeded()
//                self.tableView.isScrollEnabled = false
//                self.tableHeaderView.setNameForButton()
//            }
//        }
//    }
//}


extension SearchViewController:UISearchControllerDelegate,UISearchBarDelegate{
    
}
