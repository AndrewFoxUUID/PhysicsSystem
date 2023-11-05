//
//  Value.swift
//  PhysicsSystem
//
//  Created by Andrew Fox on 12/3/22.
//

import Foundation

struct value : Equatable {
    let base: Decimal
    let power: Int
    let added_value: Decimal
    
    init(_ base: Decimal = 1.0, _ power: Int = 0, added_value: Decimal = 0.0) {
        var base: Decimal = base
        var power: Int = power
        
        while abs(base) >= 10.0 {
            base /= 10.0
            power += 1
        }
        while abs(base) < 1.0 && base != 0.0 {
            base *= 10.0
            power -= 1
        }
        
        self.base = base
        self.power = power
        self.added_value = added_value
    }
    
    init(_ str: String) {
        let comps = str.components(separatedBy: "E")
        let l: Decimal
        let r: Int
        if comps.count >= 1 {
            l = Decimal(string: comps[0]) ?? 1.0
        } else {
            l = 1.0
        }
        if comps.count >= 2 {
            r = Int(comps[1]) ?? 0
        } else {
            r = 0
        }
        self.init(l, r)
    }
    
    func toString() -> String {
        return String(describing: base) + "E" + String(power)
    }
    
    static func * (left: value, right: value) -> value {
        value((left.base + right.added_value) * right.base, left.power + right.power)
    }
    
    static func / (left: value, right: value) -> value {
        value((left.base - right.added_value) / right.base, left.power - right.power)
    }
    
    static func *= (left: inout value, right: value) {
        left = left * right
    }
    
    static func /= (left: inout value, right: value) {
        left = left / right
    }
    
    static func == (left: value, right: value) -> Bool {
        return left.base == right.base && left.power == right.power && left.added_value == right.added_value
    }
}

struct Value : Hashable {
    let variable: Variable.Type
    var numericValue: value
    var units: Unit
    
    init(_ variable: Variable.Type, _ numericValue: value, _ units: Unit) {
        self.variable = variable
        self.numericValue = numericValue * units.si_base_factor
        self.units = units
    }
    
    mutating func update(_ numericValue: value, _ units: Unit) {
        self.numericValue = numericValue * (units.si_base_factor / self.units.si_base_factor)
        self.units = units
    }
    
    func copy() -> Value {
        return Value(variable, numericValue, units)
    }
    
    static func == (lhs: Value, rhs: Value) -> Bool {
        return lhs.variable == rhs.variable && lhs.numericValue == rhs.numericValue && lhs.units == rhs.units
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(variable.symbol)
        hasher.combine(numericValue.base * pow(10, numericValue.power))
    }
}
