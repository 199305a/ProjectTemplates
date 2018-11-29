//
//  GymMapProtocol.swift
//  CommaUser
//
//  Created by Marco Sun on 2017/7/31.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit

protocol GymMapProtocol: BaseProtocol {
    var gymName: String { get }
    var gymAddress: String { get }
    var gymLongitude: Double { get }
    var gymLatitude: Double { get }
    var coordinate: CLLocationCoordinate2D { get }
    
}


extension GymInfoModel: GymMapProtocol {
    
    var gymName: String {
        return gym_name ?? " "
    }
    
    var gymAddress: String {
        return address ?? " "
    }
    
    var gymLongitude: Double {
        return Double.init(longitude ?? "0") ?? 0
    }
    
    var gymLatitude: Double {
        return Double.init(latitude ?? "0") ?? 0
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D.init(latitude: gymLatitude, longitude: gymLongitude)
    }
    
}


