#############################################
# Flutter / Android ProGuard Keep Rules
# Safe for Play Store release builds
#############################################

# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }

# Keep Firebase & Google Services
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Play Core splitinstall/deferred components (fixes R8 missing classes)
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Keep Play Core (SplitInstall / SplitCompat)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Keep Kotlin metadata
-keep class kotlin.Metadata { *; }

# Prevent stripping of Flutter's deferred component support
-keep class io.flutter.embedding.engine.deferredcomponents.PlayStoreDeferredComponentManager { *; }
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Optional: keep everything in your main package
-keep class com.cangrow.cozy.** { *; }

#############################################
