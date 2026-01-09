import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // FlutterFire
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties from key.properties
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.outcrop" // change if needed
    compileSdk = 36

    defaultConfig {
        applicationId = "com.example.outcrop"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = 1 // <-- replace with your app version code
        versionName = "1.0.0" // <-- replace with your app version name
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

   kotlin {
    jvmToolchain(17)
   }

    signingConfigs {
    create("release") {
        if (keystoreProperties.containsKey("storeFile")) {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storePassword = keystoreProperties["storePassword"] as String
            
            // Use rootProject.file to anchor the path to the PROJECT ROOT
            val storePath = keystoreProperties["storeFile"] as String
            storeFile = rootProject.file(storePath) 
        }
    }
}

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            // proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}
