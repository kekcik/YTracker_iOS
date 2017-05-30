//
//  ViewController.swift
//  YTracker
//
//  Created by Ivan Trofimov on 19.05.17.
//  Copyright © 2017 Ivan Trofimov. All rights reserved.
//

import UIKit
import MapKit

extension MKMapRect {
    init(minX: Double, minY: Double, maxX: Double, maxY: Double) {
        self.init(x: minX, y: minY, width: abs(maxX - minX), height: abs(maxY - minY))
    }
    init(x: Double, y: Double, width: Double, height: Double) {
        self.init(origin: MKMapPoint(x: x, y: y), size: MKMapSize(width: width, height: height))
    }
    var minX: Double { return MKMapRectGetMinX(self) }
    var minY: Double { return MKMapRectGetMinY(self) }
    var midX: Double { return MKMapRectGetMidX(self) }
    var midY: Double { return MKMapRectGetMidY(self) }
    var maxX: Double { return MKMapRectGetMaxX(self) }
    var maxY: Double { return MKMapRectGetMaxY(self) }
    func intersects(_ rect: MKMapRect) -> Bool {
        return MKMapRectIntersectsRect(self, rect)
    }
    func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        return MKMapRectContainsPoint(self, MKMapPointForCoordinate(coordinate))
    }
}

class ClusteredZone {
    private let rect : CGRect
    private var array = [MKPointAnnotation]()
    private var totalX = CLLocationDegrees()
    private var totalY = CLLocationDegrees()
    
    init (_ rect: CGRect) {
        self.rect = rect
    }
    
    func getAmount() -> Int {
        return array.count
    }
    
    func getMidX() -> CLLocationDegrees {
        return totalX / Double(array.count)
    }
    
    func getMidY() -> CLLocationDegrees {
        return totalY / Double(array.count)
    }
    
    func addAnnotation(_ annotation: MKPointAnnotation) {
        array.append(annotation)
        totalX += annotation.coordinate.latitude
        totalY += annotation.coordinate.longitude
    }
}


class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var minus: UIButton!
    @IBAction func minusAction(_ sender: Any) {
        mapView.region.span.latitudeDelta *= 2
    }
    
    var annotations: [MKPointAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        annotations = (0..<1000).map { i in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: drand48() * 80 - 40, longitude: drand48() * 80 - 40)
            return annotation
        }
    }

    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        var x = mapView.visibleMapRect.size.width // -- ширина
        var y = mapView.visibleMapRect.size.height // -- высота
        var xx = 1.0
        while (xx < x) {
            xx *= 2
        }
        y = y * (xx / x)
        x = xx
        
        let deltaX = x / 6
        let deltaY = y / 9
        let startX = Double(Int(mapView.visibleMapRect.origin.x) % Int(deltaX))
        let startY = Double(Int(mapView.visibleMapRect.origin.y) % Int(deltaY))
        mapView.annotations.forEach { (an) in
            mapView.removeAnnotation(an)
        }
        
        for dx in -3 ... 4 {
            for dy in -5...6 {
                let annotation = MKPointAnnotation()

                let rect = CGRect(
                        x: mapView.visibleMapRect.origin.x - startX + x / 2 + deltaX * Double(dx),
                        y: mapView.visibleMapRect.origin.y - startY + y / 2 + deltaY * Double(dy),
                        width: deltaX,
                        height: deltaY)
                let chto = ClusteredZone(rect)

                for annotation in annotations.filter({ (an) -> Bool in
                    return rect.contains(CGPoint(
                            x: MKMapPointForCoordinate(an.coordinate).x,
                            y: MKMapPointForCoordinate(an.coordinate).y
                    ))
                }) {
                    chto.addAnnotation(annotation)
                }

                let coord = CLLocationCoordinate2D(
                        latitude: chto.getMidX(),
                        longitude: chto.getMidY()
                )

                annotation.title = "union for \(chto.getAmount()) points"
                annotation.coordinate = coord
                mapView.addAnnotation(annotation)
            }
        }
    }
}
