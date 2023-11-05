//
//  ContentView.swift
//  PhysicsSystem
//
//  Created by Andrew Fox on 11/26/22.
//

import SwiftUI
import Charts

enum tools: String, CaseIterable {
    case unselected
    case particles
    case knowledge_base
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            ToolsView()
            Text("Select a tool to begin.")
            DetailsView()
        }
    }
}

struct ToolsView: View {
    let toolSymbols: [tools: String] = [
        .particles: "dot.radiowaves.left.and.right"
    ]
    
    @State var unit_system: UnitSystem = .mks
    
    var body: some View {
        List {
            Picker("Units", selection: $unit_system) {
                ForEach(UnitSystem.allCases, id: \.self) { system in
                    Label(unitSystemNames[system] ?? "", systemImage: unitSystemIcons[system] ?? "").tag(system.rawValue)
                }
            }.pickerStyle(DefaultPickerStyle()).labelStyle(TitleAndIconLabelStyle())
                .onChange(of: unit_system) { newVal in
                    UserDefaults.standard.set(newVal.rawValue, forKey: "unit_system")
                }
            Spacer()
            ForEach(Array(toolSymbols.keys), id: \.self) { t in
                NavigationLink {
                    ConfigurationView(tool: t)
                } label: {
                    Label(t.rawValue.capitalized, systemImage: toolSymbols[t] ?? "")
                }

            }
            Divider()
            NavigationLink {
                KnowledgeConfigurationView()
            } label: {
                Label("Knowledge Base", systemImage: "text.book.closed")
            }
        }.listStyle(SidebarListStyle())
    }
}

struct ConfigurationView: View {
    var tool: tools
    
    @State var particle: Int = 0
    @State var wavelength: Value = Value(Wavelength.self, value(0), Unit("m"))
    @State var frequency: Value = Value(Frequency.self, value(0), Unit("Hz"))
    @State var velocity: Value = Value(Velocity.self, value(0), Unit("m/s"))
    @State var energy: Value = Value(Energy.self, value(0), Unit("J"))
    
    var body: some View {
        List {
            switch (tool) {
            case .particles:
                Picker("Type", selection: $particle) {
                    ForEach(0..<particles.count, id: \.self) { i in
                        Label(String(describing: particles[i]).components(separatedBy: "(")[0], systemImage: particles[i].symbol).tag(i)
                    }
                }.pickerStyle(DefaultPickerStyle()).labelStyle(TitleAndIconLabelStyle())
                Spacer()
                ValueField(wavelength)
                ValueField(frequency)
                ValueField(velocity)
                ValueField(energy)
            default:
                Text("Select a tool to begin.")
            }
        }
    }
}

struct KnowledgeConfigurationView: View {
    var sections: [String: String] = [
        "Newtonian Mechanics": "scalemass"
    ]
    var body: some View {
        List{
            Label("Search", systemImage: "magnifyingglass")
            Spacer()
            ForEach(Array(sections.keys), id: \.self) { section in
                NavigationLink {
                    KnowledgeView(section: section)
                } label: {
                    Label(section, systemImage: sections[section] ?? "")
                }
            }
        }
    }
}

struct DetailsView: View {
    var body: some View {
        /*if #available(macOS 13.0, *) {
            // if tool == particles
            Chart([Photon()], id: \.self) { c in
                /*PointMark(
                    x: .value("", 10),
                    y: .value("", 0)
                )*/
            }
        } else {
        }*/
        Spacer() // temporary
    }
}

struct KnowledgeView: View {
    var section: String
    var body: some View {
        Text("* Knowledge *")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
