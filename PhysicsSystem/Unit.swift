//
//  Unit.swift
//  PhysicsSystem
//
//  Created by Andrew Fox on 12/3/22.
//

import Foundation

enum UnitSystem: Int, CaseIterable {
    case mks, cgs, imp
}

let unitSystemNames: [UnitSystem: String] = [
    .mks: "SI (meters, kilometers, seconds)",
    .cgs: "Old Metric (centimeters, grams, seconds)",
    .imp: "Imperial (American)"
]

let unitSystemIcons: [UnitSystem: String] = [
    .mks: "m.square",
    .cgs: "c.square",
    .imp: "i.square"
]

protocol Prefix {
    static var power: Int { get }
    static var name: String { get }
    static var symbol: String { get }
}

struct quetta: Prefix {
    static let power = 30
    static let name = "quetta"
    static let symbol = "Q"
}

struct ronna: Prefix {
    static let power = 27
    static let name = "ronna"
    static let symbol = "R"
}

struct yotta: Prefix {
    static let power = 24
    static let name = "yotta"
    static let symbol = "Y"
}

struct zetta: Prefix {
    static let power = 21
    static let name = "zetta"
    static let symbol = "Z"
}

struct exa: Prefix {
    static let power = 18
    static let name = "exa"
    static let symbol = "E"
}

struct peta: Prefix {
    static let power = 15
    static let name = "peta"
    static let symbol = "P"
}

struct tera: Prefix {
    static let power = 12
    static let name = "tera"
    static let symbol = "T"
}

struct giga: Prefix {
    static let power = 9
    static let name = "giga"
    static let symbol = "G"
}

struct mega: Prefix {
    static let power = 6
    static let name = "mega"
    static let symbol = "M"
}

struct kilo: Prefix {
    static let power = 3
    static let name = "kilo"
    static let symbol = "k"
}

struct hecto: Prefix {
    static let power = 2
    static let name = "hecto"
    static let symbol = "h"
}

struct deca: Prefix {
    static let power = 1
    static let name = "deca"
    static let symbol = "da"
}

struct base: Prefix {
    static let power = 0
    static let name = ""
    static let symbol = ""
}

struct deci: Prefix {
    static let power = -1
    static let name = "deci"
    static let symbol = "d"
}

struct centi: Prefix {
    static let power = -2
    static let name = "centi"
    static let symbol = "c"
}

struct milli: Prefix {
    static let power = -3
    static let name = "milli"
    static let symbol = "m"
}

struct micro: Prefix {
    static let power = -6
    static let name = "micro"
    static let symbol = "μ"
}

struct nano: Prefix {
    static let power = -9
    static let name = "nano"
    static let symbol = "n"
}

struct pico: Prefix {
    static let power = -12
    static let name = "pico"
    static let symbol = "p"
}

struct femto: Prefix {
    static let power = -15
    static let name = "femto"
    static let symbol = "f"
}

struct atto: Prefix {
    static let power = -18
    static let name = "atto"
    static let symbol = "a"
}

struct zepto: Prefix {
    static let power = -21
    static let name = "zepto"
    static let symbol = "z"
}

struct yocto: Prefix {
    static let power = -24
    static let name = "yocto"
    static let symbol = "y"
}

struct ronto: Prefix {
    static let power = -27
    static let name = "ronto"
    static let symbol = "r"
}

struct quecto: Prefix {
    static let power = -30
    static let name = "quecto"
    static let symbol = "q"
}

let prefixesByPower: [Int: Prefix.Type] = [
    30: quetta.self,
    27: ronna.self,
    24: yotta.self,
    21: zetta.self,
    18: exa.self,
    15: peta.self,
    12: tera.self,
    9: giga.self,
    6: mega.self,
    3: kilo.self,
    2: hecto.self,
    1: deca.self,
    0: base.self,
    -1: deci.self,
    -2: centi.self,
    -3: milli.self,
    -6: micro.self,
    -9: nano.self,
    -12: pico.self,
    -15: femto.self,
    -18: atto.self,
    -21: zepto.self,
    -24: yocto.self,
    -27: ronto.self,
    -30: quecto.self
]

protocol unit {
    var prefix: Prefix.Type { get set }
    var can_prefix: Bool { get }
    
    var base_singular: String { get }
    var base_plural: String { get }
    var base_symbol: String { get }
    
    var si_numerator: [unit] { get }
    var si_denominator: [unit] { get }
    var si_base_factor: value { get }
    
    init()
}

extension unit {
    init(_ prefix: Prefix.Type = base.self) {
        self.init()
        self.prefix = prefix
    }
    
    func singular() -> String {
        return self.prefix.name + self.base_singular
    }
    
    func plural() -> String {
        return self.prefix.name + self.base_plural
    }
    
    func symbol() -> String {
        return self.prefix.symbol + self.base_symbol
    }
    
    func mks_factor() -> value {
        return si_base_factor / value(1, prefix.power)
    }
}

protocol base_unit: unit {
    var permutations: [unit.Type] { get }
}

struct quantum: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "quantum"
    let base_plural = "quanta"
    let base_symbol = ""
    
    let si_numerator: [unit] = []
    let si_denominator: [unit] = []
    let si_base_factor: value = value()
    
    let permutations: [unit.Type] = []
}

struct angstrom: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "angstrom"
    let base_plural = "angstroms"
    let base_symbol = "Å"
    
    let si_numerator: [unit] = [meter()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(1, -10)
}

struct astronomical_unit: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "astronomical unit"
    let base_plural = "astronomical units"
    let base_symbol = "AU"
    
    let si_numerator: [unit] = [meter()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(1.496, 11)
}

struct light_year: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "light year"
    let base_plural = "light years"
    let base_symbol = "ly"
    
    let si_numerator: [unit] = [meter()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(9.461, 15)
}

struct parsec: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "parsec"
    let base_plural = "parsecs"
    let base_symbol = "pc"
    
    let si_numerator: [unit] = [meter()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(3.086, 16)
}

struct meter: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = true
    
    let base_singular = "meter"
    let base_plural = "meters"
    let base_symbol = "m"
    
    let si_numerator: [unit] = []
    let si_denominator: [unit] = []
    let si_base_factor: value = value()
    
    let permutations: [unit.Type] = [angstrom.self, astronomical_unit.self, light_year.self, parsec.self]
}

struct inch: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "inch"
    let base_plural = "inches"
    let base_symbol = "in"
    
    let si_numerator: [unit] = [meter()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(2.54, -2)
}

struct yard: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "yard"
    let base_plural = "yards"
    let base_symbol = "yd"
    
    let si_numerator: [unit] = [meter()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(9.144, -1)
}

struct mile: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "mile"
    let base_plural = "miles"
    let base_symbol = "mi"
    
    let si_numerator: [unit] = [meter()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(1.60934, 3)
}

struct foot: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "foot"
    let base_plural = "feet"
    let base_symbol = "ft"
    
    let si_numerator: [unit] = [meter()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(3.048, -1)
    
    let permutations: [unit.Type] = [inch.self, yard.self, mile.self]
}

struct radian: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = true
    
    let base_singular = "radian"
    let base_plural = "radians"
    let base_symbol = "rad"
    
    let si_numerator: [unit] = []
    let si_denominator: [unit] = []
    let si_base_factor: value = value()
    
    let permutations: [unit.Type] = []
}

struct arcsecond: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "arcsecond"
    let base_plural = "arcseconds"
    let base_symbol = "\""
    
    let si_numerator: [unit] = [radian()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(Decimal.pi / 180 / 60 / 60)
}

struct arcminute: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "arcminute"
    let base_plural = "arcminutes"
    let base_symbol = "'"
    
    let si_numerator: [unit] = [radian()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(Decimal.pi / 180 / 60)
}

struct degree: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "degree"
    let base_plural = "degrees"
    let base_symbol = "°"
    
    let si_numerator: [unit] = [radian()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(Decimal.pi / 180)
    
    let permutations: [unit.Type] = [arcsecond.self, arcminute.self]
}

struct liter: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = true
    
    let base_singular = "liter"
    let base_plural = "liters"
    let base_symbol = "l"
    
    let si_numerator: [unit] = [meter(), meter(), meter()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(1, -3)
    
    let permutations: [unit.Type] = []
}

struct fluid_ounce: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "fluid ounce"
    let base_plural = "fluid ounces"
    let base_symbol = "fl. oz"
    
    let si_numerator: [unit] = [meter(), meter(), meter()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(2.95735, -5)
}

struct cup: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "cup"
    let base_plural = "cups"
    let base_symbol = "C"
    
    let si_numerator: [unit] = [meter(), meter(), meter()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(2.36588, -4)
}

struct pint: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "pint"
    let base_plural = "pints"
    let base_symbol = "pt"
    
    let si_numerator: [unit] = [meter(), meter(), meter()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(4.73176, -4)
}

struct quart: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "quart"
    let base_plural = "quarts"
    let base_symbol = "qt"
    
    let si_numerator: [unit] = [meter(), meter(), meter()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(9.46353, -4)
}

struct gallon: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "gallon"
    let base_plural = "gallons"
    let base_symbol = "gal"
    
    let si_numerator: [unit] = [meter(), meter(), meter()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(3.78541, -3)
    
    let permutations: [unit.Type] = [fluid_ounce.self, cup.self, pint.self, quart.self]
}

struct tonne: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = true
    
    let base_singular = "tonne"
    let base_plural = "tonnes"
    let base_symbol = "t"
    
    let si_numerator: [unit] = [gram(kilo.self)]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(1, 3)
}

struct gram: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = true
    
    let base_singular = "gram"
    let base_plural = "grams"
    let base_symbol = "g"
    
    let si_numerator: [unit] = []
    let si_denominator: [unit] = []
    let si_base_factor: value = value(1, 3)
    
    let permutations: [unit.Type] = [tonne.self]
}

struct ounce: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "ounce"
    let base_plural = "ounces"
    let base_symbol = "oz"
    
    let si_numerator: [unit] = [gram(kilo.self)]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(2.83495, -2)
}

struct ton: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "ton"
    let base_plural = "tons"
    let base_symbol = "tn"
    
    let si_numerator: [unit] = [gram(kilo.self)]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(9.07185, 2)
}

struct pound: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "pound"
    let base_plural = "pounds"
    let base_symbol = "lb"
    
    let si_numerator: [unit] = [gram(prefix: kilo.self)]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(4.53592, -1)
    
    let permutations: [unit.Type] = [ounce.self, ton.self]
}

struct newton: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = true
    
    let base_singular = "newton"
    let base_plural = "newtons"
    let base_symbol = "N"
    
    let si_numerator: [unit] = [gram(prefix: kilo.self), meter()]
    let si_denominator: [unit] = [second(), second()]
    let si_base_factor: value = value()
    
    let permutations: [unit.Type] = []
}

struct dyne: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "dyne"
    let base_plural = "dynes"
    let base_symbol = "dyn"
    
    let si_numerator: [unit] = [gram(prefix: kilo.self), meter()]
    let si_denominator: [unit] = [second(), second()]
    let si_base_factor: value = value(1, -5)
    
    let permutations: [unit.Type] = []
}

struct forcepound: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "pound of force"
    let base_plural = "pounds of force"
    let base_symbol = "lbf"
    
    let si_numerator: [unit] = [gram(prefix: kilo.self), meter()]
    let si_denominator: [unit] = [second(), second()]
    let si_base_factor: value = value(4.44822)
    
    let permutations: [unit.Type] = []
}

struct minute: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "minute"
    let base_plural = "minutes"
    let base_symbol = "min"
    
    let si_numerator: [unit] = [second()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(6, 1)
}

struct hour: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "hour"
    let base_plural = "hours"
    let base_symbol = "hr"
    
    let si_numerator: [unit] = [second()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(3.6, 3)
}

struct day: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "day"
    let base_plural = "days"
    let base_symbol = "d"
    
    let si_numerator: [unit] = [second()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(8.64, 4)
}

struct week: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "week"
    let base_plural = "weeks"
    let base_symbol = "w"
    
    let si_numerator: [unit] = [second()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(6.048, 5)
}

struct month: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "month"
    let base_plural = "months"
    let base_symbol = "mo"
    
    let si_numerator: [unit] = [second()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(2.629728, 6)
}

struct year: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "year"
    let base_plural = "years"
    let base_symbol = "yr"
    
    let si_numerator: [unit] = [second()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(3.1556736, 7)
}

struct decade: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "decade"
    let base_plural = "decades"
    let base_symbol = "dec"
    
    let si_numerator: [unit] = [second()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(3.1556736, 8)
}

struct century: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "century"
    let base_plural = "centuries"
    let base_symbol = "cen"
    
    let si_numerator: [unit] = [second()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(3.1556736, 9)
}

struct millenium: unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "millenium"
    let base_plural = "millenia"
    let base_symbol = "mil"
    
    let si_numerator: [unit] = [second()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(3.1556736, 10)
}

struct second: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = true
    
    let base_singular = "second"
    let base_plural = "seconds"
    let base_symbol = "s"
    
    let si_numerator: [unit] = []
    let si_denominator: [unit] = []
    let si_base_factor: value = value()
    
    let permutations: [unit.Type] = [minute.self, hour.self, day.self, week.self, month.self, year.self, decade.self, century.self, millenium.self]
}

struct hertz: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = true
    
    let base_singular = "hertz"
    let base_plural = "hertz"
    let base_symbol = "Hz"
    
    let si_numerator: [unit] = []
    let si_denominator: [unit] = [second()]
    let si_base_factor: value = value()
    
    let permutations: [unit.Type] = []
}

struct galileo: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "galileo"
    let base_plural = "galileo"
    let base_symbol = "Gal"
    
    let si_numerator: [unit] = [meter()]
    let si_denominator: [unit] = [second(), second()]
    let si_base_factor: value = value(1, -2)
    
    let permutations: [unit.Type] = []
}

struct joule: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = true
    
    let base_singular = "joule"
    let base_plural = "joules"
    let base_symbol = "J"
    
    let si_numerator: [unit] = [gram(prefix: kilo.self), meter(), meter()]
    let si_denominator: [unit] = [second(), second()]
    let si_base_factor: value = value()
    
    let permutations: [unit.Type] = []
}

struct erg: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "erg"
    let base_plural = "ergs"
    let base_symbol = "erg"
    
    let si_numerator: [unit] = [gram(prefix: kilo.self), meter(), meter()]
    let si_denominator: [unit] = [second(), second()]
    let si_base_factor: value = value(1, -7)
    
    let permutations: [unit.Type] = []
}

struct britishthermalunit: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "british thermal unit"
    let base_plural = "british thermal units"
    let base_symbol = "BTU"
    
    let si_numerator: [unit] = [gram(prefix: kilo.self), meter(), meter()]
    let si_denominator: [unit] = [second(), second()]
    let si_base_factor: value = value(1.05506, 3)
    
    let permutations: [unit.Type] = []
}

struct watt: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = true
    
    let base_singular = "watt"
    let base_plural = "watts"
    let base_symbol = "W"
    
    let si_numerator: [unit] = [gram(prefix: kilo.self), meter(), meter()]
    let si_denominator: [unit] = [second(), second(), second()]
    let si_base_factor: value = value()
    
    let permutations: [unit.Type] = []
}

struct horsepower: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "horsepower"
    let base_plural = "horsepower"
    let base_symbol = "hp"
    
    let si_numerator: [unit] = [gram(prefix: kilo.self), meter(), meter()]
    let si_denominator: [unit] = [second(), second(), second()]
    let si_base_factor: value = value(7.457, 2)
    
    let permutations: [unit.Type] = []
}

struct kelvin: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "kelvin"
    let base_plural = "kelvin"
    let base_symbol = "K"
    
    let si_numerator: [unit] = []
    let si_denominator: [unit] = []
    let si_base_factor: value = value()
    
    let permutations: [unit.Type] = []
}

struct centigrade: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "degree celsius"
    let base_plural = "degrees celsius"
    let base_symbol = "°C"
    
    let si_numerator: [unit] = [kelvin()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(added_value: 273.15)
    
    let permutations: [unit.Type] = []
}

struct fahrenheit: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "degree fahrenheit"
    let base_plural = "degrees fahrenheit"
    let base_symbol = "°F"
    
    let si_numerator: [unit] = [centigrade()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(5/9, 0, added_value: -32)
    
    let permutations: [unit.Type] = []
}

struct volt: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = true
    
    let base_singular = "volt"
    let base_plural = "volts"
    let base_symbol = "V"
    
    let si_numerator: [unit] = [gram(prefix: kilo.self), meter(), meter()]
    let si_denominator: [unit] = [second(), second(), coulomb()]
    let si_base_factor: value = value()
    
    let permutations: [unit.Type] = []
}

struct abvolt: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "abvolt"
    let base_plural = "abvolts"
    let base_symbol = "abV"
    
    let si_numerator: [unit] = [gram(prefix: kilo.self), meter(), meter()]
    let si_denominator: [unit] = [second(), second(), coulomb()]
    let si_base_factor: value = value(1, -8)
    
    let permutations: [unit.Type] = []
}

struct coulomb: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = true
    
    let base_singular = "coulomb"
    let base_plural = "coulombs"
    let base_symbol = "C"
    
    let si_numerator: [unit] = []
    let si_denominator: [unit] = []
    let si_base_factor: value = value()
    
    let permutations: [unit.Type] = []
}

struct franklin: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "franklin"
    let base_plural = "franklin"
    let base_symbol = "Fr"
    
    let si_numerator: [unit] = [coulomb()]
    let si_denominator: [unit] = []
    let si_base_factor: value = value(3.3356, -10)
    
    let permutations: [unit.Type] = []
}

struct ampere: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = true
    
    let base_singular = "ampere"
    let base_plural = "amperes"
    let base_symbol = "A"
    
    let si_numerator: [unit] = [coulomb()]
    let si_denominator: [unit] = [second()]
    let si_base_factor: value = value()
    
    let permutations: [unit.Type] = []
}

struct biot: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = false
    
    let base_singular = "biot"
    let base_plural = "biot"
    let base_symbol = "Bi"
    
    let si_numerator: [unit] = [coulomb()]
    let si_denominator: [unit] = [second()]
    let si_base_factor: value = value(1, 1)
    
    let permutations: [unit.Type] = []
}

struct ohm: base_unit {
    var prefix: Prefix.Type = base.self
    let can_prefix: Bool = true
    
    let base_singular = "ohm"
    let base_plural = "ohms"
    let base_symbol = "Ω"
    
    let si_numerator: [unit] = [gram(prefix: kilo.self), meter(), meter()]
    let si_denominator: [unit] = [second(), coulomb(), coulomb()]
    let si_base_factor: value = value()
    
    let permutations: [unit.Type] = []
}

let baseUnits: [unit.Type] = [
    quantum.self,
    meter.self,
    foot.self,
    radian.self,
    degree.self,
    liter.self,
    gallon.self,
    gram.self,
    pound.self,
    newton.self,
    dyne.self,
    forcepound.self,
    second.self,
    hertz.self,
    galileo.self,
    joule.self,
    erg.self,
    britishthermalunit.self,
    watt.self,
    horsepower.self,
    kelvin.self,
    centigrade.self,
    fahrenheit.self,
    volt.self,
    abvolt.self,
    coulomb.self,
    franklin.self,
    ampere.self,
    biot.self,
    ohm.self
]

struct Unit : base_unit, Equatable {
    var stringForm: String = ""
    
    var prefix: Prefix.Type = base.self
    var can_prefix: Bool { get {
        for u in si_numerator + si_denominator {
            if u.can_prefix {
                return true
            }
        }
        return false
    }}
    
    var base_singular: String { get {
        return stringForm // temporary solution, doesn't account for order changes
    }}
    var base_plural: String { get {
        var str: String = ""
        for (i, u) in si_numerator.enumerated() {
            if i > 0 {
                str += "*"
            }
            str += u.plural()
        }
        for (i, u) in si_denominator.enumerated() {
            if i == 0 && str == "" {
                str = "1"
            }
            str += "/"
            str += u.singular()
        }
        return str
    }}
    var base_symbol: String { get {
        var str: String = ""
        for (i, u) in si_numerator.enumerated() {
            if i > 0 {
                str += "*"
            }
            str += u.symbol()
        }
        for (i, u) in si_denominator.enumerated() {
            if i == 0 && str == "" {
                str = "1"
            }
            str += "/"
            str += u.symbol()
        }
        return str
    }}
    
    var si_numerator: [unit]
    var si_denominator: [unit]
    var si_base_factor: value
    
    let permutations: [unit.Type]
    
    init(_ numerator: [unit], _ denominator: [unit], _ permutations: [unit.Type]) {
        self.si_numerator = []
        self.si_denominator = []
        self.si_base_factor = value()
        self.permutations = permutations
        
        var top = numerator
        var bottom = denominator
        while !top.isEmpty || !bottom.isEmpty {
            while !top.isEmpty {
                self.si_base_factor *= top[0].mks_factor()
                if top[0].si_numerator.isEmpty && top[0].si_denominator.isEmpty {
                    top[0].prefix = prefixesByPower[top[0].si_base_factor.power]!
                    self.si_numerator.append(top[0])
                } else {
                    top.append(contentsOf: top[0].si_numerator)
                    bottom.append(contentsOf: top[0].si_denominator)
                }
                top.remove(at: 0)
            }
            
            while !bottom.isEmpty {
                self.si_base_factor /= bottom[0].mks_factor()
                if bottom[0].si_numerator.isEmpty && bottom[0].si_denominator.isEmpty {
                    bottom[0].prefix = prefixesByPower[bottom[0].mks_factor().power]!
                    self.si_denominator.append(bottom[0])
                } else {
                    top.append(contentsOf: bottom[0].si_denominator)
                    bottom.append(contentsOf: bottom[0].si_numerator)
                }
                bottom.remove(at: 0)
            }
        }
        
        self.cancel()
        self.stringForm = self.symbol()
    }
    
    static func unifyList(_ list: [String]) -> [unit] {
        var unified: [unit] = []
        for item in list {
            for unitType in baseUnits {
                var appended: Bool = false
                var potentialUnit: unit = unitType.init()
                for p in (potentialUnit.can_prefix ? Array(prefixesByPower.values) : [base.self]) {
                    potentialUnit = unitType.init(p)
                    if item == potentialUnit.singular() || item == potentialUnit.plural() || item == potentialUnit.symbol() {
                        unified.append(potentialUnit)
                        appended = true
                        break
                    }
                }
                if appended {
                    break
                }
            }
        }
        return unified
    }
    
    init(_ stringRepresentation: String, _ permutations: [unit.Type] = []) {
        var top: [String] = []
        var bottom: [String] = []
        
        enum operation { case multiplication, division }
        var prevOperation: operation = .multiplication
        var seekingPower: Bool = false
        var curPower: String = ""
        var curUnit: String = ""
        for char in stringRepresentation + "*" {
            if char == "*" || char == "/" {
                if seekingPower {
                    for _ in 0..<abs(Int(curPower) ?? 0) {
                        if (prevOperation == .multiplication) == (Int(curPower) ?? 0 >= 0) {
                            top.append(curUnit)
                        } else {
                            bottom.append(curUnit)
                        }
                    }
                    
                    seekingPower = false
                    curPower = ""
                } else if !curUnit.isEmpty {
                    if prevOperation == .multiplication {
                        top.append(curUnit)
                    } else {
                        bottom.append(curUnit)
                    }
                }
                curUnit = ""
                prevOperation = char == "*" ? .multiplication : .division
            } else if char == "^" {
                seekingPower = true
            } else if seekingPower {
                curPower += String(char)
            } else {
                curUnit += String(char)
            }
        }
        
        self.init(Unit.unifyList(top), Unit.unifyList(bottom), permutations)
        self.stringForm = stringRepresentation
    }
    
    init() {
        self.init("")
    }
    
    mutating func cancel() {
        var remove: [Int] = []
        for (i, u) in si_numerator.enumerated() {
            if si_denominator.contains(where: {(v: unit) in return v.singular() == u.singular()}) {
                remove.append(i)
                si_denominator.remove(at: si_denominator.firstIndex(where: {(v: unit) in return v.singular() == u.singular()})!)
            }
        }
        for i in remove.reversed() {
            si_numerator.remove(at: i)
        }
    }
    
    static func == (lhs: Unit, rhs: Unit) -> Bool {
        if lhs.si_numerator.count == rhs.si_numerator.count {
            for i in 0..<lhs.si_numerator.count {
                if type(of: lhs.si_numerator[i]) != type(of: rhs.si_numerator[i]) || lhs.si_numerator[i].prefix != rhs.si_numerator[i].prefix {
                    return false
                }
            }
            if lhs.si_denominator.count == rhs.si_denominator.count {
                for i in 0..<lhs.si_denominator.count {
                    if type(of: lhs.si_denominator[i]) != type(of: rhs.si_denominator[i]) || lhs.si_denominator[i].prefix != rhs.si_denominator[i].prefix {
                        return false
                    }
                }
                return true
            }
        }
        return false
    }
}
