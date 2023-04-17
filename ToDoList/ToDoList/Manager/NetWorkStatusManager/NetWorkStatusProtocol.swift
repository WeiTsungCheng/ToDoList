//
//  NetWorkStatusProtocol.swift
//  ToDoList
//
//  Created by WEI-TSUNG CHENG on 2023/4/17.
//

import UIKit

protocol NetWorkStatusProtocal: AnyObject {
    var observerNetStatusChangedNotification: NSObjectProtocol? { get set }
    func noticeNetStatusChanged(_ nofification: Notification)
}

extension NetWorkStatusProtocal where Self: UIViewController {
    
    func registerNetStatusManager() {
        let notificationCenter = NotificationCenter.default
        observerNetStatusChangedNotification = notificationCenter.addObserver(forName: NetWorkStatusManager.NotificationChangeNetStatusName, object: nil, queue: nil, using: { [weak self] notification in
            
            self?.noticeNetStatusChanged(notification)
        })
    }
    
    func unregisterNetStatusManager() {
        guard let observerNetStatusChangedNotification = observerNetStatusChangedNotification else {
            return
        }

        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(observerNetStatusChangedNotification)
    }
    
    
    func checkNetStatusAlert() {
        
        DispatchQueue.main.async {
            if !(NetWorkStatusManager.sharedIntance!.isConnected) {
                
                let alertController = UIAlertController(title: "Note", message:"No network line detected at this time", preferredStyle: .alert)
                let confirmAlertAction = UIAlertAction(title: "Confirm", style: .default) { _ in
                    self.checkNetStatusAlert()
                }
                let cancelAlertAction = UIAlertAction(title:"Ignore", style: .cancel, handler: nil)
                
                alertController.addAction(confirmAlertAction)
                alertController.addAction(cancelAlertAction)
                
                if self.presentedViewController == nil {
                    self.present(alertController, animated: false, completion: nil)
                }
            }
        }
    }
    
}
