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
    /*
    lazy var carImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    */
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DetailImageTableViewCell.self, forCellReuseIdentifier: DetailImageTableViewCell.identifier)
        
        viewModel = DetailViewModel()
        guard let fetchedImage = DataManager.shared.getImage(urlString: "https://www.roxiemobile.ru/careers/test/images/" + (data?.vehicle.photo)!) else { print("error"); return }  // NetworkManager.shared.fetchImage(urlString: "https://www.roxiemobile.ru/careers/test/images/" + (data?.vehicle.photo)!)
        let newImage = PhotoElement(image: fetchedImage, apiString: "https://www.roxiemobile.ru/careers/test/images/" + (data?.vehicle.photo)!)
        let nameDriver = NameElement(nameDriver: (data?.vehicle.driverName)!)
        tableView.register(PhotoElementCell.self, forCellReuseIdentifier: newImage.type.rawValue) //
        tableView.register(NameElementCell.self, forCellReuseIdentifier: nameDriver.type.rawValue)
        self.viewModel?.customElements = [newImage, nameDriver]
        tableView.reloadData()
        #warning("remove force unwrapping")

        //viewModel?.customElements?.append(PhotoElement(image: fetchedImage))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(tableView)
        //carImage.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        /*
        let carImageConstraints = [
            carImage.topAnchor.constraint(equalTo: view.topAnchor),
            carImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.height / 2)
        ]
        */
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        //NSLayoutConstraint.activate(carImageConstraints)
        NSLayoutConstraint.activate(tableViewConstraints)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController: UITableViewDelegate {
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailImageTableViewCell.identifier, for: indexPath) as? DetailImageTableViewCell else { return UITableViewCell() }
        let fetchedImage = NetworkManager.shared.fetchImage(urlString: "https://www.roxiemobile.ru/careers/test/images/" + (data?.vehicle.photo)!); #warning("remove force unwrapping")
        cell.configureCell(image: fetchedImage)
        return cell
         */
        let cellModel = viewModel?.customElements?[indexPath.row]
        let cellIdentifier = cellModel?.type.rawValue
        let customCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier!, for: indexPath) as! CustomElementCell;  #warning("remove force unwrapping")
        customCell.configure(withModel: cellModel!)
        return customCell as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (viewModel?.customElements!.count)!
        //viewModel?.customElements?.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        (viewModel?.customElements[indexPath.row].heightRow.rawValue)!
        /*
        switch indexPath.row {
        case 0: return HeightOfTableViewRow.photo.rawValue
        default: return UITableView.automaticDimension
        }
         */
    }
}
