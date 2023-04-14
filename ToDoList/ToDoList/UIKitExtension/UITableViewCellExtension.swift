//
//  UITableViewCellExtension.swift
//  DoToList
//
//  Created by WEI-TSUNG CHENG on 2023/4/13.
//

import UIKit

extension UITableViewCell {
    
    public static func cellIdentifier() -> String {
        return String(describing: self)
    }
}

