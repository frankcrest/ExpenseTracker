//
//  LockView.swift
//  LockSwiftUIView
//
//  Created by Frank Chen on 2024-04-05.
//

import SwiftUI
import LocalAuthentication

struct LockView<Content: View>: View {
    
    var lockType: LockType
    var lockPin: String
    var isEnabled: Bool
    var lockWhenAppGoesBackground: Bool = true
    @ViewBuilder var content: Content
    var forgotPin: () -> () = { }
    
    @State private var pin: String = ""
    @State private var animateField: Bool = false
    @State private var isUnlocked: Bool = false
    @State private var noBiometricAccess: Bool = false
    
    let context = LAContext()
    
    @Environment(\.scenePhase) private var phase
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            content
                .frame(width: size.width, height: size.height)
            
            if isEnabled && !isUnlocked {
                ZStack {
                    Rectangle()
                        .fill(.black)
                        .ignoresSafeArea()
                    if (lockType == .both && !noBiometricAccess) || lockType == .biometric {
                        Group {
                            if noBiometricAccess {
                                Text("Enable biometric authentification in settings to unlock the view")
                                    .font(.callout)
                                    .multilineTextAlignment(.center)
                                    .padding(50)
                            } else {
                                // Biometric / Pin Unlock
                                VStack(spacing: 12) {
                                    VStack(spacing: 6) {
                                        Image(systemName: "lock")
                                            .font(.largeTitle)
                                        
                                        Text("Tap to Unlock")
                                            .font(.caption2)
                                            .foregroundStyle(.gray)
                                    }
                                    .frame(width: 100, height: 100)
                                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 10)
                                    )
                                    .contentShape(.rect)
                                    .onTapGesture {
                                        unlockView()
                                    }
                                    
                                    if lockType == .both {
                                        Text("Enter Pin")
                                            .frame(width: 100, height: 40)
                                            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                                            .contentShape(.rect)
                                            .onTapGesture {
                                                noBiometricAccess = true
                                            }
                                    }
                                }
                            }
                        }
                    } else {
                        // Custom Number Pad to type App Lock Pin
                        NumberPadPinView()
                    }
                }
                .environment(\.colorScheme, .dark)
                .transition(.offset(y: size.height + 100))
            }
        }
        .onChange(of: isEnabled) { oldValue, newValue in
            if newValue {
                unlockView()
            }
        }
        // Locking When App Goes Background
        .onChange(of: phase) { oldValue, newValue in
            if newValue != .active && lockWhenAppGoesBackground {
                isUnlocked = false
                pin = ""
            }
            
            if newValue == .active && !isUnlocked && isEnabled {
                unlockView()
            }
        }
    }
    
    private func unlockView() {
        // Checking and Unlocking View
        Task {
            if isBiometricAvailable && lockType != .number {
                // Requesting Biometric Unlock
                if let result = try? await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock the View"), result {
                    print("Unlocked")
                    withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                        isUnlocked = true
                    } completion: {
                        pin = ""
                    }
                }
            }
            
            // No Biometric Permission || Lock Type Must be set as keypad
            // Updating Biometric Status
            noBiometricAccess = !isBiometricAvailable
        }
    }
    
    private var isBiometricAvailable: Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    // Numberpad Pin View
    @ViewBuilder
    private func NumberPadPinView() -> some View {
        VStack(spacing: 15) {
            Text("Enter Pin")
                .font(.title.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    // Back button only for Both Lock Type
                    if lockType == .both && isBiometricAvailable {
                        Button(action: {
                            pin = ""
                            noBiometricAccess = false
                        }, label: {
                            Image(systemName: "arrow.left")
                                .font(.title3)
                                .contentShape(.rect)
                        })
                        .tint(.white)
                        .padding(.leading)
                    }
                }
            
            // Adding Wiggling Animation For Wrong Passport With Keyframe Animation
            HStack(spacing: 10, content: {
                ForEach(0..<4, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 50, height: 55)
                    // Showing Pin at each box with the help of Index
                        .overlay {
                            // Safe check
                            if pin.count > index {
                                let index = pin.index(pin.startIndex, offsetBy: index)
                                let string = String(pin[index])
                                
                                Text(string)
                                    .font(.title.bold())
                                    .foregroundStyle(.black)
                            }
                        }
                }
            })
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: animateField, content: { content, value in
                content.offset(x: value)
            }, keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(30, duration: 0.07)
                    CubicKeyframe(-30, duration: 0.07)
                    CubicKeyframe(20, duration: 0.07)
                    CubicKeyframe(-20, duration: 0.07)
                    CubicKeyframe(0, duration: 0.07)
                }
            })
            .padding(.top, 15)
            .overlay(alignment: .bottomTrailing, content: {
                Button("Forgot Pin?") {
                    forgotPin()
                }
                .font(.callout)
                .foregroundStyle(.white)
                .offset(y: 40)
            })
            .frame(maxHeight: .infinity)
            
            GeometryReader { _ in
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3), content: {
                    ForEach(1...9, id: \.self) { number in
                        Button(action: {
                            // Adding Number To Pin
                            // Max Limit - 4
                            if pin.count <= 4 {
                                pin.append("\(number)")
                            }
                        }, label: {
                            Text("\(number)")
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .contentShape(.rect)
                        })
                        .tint(.white)
                    }
                        
                        Button(action: {
                            if !pin.isEmpty {
                                pin.removeLast()
                            }
                        }, label: {
                            Image(systemName: "delete.backward")
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .contentShape(.rect)
                        })
                        .tint(.white)
                        
                        Button(action: {
                            if pin.count <= 4 {
                                pin.append("0")
                            }
                        }, label: {
                            Text("0")
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .contentShape(.rect)
                        })
                        .tint(.white)
                })
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .onChange(of: pin) { oldValue, newValue in
                if newValue.count == 4 {
                    if lockPin == pin {
                        print("Unlocked")
                        withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                            isUnlocked = true
                        } completion: {
                            // Clearing Pin
                            pin = ""
                            noBiometricAccess = !isBiometricAvailable
                        }

                    } else {
                        print("Wrong Pin")
                        pin = ""
                        animateField.toggle()
                    }
                }
            }
        }
        .padding()
        .environment(\.colorScheme, .dark)
    }
    
    enum LockType: String {
        case biometric = "Bio Metric Auth"
        case number = "Custom Number Lock"
        case both = "First preference will be biometric, and if it's not available, it will go for number lock."
    }
}

#Preview {
    ContentView()
}