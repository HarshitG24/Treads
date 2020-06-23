//
//  RunLogCell.swift
//  Treads
//
//  Created by Harshit Gajjar on 6/23/20.
//  Copyright © 2020 ThinkX. All rights reserved.
//

import UIKit

class RunLogCell: UITableViewCell {
    
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    func customizeCell(run: Run){
        self.paceLbl.text = run.pace.formatTimeDurationToString()
        self.durationLbl.text = "\(run.duration)"
        self.distanceLbl.text = "\(run.distance.meterToMiles(places: 2)) mi"
        self.dateLbl.text = run.date.getDateString()
    }

}
