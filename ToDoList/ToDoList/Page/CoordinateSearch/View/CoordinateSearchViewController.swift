//
//  CoordinateSearchViewController.swift
//  ToDoList
//
//  Created by WEI-TSUNG CHENG on 2023/4/16.
//

import UIKit
import MapKit


class CoordinateSearchViewController: UIViewController {
    
    lazy var mapView: MKMapView = {
        let mv = MKMapView()
        
        return mv
    }()
    
    lazy var searchTextField: UITextField = {
        let txf = UITextField()
        txf.backgroundColor = .white
        txf.textColor = .black
        txf.placeholder = "搜尋"
        
        let image = UIImage(systemName: "magnifyingglass")
        let imageView = UIImageView(image: image)
        txf.leftViewMode = .always
        txf.leftView = imageView
        txf.delegate = self
        
        return txf
    }()
    
    lazy var selectCoordinateTextField: UITextField = {
        let txf = UITextField()
        txf.backgroundColor = .white
        txf.placeholder = "當前選擇位置的座標"
        txf.isEnabled = false
        
        return txf
    }()
    
    lazy var selectButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        btn.setTitle("Select", for: .normal)
        btn.addTarget(self, action: #selector(selectCoordinate(_:)), for: .touchUpInside)
        
        return btn
    }()
    
    @objc private func selectCoordinate(_: UIButton) {
       
        passCoordinateClosure!(CLLocationCoordinate2D(latitude: 1, longitude: 2))
        
        dismiss(animated: true)
    }
    
    
    var passCoordinateClosure: ((CLLocationCoordinate2D) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        addGesture()
        
        MapManager.shared.delegate = self
        
        mapView.showsUserLocation = true
        MapManager.shared.mapView = mapView
        mapView.delegate = MapManager.shared
        
    }
    
    private func setUpUI() {
        
        self.view.backgroundColor = .systemGray
        
        self.view.addSubview(searchTextField)
        self.view.addSubview(mapView)
        self.view.addSubview(selectCoordinateTextField)
        self.view.addSubview(selectButton)
        
        searchTextField.snp.makeConstraints { make in
            
            make.top.equalTo(view.snp.top).inset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(44)
        }
        
        selectButton.snp.makeConstraints { make in
            
            make.bottom.equalTo(view.snp.bottomMargin)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
            
        }
        
        selectCoordinateTextField.snp.makeConstraints { make in
            
            make.bottom.equalTo(selectButton.snp.top).offset(-8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(44)
            
        }
        
        mapView.snp.makeConstraints { make in
            
            make.top.equalTo(searchTextField.snp.bottom).offset(8)
            make.bottom.equalTo(selectCoordinateTextField.snp.top).offset(-8)
            make.leading.trailing.equalToSuperview()
        }
        
    }
    
    private func addGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        searchTextField.resignFirstResponder()
    }
    
}

extension CoordinateSearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == searchTextField {
            
            let query = textField.text
            MapManager.shared.search(query: query)
        }
        
        return true
    }
}

extension CoordinateSearchViewController: MapManagerProtocol {
    
    func selectedCoordinateOnMap(_ coodinate: CLLocationCoordinate2D) {
        
        selectCoordinateTextField.text = "\(coodinate.longitude), \(coodinate.latitude)"
    }
    
}
