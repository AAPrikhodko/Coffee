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

        // 🔹 Упрощённая карта
        if #available(iOS 16.0, *) {
            let config = MKStandardMapConfiguration(elevationStyle: .flat)
            config.pointOfInterestFilter = .excludingAll
            config.showsTraffic = false
            mapView.preferredConfiguration = config
            mapView.showsBuildings = false
        } else {
            mapView.mapType = .mutedStandard
            mapView.pointOfInterestFilter = .excludingAll
            mapView.showsBuildings = false
        }

        // 🔹 Регион
        mapView.setRegion(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 20, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
            ),
            animated: false
        )

        // 🔹 Жест
        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        mapView.addGestureRecognizer(tap)

        // 🔹 Загрузка геоданных
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

            let codes = records
                .compactMap { $0.place.countryCode }
                .compactMap { isoA2(from: $0) }
                .map { $0.uppercased() }

            self.visitedCountries = Set(codes)
            print("Visited countries: \(self.visitedCountries)")
        }

        func loadGeoJSON(into mapView: MKMapView) {
            guard let url = Bundle.main.url(forResource: "countries", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                print("❌ Failed to load countries.json")
                return
            }

            do {
                let features = try MKGeoJSONDecoder()
                    .decode(data)
                    .compactMap { $0 as? MKGeoJSONFeature }

                print("🌍 Total features: \(features.count)")

                for feature in features {
                    var isoCode: String?

                    if let propsData = feature.properties,
                       let props = try? JSONSerialization.jsonObject(with: propsData) as? [String: Any] {

                        // Получаем ISO-код
                        isoCode = (props["iso_a2"] as? String)?.uppercased()

                        // 🔁 Попытка восстановить код, если он "-99" или отсутствует
                        if isoCode == nil || isoCode == "-99",
                           let adminName = props["admin"] as? String,
                           let resolved = isoA2(from: adminName) {
                            print("🔁 Resolved ISO from admin '\(adminName)' → \(resolved)")
                            isoCode = resolved
                        }
                    }

                    // Обработка геометрии
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
                        } else {
                            print("⚠️ Unsupported geometry: \(geometry)")
                        }
                    }
                }

                print("✅ Loaded \(overlays.count) polygons")
            } catch {
                print("❌ GeoJSON parse error: \(error)")
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
            renderer.strokeColor = UIColor.black.withAlphaComponent(0.7)
            renderer.lineWidth = 0.4

            guard let code = polygon.title else {
                print("⚠️ Polygon without ISO code")
                renderer.fillColor = UIColor.systemGray.withAlphaComponent(1)
                return renderer
            }

            let isVisited = visitedCountries.contains(code)
            print("🗺 Rendering polygon for: \(code) – Visited: \(isVisited)")

            renderer.fillColor = isVisited
                ? UIColor.systemYellow.withAlphaComponent(1)
                : UIColor.systemGray.withAlphaComponent(1)

            return renderer
        }

    }
}

func isoA2(from countryName: String) -> String? {
    let locale = Locale(identifier: "en_US")

    if #available(iOS 16.0, *) {
        for region in Locale.Region.isoRegions {
            let code = region.identifier  // например: "IT"
            if let name = locale.localizedString(forRegionCode: code),
               name.uppercased() == countryName.uppercased() {
                return code
            }
        }
    } else {
        for code in Locale.isoRegionCodes {
            if let name = locale.localizedString(forRegionCode: code),
               name.uppercased() == countryName.uppercased() {
                return code
            }
        }
    }

    return nil
}

