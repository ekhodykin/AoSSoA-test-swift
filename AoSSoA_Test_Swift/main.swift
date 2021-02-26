//
//  main.swift
//  AoSSoA_Test_Swift
//
//  Created by ekhodykin on 25.02.2021.
//

import Foundation

let kSizeOfArray = 1<<24

struct AoSStruct {
    var a, b, c: Float
}

struct SoAStruct {
    var a, b, c: UnsafeMutablePointer<Float>
}

let roots = UnsafeMutablePointer<Float>.allocate(capacity: kSizeOfArray)
let soaArray = SoAStruct(a: UnsafeMutablePointer<Float>.allocate(capacity: kSizeOfArray),
                         b: UnsafeMutablePointer<Float>.allocate(capacity: kSizeOfArray),
                         c: UnsafeMutablePointer<Float>.allocate(capacity: kSizeOfArray))
var aosArray = [AoSStruct].init()
aosArray.reserveCapacity(kSizeOfArray)
var startTime = mach_absolute_time()
for i in 0..<kSizeOfArray {
    let tmpA = Float.random(in: 0..<99)
    let tmpB = Float.random(in: 0..<99)
    let tmpC = Float.random(in: 0..<99)
    soaArray.a[i] = tmpA
    soaArray.b[i] = tmpB
    soaArray.c[i] = tmpC
    aosArray.append(AoSStruct(a:tmpA, b:tmpB, c:tmpC))
}
var elapsedTime = mach_absolute_time() - startTime
print("Initialization time: \(Float(elapsedTime)/Float(NSEC_PER_MSEC)) (ms)")

let kNumberOfRuns = 10

startTime = mach_absolute_time()
for _ in 0..<kNumberOfRuns{
    for i in 0..<kSizeOfArray {
        roots[i] = (-aosArray[i].b+sqrt(aosArray[i].b*aosArray[i].b-4*(aosArray[i].a * aosArray[i].c))) / (2.0 * aosArray[i].a)
    }
}
elapsedTime = mach_absolute_time() - startTime
print("AoS test done in: \(Float(elapsedTime)/Float(NSEC_PER_MSEC)) (ms)")

startTime = mach_absolute_time()
for _ in 0..<kNumberOfRuns{
    for i in 0..<kSizeOfArray {
        roots[i] = (-soaArray.b[i] + sqrt( soaArray.b[i]*soaArray.b[i] - 4*soaArray.a[i]*soaArray.c[i]) / (2.0 * soaArray.a[i]))
    }
}
elapsedTime = mach_absolute_time() - startTime
print("SoA test done in: \(Float(elapsedTime)/Float(NSEC_PER_MSEC)) (ms)")


soaArray.a.deallocate()
soaArray.b.deallocate()
soaArray.c.deallocate()
