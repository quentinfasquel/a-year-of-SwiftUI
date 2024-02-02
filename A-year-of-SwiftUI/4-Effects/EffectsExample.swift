//
//  EffectsExample.swift
//  A-year-of-SwiftUI
//
//  Created by Quentin Fasquel on 03/02/2024.
//

import SwiftUI
import AVKit

@available(iOS 17, *)
struct EffectsExample: View {
    let startDate = Date()

    var body: some View {
        VerticalScrollView {
            VStack(spacing: 24) {
                Text("Color Effects")
                HStack(spacing: 24) {
                    colorEffectView0
                    colorEffectView1
                }

                Divider()
                    .brightness(0.25)

                Text("Distortion Effects")
                HStack(spacing: 24) {
                    distortionEffectView0
                    distortionEffectView1
                }

                Divider()
                    .brightness(0.5)

                Text("Layer Effect")
                HStack(spacing: 24) {
                    layerEffectView0
                    layerEffectView1
                }
            }
            .font(.headline)
            .padding(16)
        }
        .background(.black.gradient)
    }

    // MARK: - Color Shaders (See Shaders.metal)

    @State private var isColorEffect0Enabled = true
    @State private var isColorEffect1Enabled = true

    var colorEffectView0: some View {
        Image(systemName: "heart.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(Color.pink)
            .colorEffect(
                ShaderLibrary.checkerboard(
                    .float(10),
                    .color(.pink)
                ),
                isEnabled: isColorEffect0Enabled
            )
            .onTapGesture {
                isColorEffect0Enabled.toggle()
            }
    }

    var colorEffectView1: some View {
        TimelineView(.animation) { context in
            Image(systemName: "bolt.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.yellow)
                .colorEffect(
                    ShaderLibrary.noise(
                        .float(startDate.timeIntervalSinceNow)
                    ),
                    isEnabled: isColorEffect1Enabled
                )
        }
        .onTapGesture {
            isColorEffect1Enabled.toggle()
        }
    }

    // MARK: - Distortion Shaders (See Shaders.metal)

    @State private var distortionEffect0Enabled = true
    @State private var distortionEffect1Enabled = true

    var distortionEffectView0: some View {
        TimelineView(.animation) { context in
            Image(systemName: "figure.2.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.blue)
                .distortionEffect(
                    ShaderLibrary.simpleWave(
                        .float(startDate.timeIntervalSinceNow)
                    ),
                    maxSampleOffset: .zero,
                    isEnabled: distortionEffect0Enabled
                )
        }
        .onTapGesture {
            distortionEffect0Enabled.toggle()
        }
    }

    var distortionEffectView1: some View {
        TimelineView(.animation) { context in
            Image(systemName: "figure.child.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.green)
                .visualEffect { content, proxy in
                    content.distortionEffect(
                        ShaderLibrary.complexWave(
                            .float(startDate.timeIntervalSinceNow),
                            .float2(proxy.size),
                            .float(0.5),
                            .float(8),
                            .float(10)
                        ),
                        maxSampleOffset: .zero,
                        isEnabled: distortionEffect1Enabled)
                }
        }
        .onTapGesture {
            distortionEffect1Enabled.toggle()
        }
    }

    // MARK: - Layer Shader (See Shaders.metal)

    @State private var layerEffect0Enabled = true
    @State private var layerEffect1Enabled = true

    var layerEffectView0: some View {
        TimelineView(.animation) { context in
            Image(systemName: "figure.2.arms.open")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.orange)
                .layerEffect(
                    ShaderLibrary.pixellate(
                        .float(CGFloat.random(in: 1...10))
                    ),
                    maxSampleOffset: .zero,
                    isEnabled: layerEffect0Enabled
                )
        }
        .onTapGesture {
            layerEffect0Enabled.toggle()
        }
    }

    var layerEffectPlayer: AVPlayer = {
        let videoURL = Bundle.main.url(forResource: "bordeaux", withExtension: "mp4")!
        return AVPlayer(url: videoURL)
    }()

    var layerEffectView1: some View {
        Group {
            if layerEffect1Enabled {
                VideoPlayer(player: layerEffectPlayer)
                    .layerEffect(
                        ShaderLibrary.pixellate(
                            .float(CGFloat.random(in: 1...10))
                        ),
                        maxSampleOffset: .zero
                    )
            } else {
                VideoPlayer(player: layerEffectPlayer)
            }
        }
        .aspectRatio(1, contentMode: .fill)
        .onAppear {
            layerEffectPlayer.play()
        }
        .onTapGesture {
            layerEffect1Enabled.toggle()
        }
    }
}

@available(iOS 17, *)
#Preview {
    EffectsExample()
        .preferredColorScheme(.dark)
}
