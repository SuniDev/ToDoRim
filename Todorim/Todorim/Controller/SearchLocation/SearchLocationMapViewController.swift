//
//  SearchLocationMapViewController.swift
//  Todorim
//
//  Created by suni on 8/15/24.
//

import UIKit
import MapKit
import CoreLocation

protocol SelectLocationMapViewDelegate: AnyObject {
    func searchLocationMapView(didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, locationType: LocationNotificationType, name: String)
}

class SearchLocationMapViewController: UIViewController {
    
    // MARK: - Data
    var locationManager = CLLocationManager()
    var tabButton = TabButton()
    var geotification: Geotification?
    var selectedPin: MKPlacemark?
    var selectLocationType: LocationNotificationType?
    var coordinate: CLLocationCoordinate2D?
    
    weak var delegate: SelectLocationMapViewDelegate?
    
    // MARK: - Outlet
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var entryButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    // MARK: - Action
    @IBAction func changedTextRadius(_ sender: UITextField) {
        sender.setMaxLength(max: 5)
    }
    
    @IBAction func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.hero.isEnabled = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedCompleteButton(_ sender: UIButton) {
        if let coordinate,
           let radius = geotification?.radius,
           let selectLocationType,
           let name = geotification?.note {
            delegate?.searchLocationMapView(didAddCoordinate: coordinate, radius: radius, locationType: selectLocationType, name: name)
        }
    }
    
    
    @IBAction func tapEntry(_ sender: UIButton) {
        selectLocationType = .entry
        addRadiusOverlay(forGeotification: geotification)
    }
    
    @IBAction func tapExit(_ sender: UIButton) {
        selectLocationType = .exit
        addRadiusOverlay(forGeotification: geotification)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView?.delegate = self
        radiusTextField?.delegate = self
        locationManager.delegate = self
                
        createKeyboardEvent()
        
        selectLocationType = .entry
        
        tabButton.initButton(type: .locationType, color: Asset.Color.default.color, buttons: [exitButton, entryButton])
        tabButton.selectButton(sender: entryButton)
        
        coordinate = selectedPin?.coordinate
        let radius = 100.0
        let clampedRadius = min(radius, locationManager.maximumRegionMonitoringDistance)
        
        if let coordinate {
            geotification = Geotification(coordinate: coordinate, radius: clampedRadius, identifier: UUID().uuidString, note: selectedPin?.name ?? "현재 위치", eventType: .onEntry)
        }
        
        dropPinZoomIn()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
    }
    
    // 키보드 기본 처리
    func createKeyboardEvent() {
        // 화면 터치 시 키보드 숨김
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension SearchLocationMapViewController {
    func dropPinZoomIn() {
        // cache the pin
        if let placemark = selectedPin {
            // clear existing pins
            mapView.removeAnnotations(mapView.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark.coordinate
            annotation.title = placemark.name
            if let city = placemark.locality,
                let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
            }
            mapView.addAnnotation(annotation)
            
            
            if let text = radiusTextField.text {
                let radius = Double(text) ?? 0
                if radius >= 100.0 {
                    geotification?.radius = radius
                    addRadiusOverlay(forGeotification: geotification)
                } else {
                    let alert = UIAlertController(title: "반경은 최소 100m 이상 입니다.", message: "", preferredStyle: UIAlertController.Style.alert)
                    let defaultAction = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(defaultAction)
                    self.present(alert, animated: false, completion: nil)
                    radiusTextField.text = "100"
                }
            } else {
                let alert = UIAlertController(title: "잘못된 입력입니다.", message: "", preferredStyle: UIAlertController.Style.alert)
                let defaultAction = UIAlertAction(title: "확인", style: .default)
                alert.addAction(defaultAction)
                self.present(alert, animated: false, completion: nil)
                radiusTextField.text = "100"
            }
            
            let radius = geotification?.radius ?? 0
            let delta = radius / 15000
            let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
            let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func addRadiusOverlay(forGeotification geotification: Geotification?) {
        guard let geotification else { return }
        for i in 0..<mapView.overlays.count {
            mapView.removeOverlay(mapView.overlays[i])
        }
        mapView.addOverlay(MKCircle(center: geotification.coordinate, radius: geotification.radius))
    }
    
}

// MARK: - CLLocationManagerDelegate
extension SearchLocationMapViewController: CLLocationManagerDelegate {
    // 위치 정보가 다시 오면 호출됩니다. 위치가 다양하지만 첫 번째 항목에만 관심이 있습니다. 아직 아무것도하지 않지만 결국이 위치로 확대됩니다.
    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let delta = 100.0 / 15000
            let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // 오류를 인쇄합니다.
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
}

// MARK: - MKMapViewDelegate
extension SearchLocationMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            if selectLocationType == .entry {
                let circleRenderer = MKCircleRenderer(overlay: overlay)
                circleRenderer.lineWidth = 3.0
                circleRenderer.strokeColor = UIColor(rgb: 0x47B8E0)
                circleRenderer.fillColor = UIColor(rgb: 0x47B8E0).withAlphaComponent(0.4)
                return circleRenderer
            } else {
                let circleRenderer = MKCircleRenderer(overlay: overlay)
                circleRenderer.lineWidth = 3.0
                circleRenderer.strokeColor = UIColor(rgb: 0x47B8E0)
                circleRenderer.fillColor = UIColor.clear
                return circleRenderer
            }
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

// MARK: - UITextFieldDelegate
extension SearchLocationMapViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        dropPinZoomIn()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
