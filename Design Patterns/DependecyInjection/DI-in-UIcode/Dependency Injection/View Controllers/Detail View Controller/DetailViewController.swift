//
//  DetailViewController.swift
//  Dependency Injection
//
//  Created by Bart Jacobs on 29/01/2018.
//  Copyright © 2018 Bart Jacobs. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var doneButton : UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.titleLabel?.textColor = .white
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(done(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: -
    var note: Note?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutLabel()
        layoutContentLabel()
        layoutButton()
        
        // Configure Labels
        titleLabel.text = note?.title
        contentLabel.text = note?.contents
    }
    
    //    // MARK: - Actions
    //
    @objc func done(_ sender: UIButton) {
        // Dismiss View Controller
        dismiss(animated: true)
    }
}

private extension DetailViewController {
    func layoutLabel() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30)
        ])
        
    }
    
    func layoutContentLabel() {
        view.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            contentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            contentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
    }
    
    func layoutButton() {
        view.addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant:  10),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}
