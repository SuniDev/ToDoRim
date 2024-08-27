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

class SearchLocationMapViewController: BaseViewController {
    
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
    @IBOutlet weak var completeButton: UIButton!
    
    // MARK: - Action
    @IBAction private func changedTextRadius(_ sender: UITextField) {
        sender.setMaxLength(max: 5)
    }
    
    @IBAction private func tappedBackButton(_ sender: UIButton) {
        self.navigationController?.hero.isEnabled = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func tappedCompleteButton(_ sender: UIButton) {
        if let coordinate,
           let radius = geotification?.radius,
           let selectLocationType,
           let name = geotification?.note {
            delegate?.searchLocationMapView(didAddCoordinate: coordinate, radius: radius, locationType: selectLocationType, name: name)
        }
    }
    
    @IBAction private func tapEntry(_ sender: UIButton) {
        selectLocationType = .entry
        addRadiusOverlay(forGeotification: geotification)
    }
    
    @IBAction private func tapExit(_ sender: UIButton) {
        selectLocationType = .exit
        addRadiusOverlay(forGeotification: geotification)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createKeyboardEvent()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Data 설정
    override func fetchData() {
        selectLocationType = .entry
        coordinate = selectedPin?.coordinate
    }
    
    // MARK: - UI 설정
    override func configureUI() {
        mapView?.delegate = self
        radiusTextField?.delegate = self
        locationManager.delegate = self
        
        tabButton.initButton(type: .locationType, color: Asset.Color.default.color, buttons: [entryButton, exitButton])
        
        performUIUpdatesOnMain {
            self.completeButton.layer.cornerRadius = 15
            self.completeButton.layer.masksToBounds = true
            self.tabButton.selectButton(sender: self.entryButton)
        }
        
        let radius = 100.0
        let clampedRadius = min(radius, locationManager.maximumRegionMonitoringDistance)
        if let coordinate {
            geotification = Geotification(coordinate: coordinate, radius: clampedRadius, identifier: UUID().uuidString, note: selectedPin?.name ?? L10n.Location.current, eventType: .onEntry)
        }
        
        dropPinZoomIn()
    }
    
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
                    Alert.showDone(
                        self,
                        title: L10n.Alert.SearchLocation.RadiusWarning.title
                    )
                    radiusTextField.text = "100"
                }
            } else {
                Alert.showDone(
                    self,
                    title: L10n.Alert.SearchLocation.TextWarning.title
                )
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
        for index in 0..<mapView.overlays.count {
            mapView.removeOverlay(mapView.overlays[index])
        }
        mapView.addOverlay(MKCircle(center: geotification.coordinate, radius: geotification.radius))
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
                circleRenderer.strokeColor = Asset.Color.blue.color
                circleRenderer.fillColor = Asset.Color.blue.color.withAlphaComponent(0.4)
                return circleRenderer
            } else {
                let circleRenderer = MKCircleRenderer(overlay: overlay)
                circleRenderer.lineWidth = 3.0
                circleRenderer.strokeColor = Asset.Color.blue.color
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
