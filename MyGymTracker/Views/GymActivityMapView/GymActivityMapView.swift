//
//  GymActivityMapView.swift
//  MyGymTracker
//
//  Created by Vaibhav Singh on 15/03/23.
//

import SwiftUI
import MapKit
import HealthKit

struct GymActivityMapView: View {
    @EnvironmentObject var vm: HealthKitViewModel

    @Binding var workout: HKWorkout?
    @Binding var coordinateRegion: MKCoordinateRegion

    private var locations: [CLLocation]? {
        guard let workout = workout else { return nil }
        return vm.workoutLocations[workout]
    }

    var body: some View {
        VStack {
            if let currentWorkout = workout {
                Text("Workout details")
                    .font(.title2)
                    .padding(.bottom, 10)
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Workout Date:")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("\(currentWorkout.startDate, formatter: DateFormatter.workoutDateFormatter)")
                                .font(.subheadline)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Workout Type:")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("\(currentWorkout.workoutActivityType.name)")
                                .font(.subheadline)
                        }
                    }
                    .padding(.bottom, 10)
                    HStack {
                        VStack(alignment: .center, spacing: 4) {
                            Text("Duration:")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(String(format: "%.1f", currentWorkout.duration / 60) + " mins")
                                .font(.subheadline)
                        }
                        Spacer()
                        VStack(alignment: .center, spacing: 4) {
                            Text("Energy Burned:")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(String(format: "%.1f", currentWorkout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0.0) + " kcal")
                                .font(.subheadline)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            Map(coordinateRegion: $coordinateRegion, annotationItems: locations ?? []) { location in

                MapMarker(coordinate: location.coordinate)

            }
//            MapView()
            .frame(height: 500)
            .cornerRadius(8)

            if locations == nil || locations?.count == 0 {
                Spacer()
                Text("No location available")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                Spacer()
            }
        }
    }
    
}

extension CLLocation: Identifiable {
    public var id: Int {
        hashValue
    }
}

extension DateFormatter {
    static let workoutDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}

extension HKWorkoutActivityType {

    var name: String {
        switch self {
        case .americanFootball: return "American Football"
        case .archery: return "Archery"
        case .australianFootball: return "Australian Football"
        case .badminton: return "Badminton"
        case .baseball: return "Baseball"
        case .basketball: return "Basketball"
        case .bowling: return "Bowling"
        case .boxing: return "Boxing"
        case .climbing: return "Climbing"
        case .cricket: return "Cricket"
        case .crossCountrySkiing: return "Cross Country Skiing"
        case .crossTraining: return "Cross Training"
        case .curling: return "Curling"
        case .cycling: return "Cycling"
        case .dance: return "Dance"
        case .danceInspiredTraining: return "Dance Inspired Training"
        case .elliptical: return "Elliptical"
        case .equestrianSports: return "Equestrian Sports"
        case .fencing: return "Fencing"
        case .fishing: return "Fishing"
        case .functionalStrengthTraining: return "Functional Strength Training"
        case .golf: return "Golf"
        case .gymnastics: return "Gymnastics"
        case .handball: return "Handball"
        case .hiking: return "Hiking"
        case .hockey: return "Hockey"
        case .hunting: return "Hunting"
        case .lacrosse: return "Lacrosse"
        case .martialArts: return "Martial Arts"
        case .mindAndBody: return "Mind and Body"
        case .mixedCardio: return "Mixed Cardio"
        case .paddleSports: return "Paddle Sports"
        case .play: return "Play"
        case .preparationAndRecovery: return "Preparation and Recovery"
        case .racquetball: return "Racquetball"
        case .rowing: return "Rowing"
        case .rugby: return "Rugby"
        case .running: return "Running"
        case .sailing: return "Sailing"
        case .skatingSports: return "Skating Sports"
        case .snowSports: return "Snow Sports"
        case .soccer: return "Soccer"
        case .softball: return "Softball"
        case .squash: return "Squash"
        case .stairClimbing: return "Stair Climbing"
        case .surfingSports: return "Surfing Sports"
        case .swimming: return "Swimming"
        case .tableTennis: return "Table Tennis"
        case .tennis: return "Tennis"
        case .trackAndField: return "Track and Field"
        case .traditionalStrengthTraining: return "Traditional Strength Training"
        case .volleyball: return "Volleyball"
        case .walking: return "Walking"
        case .waterFitness: return "Water Fitness"
        case .waterPolo: return "Water Polo"
        case .waterSports: return "Water Sports"
        case .wheelchairRunPace: return "Wheelchair Run Pace"
        case .wheelchairWalkPace: return "Wheelchair Walk Pace"
        case .wrestling: return "Wrestling"
        default: return "Other"
        }
    }

}


struct GymActivityMapView_Previews: PreviewProvider {
    static var previews: some View {
        let workout: HKWorkout? = HKWorkout(activityType: .functionalStrengthTraining, start: Date(), end: Date())
        let workoutBinding = Binding.constant(workout)
        let region = Binding.constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.33182, longitude: -122.03118), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
        let viewModel = HealthKitViewModel()

        return GymActivityMapView(workout: workoutBinding, coordinateRegion: region)
            .environmentObject(viewModel)
            .previewLayout(.fixed(width: 375, height: 667)) // Set the preview size
            .preferredColorScheme(.dark) // Set the color scheme
    }
}

