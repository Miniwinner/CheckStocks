//
//  SearchViewController.swift
//  CheckStocks
//
//  Created by Александр Кузьминов on 11.10.23.
//

import UIKit

protocol SearchViewProtocol: AnyObject {
    func reloadData()
   // func openDetailedVC(vc: UIViewController)
}

class SearchViewController: UIViewController,SearchViewProtocol, UISearchResultsUpdating {
    
    
   
    var presenter:SearchPresenterProtocol?
    private let searchController = UISearchController(searchResultsController: nil)

    
    lazy var collectionViewRecent:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
            self.searchController.isActive = true
        }
    }
    
    
    func reloadData() {
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    //MARK: UI CONSTRAINTS
    
    func setupUI() {
        view.backgroundColor = .white
        
        collectionViewRecent.collectionViewLayout = recentCollectionLayout()
        
        collectionViewRecent.delegate = self
        collectionViewRecent.dataSource = self
        
        collectionViewRecent.register(RecentCollectionViewCell.self, forCellWithReuseIdentifier: "recent")
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(collectionViewRecent)
        
        view.addSubview(labelRecent)
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
           widthDimension: .estimated(55),
           heightDimension: .absolute(40)
       )
       
       let item = NSCollectionLayoutItem(layoutSize: size)
       
       let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, repeatingSubitem: item, count: 7)
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
            
            labelRecent.topAnchor.constraint(equalTo: view.topAnchor,constant: 271),
            labelRecent.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            labelRecent.widthAnchor.constraint(equalToConstant: 300),
            labelRecent.heightAnchor.constraint(equalToConstant: 20),
            
            collectionViewRecent.topAnchor.constraint(equalTo: view.topAnchor,constant: 306),
            collectionViewRecent.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            collectionViewRecent.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            collectionViewRecent.heightAnchor.constraint(equalToConstant: 200)
            
        ])
        
    }
    
}

//MARK: RECENT TABLE DELEGATE

extension SearchViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return presenter?.filteredRows.count ?? 0
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewRecent.dequeueReusableCell(withReuseIdentifier: "recent", for: indexPath) as! RecentCollectionViewCell
        
        if indexPath.section % 2 != 0 {
            cell.setupColor(color: UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00))
        } else {
            cell.setupColor(color: UIColor(red: 0.94, green: 0.96, blue: 0.97, alpha: 1.00))
        }
        
       // guard let model = self.presenter?.filteredRows else { return UICollectionViewCell() }

       // cell.configData(with: model[indexPath.section])
        return cell
    }
    
}

extension SearchViewController:UISearchControllerDelegate,UISearchBarDelegate{
    
}
