import SwiftUI

struct NavigationSamples: View {
    let settings: GallerySettings
    let action: (String) -> Void
    @State private var showSheet = false
    @State private var selectedTool = "Draw"

    var body: some View {
        VStack(spacing: 30) {
            GallerySection(title: "Navigation & presentation", detail: "Open a real screen to inspect the system back button, grouped toolbar actions, and bottom bar.") {
                SampleGrid {
                    SampleTile(title: "Glass navigation link", code: "NavigationLink + .glass", settings: settings) {
                        NavigationLink {
                            ToolbarDemo(settings: settings, action: action)
                        } label: { Label("Open demo", systemImage: "arrow.right") }
                        .buttonStyle(.glass).controlSize(.large)
                    }
                    SampleTile(title: "Prominent link", code: "NavigationLink + .glassProminent", settings: settings) {
                        NavigationLink {
                            ToolbarDemo(settings: settings, action: action)
                        } label: { Label("Open demo", systemImage: "arrow.up.right") }
                        .buttonStyle(.glassProminent).controlSize(.large)
                    }
                    SampleTile(title: "Modal presentation", code: "Sheet + cancellation / confirmation", settings: settings) {
                        Button("Open sheet", systemImage: "rectangle.bottomthird.inset.filled") { showSheet = true }
                            .buttonStyle(.glass).controlSize(.large)
                    }
                    SampleTile(title: "Menu button", code: "Menu + .glass", settings: settings) {
                        Menu {
                            Button("Copy", systemImage: "doc.on.doc") { action("Menu: copy demo") }
                            Button("Duplicate", systemImage: "plus.square.on.square") { action("Menu: duplicate demo") }
                            Divider()
                            Button("Delete", systemImage: "trash", role: .destructive) { action("Menu: delete demo") }
                        } label: { Label("Actions", systemImage: "ellipsis") }
                        .buttonStyle(.glass).controlSize(.large)
                    }
                }
            }
            GallerySection(title: "Floating tool palette", detail: "A custom glass container groups separate interactive controls. Select a tool to change its tint.") {
                GlassEffectContainer(spacing: 14) {
                    HStack(spacing: 12) {
                        tool("Draw", "pencil.tip")
                        tool("Erase", "eraser")
                        tool("Select", "lasso")
                        tool("Move", "hand.draw")
                    }
                    .padding(26)
                }
                .frame(maxWidth: .infinity, minHeight: 140)
                .background { SampleBackdrop(style: settings.backdrop, offset: settings.backgroundOffset) }
                .clipShape(.rect(cornerRadius: 24))
                .disabled(settings.disableSamples)
                Text("Selected tool: \(selectedTool)").font(.caption).foregroundStyle(.secondary)
            }
        }
        .sheet(isPresented: $showSheet) {
            NavigationStack {
                VStack(spacing: 22) {
                    Image(systemName: "square.and.pencil").font(.system(size: 48)).foregroundStyle(settings.tint)
                    Text("An everyday sheet").font(.title2.bold())
                    Text("Compare the system Cancel and Done actions with the glass buttons below.")
                        .multilineTextAlignment(.center).foregroundStyle(.secondary)
                    Button("Confirm", systemImage: "checkmark", role: .confirm) {
                        action("Sheet confirmed"); showSheet = false
                    }.buttonStyle(.glassProminent).controlSize(.large)
                    Button("Close", role: .close) {
                        action("Sheet closed"); showSheet = false
                    }.buttonStyle(.glass).controlSize(.large)
                }
                .padding(30).frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("Presentation")
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel", role: .cancel) { action("Sheet cancelled"); showSheet = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done", role: .confirm) { action("Sheet done"); showSheet = false }
                    }
                }
            }
            .tint(settings.tint).preferredColorScheme(settings.appearance.scheme)
            .presentationDetents([.medium, .large])
            .frame(minWidth: 300, minHeight: 360)
        }
    }

    private func tool(_ title: String, _ symbol: String) -> some View {
        Button {
            selectedTool = title; action("\(title) tool selected")
        } label: {
            Image(systemName: symbol).font(.title3).frame(width: 48, height: 48)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.tint(selectedTool == title ? settings.tint : nil).interactive(), in: .circle)
        .accessibilityLabel(title)
        .accessibilityAddTraits(selectedTool == title ? .isSelected : [])
    }
}

struct ToolbarDemo: View {
    let settings: GallerySettings
    let action: (String) -> Void
    @State private var favorite = false
    @State private var editing = false
    @State private var status = "Try the toolbar controls"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ZStack(alignment: .bottomLeading) {
                    SampleBackdrop(style: settings.backdrop, offset: settings.backgroundOffset)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("In context").font(.system(size: 40, weight: .bold, design: .rounded))
                        Text("Native navigation. Native glass.").font(.headline)
                    }.foregroundStyle(.white).padding(26)
                }.frame(height: 280).clipShape(.rect(cornerRadius: 28))
                Text(status).font(.headline).foregroundStyle(settings.tint)
                Text("Scroll this page to see content pass beneath the navigation bar. The back button and toolbar glass are supplied by the system.")
                    .foregroundStyle(.secondary)
                ForEach(0..<6) { index in
                    HStack(spacing: 18) {
                        Image(systemName: ["arrow.left", "heart", "square.and.arrow.up", "ellipsis", "pencil", "plus"][index])
                            .font(.title2).foregroundStyle(settings.tint).frame(width: 40)
                        VStack(alignment: .leading, spacing: 5) {
                            Text(["Back navigation", "Grouped actions", "Toolbar menu", "Overflow menu", "Edit state", "Bottom bar"][index]).font(.headline)
                            Text("System controls adapt to their placement, tint, and role.")
                                .font(.subheadline).foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .padding(20).background(.primary.opacity(0.045), in: .rect(cornerRadius: 20))
                }
            }.padding(20).frame(maxWidth: 800).frame(maxWidth: .infinity)
        }
        .navigationTitle("Toolbar playground")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button("Favorite", systemImage: favorite ? "heart.fill" : "heart") {
                    favorite.toggle(); report(favorite ? "Favorited" : "Favorite cleared")
                }.tint(favorite ? .pink : settings.tint)
                Menu {
                    Button("Copy link", systemImage: "link") { report("Copy link demo") }
                    Button("Share", systemImage: "square.and.arrow.up") { report("Share demo") }
                    Button("Delete", systemImage: "trash", role: .destructive) { report("Delete demo — no data removed") }
                } label: { Label("More", systemImage: "ellipsis") }
            }
            #if os(iOS)
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Add", systemImage: "plus") { report("Add tapped") }
                Spacer()
                Button(editing ? "Done" : "Edit", systemImage: editing ? "checkmark" : "pencil") {
                    editing.toggle(); report(editing ? "Editing enabled" : "Editing completed")
                }
                .buttonStyle(.glassProminent)
                Spacer()
                Button("Delete", systemImage: "trash", role: .destructive) { report("Delete demo — no data removed") }
            }
            #else
            ToolbarItem(placement: .automatic) {
                Button(editing ? "Done" : "Edit", systemImage: editing ? "checkmark" : "pencil") {
                    editing.toggle(); report(editing ? "Editing enabled" : "Editing completed")
                }.buttonStyle(.glassProminent)
            }
            #endif
        }
    }

    private func report(_ message: String) { status = message; action(message) }
}

struct MotionSamples: View {
    let settings: GallerySettings
    let action: (String) -> Void
    @Namespace private var namespace
    @State private var expanded = false
    @State private var spacing = 18.0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 30) {
            GallerySection(title: "Morphing action group", detail: "Expand the group to reveal more actions. Stable glass IDs let the material flow between layouts.") {
                GlassEffectContainer(spacing: 24) {
                    HStack(spacing: 16) {
                        Button {
                            withAnimation(reduceMotion ? nil : .bouncy(duration: 0.55)) { expanded.toggle() }
                            action(expanded ? "Action group expanded" : "Action group collapsed")
                        } label: {
                            Image(systemName: expanded ? "xmark" : "plus")
                                .font(.title2).frame(width: 54, height: 54)
                        }
                        .buttonStyle(.plain)
                        .glassEffect(.regular.tint(settings.tint).interactive(), in: .circle)
                        .glassEffectID("toggle", in: namespace)
                        .accessibilityLabel(expanded ? "Collapse actions" : "Expand actions")
                        if expanded {
                            morphButton("Camera", "camera", "camera")
                            morphButton("Photos", "photo", "photos")
                            morphButton("Files", "folder", "files")
                        }
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity, minHeight: 180)
                }
                .background { SampleBackdrop(style: settings.backdrop, offset: settings.backgroundOffset) }
                .clipShape(.rect(cornerRadius: 24))
                .disabled(settings.disableSamples)
            }
            GallerySection(title: "Proximity & blending", detail: "Move the slider. Nearby shapes blend within a GlassEffectContainer with 40 pt spacing.") {
                GlassEffectContainer(spacing: 40) {
                    HStack(spacing: spacing) {
                        blendingButton("Sun", "sun.max.fill")
                        blendingButton("Moon", "moon.fill")
                        blendingButton("Stars", "sparkles")
                    }
                    .frame(maxWidth: .infinity, minHeight: 160)
                }
                .background { SampleBackdrop(style: settings.backdrop, offset: settings.backgroundOffset) }
                .clipShape(.rect(cornerRadius: 24))
                .disabled(settings.disableSamples)
                HStack {
                    Text("Gap").font(.subheadline)
                    Slider(value: $spacing, in: 0...56) { Text("Space between glass buttons") }
                    Text("\(Int(spacing)) pt").font(.caption.monospacedDigit()).frame(width: 46)
                }
            }
            GallerySection(title: "Press response", detail: "Press and hold each button. Interactive glass reacts to touch; the static effect keeps its material appearance.") {
                SampleGrid {
                    SampleTile(title: "Static effect", code: ".regular", settings: settings) {
                        GlassAction(title: "Press me", symbol: "hand.tap", glass: .regular) { action("Static glass tapped") }
                    }
                    SampleTile(title: "Interactive effect", code: ".regular.interactive()", settings: settings) {
                        GlassAction(title: "Press me", symbol: "hand.tap", glass: .regular.interactive()) { action("Interactive glass tapped") }
                    }
                }
            }
        }
    }

    private func morphButton(_ title: String, _ symbol: String, _ id: String) -> some View {
        Button { action("\(title) action tapped") } label: {
            Image(systemName: symbol).font(.title3).frame(width: 48, height: 48)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .circle)
        .glassEffectID(id, in: namespace)
        .glassEffectTransition(.matchedGeometry)
        .accessibilityLabel(title)
    }

    private func blendingButton(_ title: String, _ symbol: String) -> some View {
        Button { action("\(title) tapped") } label: {
            Image(systemName: symbol).font(.title2).frame(width: 56, height: 56)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .circle)
        .accessibilityLabel(title)
    }
}
