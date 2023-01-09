//
//  NameElementCell.swift
//  RoxieTestTask
//
//  Created by Артем Соколовский on 08.01.2023.
//

import UIKit

class NameElementCell: UITableViewCell, CustomElementCell {
    static var identifier = "NameElementCell"
    
    var model: NameElement?
    
    func configure(withModel elementModel: CustomElementModel?) {
        guard let model = elementModel as? NameElement else {
            print("Unable to cast model as ProfileElement: \(elementModel)")
            return
        }
        self.model = model
        
        configureUI()
    }
    
    func configureUI() {
        collectionView.reloadData()
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let collectionView = UICollectionView(frame: .infinite, collectionViewLayout: layout)
        collectionView.register(DetailInfoCollectionViewCell.self, forCellWithReuseIdentifier: DetailInfoCollectionViewCell.identifier)
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let collectionViewConstraints = [
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(collectionViewConstraints)
    }

}

// MARK: - Collection View

extension NameElementCell: UICollectionViewDelegate {
    
}

extension NameElementCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model?.arrayForCells?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailInfoCollectionViewCell.identifier, for: indexPath) as? DetailInfoCollectionViewCell else { print("error in collectionView cell"); return UICollectionViewCell() }
        cell.configureCell(model: model?.arrayForCells?[indexPath.item])
        return cell
    }
}

extension NameElementCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = contentView.frame.size.width * 0.42
        let height: CGFloat = contentView.frame.size.width * 0.3
        return CGSize(width: width, height: height)
    }
}
