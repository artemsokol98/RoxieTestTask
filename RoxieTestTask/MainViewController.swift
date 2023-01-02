//
//  MainViewController.swift
//  RoxieTestTask
//
//  Created by Артем Соколовский on 01.01.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(TaxiRideTableViewCell.self, forCellReuseIdentifier: TaxiRideTableViewCell.identifier)
        return tableView
    }()
    
    var viewModel: MainViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel = MainViewModel()
        viewModel.fetchData(completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(tableViewConstraints)
    }

}

extension MainViewController: UITableViewDelegate {
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaxiRideTableViewCell.identifier, for: indexPath) as? TaxiRideTableViewCell else { return TaxiRideTableViewCell() }
        cell.configureCell(cellInfo: viewModel.parsedTaxiRide[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.parsedTaxiRide.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300.0
    }
}

