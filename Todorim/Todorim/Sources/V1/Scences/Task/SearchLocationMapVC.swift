//
//  SearchLocationMapVC.swift
//  HSTODO
//
//  Created by 박현선 on 24/09/2019.
//  Copyright © 2019 hspark. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol SelectLocationDelegate {
    func SearchLocationMapVC(_ controllers: [UIViewController], didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, eventType: LocationConfig, name: String)
}

class SearchLocationMapVC: UIViewController {

    // Outlet
    @IBOutlet weak var textRadius: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnEntry: UIButton!
    @IBOutlet weak var btnExit: UIButton!
    
    @IBOutlet weak var constBtnCompletBottom: NSLayoutConstraint!
    @IBOutlet weak var bottomGuideView: UIView!
    
    // var
    var locationManager = CLLocationManager()
    var selectedPin: MKPlacemark!
    var tabButton = CustomTabButton()
    var geotification: Geotification!
    var selectLocation: LocationConfig!
    var coordinate: CLLocationCoordinate2D!
    
    var delegate: SelectLocationDelegate?
    var superVC: UIViewController!
    var searchVC: UIViewController!
    var tableVC: UIViewController!
    
    // Action
    @IBAction func textRadiusChanged(_ sender: UITextField) {
        sender.setMaxLength(max: 5)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.hero.isEnabled = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func completeLocation(_ sender: UIButton) {
        searchVC.view.endEditing(true)
        delegate?.SearchLocationMapVC([self,searchVC], didAddCoordinate: coordinate, radius: geotification.radius, eventType: selectLocation, name: geotification.note)
    }
    
    
    @IBAction func tapEntry(_ sender: UIButton) {
        selectLocation = .entry
        addRadiusOverlay(forGeotification: geotification)
    }
    
    @IBAction func tapExit(_ sender: UIButton) {
        selectLocation = .exit
        addRadiusOverlay(forGeotification: geotification)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
//            scrollView.contentInsetAdjustmentBehavior = .never
            
            let window = UIApplication.shared.keyWindow
            
            if let bottomPadding = window?.safeAreaInsets.bottom {
                let layoutHeight = bottomGuideView.constraints.filter{ $0.identifier == "guideHeight" }.first
                layoutHeight?.constant = bottomPadding
            }
        }
        
        self.delegate = superVC as? SelectLocationDelegate
        
        mapView.delegate = self
        textRadius.delegate = self
        
        
        
        createKeyboardEvent()
        
        selectLocation = .entry
        locationManager.delegate = self
        
        // location type tab 세팅
        tabButton.initLocationButton(btn: btnEntry, tag: 0, color: UIColor(rgb: 0x39393E))
        tabButton.initLocationButton(btn: btnExit, tag: 1, color: UIColor(rgb: 0x39393E))
        tabButton.locationBtnSelected(sender: btnEntry)
        
        coordinate = selectedPin.coordinate
        let radius = 100.0
        let clampedRadius = min(radius, locationManager.maximumRegionMonitoringDistance)
        
//        geotification = Geotification(coordinate: coordinate, radius: clampedRadius, identifier: NSUUID().uuidString, note: selectedPin.name ?? "\(String(format: "%.2f", CGFloat(coordinate.latitude))), \(String(format: "%.2f", CGFloat(coordinate.longitude)))", eventType: .onEntry)
        geotification = Geotification(coordinate: coordinate, radius: clampedRadius, identifier: NSUUID().uuidString, note: selectedPin.name ?? "현재 위치", eventType: .onEntry)
        
        dropPinZoomIn()
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
    }
}

// MARK: - CLLocationManagerDelegate
extension SearchLocationMapVC: CLLocationManagerDelegate {
    
    
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

// MARK: - extension
extension SearchLocationMapVC {
    
    func dropPinZoomIn(){
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
            
            
            if let text = textRadius.text {
                let radius = Double(text) ?? 0
                if radius >= 100.0 {
                    geotification.radius = radius
                    addRadiusOverlay(forGeotification: geotification)
                } else {
                    let alert = UIAlertController(title: "반경은 최소 100m 이상 입니다.", message: "", preferredStyle: UIAlertController.Style.alert)
                    let defaultAction = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(defaultAction)
                    self.present(alert, animated: false, completion: nil)
                    textRadius.text = "100"
                }
            } else {
                let alert = UIAlertController(title: "잘못된 입력입니다.", message: "", preferredStyle: UIAlertController.Style.alert)
                let defaultAction = UIAlertAction(title: "확인", style: .default)
                alert.addAction(defaultAction)
                self.present(alert, animated: false, completion: nil)
                textRadius.text = "100"
            }
            
            let delta = geotification.radius / 15000
            let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
            let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    // 키보드 기본 처리
    func createKeyboardEvent() {
        // 키보드가 팝업되거나 숨김 처리될 때 화면 처리 noti
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 화면 터치 시 키보드 숨김
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    func addRadiusOverlay(forGeotification geotification: Geotification) {
        for i in 0..<mapView.overlays.count {
            mapView.removeOverlay(mapView.overlays[i])
        }
        mapView.addOverlay(MKCircle(center: geotification.coordinate, radius: geotification.radius))
    }
    
}

@objc extension SearchLocationMapVC {
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // 키보드 팝업 처리
    func keyboardWillShow(_ sender: Notification) {
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
    }
    
    // 키보드 숨김 처리
    func keyboardWillHide(_ sender: Notification) {
        
    }
}

// MARK: - MKMapViewDelegate
extension SearchLocationMapVC: MKMapViewDelegate {
  
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            if selectLocation == .entry {
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

extension SearchLocationMapVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dropPinZoomIn()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
