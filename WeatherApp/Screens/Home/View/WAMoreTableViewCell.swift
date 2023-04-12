//
//  MoreTableViewCell.swift
//  WeatherApp
//
//  Created by Girish Muchalambe on 11/04/23.
//

import UIKit

class WAMoreTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel?
    
    var viewModel: WeatherInformation? {
        didSet {
            titleLabel?.text = viewModel?.title
        }
    }
}
