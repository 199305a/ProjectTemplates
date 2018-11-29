//
//  MyAppointHaveTeamCell.swift
//  CommaUser
//
//  Created by user on 2018/10/23.
//  Copyright © 2018 LikingFit. All rights reserved.
//

import UIKit

class MyAppointHaveTeamCell: UITableViewCell {
    var emptyClosure: EmptyClosure!
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var localtionLabel: UILabel!
    @IBAction func commentBtnClicked(_ sender: UIButton) {
        if emptyClosure != nil {
            emptyClosure()
        }
    }
    
    var model: MyScheduleModel! {
        didSet{
            commentBtn.isHidden = model.is_evaluate == "1"
            nameLabel.text = model.course_name
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
        
        commentBtn.layer.cornerRadius = 5
        commentBtn.layer.borderWidth = 1
        commentBtn.layer.borderColor = UIColor.hx129faa.cgColor
        commentBtn.clipsToBounds = true
    }
    
}
