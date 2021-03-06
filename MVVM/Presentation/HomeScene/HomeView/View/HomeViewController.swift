//
//  HomeViewController.swift
//  MVVM
//
//  Created by Oscar Cardona on 29/02/2020.
//  Copyright © 2020 Cardona.tv. All rights reserved.
//

import UIKit
import SKRools

class HomeViewController: UIViewController, Storyboarded {

    // MARK: Private Constants
    private struct Constants {
        static let cellIdentifier = "HomeCollectionViewCellID"
        static let cellName = "HomeCollectionViewCell"
        static let fontName = "Verdana-bold"
    }

    // MARK: Properties
    private var model: HomeModel?
    var viewModel: HomeViewModel?
    var forcesList: (() -> Void)?
    var beersList: (() -> Void)?

    private let collectionView: UICollectionView = {
        let layout = HomeCollectionViewLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white

        return cv
    }()

    private let titleLbl: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.font = UIFont(name: Constants.fontName, size: 30)
        lbl.backgroundColor = .lightGray
        lbl.textAlignment = .center
        lbl.numberOfLines = 1
        lbl.textColor = .black
        lbl.adjustsFontSizeToFitWidth = true

        return lbl
    }()

    // MARK: View lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBinding()
        viewModel?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: - Private methods
private extension HomeViewController {

    // MARK: Setup View
    private func setupView() {
        view.addSubview(titleLbl)
        setupTitleConstraints()
        collectionView.register(UINib(nibName: Constants.cellName,
                                      bundle: nil ),
                                forCellWithReuseIdentifier: Constants.cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        setupCollectionConstraints()
    }

    // MARK: Binding
    private func setupBinding() {
        viewModel?.model.bind(listener: { [unowned self]  homeModel in
            DispatchQueue.main.async {
                self.model = homeModel
                self.titleLbl.text = "HomeViewController"
                self.collectionView.reloadData()
            }
        })

        viewModel?.loadingStatus.bind(listener: { (status) in
            guard let status = status else {
                return
            }
            switch status {
            case .start:
                print("[\(self.className())] Loading: Start")
            case .stop:
                print("[\(self.className())] Loading: Stop")
            }
        })
    }

    private func className() -> String {
        return String(describing: self.self)
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.model?.items?[indexPath.row],
            let identifier = item.id else {
            return
        }

        switch identifier {
        case "policeId":
            forcesList?()
        case "beerId":
            beersList?()
        case "settingsId":
            print("SETTINGS")
        default:
            print("Default")
        }

    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.model?.items?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.data = model?.items?[indexPath.row]

        return cell
    }
}

// MARK: - Constraints
private extension HomeViewController {
    private func setupCollectionConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    private func setupTitleConstraints() {
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 30.0).isActive = true
        titleLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
        titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
        titleLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
