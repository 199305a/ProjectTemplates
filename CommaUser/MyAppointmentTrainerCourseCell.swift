//
//  MyAppointmentTrainerCourseCell.swift
//  CommaUser
//
//  Created by user on 2018/10/22.
//  Copyright © 2018 LikingFit. All rights reserved.
//

import UIKit

class MyAppointmentTrainerCourseCell: UITableViewCell {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var scene: UILabel!
    @IBOutlet weak var localtion: UILabel!
    @IBOutlet weak var refuseBtn: UIButton!
    @IBOutlet weak var receiveBtn: UIButton!
    @IBOutlet weak var statusView: UIView!
    
    var refuseClosure: EmptyClosure!
    var receiveClosure: EmptyClosure!
    
    var model: MyScheduleModel! {
        didSet{
            courseName.text = model.course_name
            name.text = model.trainer_name
            scene.text = model.gym_name
            localtion.text = model.address
            imgView.sd_setImage(with: URL(string: model.image), placeholderImage: nil)
            statusView.isHidden = (model.course_status != "1")
            refuseBtn.isHidden = (model.course_status != "1")
            receiveBtn.isHidden = (model.course_status != "1")
        }
    }
    
    @IBAction func refuseBtnClicked(_ sender: UIButton) {
        if refuseClosure != nil {
            refuseClosure()
        }
    }
    
    @IBAction func receiveBtnClicked(_ sender: Any) {
        if receiveClosure != nil {
            receiveClosure()
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
        
        refuseBtn.layer.cornerRadius = 5
        refuseBtn.layer.borderWidth = 1
        refuseBtn.layer.borderColor = UIColor.hx129faa.cgColor
        refuseBtn.clipsToBounds = true
        
        receiveBtn.layer.cornerRadius = 5
        receiveBtn.clipsToBounds = true
    }

}
