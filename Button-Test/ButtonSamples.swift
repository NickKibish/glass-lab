import SwiftUI

struct StyleSamples: View {
    let settings: GallerySettings
    let action: (String) -> Void

    var body: some View {
        VStack(spacing: 30) {
            GallerySection(title: "Native button styles", detail: "Compare Liquid Glass with the familiar system styles.") {
                SampleGrid {
                    SampleTile(title: "Glass", code: ".buttonStyle(.glass)", settings: settings) {
                        button("Glass").buttonStyle(.glass)
                    }
                    SampleTile(title: "Glass prominent", code: ".glassProminent", settings: settings) {
                        button("Prominent").buttonStyle(.glassProminent)
                    }
                    SampleTile(title: "Clear glass", code: ".buttonStyle(.glass(.clear))", settings: settings) {
                        button("Clear").buttonStyle(.glass(.clear))
                    }
                    SampleTile(title: "Tinted glass", code: ".glass(.regular.tint(color))", settings: settings) {
                        button("Tinted").buttonStyle(.glass(.regular.tint(settings.tint)))
                    }
                    SampleTile(title: "Automatic", code: ".automatic · reference", settings: settings) {
                        button("Automatic").buttonStyle(.automatic)
                    }
                    SampleTile(title: "Bordered", code: ".bordered · reference", settings: settings) {
                        button("Bordered").buttonStyle(.bordered)
                    }
                    SampleTile(title: "Bordered prominent", code: ".borderedProminent · reference", settings: settings) {
                        button("Bordered").buttonStyle(.borderedProminent)
                    }
                    SampleTile(title: "Plain", code: ".plain · reference", settings: settings) {
                        button("Plain").buttonStyle(.plain)
                    }
                    SampleTile(title: "Borderless", code: ".borderless · reference", settings: settings) {
                        button("Borderless").buttonStyle(.borderless)
                    }
                }
            }
            GallerySection(title: "Label treatments", detail: "Text, symbols, and custom content inside native glass buttons.") {
                SampleGrid {
                    SampleTile(title: "Text only", code: "Text label", settings: settings) {
                        Button("Continue") { action("Continue tapped") }.buttonStyle(.glass)
                    }
                    SampleTile(title: "Symbol only", code: ".labelStyle(.iconOnly)", settings: settings) {
                        Button("Add", systemImage: "plus") { action("Add tapped") }
                            .labelStyle(.iconOnly).buttonStyle(.glass).buttonBorderShape(.circle)
                    }
                    SampleTile(title: "Symbol + text", code: "Label", settings: settings) {
                        Button("Favorite", systemImage: "heart") { action("Favorite tapped") }.buttonStyle(.glass)
                    }
                    SampleTile(title: "Two-line label", code: "Custom VStack", settings: settings) {
                        Button { action("Download tapped") } label: {
                            VStack(spacing: 3) {
                                Label("Download", systemImage: "arrow.down.circle")
                                Text("24 MB · PDF").font(.caption2).foregroundStyle(.secondary)
                            }.padding(4)
                        }.buttonStyle(.glass)
                    }
                }
            }
        }
        .controlSize(.large)
    }

    private func button(_ name: String) -> some View {
        Button("Explore", systemImage: "sparkle") { action("\(name) button tapped") }
    }
}

struct MaterialSamples: View {
    let settings: GallerySettings
    let action: (String) -> Void

    var body: some View {
        VStack(spacing: 30) {
            GallerySection(title: "Liquid Glass materials", detail: "Regular adds a frosted appearance. Clear reveals more of the backdrop. Press and hold to compare the response.") {
                SampleGrid {
                    sample("Regular", ".regular.interactive()", .regular.interactive())
                    sample("Clear", ".clear.interactive()", .clear.interactive())
                    sample("Regular + tint", ".regular.tint(accent)", .regular.tint(settings.tint).interactive())
                    sample("Clear + tint", ".clear.tint(accent)", .clear.tint(settings.tint).interactive())
                    sample("Subtle tint", ".tint(accent.opacity(0.25))", .regular.tint(settings.tint.opacity(0.25)).interactive())
                    sample("No glass", ".identity · reference", .identity)
                    sample("Noninteractive glass", ".regular", .regular)
                    sample("Interactive glass", ".regular.interactive()", .regular.interactive())
                }
            }
            GallerySection(title: "Frost comparison", detail: "These are standard blur materials, not Liquid Glass. They provide a useful comparison; Liquid Glass has no public frost-radius control.") {
                SampleGrid {
                    frost("Ultra thin", ".ultraThinMaterial", .ultraThinMaterial)
                    frost("Thin", ".thinMaterial", .thinMaterial)
                    frost("Regular", ".regularMaterial", .regularMaterial)
                    frost("Thick", ".thickMaterial", .thickMaterial)
                    frost("Ultra thick", ".ultraThickMaterial", .ultraThickMaterial)
                }
            }
        }
    }

    private func sample(_ title: String, _ code: String, _ glass: Glass) -> some View {
        SampleTile(title: title, code: code, settings: settings) {
            GlassAction(glass: glass) { action("\(title) tapped") }
        }
    }

    private func frost(_ title: String, _ code: String, _ material: Material) -> some View {
        SampleTile(title: title, code: code, settings: settings) {
            Button { action("\(title) blur material tapped") } label: {
                Label("Explore", systemImage: "sparkle")
                    .font(.subheadline.weight(.semibold))
                    .padding(.horizontal, 20).frame(minHeight: 46)
                    .background(material, in: .capsule)
            }.buttonStyle(.plain)
        }
    }
}

struct ColorSamples: View {
    let settings: GallerySettings
    let action: (String) -> Void
    private let colors: [(String, Color)] = [
        ("Blue", .blue), ("Cyan", .cyan), ("Mint", .mint), ("Green", .green),
        ("Yellow", .yellow), ("Orange", .orange), ("Red", .red), ("Pink", .pink),
        ("Purple", .purple), ("Indigo", .indigo), ("Brown", .brown), ("Gray", .gray)
    ]

    var body: some View {
        VStack(spacing: 30) {
            GallerySection(title: "The tint spectrum", detail: "Each pair compares a translucent glass tint with a prominent glass button.") {
                SampleGrid {
                    ForEach(colors, id: \.0) { name, color in
                        SampleTile(title: name, code: "Glass tint / glassProminent", settings: settings) {
                            VStack(spacing: 12) {
                                Button("\(name)", systemImage: "drop.fill") { action("\(name) glass tint tapped") }
                                    .buttonStyle(.glass(.regular.tint(color)))
                                Button("\(name)", systemImage: "drop.fill") { action("\(name) prominent tapped") }
                                    .buttonStyle(.glassProminent).tint(color)
                            }.padding(.vertical, 18)
                        }
                    }
                }.controlSize(.large)
            }
            GallerySection(title: "Tint strength", detail: "Tint opacity changes color strength, not the glass blur radius.") {
                SampleGrid {
                    ForEach([0.15, 0.35, 0.65, 1.0], id: \.self) { opacity in
                        SampleTile(title: "\(Int(opacity * 100))% tint", code: ".tint(accent.opacity(\(opacity.formatted())))", settings: settings) {
                            GlassAction(glass: .regular.tint(settings.tint.opacity(opacity)).interactive()) {
                                action("\(Int(opacity * 100))% tint tapped")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ShapeSamples: View {
    let settings: GallerySettings
    let action: (String) -> Void

    var body: some View {
        VStack(spacing: 30) {
            GallerySection(title: "Native silhouettes", detail: "Button border shapes preserve the system's built-in interaction.") {
                SampleGrid {
                    shape("Automatic", .automatic)
                    shape("Capsule", .capsule)
                    shape("Rounded rectangle", .roundedRectangle)
                    shape("8 pt corners", .roundedRectangle(radius: 8))
                    shape("24 pt corners", .roundedRectangle(radius: 24))
                    SampleTile(title: "Circle", code: ".buttonBorderShape(.circle)", settings: settings) {
                        Button("Favorite", systemImage: "heart.fill") { action("Circle tapped") }
                            .labelStyle(.iconOnly).buttonStyle(.glassProminent)
                            .buttonBorderShape(.circle).controlSize(.extraLarge)
                    }
                }
            }
            GallerySection(title: "Control sizes", detail: "From compact actions to a generous primary button. Exact sizing varies by platform.") {
                SampleGrid {
                    size("Mini", .mini)
                    size("Small", .small)
                    size("Regular", .regular)
                    size("Large", .large)
                    size("Extra large", .extraLarge)
                }
            }
            GallerySection(title: "Custom geometry", detail: "Apply an interactive glass effect to the padded button content.") {
                SampleGrid {
                    SampleTile(title: "Soft rectangle", code: ".glassEffect(in: .rect(cornerRadius: 16))", settings: settings) {
                        Button { action("Soft rectangle tapped") } label: {
                            Label("Explore", systemImage: "sparkle").padding(18)
                        }.buttonStyle(.plain)
                            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
                    }
                    SampleTile(title: "Rounded square", code: "72 × 72 · 22 pt corners", settings: settings) {
                        Button { action("Rounded square tapped") } label: {
                            Image(systemName: "camera.fill").font(.title2).frame(width: 72, height: 72)
                        }.buttonStyle(.plain).accessibilityLabel("Camera")
                            .glassEffect(.regular.tint(settings.tint).interactive(), in: .rect(cornerRadius: 22))
                    }
                }
                Button { action("Full-width continue tapped") } label: {
                    HStack { Text("Continue"); Spacer(); Image(systemName: "arrow.right") }
                        .fontWeight(.semibold).padding(8).frame(maxWidth: .infinity)
                }
                .buttonStyle(.glassProminent).controlSize(.large)
                .disabled(settings.disableSamples)
            }
        }
    }

    private func shape(_ title: String, _ shape: ButtonBorderShape) -> some View {
        SampleTile(title: title, code: ".buttonBorderShape(…)", settings: settings) {
            Button("Explore", systemImage: "sparkle") { action("\(title) tapped") }
                .buttonStyle(.glass).buttonBorderShape(shape).controlSize(.large)
        }
    }

    private func size(_ title: String, _ size: ControlSize) -> some View {
        SampleTile(title: title, code: ".controlSize(.\(title == "Extra large" ? "extraLarge" : title.lowercased()))", settings: settings) {
            Button("Explore") { action("\(title) tapped") }.buttonStyle(.glass).controlSize(size)
        }
    }
}

struct RoleSamples: View {
    let settings: GallerySettings
    let action: (String) -> Void
    @State private var favorite = false
    @State private var playing = false
    @State private var showConfirmation = false
    @State private var loading = false

    var body: some View {
        VStack(spacing: 30) {
            GallerySection(title: "Semantic roles", detail: "The same role in glass and prominent glass. Role appearance is determined by the system and context.") {
                SampleGrid {
                    role("Default", nil, "sparkle")
                    role("Destructive", .destructive, "trash")
                    role("Cancel", .cancel, "arrow.uturn.backward")
                    role("Confirm", .confirm, "checkmark")
                    role("Close", .close, "xmark")
                }
            }
            GallerySection(title: "States & interaction", detail: "Try selection, playback, a temporary loading state, and a confirmation dialog. All actions are local demos.") {
                SampleGrid {
                    SampleTile(title: "Disabled glass", code: ".disabled(true)", settings: settings) {
                        Button("Unavailable") {}.buttonStyle(.glass).disabled(true)
                    }
                    SampleTile(title: "Disabled prominent", code: ".glassProminent + disabled", settings: settings) {
                        Button("Unavailable") {}.buttonStyle(.glassProminent).disabled(true)
                    }
                    SampleTile(title: "Selected / unselected", code: "State-driven tint + symbol", settings: settings) {
                        Button(favorite ? "Saved" : "Save", systemImage: favorite ? "heart.fill" : "heart") {
                            favorite.toggle(); action(favorite ? "Saved to favorites" : "Removed from favorites")
                        }
                        .buttonStyle(.glass(.regular.tint(favorite ? .pink : nil)))
                        .accessibilityValue(favorite ? "Selected" : "Not selected")
                    }
                    SampleTile(title: "Play / pause", code: "State-driven label", settings: settings) {
                        Button(playing ? "Pause" : "Play", systemImage: playing ? "pause.fill" : "play.fill") {
                            playing.toggle(); action(playing ? "Playback demo started" : "Playback demo paused")
                        }.buttonStyle(.glassProminent)
                    }
                    SampleTile(title: "Loading", code: "ProgressView + disabled", settings: settings) {
                        Button {
                            loading = true; action("Loading demo started")
                        } label: {
                            HStack {
                                if loading { ProgressView().controlSize(.small) }
                                Text(loading ? "Loading" : "Load demo")
                            }
                        }
                        .buttonStyle(.glass).disabled(loading)
                        .task(id: loading) {
                            guard loading else { return }
                            do { try await Task.sleep(for: .seconds(2)) } catch { return }
                            loading = false; action("Loading demo completed")
                        }
                    }
                    SampleTile(title: "Confirmation dialog", code: "Destructive + cancel roles", settings: settings) {
                        Button("Delete…", systemImage: "trash", role: .destructive) { showConfirmation = true }
                            .buttonStyle(.glass)
                    }
                }
            }
        }
        .controlSize(.large)
        .confirmationDialog("Delete this demo item?", isPresented: $showConfirmation, titleVisibility: .visible) {
            Button("Delete demo item", role: .destructive) { action("Demo delete confirmed — no data was removed") }
            Button("Keep item", role: .cancel) { action("Demo delete cancelled") }
        } message: { Text("This only demonstrates button roles.") }
    }

    private func role(_ title: String, _ role: ButtonRole?, _ symbol: String) -> some View {
        SampleTile(title: title, code: role == nil ? "role: nil" : "role: .\(title.lowercased())", settings: settings) {
            VStack(spacing: 12) {
                Button(title, systemImage: symbol, role: role) { action("\(title) glass role tapped") }.buttonStyle(.glass)
                Button(title, systemImage: symbol, role: role) { action("\(title) prominent role tapped") }.buttonStyle(.glassProminent)
            }.padding(.vertical, 18)
        }
    }
}
