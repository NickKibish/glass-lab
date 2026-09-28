import SwiftUI

enum GalleryCategory: String, CaseIterable, Identifiable {
    case styles = "Styles", materials = "Materials", colors = "Colors", shapes = "Shapes"
    case roles = "Roles", navigation = "Navigation", motion = "Motion"
    var id: String { rawValue }
    var symbol: String {
        switch self {
        case .styles: "square.grid.2x2"
        case .materials: "drop.halffull"
        case .colors: "paintpalette"
        case .shapes: "square.on.circle"
        case .roles: "hand.tap"
        case .navigation: "arrow.triangle.turn.up.right.diamond"
        case .motion: "sparkles"
        }
    }
    var subtitle: String {
        switch self {
        case .styles: "The same action, a different presence."
        case .materials: "Explore transparency, refraction, and frost."
        case .colors: "A spectrum of glass, from subtle to bold."
        case .shapes: "Find the right silhouette and scale."
        case .roles: "Meaning, selection, and availability."
        case .navigation: "Glass in its natural habitat."
        case .motion: "Press, expand, and watch glass come together."
        }
    }
}

enum GalleryBackdrop: String, CaseIterable, Identifiable {
    case ocean = "Ocean", sunset = "Sunset", monochrome = "Monochrome", grid = "Grid"
    var id: String { rawValue }
    var colors: [Color] {
        switch self {
        case .ocean: [.cyan, .blue, .indigo, .mint]
        case .sunset: [.orange, .pink, .purple, .yellow]
        case .monochrome: [.gray, .black, .gray, .white]
        case .grid: [.cyan, .indigo, .pink, .orange]
        }
    }
}

enum GalleryAppearance: String, CaseIterable, Identifiable {
    case system = "System", light = "Light", dark = "Dark"
    var id: String { rawValue }
    var scheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light: .light
        case .dark: .dark
        }
    }
}

struct GallerySettings {
    var backdrop: GalleryBackdrop = .ocean
    var appearance: GalleryAppearance = .system
    var tint: Color = .blue
    var backgroundOffset: Double = 0.35
    var disableSamples = false
}

/// Color and sharp edges behind the controls make the optical differences visible.
struct SampleBackdrop: View {
    var style: GalleryBackdrop
    var offset: Double
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(colors: style.colors.map { $0.opacity(scheme == .dark ? 0.7 : 0.48) },
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                if style == .grid {
                    Canvas { context, size in
                        for row in 0..<12 {
                            for column in 0..<20 where (row + column).isMultiple(of: 2) {
                                let rect = CGRect(x: CGFloat(column) * 28, y: CGFloat(row) * 28, width: 28, height: 28)
                                context.fill(Path(rect), with: .color(.white.opacity(0.3)))
                            }
                        }
                    }
                } else {
                    Ellipse()
                        .fill(style.colors[3].opacity(0.85))
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 1.4)
                        .rotationEffect(.degrees(-35))
                        .offset(x: geometry.size.width * (offset - 0.5), y: geometry.size.height * 0.15)
                    Ellipse()
                        .fill(style.colors[2].opacity(0.5))
                        .frame(width: geometry.size.width * 0.55, height: geometry.size.height * 1.5)
                        .rotationEffect(.degrees(35))
                        .offset(x: geometry.size.width * (0.7 - offset), y: -geometry.size.height * 0.3)
                    Rectangle()
                        .fill(.white.opacity(0.28))
                        .frame(width: 14)
                        .rotationEffect(.degrees(30))
                        .offset(x: geometry.size.width * (offset - 0.5))
                }
            }
        }
        .clipped()
        .accessibilityHidden(true)
    }
}

struct GallerySection<Content: View>: View {
    let title: String
    let detail: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 5) {
                Text(title).font(.title3.bold())
                Text(detail).font(.subheadline).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
            }
            content
        }
    }
}

struct SampleTile<Content: View>: View {
    let title: String
    let code: String
    let settings: GallerySettings
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            content
                .disabled(settings.disableSamples)
                .frame(maxWidth: .infinity, minHeight: 104)
                .padding(.horizontal, 8)
                .background { SampleBackdrop(style: settings.backdrop, offset: settings.backgroundOffset) }
                .clipShape(.rect(cornerRadius: 20))
            Text(title).font(.subheadline.weight(.semibold))
            Text(code).font(.system(size: 10, design: .monospaced)).foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

struct SampleGrid<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], alignment: .leading, spacing: 22) {
            content
        }
    }
}

struct GlassAction: View {
    var title = "Explore"
    var symbol = "sparkle"
    var glass: Glass = .regular
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: symbol)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 20)
                .frame(minHeight: 46)
                .contentShape(.capsule)
        }
        .buttonStyle(.plain)
        .glassEffect(glass, in: .capsule)
    }
}

struct SettingsView: View {
    @Binding var settings: GallerySettings
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Environment") {
                    Picker("Appearance", selection: $settings.appearance) {
                        ForEach(GalleryAppearance.allCases) { Text($0.rawValue).tag($0) }
                    }
                    Picker("Backdrop", selection: $settings.backdrop) {
                        ForEach(GalleryBackdrop.allCases) { Text($0.rawValue).tag($0) }
                    }
                    ColorPicker("Accent color", selection: $settings.tint, supportsOpacity: false)
                }
                Section("Behind the glass") {
                    Slider(value: $settings.backgroundOffset, in: 0...1) {
                        Text("Background position")
                    }
                    Text("Move the background to inspect how glass refracts edges and picks up color.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                Section("State") {
                    Toggle("Disable sample buttons", isOn: $settings.disableSamples)
                    Text("System accessibility settings, including Reduce Transparency and Reduce Motion, also affect the examples.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                Button("Reset settings") { settings = GallerySettings() }
            }
            .navigationTitle("Viewing options")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", role: .confirm) { dismiss() }
                }
            }
        }
        .tint(settings.tint)
        .preferredColorScheme(settings.appearance.scheme)
        .frame(minWidth: 300, minHeight: 440)
    }
}
