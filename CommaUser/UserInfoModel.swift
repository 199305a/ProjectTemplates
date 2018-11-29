//
//  UserInfoModel.swift
//  CommaUser
//
//  Created by Marco Sun on 17/3/29.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

class UserInfoModel: BaseModel {
    var username: String?
    var gender: Int = InvalidInteger
    var birthday: String?
    var avatar: String?
    var height: String?
    var weight: String?
    var sex: Gender {
        return Gender(rawValue: gender) ?? .unknown
    }
    
    var is_update_birthday: Int = InvalidInteger
    var is_update_gender: Int = InvalidInteger
    
    var canModifyGender: Bool {
        return is_update_gender == 1
    }
    
    var canModifyBirthday: Bool {
        return is_update_birthday == 1
    }
    
    var canModifyGenderOrBirthday: Bool {
        if canModifyBirthday || canModifyGender {
            return true
        }
        return false
    }
    
    var canModifyGenderAndBirthday: Bool {
        if canModifyBirthday && canModifyGender {
            return true
        }
        return false
    }
    
    var dataFromServer: Bool {
        guard username != nil,
            birthday != nil,
            avatar != nil,
            height != nil,
            weight != nil,
            gender != InvalidInteger
            else {
                return false
        }
        return true
    }
    
}

enum Gender: Int {
    case female = 1
    case male
    case unknown
    
    
    var userImage: UIImage? {
        switch self {
        case .female:
            return UIImage.init(named: "user_gender_female")
        case .male:
            return UIImage.init(named: "user_gender_male")
        case .unknown:
            return nil
        }
    }
    
    var userPlaceholderImage: UIImage? {
        switch self {
        case .female:
            return UIImage.init(named: "profile_avatar_female")
        default:
            return UIImage.init(named: "profile_avatar_male")
        }
    }
    
    var defaultNickname: String? {
        var text: String?
        switch self {
        case .female:
            text = "Miss.Comma"
        case .male:
            text = "Mr.Comma"
        case .unknown:
            break
        }
        return text
    }
    
    var defaultPlaceHolderText: String? {
        var text: String?
        switch self {
        case .female:
            text = "Miss.Comma"
        case .male:
            text = "Mr.Comma"
        case .unknown:
            text = Text.NicknameInputLimite
        }
        return text
    }
    
    
    static func string(_ rawValue: Int) -> String? {
        switch rawValue {
        case 1:
            return Text.Female
        case 2:
            return Text.Male
        default:
            return nil
        }
    }
}
