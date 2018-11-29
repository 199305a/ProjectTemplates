//
//  MyAppointHaveTrainerCell.swift
//  CommaUser
//
//  Created by user on 2018/10/23.
//  Copyright © 2018 LikingFit. All rights reserved.
//

import UIKit

class MyAppointHaveTrainerCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var trainerName: UILabel!
    @IBOutlet weak var sceneName: UILabel!
    @IBOutlet weak var localtionName: UILabel!
    
    var emptyClosure: EmptyClosure!
    
    var model: MyScheduleModel! {
        didSet{
            commentBtn.isHidden = (model.is_evaluate == "1")
            nameLabel.text = model.course_name
            trainerName.text = model.trainer_name
            imgView.sd_setImage(with: URL(string: model.image), placeholderImage: nil)
            sceneName.text = model.gym_name
            localtionName.text = model.address
        }
    }
    
    @IBAction func commentBtnClicked(_ sender: UIButton) {
        if emptyClosure != nil {
            emptyClosure()
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
