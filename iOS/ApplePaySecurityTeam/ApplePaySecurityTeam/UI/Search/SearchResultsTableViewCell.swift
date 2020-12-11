//
//  SearchResultsTableViewCell.swift
//  ApplePaySecurityTeam
//
//  Created by Ravi Vooda on 12/10/20.
//  Copyright © 2020 Ravi Vooda. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {
    let posterImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.titleLabel.font = .boldSystemFont(ofSize: 18)
        
        self.titleLabel.numberOfLines = 0
        self.descriptionLabel.numberOfLines = 0
        
        self.contentView.addSubview(self.posterImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.descriptionLabel)
        
        self.posterImageView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = self.contentView.layoutMarginsGuide
        self.posterImageView.layer.borderColor = UIColor.black.cgColor
        self.posterImageView.layer.borderWidth = 1
        
        NSLayoutConstraint.activate([
            self.posterImageView.topAnchor.constraint(equalTo: margins.topAnchor),
            self.posterImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            self.posterImageView.heightAnchor.constraint(equalToConstant: 50),
            self.posterImageView.widthAnchor.constraint(equalToConstant: 50),
            self.posterImageView.bottomAnchor.constraint(lessThanOrEqualTo: margins.bottomAnchor),
            
            self.titleLabel.topAnchor.constraint(equalTo: margins.topAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor, constant: 10),
            
            self.descriptionLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 10),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor, constant: 10),
            self.descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.descriptionLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
    }
    
    func render(displayable: ResultDisplayable) {
        self.titleLabel.text = displayable.title
        self.descriptionLabel.text = displayable.description
        
        self.posterImageView.image = nil
        globalImageLoaderService.cancel(for: self.posterImageView)
        if let posterURL = displayable.posterURL {
            globalImageLoaderService.load(posterURL, for: self.posterImageView) { (image, error) in
                guard error == nil else {
                    self.posterImageView.image = UIImage(named: "ImageLoadingError")
                    return
                }
                
                self.posterImageView.image = image
            }
        } else {
            // Should use does not have an image instead, but for time being
            self.posterImageView.image = UIImage(named: "ImageLoadingError")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
