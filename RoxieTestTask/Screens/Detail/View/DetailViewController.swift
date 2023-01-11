//
//  DetailViewController.swift
//  RoxieTestTask
//
//  Created by Артем Соколовский on 03.01.2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    var data: AddressElement?
    var viewModel: DetailViewModelProtocol?
    var fetchedImage: Data?

    var heightOfPhoto: (_ height: CGFloat) -> CGFloat = { (height: CGFloat) in
        return height * Constants.multiplierHeightOfPhotoDetailView
    }
    
    let heightOfOneRowCollectionWithInfo: (CGFloat) -> CGFloat = { (width: CGFloat) in
        return width * Constants.multiplierHeightOfOneRowCollectionWithInfo
    }
    
    let spinner = UIActivityIndicatorView(style: .large)
    private var loadingView = UIActivityIndicatorView()
   
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DetailViewModel()
        viewModel?.data = data
        //tableView.backgroundView = spinner
        loadingView = LoadingIndicator.shared.showLoading(in: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        guard let photoElementCellReuseIdentifier = viewModel?.customElements[Constants.zeroRow].type.rawValue else { return }
        guard let nameElementCellReuseIdentifier = viewModel?.customElements[Constants.firstRow].type.rawValue else { return }
        
        tableView.register(PhotoElementCell.self, forCellReuseIdentifier: photoElementCellReuseIdentifier)
        tableView.register(NameElementCell.self, forCellReuseIdentifier: nameElementCellReuseIdentifier)
        sendRequest()
    }
    
    func sendRequest() {
        viewModel?.downloadImage { data in
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                switch data {
                case .success(()):
                    self.fetchedImage = self.viewModel?.image
                    guard let dataForArrayOfCells = self.viewModel?.data else { return }
                    let nameDriver = NameElement(nameDriver: dataForArrayOfCells.vehicle.driverName, arrayOfCells: self.viewModel?.parseForCollectionView(data: dataForArrayOfCells))
                    let newImage = PhotoElement(image: self.fetchedImage, apiString: "https://www.roxiemobile.ru/careers/test/images/" + dataForArrayOfCells.vehicle.photo)
                    self.viewModel?.customElements = [newImage, nameDriver]
                    self.tableView.reloadData()
                case .failure(let error):
                    self.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
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
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(tableViewConstraints)
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellModel = viewModel?.customElements[indexPath.row]
        guard let cellIdentifier = cellModel?.type.rawValue else { return UITableViewCell() }
        guard let customCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CustomElementCell else { return UITableViewCell() }
        customCell.configure(withModel: cellModel)
        guard let customCell = customCell as? UITableViewCell else { return UITableViewCell() }
        return customCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRowsInSection(numberOfElements: viewModel?.customElements.count)
    }
    
    func numberOfRowsInSection(numberOfElements: Int?) -> Int {
        guard let numberOfElements = numberOfElements else { return 0 }
        return numberOfElements
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case Constants.zeroRow: return heightOfPhoto(view.bounds.height)
        case Constants.firstRow: return heightOfOneRowCollectionWithInfo(view.bounds.width) * CGFloat((numberOfRowsInSection(numberOfElements: viewModel?.customElements.count) / 2))
        default: print("another row")
        }
        return CGFloat()
    }
}
