//
//  Variable.swift
//  PhysicsSystem
//
//  Created by Andrew Fox on 12/3/22.
//

import Foundation

protocol Variable {
    static var names: [String] { get }
    static var symbol: String { get }
    static var info: String { get }
    
    static var units: [UnitSystem: base_unit] { get }
}

struct QuantumNumber: Variable {
    static let names: [String] = ["number", "quantum number", "quanta", "quantum constant"]
    static let symbol: String = "n"
    static let info: String = "Represents the quantized energy level of a particle"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: quantum(),
        .cgs: quantum(),
        .imp: quantum()
    ]
}

struct Position: Variable {
    static let names: [String] = ["position"]
    static let symbol: String = "x"
    static let info: String = "Represents the distance from the origin to a point"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: meter(),
        .cgs: meter(prefix: centi.self),
        .imp: foot()
    ]
}

struct Length: Variable {
    static let names: [String] = ["length"]
    static let symbol: String = "l"
    static let info: String = "Represents the distance between two points"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: meter(),
        .cgs: meter(prefix: centi.self),
        .imp: foot()
    ]
}

struct Angle: Variable {
    static let names: [String] = ["angle"]
    static let symbol: String = "∠"
    static let info: String = "Represents the angular distance between two rays"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: radian(),
        .cgs: radian(),
        .imp: degree()
    ]
}

struct Radius: Variable {
    static let names: [String] = ["radius"]
    static let symbol: String = "r"
    static let info: String = "Represents the linear distance from the center of a circle to its perimeter"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: meter(),
        .cgs: meter(prefix: centi.self),
        .imp: foot()
    ]
}

struct Wavelength: Variable {
    static let names: [String] = ["wavelength", "lambda"]
    static let symbol: String = "λ"
    static let info: String = "Represents the linear distance between the two nearest crests of a wave"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: meter(),
        .cgs: meter(prefix: centi.self),
        .imp: foot()
    ]
}

struct Distance: Variable {
    static let names: [String] = ["distance"]
    static let symbol: String = "d"
    static let info: String = "Represents the scalar distance traveled between two points"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: meter(),
        .cgs: meter(prefix: centi.self),
        .imp: foot()
    ]
}

struct Displacement: Variable {
    static let names: [String] = ["displacement", "delta x"]
    static let symbol: String = "Δx"
    static let info: String = "Represents the vector distance traveled between two points"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: meter(),
        .cgs: meter(prefix: centi.self),
        .imp: foot()
    ]
}

struct Area: Variable {
    static let names: [String] = ["area"]
    static let symbol: String = "A"
    static let info: String = "Represents the magnitude of a two dimensional shape"
    
    static let units: [UnitSystem: base_unit] = [:]
}

struct Volume: Variable {
    static let names: [String] = ["volume"]
    static let symbol: String = "V"
    static let info: String = "Represents the magnitude of a three dimensional shape"
    
    static let units: [UnitSystem: base_unit] = [
        .cgs: liter(),
        .imp: gallon()
    ]
}

struct Mass: Variable {
    static let names: [String] = ["mass"]
    static let symbol: String = "m"
    static let info: String = "Represents the magnitude of the property of matter that defines an objects weight in a gravitational field"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: gram(prefix: kilo.self),
        .cgs: gram(),
        .imp: pound()
    ]
}

struct Weight: Variable {
    static let names: [String] = ["weight"]
    static let symbol: String = "W"
    static let info: String = "Represents the magnitude of the force exerted on an object by a gravitational field"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: newton(),
        .cgs: dyne(),
        .imp: forcepound()
    ]
}

struct Density: Variable {
    static let names: [String] = ["density", "rho"]
    static let symbol: String = "ρ"
    static let info: String = "Represents the ratio of the amount of mass an object has and the magnitude of its three dimensional shape"
    
    static let units: [UnitSystem: base_unit] = [:]
}

struct Time: Variable {
    static let names: [String] = ["time"]
    static let symbol: String = "t"
    static let info: String = "Represents the time between a point and the time origin"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: second(),
        .cgs: second(),
        .imp: second()
    ]
}

struct DeltaTime: Variable {
    static let names: [String] = ["delta time", "delta t"]
    static let symbol: String = "Δt"
    static let info: String = "Represents the time between two points"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: second(),
        .cgs: second(),
        .imp: second()
    ]
}

struct Frequency: Variable {
    static let names: [String] = ["frequency", "nu"]
    static let symbol: String = "ν"
    static let info: String = "Represents the number of wave crests reaching a point in a given amount of time"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: hertz(),
        .cgs: hertz(),
        .imp: hertz()
    ]
}

struct Speed: Variable {
    static let names: [String] = ["speed"]
    static let symbol: String = "S"
    static let info: String = "Represents the scalar amount of distance covered in a given amount of time"
    
    static let units: [UnitSystem: base_unit] = [:]
}

struct Velocity: Variable {
    static let names: [String] = ["velocity"]
    static let symbol: String = "v"
    static let info: String = "Represents the vector amount of distance covered in a given amount of time"
    
    static let units: [UnitSystem: base_unit] = [:]
}

struct Momentum: Variable {
    static let names: [String] = ["momentum"]
    static let symbol: String = "p"
    static let info: String = "Represents the quantity of an object's motion"
    
    static let units: [UnitSystem: base_unit] = [:]
}

struct AngularVelocity: Variable {
    static let names: [String] = ["angular velocity", "little omega"]
    static let symbol: String = "ω"
    static let info: String = "Represents the vector amount of angle covered in a given amount of time"
    
    static let units: [UnitSystem: base_unit] = [:]
}

struct AngularMomentum: Variable {
    static let names: [String] = ["angular momentum"]
    static let symbol: String = "L"
    static let info: String = "Represents the quantity of the angle of an object's motion"
    
    static let units: [UnitSystem: base_unit] = [:]
}

struct Acceleration: Variable {
    static let names: [String] = ["acceleration"]
    static let symbol: String = "a"
    static let info: String = "Represents the change in velocity in a given amount of time"
    
    static let units: [UnitSystem: base_unit] = [
        .cgs: galileo()
    ]
}

struct Force: Variable {
    static let names: [String] = ["force"]
    static let symbol: String = "F"
    static let info: String = "Represents the requirement for a given mass to receive a given acceleration"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: newton(),
        .cgs: dyne(),
        .imp: forcepound()
    ]
}

struct Impulse: Variable {
    static let names: [String] = ["impulse"]
    static let symbol: String = "J"
    static let info: String = "Represents the change in force over a given amount of time"
    
    static let units: [UnitSystem: base_unit] = [:]
}

struct Energy: Variable {
    static let names: [String] = ["energy"]
    static let symbol: String = "E"
    static let info: String = "Represents the amount of force a given point can generate"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: joule(),
        .cgs: erg(),
        .imp: britishthermalunit()
    ]
}

struct Work: Variable {
    static let names: [String] = ["work", "moment", "moment of force"]
    static let symbol: String = "W"
    static let info: String = "Represents the amount of force generated by a given point"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: joule(),
        .cgs: erg(),
        .imp: britishthermalunit()
    ]
}

struct Torque: Variable {
    static let names: [String] = ["torque", "angular energy", "angular work", "angular moment", "tau"]
    static let symbol: String = "τ"
    static let info: String = "Represents the angular force a given point can generate"
    
    static let units: [UnitSystem: base_unit] = [:]
}

struct Power: Variable {
    static let names: [String] = ["power", "luminocity"]
    static let symbol: String = "P"
    static let info: String = "Represents the energy a given point can generate over time"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: watt(),
        .imp: horsepower()
    ]
}

struct Temperature: Variable {
    static let names: [String] = ["temperature"]
    static let symbol: String = "T"
    static let info: String = "Represents the amount of heat at a given point"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: kelvin(),
        .cgs: centigrade(),
        .imp: fahrenheit()
    ]
}

struct Flux: Variable {
    static let names: [String] = ["flux", "brightness", "apparent brightness", "phi"]
    static let symbol: String = "Φ"
    static let info: String = "Represents the amount of energy generated by a point per over time"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: watt(),
        .imp: horsepower()
    ]
}

struct Voltage: Variable {
    static let names: [String] = ["voltage"]
    static let symbol: String = "V"
    static let info: String = "Represents the amount of electric potential energy over each unit charge"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: volt(),
        .cgs: abvolt()
    ]
}

struct Charge: Variable {
    static let names: [String] = ["charge", "electric charge"]
    static let symbol: String = "q"
    static let info: String = "Represents the property of matter that allows it to interact with an electromagnetic field"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: coulomb(),
        .cgs: franklin()
    ]
}

struct Current: Variable {
    static let names: [String] = ["current"]
    static let symbol: String = "I"
    static let info: String = "Represents the amount of charge moving across a point in a given time"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: ampere(),
        .cgs: biot()
    ]
}

struct Resistance: Variable {
    static let names: [String] = ["resistance"]
    static let symbol: String = "R"
    static let info: String = "Represents the amount of charge a point does not allow to move across it"
    
    static let units: [UnitSystem: base_unit] = [
        .mks: ohm(),
        .cgs: ohm(prefix: giga.self)
    ]
}
