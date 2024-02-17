//
//  HealthManager.swift
//  FitnessApp
//
//  Created by David on 2/12/24.
//

import Foundation
import HealthKit

class HealthManager: ObservableObject {
    @Published var stepsActivity: ActivityModel = ActivityModel(title: "Today steps", subtitle: "Goal 10,000", image: "figure.walk", amount: "0")
    @Published var caloriesActivity:ActivityModel = ActivityModel(title: "Today calories", subtitle: "Goal 400", image: "flame", amount: "0")
    @Published var runningActivity: ActivityModel = ActivityModel(title: "Running", subtitle: "120 min", image: "figure.run", amount: "0")
    @Published var swimmingActivity: ActivityModel = ActivityModel(title: "swimming", subtitle: "70 min", image: "figure.open.water.swim", amount: "0 min")
    @Published var basketballActivity: ActivityModel = ActivityModel(title: "Basketball", subtitle: "70 min", image: "basketball", amount: "0 min")
    @Published var baseballActivity: ActivityModel = ActivityModel(title: "Baseball", subtitle: "30 min", image: "figure.baseball", amount: "0 min")
    @Published var soccerActivity: ActivityModel = ActivityModel(title: "Soccer", subtitle: "90 min", image: "figure.soccer", amount: "0 min")
    @Published var boxingActivity: ActivityModel = ActivityModel(title: "Boxing", subtitle: "40 min", image: "figure.boxing", amount: "0 min")
    
    let healthStore = HKHealthStore()
    
    init() {
        let steps = HKQuantityType(.stepCount)
        let calories = HKQuantityType(.activeEnergyBurned)
        let running = HKObjectType.workoutType()
        
        let healthTypes: Set = [steps, calories, running]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
                fetchSteps()
                fetchCalories()
                fetchRunning()
            } catch {
                print("Error")
            }
        }
    }
    
    func fetchSteps() {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, result, error in
            guard let result = result, let quantity = result.sumQuantity(), error == nil else { return }
            let stepCount = quantity.doubleValue(for: .count())
            print(stepCount)
            let activity = ActivityModel(title: "Today steps", subtitle: "Goal 10,000", image: "figure.walk", amount: "\(Int(stepCount))")
            DispatchQueue.main.async {
                self.stepsActivity = activity
            }
            
        }
        healthStore.execute(query)
    }
    
    func fetchCalories() {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, result, error in
            guard let result = result, let quantity = result.sumQuantity(), error == nil else { return }
            let calories = quantity.doubleValue(for: .kilocalorie())
            let activity = ActivityModel(title: "Today calories", subtitle: "Goal 400", image: "flame", amount: "\(calories)")
            DispatchQueue.main.async {
                self.caloriesActivity = activity
            }
            
        }
        healthStore.execute(query)
    }
    
    func fetchRunning() {
        let workouts = HKSampleType.workoutType()
        
        let timePredicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())
        
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .running)
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
        
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                return
            }
            
            for workout in workouts {
                print(workout.duration)
                if workout.workoutActivityType == .running {
                    DispatchQueue.main.async {
                        self.runningActivity = ActivityModel(title: "Running", subtitle: "120 min", image: "figure.run", amount: "\(Int(workout.duration)) min")
                    }
                }
            }
        }
        healthStore.execute(query)
    }
    
    func fetchSwimming() {
        let workouts = HKSampleType.workoutType()
        
        let timePredicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())
        
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .swimming)
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
        
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                return
            }
            
            for workout in workouts {
                print(workout.duration)
                if workout.workoutActivityType == .swimming {
                    DispatchQueue.main.async {
                        self.runningActivity = ActivityModel(title: "Swimming", subtitle: "40 min", image: "figure.open.water.swim", amount: "\(workout.duration) min")
                    }
                }
                
            }
        }
        healthStore.execute(query)
    }
    
    func fetchBasketball() {
        let workouts = HKSampleType.workoutType()
        
        let timePredicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())
        
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .basketball)
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
        
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                return
            }
            
            for workout in workouts {
                print(workout.duration)
                if workout.workoutActivityType == .basketball {
                    DispatchQueue.main.async {
                        self.runningActivity = ActivityModel(title: "Basketball", subtitle: "70 min", image: "basketball", amount: "\(workout.duration) min")
                    }
                }
                
            }
        }
        healthStore.execute(query)
    }
    
    func fetchBaseball() {
        let workouts = HKSampleType.workoutType()
        
        let timePredicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())
        
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .baseball)
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
        
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                return
            }
            
            for workout in workouts {
                print(workout.duration)
                if workout.workoutActivityType == .baseball {
                    DispatchQueue.main.async {
                        self.runningActivity = ActivityModel(title: "Baseball", subtitle: "30 min", image: "figure.baseball", amount: "\(workout.duration) min")
                    }
                }
                
            }
        }
        healthStore.execute(query)
    }
    
    func fetchSoccer() {
        let workouts = HKSampleType.workoutType()
        
        let timePredicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())
        
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .soccer)
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
        
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                return
            }

            for workout in workouts {
                print(workout.duration)
                if workout.workoutActivityType == .soccer {
                    DispatchQueue.main.async {
                        self.runningActivity = ActivityModel(title: "Soccer", subtitle: "90 min", image: "figure.soccer", amount: "\(workout.duration) min")
                    }
                }
                
            }
        }
        healthStore.execute(query)
    }
    
    func fetchBoxing() {
        let workouts = HKSampleType.workoutType()
        
        let timePredicate = HKQuery.predicateForSamples(withStart: Calendar.current.startOfDay(for: Date()), end: Date())
        
        let workoutPredicate = HKQuery.predicateForWorkouts(with: .boxing)
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [timePredicate, workoutPredicate])
        
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, sample, error in
            guard let workouts = sample as? [HKWorkout], error == nil else {
                return
            }
            
            for workout in workouts {
                print(workout.duration)
                if workout.workoutActivityType == .boxing {
                    DispatchQueue.main.async {
                        self.runningActivity = ActivityModel(title: "Boxing", subtitle: "40 min", image: "figure.boxing", amount: "\(workout.duration) min")
                    }
                }
                
            }
        }
        healthStore.execute(query)
    }
}
