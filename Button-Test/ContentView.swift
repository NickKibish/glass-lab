import SwiftUI

struct ContentView: View {
    @State private var settings = GallerySettings()
    @State private var category: GalleryCategory = .styles
    @State private var showSettings = false
    @State private var lastAction = "Tap any sample to try it"
    @State private var tapCount = 0

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        intro.id("top")
                        categoryPicker
                        VStack(alignment: .leading, spacing: 6) {
                            Text(category.rawValue).font(.system(.largeTitle, design: .rounded, weight: .bold))
                            Text(category.subtitle).foregroundStyle(.secondary)
                        }
                        samples
                        Text("LIQUID GLASS / SWIFTUI EXPLORATIONS")
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .tracking(2).foregroundStyle(.tertiary)
                            .frame(maxWidth: .infinity).padding(.vertical, 14)
                    }
                    .padding(20)
                    .frame(maxWidth: 980)
                    .frame(maxWidth: .infinity)
                }
                .onChange(of: category) { _, _ in proxy.scrollTo("top", anchor: .top) }
                .background(Color.primary.opacity(0.025))
                .navigationTitle("Glass Lab")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Viewing options", systemImage: "slider.horizontal.3") { showSettings = true }
                    }
                }
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    HStack(spacing: 8) {
                        Image(systemName: tapCount == 0 ? "hand.tap" : "checkmark.circle.fill")
                            .foregroundStyle(settings.tint)
                        Text(lastAction).lineLimit(2).font(.caption)
                        Spacer(minLength: 0)
                        if tapCount > 0 { Text("\(tapCount)").font(.caption.monospacedDigit()).foregroundStyle(.secondary) }
                    }
                    .padding(.horizontal, 18).padding(.vertical, 12)
                    .background(.bar)
                    .accessibilityElement(children: .combine)
                }
            }
            .sheet(isPresented: $showSettings) { SettingsView(settings: $settings) }
        }
        .tint(settings.tint)
        .preferredColorScheme(settings.appearance.scheme)
    }

    private var intro: some View {
        HStack(alignment: .center, spacing: 18) {
            Image(systemName: "circle.hexagongrid.fill")
                .font(.system(size: 30, weight: .light))
                .foregroundStyle(.white)
                .frame(width: 64, height: 64)
                .background(LinearGradient(colors: [.cyan, .blue, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing), in: .rect(cornerRadius: 21))
            VStack(alignment: .leading, spacing: 5) {
                Text("A study in glass").font(.title2.bold())
                Text("Real controls. Every shade of possibility.")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }

    private var categoryPicker: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 9) {
                ForEach(GalleryCategory.allCases) { item in
                    Button { category = item } label: {
                        Label(item.rawValue, systemImage: item.symbol)
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 15).padding(.vertical, 11)
                            .background(category == item ? settings.tint : Color.primary.opacity(0.06), in: .capsule)
                            .foregroundStyle(category == item ? .white : .primary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(category == item ? .isSelected : [])
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    @ViewBuilder private var samples: some View {
        switch category {
        case .styles: StyleSamples(settings: settings, action: record)
        case .materials: MaterialSamples(settings: settings, action: record)
        case .colors: ColorSamples(settings: settings, action: record)
        case .shapes: ShapeSamples(settings: settings, action: record)
        case .roles: RoleSamples(settings: settings, action: record)
        case .navigation: NavigationSamples(settings: settings, action: record)
        case .motion: MotionSamples(settings: settings, action: record)
        }
    }

    private func record(_ name: String) {
        tapCount += 1
        lastAction = name
    }
}

#Preview { ContentView() }
