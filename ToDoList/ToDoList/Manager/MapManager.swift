//
//  MapManager.swift
//  ToDoList
//
//  Created by WEI-TSUNG CHENG on 2023/4/16.
//

import Foundation
import MapKit


protocol MapManagerProtocol: AnyObject {
    
    func selectedCoordinateOnMap(_ coodinate: CLLocationCoordinate2D)
}

class MapManager: NSObject {
    
    var mapView: MKMapView?
    weak var delegate: MapManagerProtocol?
    
    static let shared: MapManager = {
        let instance = MapManager()
        return instance
    }()
    
    private override init() {
        super.init()
        
    }
    
    func addAnnotation(at coordinate: CLLocationCoordinate2D) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView?.addAnnotation(annotation)
        mapView?.selectAnnotation(annotation, animated: true)
    }
    
    func search(query: String?) {
        
        guard let mapView = mapView else {
            return
        }
        
        mapView.removeAnnotations(mapView.annotations)
        
        guard let query = query, !query.isEmpty else { return }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                return
            }
            let annotations = response.mapItems.map { item -> MKPointAnnotation in
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                annotation.subtitle = item.placemark.title
                return annotation
            }
            
            for annotation in annotations {
                
                self.addAnnotation(at: annotation.coordinate)
            
            }
            
            if let annotation = annotations.first {
                
                let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
                
                mapView.setRegion(region, animated: true)
                mapView.selectAnnotation(annotation, animated: false)
               
            }
                   
            
            
        }
    }
    
}


extension MapManager: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        let coordinate = annotation.coordinate
        
        delegate?.selectedCoordinateOnMap(coordinate)
        print("Selected coordinate: \(coordinate)")
    }
    
}
