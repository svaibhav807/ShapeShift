//
//  GymActivityView.swift
//  MyGymTracker
//
//  Created by Vaibhav Singh on 16/03/23.
//

import SwiftUI
import MapKit
import HealthKit

struct GymActivityView: View {
    @EnvironmentObject var vm: HealthKitViewModel
    @State private var selectedWorkoutIndex = 0

    @State private var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    var body: some View {
        VStack {
            GymActivityMapView(workout: workoutBinding, coordinateRegion: $coordinateRegion)
            Spacer()
            Button("Next") {
                // Move to the next workout and update the coordinate region
                selectedWorkoutIndex += 1
                if let workouts = vm.workouts, selectedWorkoutIndex >= workouts.count {
                    selectedWorkoutIndex = 0
                }
                coordinateRegion = getCoordinateRegion(for: currentWorkout)
            }
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
            .font(Font.system(size: 20))
        }
        .padding(.bottom, 16)
        .onAppear() {
            Task {
               await vm.readWorkouts()
            }
            coordinateRegion = getCoordinateRegion(for: currentWorkout)
        }
    }

    private var currentWorkout: HKWorkout? {
        if let workouts = vm.workouts, selectedWorkoutIndex < workouts.count {
            return  workouts[selectedWorkoutIndex]
        }
        return nil
    }

    private var workoutBinding: Binding<HKWorkout?> {
            Binding<HKWorkout?>(
                get: { currentWorkout },
                set: { newWorkout in
                    if let newWorkout = newWorkout,
                       let index = vm.workouts?.firstIndex(of: newWorkout) {
                        selectedWorkoutIndex = index
                    }
                }
            )
        }

    private func getCoordinateRegion(for workout: HKWorkout?) -> MKCoordinateRegion {
        let baseCordinate =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: +26.93222214, longitude: +75.73455152), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        guard let currentWorkout = currentWorkout, let location = vm.workoutLocations[currentWorkout]?[0] else {
            selectedWorkoutIndex += 1
            if let workouts = vm.workouts, selectedWorkoutIndex >= workouts.count {
                selectedWorkoutIndex = 0
            }
            return baseCordinate
        }

        let cordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        return cordinateRegion
    }
}

struct GymActivityView_Previews: PreviewProvider {
    static var previews: some View {
        GymActivityView()
            .environmentObject(HealthKitViewModel())
    }
}
