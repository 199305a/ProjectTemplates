//
//  UITableView+extension.swift
//  CommaUser
//
//  Created by Marco Sun on 16/6/16.
//  Copyright © 2016年 LikingFit. All rights reserved.
//

import UIKit

extension UITableView {
    //set the tableHeaderView so that the required height can be determined, update the header's frame and set it again
    @discardableResult
    func autoLayoutTableHeaderView(_ header: UIView) -> CGFloat {
        self.tableHeaderView = header
        header.setNeedsLayout()
        header.layoutIfNeeded()
        let height = header.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = header.frame
        frame.size.height = height
        header.frame = frame
        self.tableHeaderView = header
        return height
    }
    
    @discardableResult
    func autoLayoutTableFooterView(_ footer: UIView) -> CGFloat {
        self.tableFooterView = footer
        footer.setNeedsLayout()
        footer.layoutIfNeeded()
        let height = footer.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = footer.frame
        frame.size.height = height
        footer.frame = frame
        self.tableFooterView = footer
        return height
    }
}

