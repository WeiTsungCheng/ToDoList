//
//  ToDoListViewController.swift
//  DoToList
//
//  Created by WEI-TSUNG CHENG on 2023/4/13.
//

import UIKit
import SnapKit

class ToDoListViewController: UIViewController, NetWorkStatusProtocal {
    
    lazy var quotableTextView: UITextView = {
        let txv = UITextView()
        txv.backgroundColor = .cyan
        
        return txv
    }()

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
        btn.addTarget(self, action: #selector(goEditItemPage(_:)), for: .touchUpInside)
        
        return btn
    }()
    
    @objc private func goEditItemPage(_: UIButton) {
        
        let duetDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        
        guard let location = LocationManager.shared.currentLocation else {
            return
        }
        
        let coordinate = Coordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
     
        let editItemViewModel = EditItemViewModel(editingItem: ToDoItem(title: "", description: "", createDate: Date(), dueDate: duetDate, coordinate: coordinate))
        
        let editItemViewController = EditItemViewController(viewModel: editItemViewModel)
        
        self.navigationController?.pushViewController(editItemViewController, animated: false)
    }
    
    let loationManager = LocationManager.shared
    
    var observerNetStatusChangedNotification: NSObjectProtocol?
    
    func noticeNetStatusChanged(_ nofification: Notification) {
        checkNetStatusAlert()
    }
    
    var viewModel: ToDoListViewModel
    
    init(viewModel: ToDoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        registerNetStatusManager()
        viewModel.getQuotes()
        
        viewModel.quotableObservable.addObserver { quotable in
            
            guard let quotable = quotable else {
                return
            }
            
            self.quotableTextView.text = """
                Author: \(quotable.author)
                Content: \(quotable.content)
                Date Added: \(quotable.dateAdded)
                Tags: \(quotable.tags)
            """
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        checkNetStatusAlert()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        remindUserProvideLocationAuthorization()

    }
    
    deinit {
        unregisterNetStatusManager()
    }
    
    private func setupUI() {
        
        self.title = "To Do List"
        self.view.backgroundColor = .white
        
        self.view.addSubview(quotableTextView)
        self.view.addSubview(todoListTableView)
        self.view.addSubview(addNewItemButton)
        
        quotableTextView.snp.makeConstraints { make in
        
            make.top.equalTo(self.view.snp.topMargin).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(100)
        }
        
        todoListTableView.snp.makeConstraints { make in
            
            make.top.equalTo(self.quotableTextView.snp.bottom).offset(8)
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
                                print("Settings opened: \(success)")
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
        
        return viewModel.toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.cellIdentifier(), for: indexPath) as? ToDoTableViewCell else {

            return UITableViewCell()
        }
        
        cell.titleTextField.text = viewModel.toDoItems[indexPath.row].title
        cell.descriptionTextView.text = viewModel.toDoItems[indexPath.row].description
        
        cell.createdDateTextField.text = "create: " +  Date.dateToString(date: viewModel.toDoItems[indexPath.row].createDate)
 
        cell.dueDateTextField.text = "due: " +  Date.dateToString(date: viewModel.toDoItems[indexPath.row].dueDate)
        
        let latitude = viewModel.toDoItems[indexPath.row].coordinate.latitude
        let longitude = viewModel.toDoItems[indexPath.row].coordinate.longitude
         
        cell.locationTextField.text = "location: (\(String(format: "%.6f", longitude)), \(String(format: "%.6f", latitude)))"
       
        return cell
    }
    
}
