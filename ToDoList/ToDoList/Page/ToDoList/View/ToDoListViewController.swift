//
//  ToDoListViewController.swift
//  DoToList
//
//  Created by WEI-TSUNG CHENG on 2023/4/13.
//

import UIKit
import SnapKit

class ToDoListViewController: UIViewController {

    let viewModel = ToDoListViewModel()
    let loationManager = LocationManager.shared
    
    lazy var todoListTableView: UITableView = {
       
        let tbv = UITableView()
        tbv.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        tbv.delegate = self
        tbv.dataSource = self
        tbv.keyboardDismissMode = .onDrag
        tbv.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.cellIdentifier())
        
        return tbv
    }()
    
    lazy var addNewItemButton: UIButton = {
        
        let btn = UIButton()
        btn.backgroundColor = .blue
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Add New Item", for: .normal)
        btn.contentHorizontalAlignment = .center
        btn.contentVerticalAlignment = .center
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        remindUserProvideLocationAuthorization()

    }
    
    private func setupUI() {
        
        self.title = "To Do List"
        self.view.backgroundColor = .white
        
        self.view.addSubview(todoListTableView)
        self.view.addSubview(addNewItemButton)
        
        todoListTableView.snp.makeConstraints { make in
            
            make.top.equalTo(self.view.snp.topMargin)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottomMargin).offset(-44)
        }
        
        addNewItemButton.snp.makeConstraints { make in
            
            make.top.equalTo(todoListTableView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottomMargin)
        }

    }
    
    private func remindUserProvideLocationAuthorization() {
        
        if loationManager.authorizationStatus == .denied {
            let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: .alert)
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }

                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)") // Prints true
                            })
                        }
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    alertController.addAction(settingsAction)
                    self.present(alertController, animated: true, completion: nil)
        }
        
        guard let currentLocation = loationManager.currentLocation else {
            return
        }
        print("Location: ", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
    }
    

}


extension ToDoListViewController: UITableViewDelegate {
    
    
}

extension ToDoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.cellIdentifier(), for: indexPath) as? ToDoTableViewCell else {

            return UITableViewCell()
        }
       
        return cell
    }
    
}
