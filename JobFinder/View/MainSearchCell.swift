//
//  MainSearchCell.swift
//  JobFinder
//
//  Created by Abdalwhab on 4/7/19.
//  Copyright © 2019 Malkawi. All rights reserved.
//

import UIKit

class MainSearchCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLB: ClassLabelSizeClass!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        imgView.image = nil
        titleLB.text = ""
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    class func Cell(for table: UITableView, at indexPath: IndexPath)-> MainSearchCell {
        let id = "MainSearchCell"
        table.register(UINib(nibName: id, bundle: nil), forCellReuseIdentifier: id)
        let cell = table.dequeueReusableCell(withIdentifier: id, for: indexPath) as? MainSearchCell
        return cell!
    }
}
