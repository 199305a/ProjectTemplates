//
//  RegionManager.swift
//  CommaUser
//
//  Created by lekuai on 17/1/3.
//  Copyright © 2017年 LikingFit. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0


//MARK: - pickerView


class RegionPicker: UIView,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var doneClosure:((String)->Void)?
    
    var contentV: UIView!
    var pickerView: UIPickerView!
    let padding: CGFloat = 2
    
    //点击完成选中的下标
    var provinceSeletedIndex: Int = 0
    var citySelectedIndex: Int = 0
    
    //高亮显示的下标
    var provinceHighlightIndex: Int = 0
    var cityHighlightIndex: Int = 0
    
    var isShow = false  //是否展示
    
    var showProvinces: [ProvinceModel]? {
        return LocationManager.shared.region
    }
    var showCities: [CityModel]? {
        return showProvinces?[provinceHighlightIndex].cities
    }
    
    init(title: String, doneClosure: ((String)->Void)?) {
        
        let screenW = UIScreen.main.bounds.width
        let screenH = UIScreen.main.bounds.height
        super.init(frame: CGRect(x: 0, y: -64, width: screenW, height: screenH))
        
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        
        let contentH = CGFloat(270)
        contentV = UIView(frame: CGRect(x: 0, y: screenH-contentH, width: screenW, height: contentH))
        addSubview(contentV)
        contentV.backgroundColor = UIColor.white
        let customVH = CGFloat(40)
        
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 200,height: customVH))
        titleLabel.center.x = contentV.centerX
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        contentV.addSubview(titleLabel)
        
        let cancelBtn = UIButton(frame: CGRect(x: padding,y: 0,width: 50,height: customVH))
        cancelBtn.setTitle(Text.Cancel, for: .normal)
        cancelBtn.setTitleColor(UIColor.hx129faa, for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        contentV.addSubview(cancelBtn)
        cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        
        let doneBtn = UIButton(frame: CGRect(x: screenW-50-padding,y: 0,width: 50,height: customVH))
        doneBtn.setTitle(Text.Done, for: .normal)
        doneBtn.setTitleColor(UIColor.hx129faa, for: .normal)
        doneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        contentV.addSubview(doneBtn)
        doneBtn.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        
        pickerView = UIPickerView(frame: CGRect(x: 0, y: customVH, width: screenW, height: contentH-customVH))
        contentV.addSubview(pickerView)
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.doneClosure = doneClosure
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showInView(_ view: UIView) {
        view.addSubview(self)
        animate(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case 0:
            return showProvinces?.count ?? 0
        case 1:
            return showCities?.count ?? 0
        default:
            return 0
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return showProvinces?.safeObjectAtIndex(row)?.province_name ?? ""
        case 1:
            return showCities?.safeObjectAtIndex(row)?.city_name ?? ""
        default:
            return ""
        }
        
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if !isShow { return }
    
        switch component {
        case 0:
            if row != provinceHighlightIndex {
                provinceHighlightIndex = row
                pickerView.reloadComponent(1)
                pickerView.selectRow(0, inComponent: 1, animated: false)
                cityHighlightIndex = 0
            }

        case 1:
            cityHighlightIndex = row
        default:
            break
        }

    }
    
    func animate(_ show: Bool) {
    
        isShow = show
        if show {
            pickerView.reloadAllComponents()
            self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.contentV.frame.origin.y = self.bounds.height
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { 
                self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.contentV.frame.origin.y = self.bounds.height - self.contentV.bounds.height
                }, completion: { (flag) in
                   
            })
        } else {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.contentV.frame.origin.y = self.bounds.height - self.contentV.bounds.height
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                self.contentV.frame.origin.y = self.bounds.height
                }, completion: { (flag) in
                    self.pickerView.reloadAllComponents()
                    self.pickerView.selectRow(self.provinceSeletedIndex, inComponent: 0, animated: false)
                    self.pickerView.selectRow(self.citySelectedIndex, inComponent: 1, animated: false)
                    self.provinceHighlightIndex = self.provinceSeletedIndex
                    self.cityHighlightIndex = self.citySelectedIndex
                    self.removeFromSuperview()
            })

        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animate(false)
    }
    
    @objc func cancelAction() {
        animate(false)
    }
    
    @objc func doneAction() {
        provinceSeletedIndex = provinceHighlightIndex
        citySelectedIndex = cityHighlightIndex
        let provinceName = showProvinces?[provinceSeletedIndex].province_name ?? ""
        let cityName = showCities?[citySelectedIndex].city_name ?? ""
        var addressStr: String
        if provinceName == cityName {
            addressStr = cityName
        } else {
            addressStr = provinceName + cityName
        }
        doneClosure?(addressStr)
        animate(false)
    }
    
    
}


