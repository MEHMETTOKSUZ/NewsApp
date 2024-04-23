//
//  SearchViewController.swift
//  NewsApp
//
//  Created by Mehmet ÖKSÜZ on 16.04.2024.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let viewModel = SearchViewModel()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTableCells()
        setUpSearchController()
        
    }
    
    func registerTableCells() {
        let nibname = UINib(nibName: "SearchTableViewCell", bundle: nil)
        tableView.register(nibname, forCellReuseIdentifier: "SearchTableViewCell")
    }
    
    func setUpSearchController() {
        searchController.searchBar.barTintColor = UIColor.darkGray
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search News", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        searchController.searchBar.searchTextField.textColor = UIColor.white
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemInSection
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        guard let data = viewModel.item(at: indexPath.row) else {
            return cell
        }
        cell.itemFromCell(item: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedItem = viewModel.item(at: indexPath.row) else {
            return
        }
        
        let urlString = selectedItem.url ?? ""
        guard let url = URL(string: urlString) else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let query = searchController.searchBar.text {
            viewModel.searchResponse(query: query)
        }
        
        if searchController.searchBar.text?.isEmpty ?? true {
            viewModel.clearResults()
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
