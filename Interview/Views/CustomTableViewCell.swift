//
//  CustomTableViewCell.swift
//  Interview
//
//  Created by Emre AYDIN on 16.04.2022.
//

import UIKit

final class CustomTableViewCell: UITableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRect(x: 20.25, y: 12, width: 24, height: 24)
        self.imageView?.contentMode = .scaleAspectFit
        self.textLabel?.frame = CGRect(x: 55.5, y: 15, width: self.frame.width - 150, height: 15)
    }

}
