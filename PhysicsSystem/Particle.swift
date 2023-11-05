//
//  Particle.swift
//  PhysicsSystem
//
//  Created by Andrew Fox on 12/5/22.
//

import Foundation

protocol Particle {
    var antimatter: Bool { get set }
    
    var charge: Decimal { get }
    var spin: Decimal { get }
    
    var symbol: String { get }
    
    init(_ antimatter: Bool)
}

protocol Fermion : Particle {
    
}

struct Quark : Fermion {
    enum types { case up, down, charm, strange, top, bottom }
    var type: types?
    var antimatter: Bool
    
    var charge: Decimal { get {
        if type == .up || type == .charm || type == .top {
            return +2/3 * (antimatter ? -1 : 1)
        } else if type == .down || type == .strange || type == .bottom {
            return -1/3 * (antimatter ? -1 : 1)
        } else {
            return 0
        }
    }}
    var spin: Decimal = 1/2
    
    var symbol: String { get {
        return [
            types.up: "arrow.up.circle.fill",
            types.down: "arrow.down.circle.fill",
            types.charm: "asterisk.circle.fill",
            types.strange: "dollarsign.circle.fill",
            types.top: "wake.circle.fill",
            types.bottom: "sleep.circle.fill"
        ][type] ?? "circle.hexagonpath.fill"
    }}
    
    init(_ antimatter: Bool = false) {
        self.antimatter = antimatter
        self.type = nil
    }
    
    init(_ antimatter: Bool = false, _ type: types? = nil) {
        self.init(antimatter)
        self.type = type
    }
}

protocol Lepton : Fermion {
    var neutrino: Bool { get }
}

struct Electron : Lepton {
    var antimatter: Bool
    var neutrino: Bool
    
    var charge: Decimal { get {
        return neutrino ? 0 : (antimatter ? -1 : 1)
    }}
    var spin: Decimal = 1/2
    
    var symbol: String {
        return neutrino ? "minus.magnifyingglass" : "minus.circle"
    }
    
    init(_ antimatter: Bool = false) {
        self.antimatter = antimatter
        self.neutrino = false
    }
    
    init(_ antimatter: Bool = false, _ neutrino: Bool = false) {
        self.init(antimatter)
        self.neutrino = neutrino
    }
}

struct Muon : Lepton {
    var antimatter: Bool
    var neutrino: Bool
    
    var charge: Decimal { get {
        return neutrino ? 0 : (antimatter ? -1 : 1)
    }}
    var spin: Decimal = 1/2
    
    var symbol: String {
        return neutrino ? "arrow.up.left.and.down.right.magnifyingglass" : "arrow.up.left.and.arrow.down.right.circle"
    }
    
    init(_ antimatter: Bool = false) {
        self.antimatter = antimatter
        self.neutrino = false
    }
    
    init(_ antimatter: Bool = false, _ neutrino: Bool = false) {
        self.init(antimatter)
        self.neutrino = neutrino
    }
}

struct Tau : Lepton {
    var antimatter: Bool
    var neutrino: Bool
    
    var charge: Decimal { get {
        return neutrino ? 0 : (antimatter ? -1 : 1)
    }}
    var spin: Decimal = 1/2
    
    var symbol: String {
        return neutrino ? "location.magnifyingglass" : "location.circle"
    }
    
    init(_ antimatter: Bool = false) {
        self.antimatter = antimatter
        self.neutrino = false
    }
    
    init(_ antimatter: Bool = false, _ neutrino: Bool = false) {
        self.init(antimatter)
        self.neutrino = neutrino
    }
}

protocol Boson : Particle {
    
}

struct Gluon : Boson {
    var antimatter: Bool
    
    var charge: Decimal = 0
    var spin: Decimal = 1
    
    var symbol: String = "link.circle"
    
    init(_ antimatter: Bool = false) {
        self.antimatter = antimatter
    }
}

struct Photon : Boson, Hashable {
    var antimatter: Bool
    
    var charge: Decimal = 0
    var spin: Decimal = 1
    
    var symbol: String = "lightbulb.circle"
    
    init(_ antimatter: Bool = false) {
        self.antimatter = antimatter
    }
}

struct Z0 : Boson {
    var antimatter: Bool
    
    var charge: Decimal = 0
    var spin: Decimal = 1
    
    var symbol: String = "z.circle"
    
    init(_ antimatter: Bool = false) {
        self.antimatter = antimatter
    }
}

struct Wplus : Boson {
    var antimatter: Bool
    
    var charge: Decimal = +1
    var spin: Decimal = 1
    
    var symbol: String = "w.circle.fill"
    
    init(_ antimatter: Bool = false) {
        self.antimatter = antimatter
    }
}

struct Wminus : Boson {
    var antimatter: Bool
    
    var charge: Decimal = -1
    var spin: Decimal = 1
    
    var symbol: String = "w.circle"
    
    init(_ antimatter: Bool = false) {
        self.antimatter = antimatter
    }
}

struct Higgs : Boson {
    var antimatter: Bool
    
    var charge: Decimal = 0
    var spin: Decimal = 0
    
    var symbol: String = "circle.dashed"
    
    init(_ antimatter: Bool = false) {
        self.antimatter = antimatter
    }
}

protocol Hadron : Particle {
    var composition: [Particle] { get }
}

extension Hadron {
    var charge: Decimal {
        var c: Decimal = 0
        for particle in composition {
            c += particle.charge
        }
        return c
    }
    var spin: Decimal {
        var s: Decimal = 0
        for particle in composition {
            s += particle.spin
        }
        return s
    }
}

protocol Meson : Hadron { // even
    
}

protocol Baryon : Hadron { // false
    var composition: [Particle] { get }
}

struct Proton : Baryon {
    var antimatter: Bool
    
    var composition: [Particle] {
        return [
            Quark(antimatter, .up),
            Quark(antimatter, .up),
            Quark(antimatter, .down)
        ]
    }
    
    var symbol: String = "plus.circle.fill"
    
    init(_ antimatter: Bool = false) {
        self.antimatter = antimatter
    }
}

struct Neutron : Baryon {
    var antimatter: Bool
    
    var composition: [Particle] {
        return [
            Quark(antimatter, .up),
            Quark(antimatter, .down),
            Quark(antimatter, .down)
        ]
    }
    
    var symbol: String = "plusminus.circle.fill"
    
    init(_ antimatter: Bool = false) {
        self.antimatter = antimatter
    }
}

let particles: [Particle] = [
    Quark(),
    Electron(),
    Muon(),
    Tau(),
    Gluon(),
    Photon(),
    Z0(),
    Wplus(),
    Wminus(),
    Higgs(),
    Proton(),
    Neutron()
]
