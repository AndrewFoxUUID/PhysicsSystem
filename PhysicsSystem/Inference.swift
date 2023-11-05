//
//  Inference.swift
//  PhysicsSystem
//
//  Created by Andrew Fox on 11/26/22.
//

import Foundation

var uuid_iterator: Int = -1
func uuid() -> String {
    uuid_iterator += 1
    return String(uuid_iterator)
}

typealias FactName = String
typealias FactID = String
typealias RuleID = String

struct Fact {
    let name: FactName
    let args: [AnyHashable]
    let backchaining: Bool
}

struct Match: Hashable {
    let store: Bool
    let value: AnyHashable
    let condition: (AnyHashable) -> Bool
    
    static func == (left: Match, right: Match) -> Bool {
        return (left.value == right.value)
    }
    
    init(_ store: Bool = false, _ value: AnyHashable, _ condition: @escaping (AnyHashable) -> Bool = {(_) in return true}) {
        self.store = store
        self.value = value
        self.condition = condition
    }
    
    func test(value: AnyHashable) -> Bool {
        return (self.value == value) && self.condition(value)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(store)
        hasher.combine(value)
    }
}

enum MatchType {
    case NULL, STORE, NOT, EXISTS
}

struct Pattern: Hashable {
    let matchtype: MatchType
    let name: FactName
    let matches: [Match]
    
    var seen_facts: [FactID]
    var possibly_seen: [FactID]
    
    init(_ matchtype: MatchType = MatchType.NULL, _ name: FactName = "", _ matches: [Match] = []) {
        self.matchtype = matchtype
        self.name = name
        self.matches = matches
        
        self.seen_facts = []
        self.possibly_seen = []
    }
    
    static func == (left: Pattern, right: Pattern) -> Bool {
        return (left.matchtype == right.matchtype) && (left.name == right.name) && (left.matches == right.matches)
    }
    
    mutating func condense_seen() {
        seen_facts += possibly_seen
        possibly_seen = []
    }
    
    func test(_ fact: Fact) -> Bool {
        if name == fact.name {
            if matches.count == fact.args.count {
                for i in 0...matches.count {
                    if !matches[i].test(value: fact.args[i]) {
                        return false
                    }
                }
                return true
            }
        }
        return false
    }
    
    func execute(_ fact: FactID) -> [Any] {
        var result: [Any] = [fact]
        for (i, match) in matches.enumerated() {
            if match.store {
                result.append(Engine.factspace[fact]!.args[i])
            }
        }
        return result
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(matchtype)
        hasher.combine(name)
        hasher.combine(matches)
    }
}

class Rule {
    let name: String
    let lhs: [Pattern]
    let rhs: ([Any]) -> Void
    let assertions: [FactName]
    let salience: Int
    
    init(_ name: String, _ lhs: [Pattern], _ rhs: @escaping ([Any]) -> Void, _ assertions: [FactName], salience: Int) {
        self.name = name
        self.lhs = lhs
        self.rhs = rhs
        self.assertions = assertions
        self.salience = salience
    }
    
    func execute(args: [Any]) {
        for var pattern in lhs {
            pattern.condense_seen()
        }
        self.rhs(args)
    }
}

class Node {
    let pattern: Pattern
    var rules: Set<RuleID>
    var facts: Set<FactID>
    var sources: Set<RuleID>
    
    var assertions: Set<FactID>
    var retractions: Set<FactID>
    var satisfactions: Set<FactID>
    
    init(_ pattern: Pattern, _ rules: Set<RuleID> = [], _ facts: Set<FactID> = [], _ sources: Set<RuleID> = []) {
        self.pattern = pattern
        self.rules = rules
        self.facts = facts
        self.sources = sources
        
        self.assertions = []
        self.retractions = []
        self.satisfactions = []
    }
    
    func assert(fact: FactID) {
        assertions.insert(fact)
    }
    
    func source(rule: RuleID) {
        sources.insert(rule)
    }
    
    func collapse() {
        facts.formUnion(assertions)
        facts.subtract(retractions)
    }
    
    func satisfied() -> Bool {
        if pattern.matchtype == MatchType.NULL || pattern.matchtype == MatchType.NOT {
            return true
        }
        
        if !assertions.isEmpty {
            for fact_id in assertions {
                if pattern.test(Engine.factspace[fact_id]!) {
                    satisfactions.insert(fact_id)
                }
            }
        }
        if !retractions.isEmpty {
            for fact_id in retractions {
                satisfactions.remove(fact_id)
            }
        }
        
        return !satisfactions.isEmpty
    }
}

struct Engine {
    static var factspace: [FactID: Fact] = [:]
    static var rulespace: [RuleID: Rule] = [:]
    static var network: [Pattern: Node] = [:]
    static var agenda: [RuleID: [Any]] = [:]
    
    static func assert(_ name: FactName, _ args: AnyHashable... , backchaining: Bool = true) {
        let fact: Fact = Fact(name: name, args: args, backchaining: backchaining)
        let pos: FactID = uuid()
        factspace[pos] = fact
        for (pattern, node) in network {
            if pattern.name == name {
                node.assert(fact: pos)
            }
        }
    }
    
    static func retract(_ name: FactName, _ args: AnyHashable...) {
        var matches: [Match] = []
        for arg in args {
            matches.append(Match(true, arg))
        }
        let pattern: Pattern = Pattern(.STORE, name, matches)
        var remove: [FactID] = []
        
        for factid: FactID in factspace.keys {
            if pattern.test(factspace[factid]!) {
                remove.append(factid)
            }
        }
        
        // for i in remove: pop, retract
    }
    
    static func defrule(name: String, patterns: [Pattern], action: @escaping ([Any]) -> Void, assertions: [FactName] = [], salience: Int = 0) {
        let pos: RuleID = uuid()
        
        let lhs: [Pattern]
        if patterns.isEmpty {
            lhs = [Pattern()]
        } else {
            lhs = patterns
        }
        
        for pattern in lhs {
            var found: Bool = false
            for (node_pattern, node) in network {
                if pattern == node_pattern {
                    node.rules.insert(pos)
                    found = true
                }
                if assertions.contains(node_pattern.name) {
                    node.source(rule: pos)
                }
            }
            
            if !found {
                let node: Node = Node(pattern, [pos])
                for (fact_id, fact) in factspace {
                    if pattern.name == fact.name {
                        node.assert(fact: fact_id)
                    }
                }
                for (rule_id, rule) in rulespace {
                    if rule.assertions.contains(pattern.name) {
                        node.source(rule: rule_id)
                    }
                }
                network[pattern] = node
            }
        }
        
        rulespace[pos] = Rule(name, lhs, action, assertions, salience: salience)
    }
    
    static func buildAgenda() {
        agenda = [:]
        
        var potential_forward: Set<RuleID> = Set(rulespace.keys)
        var potential_backward: Set<RuleID> = []
        for (_, node) in network {
            if !node.satisfied() {
                potential_backward.formUnion(node.sources)
                potential_forward.subtract(node.rules)
            }
        }
        
        let potentials: Set<RuleID> = potential_forward.union(potential_backward)
        for rule_id in potentials {
            var satisfied: Bool = true
            var args: [Any] = []
            
            for var pattern in rulespace[rule_id]!.lhs {
                switch pattern.matchtype {
                case MatchType.NULL:
                    if !pattern.seen_facts.isEmpty {
                        satisfied = false
                    } else {
                        pattern.seen_facts.append("")
                    }
                case MatchType.NOT:
                    for fact_id in network[pattern]!.assertions {
                        if pattern.test(factspace[fact_id]!) {
                            satisfied = false
                            break
                        }
                    }
                    if satisfied {
                        pattern.seen_facts.append("")
                    }
                case MatchType.EXISTS:
                    satisfied = false
                    for fact_id in network[pattern]!.assertions {
                        if pattern.test(factspace[fact_id]!) {
                            satisfied = true
                            break
                        }
                    }
                    if satisfied {
                        pattern.seen_facts.append("")
                    }
                default:
                    satisfied = false
                    let facts: Set<FactID> = network[pattern]!.facts.union(network[pattern]!.assertions)
                    for fact_id in facts.subtracting(pattern.seen_facts) {
                        if pattern.test(factspace[fact_id]!) {
                            args.append(contentsOf: pattern.execute(fact_id))
                            pattern.seen_facts.append(fact_id)
                            satisfied = true
                            break
                        }
                    }
                }
                if !satisfied {
                    break
                }
            }
            
            if satisfied {
                agenda[rule_id] = args
            }
        }
        
        for (_, node) in network {
            node.collapse()
        }
    }
    
    static func run() {
        buildAgenda()
        while !agenda.isEmpty {
            let rules: [RuleID] = agenda.keys.sorted(by: {rulespace[$0]!.salience > rulespace[$1]!.salience})
            rulespace[rules[0]]!.execute(args: agenda[rules[0]]!)
            buildAgenda()
        }
    }
}
