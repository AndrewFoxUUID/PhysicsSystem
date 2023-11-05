//
//  UItools.swift
//  PhysicsSystem
//
//  Created by Andrew Fox on 12/11/22.
//

import SwiftUI

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        return overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
    
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        ).onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

struct NumberPicker: View {
    @State var val: Int = 0
    var step: Int = 1
    var range: (begin: Int, end: Int) = (0, 9)
    
    @State var offset: Double = 0.0
    
    var body: some View {
        let fullRange: [Int?] = [nil, nil] + Array(stride(from: range.begin, through: range.end, by: step)) + [nil, nil]
        let getColor: (Int) -> Double = { i in return abs((Double(i) - 2.0 - offset)/4.0 * 0.95) }
        let getYscale: (Int) -> Double = { i in return 1.0 - abs((Double(i) - 2.0 - offset)/5.0) }
        
        ScrollViewReader { scroller in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ForEach(fullRange.indices, id: \.self) { i in
                        Text(fullRange[i] == nil ? " " : String(fullRange[i]!))
                            .foregroundColor(Color(red: getColor(i), green: getColor(i), blue: getColor(i)))
                            .transformEffect(CGAffineTransform(scaleX: 1, y: getYscale(i)))
                            .id(i)
                    }
                }.background(GeometryReader { proxy -> Color in
                    DispatchQueue.main.async { offset = Double(-proxy.frame(in: .named("scroll")).origin.y / 19.0) }
                    return Color.clear
                })
            }.coordinateSpace(name: "scroll")
        }.frame(height: 19*5)
        .overlay {
            Rectangle()
                .fill(Color.clear)
                .frame(width: 16, height: 19, alignment: .center)
                .border(width: 1, edges: [.top, .bottom], color: .black)
        }
        .multilineTextAlignment(.center)
    }
}

struct TruncatingText: View {
    let full_text: String
    let short_text: String
    
    @State private var full_size: CGSize = .zero
    @State private var cur_size: CGSize = .zero
    var truncated: Bool { return full_size != cur_size }
    
    var body: some View {
        if !truncated {
            Text(full_text)
                .lineLimit(1)
                .readSize { size in
                    full_size = size
                }
                .background(
                    Text(full_text)
                        .fixedSize(horizontal: false, vertical: true)
                        .hidden()
                        .readSize { size in
                            cur_size = size
                        }
                )
        } else {
            Text(short_text)
        }
    }
}

struct InfoBubble: View {
    let caption: String
    
    var body: some View {
        Image(systemName: "info.circle")
            .foregroundColor(Color(NSColor.controlAccentColor))
            .help(Text(caption))
    }
}

struct NumericField: View {
    @State var val: Binding<String>
    @State var prevVal: String
    
    let decimal: Bool
    let positive: Bool
    
    let font_size: CGFloat
    let frame_width: CGFloat
    let frame_height: CGFloat
    
    @FocusState var focused: Bool
    
    var body: some View {
        TextField("", text: val)
            .textFieldStyle(PlainTextFieldStyle())
            .autocorrectionDisabled(true)
            .font(Font.system(size: font_size))
            .frame(width: frame_width, height: frame_height, alignment: .center)
            .multilineTextAlignment(.center)
            .overlay {
                RoundedRectangle(cornerRadius: frame_width / 5)
                    .stroke(focused ? Color(NSColor.controlAccentColor) : Color(NSColor.placeholderTextColor))
            }
            .focused($focused)
            .onChange(of: val.wrappedValue, perform: { newVal in
                if newVal.rangeOfCharacter(from: CharacterSet(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "-", ".", "c", "π", "p"]).inverted) != nil {
                    val.wrappedValue = prevVal.replacingOccurrences(of: "p", with: "π")
                }
                prevVal = val.wrappedValue
            })
    }
    
    init(_ val: Binding<String>, decimal: Bool = false, positive: Bool = false, font_size: CGFloat = 16, frame_width: CGFloat = 60, frame_height: CGFloat = 30) {
        self.val = val
        self.prevVal = val.wrappedValue
        
        self.decimal = decimal
        self.positive = positive
        
        self.font_size = font_size
        self.frame_width = frame_width
        self.frame_height = frame_height
    }
}

struct UnitField: View {
    let variable: Variable.Type
    @State var units: Binding<Unit>
    
    @State var unit: Int = 0
    @State var prefixPower: Int = 0
    var potential_units: [unit.Type] { get {
        let u: base_unit = variable.units[UnitSystem(rawValue: UserDefaults.standard.integer(forKey: "unit_system")) ?? UnitSystem.mks]!
        return [type(of: u)] + u.permutations
    }}
    
    var body: some View {
        VStack {
            if units.wrappedValue.can_prefix {
                Picker("Prefix", selection: $prefixPower) {
                    ForEach(Array(prefixesByPower.keys).sorted().reversed(), id: \.self) { p in
                        Text((prefixesByPower[p]!.symbol.isEmpty ? "" : "(\(prefixesByPower[p]!.symbol)) ") + (prefixesByPower[p]!.name.isEmpty ? "base" : "\(prefixesByPower[p]!.name)"))
                            .id(p)
                    }
                }.fixedSize()
            }
            Picker("Unit", selection: $unit) {
                ForEach(0..<potential_units.count, id: \.self) { u in
                    TruncatingText(full_text: "\(potential_units[u].init().plural())", short_text: "\(potential_units[u].init().symbol())")
                        .id(u)
                }
            }
        }
    }
}

struct ValueField: View {
    @State var variable: Variable.Type
    @State var val: String
    @State var units: Unit
    var total: Value { get {
        Value(variable, value(val), units)
    }}
    
    @State var focused: Bool = false
    
    var body: some View {
        HStack {
            Text(String(describing: variable))
                .font(.title3)
            InfoBubble(caption: variable.info)
        }
        
        HStack {
            Text(String(describing: value(val).base) + " × 10")
            Text(String(value(val).power))
                .baselineOffset(12)
                .padding(.leading, -6)
            Text(units.symbol())
            Button(action: {focused = true}, label: {Label(" ", systemImage: "pencil.circle").labelStyle(IconOnlyLabelStyle())})
                .buttonStyle(BorderlessButtonStyle())
                .popover(isPresented: $focused) {
                    HStack {
                        NumericField($val)
                        UnitField(variable: variable, units: $units)
                    }.padding()
                }
        }
    }
    
    init(_ variable: Variable.Type, _ val: String, _ units: Unit) {
        self.variable = variable
        self.val = val
        self.units = units
    }
    
    init(_ value: Value) {
        self.init(value.variable, value.numericValue.toString(), value.units)
    }
}

/*struct ValueField: View {
    @Binding var val: Value
    
    @State var base: String = "0.0"
    @State var power: String = "0"
    @State var units: String = ""
    
    @State private var multStrFullSize: CGSize = .zero
    @State private var multStrCurSize: CGSize = .zero
    
    enum focusable: String { case base, power, unit }
    @FocusState var focused: focusable?
    
    var body: some View {
        HStack {
            Text(String(describing: val.variable))
            InfoBubble(caption: val.variable.info)
        }
        
        HStack {
            TextField("", text: $base, onEditingChanged: updateVal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .multilineTextAlignment(.center)
                .frame(width: 60)
                .onMoveCommand(perform: { (direction) in
                    if direction == .right {
                        focused = .power
                    }
                })
                .focused($focused, equals: .base)
            
            TruncatingText(full_text: "× 10", short_text: "E")
            
            TextField("Power", text: $power, onEditingChanged: updateVal)//.textFieldStyle(ExponentTextFieldStyle(focused: {() in return focused == .power}))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .multilineTextAlignment(.center)
                .frame(width: 50)
                .onMoveCommand(perform: { (direction) in
                    if direction == .left {
                        focused = .base
                    } else if direction == .right {
                        focused = .unit
                    }
                })
                .focused($focused, equals: .power)
            
            TextField("Units", text: $units, onEditingChanged: updateVal)//.textFieldStyle(CustomRoundedFieldStyle(width: 65, font_size: 12, focused: {() in return focused == .unit}))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled(true)
                .multilineTextAlignment(.center)
                .onMoveCommand(perform: { (direction) in
                    if direction == .left {
                        focused = .power
                    }
                })
                .focused($focused, equals: .unit)
                .fixedSize()
        }
    }
    
    func updateVal(editing: Bool) {
        if !editing {
            val.update(value(Decimal(string: base) ?? 0.0, Int(power) ?? 0), Unit(units))
            base = String(describing: val.numericValue.base)
            power = String(val.numericValue.power)
            units = val.units.toString()
            
            // figure out how to link this to the inference engine
        }
    }
}

extension ValueField {
    init(_ v: Binding<Value>) {
        self.init(val: v)
        self.base = String(describing: self.val.numericValue.base)
        self.power = String(self.val.numericValue.power)
        self.units = self.val.units.toString()
    }
}*/
