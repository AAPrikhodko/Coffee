//
//  GeoCountryMapView.swift
//  Coffee
//
//  Created by Andrei on 12.05.2025.
//

import SwiftUI
import MapKit

struct GeoCountryMapView: UIViewRepresentable {
    let records: [Record]
    @Binding var selectedCountryCode: String?

    func makeCoordinator() -> Coordinator {
        Coordinator(records: records, selectedCountryCode: $selectedCountryCode)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false

        // 🔹 Упрощённая конфигурация карты
        if #available(iOS 16.0, *) {
            let config = MKStandardMapConfiguration(elevationStyle: .flat)
            config.pointOfInterestFilter = .excludingAll
            config.showsTraffic = false
            mapView.preferredConfiguration = config

            // buildings отключаются отдельно
            mapView.showsBuildings = false
        } else {
            mapView.mapType = .mutedStandard
            mapView.pointOfInterestFilter = .excludingAll
            mapView.showsBuildings = false
        }

        // 🔹 Начальный регион
        mapView.setRegion(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 20, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
            ),
            animated: false
        )

        // 🔹 Жест нажатия
        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        mapView.addGestureRecognizer(tap)

        // 🔹 Загрузка границ стран
        context.coordinator.loadGeoJSON(into: mapView)

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}

    class Coordinator: NSObject, MKMapViewDelegate {
        let records: [Record]
        private var visitedCountries: Set<String>
        private var overlays: [MKPolygon] = []
        @Binding var selectedCountryCode: String?

        init(records: [Record], selectedCountryCode: Binding<String?>) {
            self.records = records
            self._selectedCountryCode = selectedCountryCode
            self.visitedCountries = Set(records.compactMap { $0.place.countryCode })
        }

        func loadGeoJSON(into mapView: MKMapView) {
            guard let url = Bundle.main.url(forResource: "countries", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                return
            }

            do {
                let features = try MKGeoJSONDecoder()
                    .decode(data)
                    .compactMap { $0 as? MKGeoJSONFeature }

                for feature in features {
                    // Получаем ISO_A2 код
                    var isoCode: String?
                    if let propsData = feature.properties,
                       let props = try? JSONSerialization.jsonObject(with: propsData) as? [String: Any] {
                        isoCode = props["iso_a2"] as? String
                    }

                    for geometry in feature.geometry {
                        if let polygon = geometry as? MKPolygon {
                            polygon.setValue(isoCode, forKey: "title")
                            overlays.append(polygon)
                            mapView.addOverlay(polygon)
                        } else if let multiPolygon = geometry as? MKMultiPolygon {
                            for subPolygon in multiPolygon.polygons {
                                subPolygon.setValue(isoCode, forKey: "title")
                                overlays.append(subPolygon)
                                mapView.addOverlay(subPolygon)
                            }
                        }
                    }
                }
            } catch {
                print("GeoJSON parse error: \(error)")
            }
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let mapView = gesture.view as? MKMapView else { return }
            let point = gesture.location(in: mapView)
            let coord = mapView.convert(point, toCoordinateFrom: mapView)

            for polygon in overlays {
                let renderer = MKPolygonRenderer(polygon: polygon)
                renderer.createPath()

                let mapPoint = MKMapPoint(coord)
                let pointInRenderer = renderer.point(for: mapPoint)

                if renderer.path?.contains(pointInRenderer) == true {
                    selectedCountryCode = polygon.title
                    break
                }
            }
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let polygon = overlay as? MKPolygon else {
                return MKOverlayRenderer(overlay: overlay)
            }

            let renderer = MKPolygonRenderer(polygon: polygon)
            if let code = polygon.title, visitedCountries.contains(code ?? "") {
                renderer.fillColor = UIColor.systemYellow.withAlphaComponent(0.7)
            } else {
                renderer.fillColor = UIColor.systemGray4.withAlphaComponent(0.3)
            }

            renderer.strokeColor = UIColor.black.withAlphaComponent(0.3)
            renderer.lineWidth = 0.4
            return renderer
        }
    }
}

