//
//  MyAppointmentTeamCourseCell.swift
//  CommaUser
//
//  Created by user on 2018/10/23.
//  Copyright © 2018 LikingFit. All rights reserved.
//

import UIKit

class MyAppointmentTeamCourseCell: UITableViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var localtionLabel: UILabel!
    
    var model: MyScheduleModel! {
        didSet{
            name.text = model.course_name
            imgView.sd_setImage(with: URL(string: model.image), placeholderImage: nil)
            timeLabel.text = model.date + " " + "(\(model.week))" + "  " + model.start_time + "-" + model.end_time
            localtionLabel.text = model.address
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = UIColor.backgroundColor
        baseView.layer.cornerRadius = 6
        baseView.layer.shadowColor = UIColor.hx129faa.cgColor
        baseView.layer.shadowOpacity = 0.1
        baseView.layer.shadowOffset = CGSize(width: 0, height: 4)
        baseView.layer.shadowRadius = 12
        
        infoView.layer.cornerRadius = 6
        infoView.clipsToBounds = true
    }
    
}
