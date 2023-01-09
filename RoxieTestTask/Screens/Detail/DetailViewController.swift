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
        return height * 0.5
    }
    
    let heightOfOneRowCollectionWithInfo: (CGFloat) -> CGFloat = { (width: CGFloat) in
        return width * 1.15
    }
    
    let spinner = UIActivityIndicatorView(style: .large)
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DetailViewModel()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = spinner
        tableView.separatorStyle = .none
        
        guard let photoElementCellReuseIdentifier = viewModel?.customElements[0].type.rawValue else { return }
        guard let nameElementCellReuseIdentifier = viewModel?.customElements[1].type.rawValue else { return }
        
        tableView.register(PhotoElementCell.self, forCellReuseIdentifier: photoElementCellReuseIdentifier)
        tableView.register(NameElementCell.self, forCellReuseIdentifier: nameElementCellReuseIdentifier)
        sendRequest()
    }
    
    func sendRequest() {
        spinner.startAnimating()
        self.downloadImage { data in
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.fetchedImage = data
                guard let dataForArrayOfCells = self.data else { return }
                let nameDriver = NameElement(nameDriver: dataForArrayOfCells.vehicle.driverName, arrayOfCells: self.viewModel?.parseForCollectionView(data: dataForArrayOfCells))
                let newImage = PhotoElement(image: self.fetchedImage, apiString: "https://www.roxiemobile.ru/careers/test/images/" + dataForArrayOfCells.vehicle.photo)
                self.viewModel?.customElements = [newImage, nameDriver]
                self.tableView.reloadData()
            }
        }
    }
    
    func downloadImage(completion: @escaping (Data) -> Void) {
        guard let numberOfPhoto = self.data?.vehicle.photo else { return }
        DataManager.shared.getImage(urlString: "https://www.roxiemobile.ru/careers/test/images/" + numberOfPhoto) { image in
            guard let image = image else {
                return
            }
            completion(image)
        }
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
        case 0: return heightOfPhoto(view.bounds.height)
        case 1: return heightOfOneRowCollectionWithInfo(view.bounds.width) * CGFloat((numberOfRowsInSection(numberOfElements: viewModel?.customElements.count) / 2))
        default: print("another row")
        }
        return CGFloat()
    }
}
