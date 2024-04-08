//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Ринат Шарафутдинов on 04.04.2024.
//

import Foundation
import UIKit

final class MyNFTViewController: UIViewController {
    
    //MARK:  - Public Properties
   
    
    //MARK:  - Private Properties
    private lazy var returnButton: UIBarButtonItem = {
        let button = UIBarButtonItem( image: UIImage(systemName: "chevron.left"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(returnButtonTap))
        button.tintColor = UIColor(named: "ypBlack")
        return button
    }()
    
    private lazy var sortingButton: UIBarButtonItem = {
        let button = UIBarButtonItem( image: UIImage(systemName: "text.justify.left"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(sortingButtonTap))
        button.tintColor = UIColor(named: "ypBlack")
        return button
    }()
    
    private lazy var myNFTTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            MyNFTCell.self,
            forCellReuseIdentifier: MyNFTCell.cellID
        )
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    //MARK: - Action
    @objc func returnButtonTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sortingButtonTap() {
        
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizingNavigation()
        customizingScreenElements()
        customizingTheLayoutOfScreenElements()
    }
    //MARK: - Private Methods
    func customizingNavigation() {
        navigationController?.navigationBar.backgroundColor = UIColor(named: "ypWhite")
        navigationItem.title = "Мой NFT"
        navigationItem.leftBarButtonItem = returnButton
        navigationItem.rightBarButtonItem = sortingButton
    }
    
    private func customizingScreenElements() {
        view.addSubview(myNFTTableView)
    }
    
    private func customizingTheLayoutOfScreenElements() {
        NSLayoutConstraint.activate([
            myNFTTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            myNFTTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            myNFTTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            myNFTTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - UITableViewDataSource
extension MyNFTViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyNFTCell.cellID,for: indexPath) as? MyNFTCell else {fatalError("Could not cast to MyNFTCell")}
        switch indexPath.row {
        case 0:
            cell.changingNFT(image: "liloImage", name: "Lilo")
        case 1:
            cell.changingNFT(image: "springImage", name: "Spring")
        case 2:
            cell.changingNFT(image: "aprilImage", name: "April")
        default:
            break
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MyNFTViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}