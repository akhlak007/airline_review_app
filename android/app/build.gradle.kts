// File: android/app/build.gradle.kts

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")       // Kotlin plugin for Android
    id("com.google.gms.google-services")     // Google Services / Firebase
    id("dev.flutter.flutter-gradle-plugin")  // Flutter
}

android {
    namespace = "com.example.flutter_review_app"
    compileSdk = 34
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.flutter_review_app"
        minSdk = 23
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            // Use your release signing config here, or leave debug for testing
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = file("../..").path
}

