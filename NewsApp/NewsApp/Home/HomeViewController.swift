//
//  ViewController.swift
//  NewsApp
//
//  Created by Mehmet ÖKSÜZ on 4.04.2024.
//

import UIKit
import SafariServices
import Firebase
import FirebaseStorage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    let menuItems = ["Top Head Lines", "Finance", "Featured", "Science", "Sports", "Gaming", "Technology", "Politics", "Fashion", "Cinema", "Arts"]
    let viewModel = ViewModel()
    var viewOpen: Bool = true
    private let firestore = Firestore.firestore()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FavoriteManager.shared.load()
        navigationItem.leftBarButtonItem = menuButton
        self.containerView.isHidden = true
        viewOpen = false
        tableView.separatorStyle = .none
        registerTableCells()
        registerCollectionCells()
        fetchUserInfo()
        viewModel.didFinishLoad = {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(upgradeData), name: NSNotification.Name(rawValue: "notifications"), object: nil)
    }
    
    @objc func upgradeData() {
        collectionView.reloadData()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    func registerCollectionCells() {
        
        let nibName = UINib(nibName: "NewsCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "NewsCollectionViewCell")
    }
    
    func registerTableCells() {
        
        let nibName = UINib(nibName: "MenuTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "MenuTableViewCell")
    }
    
    
    @IBAction func menuButtonClicked(_ sender: Any) {
        
        setUpMenu()
    }
    
    func setUpMenu() {
        
        if viewOpen {
            UIView.animate(withDuration: 0.5) {
                self.containerView.transform = CGAffineTransform(translationX: -self.containerView.frame.width, y: 0)
                self.tableView.transform = CGAffineTransform(translationX: -self.containerView.frame.width, y: 0)
            } completion: { _ in
                self.containerView.isHidden = true
                self.tableView.isHidden = true
            }
        } else {
            containerView.isHidden = false
            tableView.isHidden = false
            containerView.transform = CGAffineTransform(translationX: -containerView.frame.width, y: 0)
            tableView.transform = CGAffineTransform(translationX: -containerView.frame.width, y: 0)
            UIView.animate(withDuration: 0.3) {
                self.containerView.transform = .identity
                self.tableView.transform = .identity
            }
        }
        viewOpen = !viewOpen
    }
    
    private func fetchUserInfo() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else { return }
        
        firestore.collection("UserInfo").whereField("email", isEqualTo: currentUserEmail).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, !documents.isEmpty else {
                print("Error fetching user info: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let userInfo = documents.first?.data() {
                DispatchQueue.main.async {
                    self.emailLabel.text = currentUserEmail
                    self.usernameLabel.text = userInfo["userName"] as? String
                }
            }
        }
    }
    
    @IBAction func bookMarkButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toFavoriteFromHome", sender: nil)
    }
    
    @IBAction func logOutButtonClicked(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toLogInScreenFromSettings", sender: nil)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as! NewsCollectionViewCell
        guard let data = viewModel.item(at: indexPath.row) else {
            return cell
        }
        cell.itemFromCell(item: data)
        
        cell.favoriteButtonClicked = {
            FavoriteManager.shared.add(item: data.data)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.bounds.width
        let cellSize = width / 2 - 15
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        cell.menuTitleLabel.text = menuItems[indexPath.row]
        cell.menuImageView.image = UIImage(named: menuItems[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMenuItem = menuItems[indexPath.row]
        viewModel.makeRequest(for: selectedMenuItem)
        navigationItem.title = selectedMenuItem
        
    }
}


