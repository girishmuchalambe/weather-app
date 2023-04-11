//
//  MoreTableViewCell.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import UIKit

class MoreTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel?
    var viewModel: String? {
        didSet {
            titleLabel?.text = viewModel
        }
    }
}
