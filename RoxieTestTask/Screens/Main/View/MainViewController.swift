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
    
    let spinner = UIActivityIndicatorView(style: .large)
    
    var viewModel: MainViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = spinner
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        viewModel = MainViewModel()
        sendRequest()
    }
    
    private func sendRequest() {
        spinner.startAnimating()
        viewModel?.fetchData(completion: { [weak self] result in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                switch result {
                case .success():
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        })
    }
    
    private func showAlert(title: String, message: String) {
        let action = UIAlertAction(title: "Try again", style: .default) { _ in
            self.sendRequest()
        }
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(action)
        present(alert, animated: true)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destanation = segue.destination as? DetailViewController else { return }
        guard let index = sender as? Int else { return }
        destanation.data = viewModel?.taxiRide[index]
    }

}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetail", sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
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
        Constants.mainVCTableViewHeightOfRow
    }
}

