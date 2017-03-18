//
//  MyHealthManager.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/17.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import Foundation
import HealthKit

class MyHealthManager {
    let healthKitStore: HKHealthStore = HKHealthStore()
    
    func authorizeHealthKit() -> Bool {
        var isEnabled = true
        
        
        if HKHealthStore.isHealthDataAvailable() {
        // State the health data type(s) we want to read from HealthKit.
        let healthDataToRead = Set(arrayLiteral: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!)
        
        // State the health data type(s) we want to write from HealthKit.
        let healthDataToWrite = Set(arrayLiteral: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!)
        
        
        // Request authorization to read and/or write the specific data.
        healthKitStore.requestAuthorization(toShare: healthDataToWrite, read: healthDataToRead) { (success, error) -> Void in
            isEnabled = success
        }
            return isEnabled
        }
        else {
            return false
        }
    }
    
    
    func getHeartRate(sampleType: HKSampleType , completion: ((HKSample?, NSError?) -> Void)!) {
        

        let distantPast = NSDate.distantPast as Date
        let lastHeartRatePredicate = HKQuery.predicateForSamples(withStart: distantPast, end: Date(), options: [])
        
        // Get the single most recent heartRate
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let heartRateQuery = HKSampleQuery(sampleType: sampleType, predicate: lastHeartRatePredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (sampleQuery, results, error ) -> Void in
            
            
            if let queryError = error {
                completion?(nil, queryError as NSError?)
                return
            }
            
            // Set the first HKQuantitySample in results as the most recent heartRate.
            let lastHeartRate = results!.first
            //print("\(lastHeartRate)")
            //print("ahahahaahah")
            if completion != nil {
                completion(lastHeartRate, nil)
            }
        }
        
        // Time to execute the query.
        self.healthKitStore.execute(heartRateQuery)
    }
    
    
    func saveDistance(distanceRecorded: Double, date: NSDate ) {
        
        // Set the quantity type to the running/walking distance.
        let distanceType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
        
        // Set the unit of measurement to meters.
        let distanceQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: distanceRecorded)
        
        // Set the official Quantity Sample.
        let distance = HKQuantitySample(type: distanceType!, quantity: distanceQuantity, start: date as Date, end: date as Date)
        
        // Save the distance quantity sample to the HealthKit Store.
        healthKitStore.save(distance, withCompletion: { (success, error) -> Void in
            if( error != nil ) {
                print(error as Any)
            }
        })
    }
    
}
