//
//  NetWorkStatusManager.swift
//  ToDoList
//
//  Created by WEI-TSUNG CHENG on 2023/4/17.
//


import Foundation
import Network

final class NetWorkStatusManager {
    
    var isMonitoring = false
    var monitor: NWPathMonitor?
    
    static var sharedIntance: NetWorkStatusManager? = NetWorkStatusManager()
    static var NotificationChangeNetStatusName: Notification.Name {
        return Notification.Name.init("NetStatusChanged")
    }
    
    private init() {
        
    }
    
    deinit {
        stopMonitoring()
    }
    
    var isConnected: Bool {
        guard let monitor = monitor else {
            return false
            
        }
        
        return monitor.currentPath.status == .satisfied
    }
    
    var interfaceType: NWInterface.InterfaceType? {
        guard let monitor = monitor else { return nil }

        return monitor.currentPath.availableInterfaces.filter {
            monitor.currentPath.usesInterfaceType($0.type) }.first?.type
    }
    
    var availableInterfacesTypes: [NWInterface.InterfaceType]? {
        guard let monitor = monitor else { return nil }
        return monitor.currentPath.availableInterfaces.map { $0.type }
    }
    
    var isExpensive: Bool {
        return monitor?.currentPath.isExpensive ?? false
    }
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        monitor = NWPathMonitor()
        
        let queue = DispatchQueue(label: "NetStatus_Monitor")
        monitor?.start(queue: queue)
        
        monitor?.pathUpdateHandler = { path in
            
            NotificationCenter.default.post(name: NetWorkStatusManager.NotificationChangeNetStatusName, object: path, userInfo: nil)
        }
        
        isMonitoring = true
    }
    
    func stopMonitoring() {
        guard isMonitoring, let monitor = monitor else { return }
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
    }
}
