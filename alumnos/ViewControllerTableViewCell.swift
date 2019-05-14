//
//  ViewControllerTableViewCell.swift
//  alumnos
//
//  Created by LABMAC07 on 03/05/19.
//  Copyright © 2019 kast. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var labelNombre: UILabel!
    
    @IBOutlet weak var labelCalificacion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
