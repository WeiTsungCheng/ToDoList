//
//  EditItemViewController.swift
//  ToDoList
//
//  Created by WEI-TSUNG CHENG on 2023/4/15.
//

import UIKit
import SnapKit

class EditItemViewController: UIViewController {
    
    lazy var editItemScrollView: UIScrollView = {
        
        let srv = UIScrollView()
        return srv
    }()
    
    lazy var editItemContentView: UIView = {
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    lazy var editItemStackView: UIStackView = {
        
        let stv = UIStackView()
        stv.alignment = .leading
        stv.axis = .vertical
        stv.spacing = 2
        stv.distribution = .fill
        stv.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        return stv
    }()
    
    lazy var titleTextField: UITextField = {
        
        let txf = UITextField()
        txf.textColor = .black
        txf.placeholder = "Item Title"
        txf.delegate = self
        
        return txf
    }()
    
    lazy var descriptionLabel: UILabel = {
        
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.text = "Description:"
        
        return lbl
    }()
    
    lazy var descriptionTextView: UITextView = {
        
        let txv = UITextView()
        txv.textColor = .black
        txv.backgroundColor = .gray
        txv.delegate = self
        
        return txv
    }()
    
    lazy var dateStackView: UIStackView = {
        
        let stv = UIStackView()
        stv.alignment = .leading
        stv.axis = .horizontal
        stv.spacing = 4
        stv.distribution = .fillEqually
        
        return stv
    }()
    
    lazy var createDateDatePicker: UIDatePicker = {
        
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.overrideUserInterfaceStyle = .light
        dp.addTarget(self, action: #selector(selectCreateDate(_:)), for: .valueChanged)
        
        return dp
    }()
    
    @objc private func selectCreateDate(_ datePicker : UIDatePicker) {
        
        self.viewModel.editingItem.createDate = datePicker.date
    }
    
    lazy var dueDateDatePicker: UIDatePicker = {
        
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.overrideUserInterfaceStyle = .light
        dp.addTarget(self, action: #selector(selectDueDate(_:)), for: .valueChanged)
        
        return dp
    }()
    
    @objc private func selectDueDate(_ datePicker : UIDatePicker) {
        
        self.viewModel.editingItem.dueDate = datePicker.date
    }
    
    lazy var locationStackView: UIStackView = {
        
        let stv = UIStackView()
        stv.alignment = .leading
        stv.axis = .horizontal
        stv.spacing = 4
        stv.distribution = .fill
        
        return stv
    }()
    
    lazy var locationLabel: UILabel = {
        
        let lbl = UILabel()
        lbl.textColor = .black
        return lbl
    }()
    
    lazy var locationButton: UIButton = {
        
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "map.fill"), for: .normal)
        btn.addTarget(self, action: #selector(showCoordinateSearchPage(_:)), for: .touchUpInside)
        
        return btn
    }()
    
    @objc func showCoordinateSearchPage(_: UIButton) {
        
        let coordinateSearchViewModel = CoordinateSearchViewModel()
        let coordinateSearchViewController = CoordinateSearchViewController(viewModel: coordinateSearchViewModel)
        
        coordinateSearchViewController.passCoordinateClosure = { coordinate in
            
            let latitude = coordinate.latitude
            let longitude = coordinate.longitude
            
            self.viewModel.editingItem.coordinate = Coordinate(latitude: latitude, longitude: longitude)
        }
        
        present(coordinateSearchViewController, animated: true)
    }
    
    lazy var confirmButton: UIButton = {
        
        let btn = UIButton()
        btn.setTitle("Confirm", for: .normal)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(confirmEditItem(_:)), for: .touchUpInside)
        
        return btn
    }()
    
    @objc func confirmEditItem(_: UIButton) {
        
        let todoItem = self.viewModel.editingItem
        print(todoItem)
        
    }
    
    var viewModel: EditItemViewModel
    
    init(viewModel: EditItemViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        addGesture()
        
        viewModel.editingItemObservable.value = viewModel.editingItem
        
        viewModel.editingItemObservable.addObserver { todoItem in
            
            guard let todoItem = todoItem else {
                return
            }
            
            self.titleTextField.text = todoItem.title
            self.descriptionTextView.text = todoItem.description
            self.createDateDatePicker.date = todoItem.createDate
            self.dueDateDatePicker.date = todoItem.dueDate
            self.locationLabel.text = "(\(String(format: "%.6f", todoItem.coordinate.longitude)), \(String(format: "%.6f", todoItem.coordinate.latitude)))"
        }
    }
    
    func setUpUI() {
        
        self.title = "Edit Item"
        self.view.backgroundColor = .white
        
        self.view.addSubview(editItemScrollView)
        self.view.addSubview(confirmButton)
        
        editItemScrollView.addSubview(editItemContentView)
        editItemContentView.addSubview(editItemStackView)
        
        editItemStackView.addArrangedSubview(titleTextField)
        editItemStackView.addArrangedSubview(descriptionLabel)
        editItemStackView.addArrangedSubview(descriptionTextView)
        editItemStackView.addArrangedSubview(dateStackView)
        editItemStackView.addArrangedSubview(locationStackView)
        
        dateStackView.addArrangedSubview(createDateDatePicker)
        dateStackView.addArrangedSubview(dueDateDatePicker)
        
        locationStackView.addArrangedSubview(locationLabel)
        locationStackView.addArrangedSubview(locationButton)
        
        editItemScrollView.snp.makeConstraints { make in
            
            make.topMargin.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottomMargin) .offset(-44)
        }
        
        confirmButton.snp.makeConstraints { make in
            
            make.top.equalTo(editItemScrollView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.snp.bottomMargin)
        }
        
        editItemContentView.snp.makeConstraints { make in
            
            make.leading.trailing.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        editItemStackView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(8)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalToSuperview()
        }
        
        dateStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(4)
        }
        
    }
    
    private func addGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        descriptionTextView.resignFirstResponder()
        titleTextField.resignFirstResponder()
    }
    
}

extension EditItemViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == titleTextField {
            viewModel.editingItem.title = textField.text ?? ""
        }
    }
    
}

extension EditItemViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == descriptionTextView {
            viewModel.editingItem.description = textView.text
        }
    }
    
}
