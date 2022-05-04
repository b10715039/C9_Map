//
//  ViewController.swift
//  C9_Map
//
//  Created by mac12 on 2022/5/4.
//

import UIKit
import MapKit
import CoreLocation
import SafariServices

enum ButtonID: Int {
    case ntuHospital = 100
}
class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    let lm = CLLocationManager()
    
    let annotations = [
        MKPointAnnotation(
            __coordinate: CLLocationCoordinate2D(
                latitude: 23.8579138636558446, longitude: 120.91596310138705
            ),
            title: "日月潭",
            subtitle: "南投縣"
        ),
        MKPointAnnotation(
            __coordinate: CLLocationCoordinate2D(
                latitude: 22.324628133505747, longitude: 120.35339885066817
            ),
            title: "落日亭",
            subtitle: "小琉球"
        ),
        
        MKPointAnnotation(
            __coordinate: CLLocationCoordinate2D(
                latitude: 25.04087516951404, longitude: 121.51892192431603
            ),
            title: "台大醫院",
            subtitle: "台大"
        ),
        
        MKPointAnnotation(
            __coordinate: CLLocationCoordinate2D(
                latitude: 25.067480171515843, longitude: 121.55268229091293
            ),
            title: "台北松山機場",
            subtitle: "台北市"
        )
        
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lm.requestWhenInUseAuthorization()
        mapView.addAnnotations(annotations)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        func toMarker(annotView: MKAnnotationView, id: String) -> MKMarkerAnnotationView {
            let markerView = annotView as! MKMarkerAnnotationView
            switch id {
            case "台大醫院":
                markerView.markerTintColor = .blue
                markerView.glyphText = "🏥"
                return markerView
            default:
                return markerView
            }
        }
        if let title = annotation.title, let id = title {
            if let annotView = mapView.dequeueReusableAnnotationView(withIdentifier: id) {
                print("\(id) reused")
                switch id {
                case "台大醫院":
                    return toMarker(annotView: annotView, id: id)
                case "台北松山機場":
                    return toMarker(annotView: annotView, id: id)
                default:
                    return annotView
                }
            }
            else {
                print("\(id) created")
                
                switch id {
                case "台大醫院":
                    let annotView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: id)
                    annotView.leftCalloutAccessoryView = UIImageView(image: UIImage(named: "台大醫院")?.resized())
                    let label = UILabel()
                    label.text = "國立臺灣大學醫學院附設醫院"
                    annotView.detailCalloutAccessoryView = label
                    
                    let button = UIButton(type: .detailDisclosure)
                    button.tag = ButtonID.ntuHospital.rawValue
                    annotView.rightCalloutAccessoryView = button
                    annotView.canShowCallout = true
                    return toMarker(annotView: annotView, id: id)
                case "台北松山機場":
                    let annotView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: id)
                    annotView.markerTintColor = .green
                    annotView.glyphText = "✈️"
                    return annotView
                case "日月潭":
                    let annotView = MKAnnotationView(annotation: annotation, reuseIdentifier: id)
                    annotView.image = UIImage(named: "日月潭")?.resized()
                    annotView.isDraggable = true
                    return annotView
                case "落日亭":
                    let annotView = MKAnnotationView(annotation: annotation, reuseIdentifier: id)
                    annotView.image = UIImage(named: "落日亭")?.resized()
                    return annotView
                default:
                    return nil
                }
            }
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //mapView.removeAnnotation(view.annotation!)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        switch control.tag {
        case ButtonID.ntuHospital.rawValue:
            if let url = URL(string: "https://www.ntuh.gov.tw/ntuh/Index.action?l=zh_TW") {
                let safari = SFSafariViewController(url: url)
                show(safari, sender: self)
            }
        default:
             return
        }
        
    }
    
}

extension UIImage {
    public func resized(to target: CGSize = CGSize(width: 50, height: 50)) -> UIImage {
        let ratio = min(target.height / size.height, target.width / size.width)
        let new = CGSize(width: size.width * ratio, height: size.height * ratio)
        let renderer = UIGraphicsImageRenderer(size: new)
        return renderer.image{_ in
                              self.draw(in: CGRect(origin: .zero, size: new))
        }
    }
}
