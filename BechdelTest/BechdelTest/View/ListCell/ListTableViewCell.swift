//
//  ListTableViewCell.swift
//  BechdelTest
//
//  Created by Gabriel Ferreira on 03/09/20.
//  Copyright © 2020 Ribeiro Ferreira. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    
    var rating: Int = 0 {
        didSet {
            switch self.rating {
            case 0:
                self.statusView.backgroundColor = .systemRed
            case 1:
                self.statusView.backgroundColor = .systemOrange
            case 2:
                self.statusView.backgroundColor = .systemYellow
            case 3:
                self.statusView.backgroundColor = .systemGreen
            default:
                self.statusView.backgroundColor = .white
            }
        }
    }
}
