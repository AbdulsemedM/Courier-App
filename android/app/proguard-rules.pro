# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.

# Keep StringConcatFactory for urovo_scanner plugin and other Java 9+ APIs
-keep class java.lang.invoke.StringConcatFactory { *; }
-keep class java.lang.invoke.** { *; }
-dontwarn java.lang.invoke.StringConcatFactory
-dontwarn java.lang.invoke.**

# Keep all classes in the urovo_scanner package
-keep class br.com.bongiolo.urovo_scanner.** { *; }
-dontwarn br.com.bongiolo.urovo_scanner.**

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep all public classes in plugin packages
-keep class * extends io.flutter.plugin.common.PluginRegistry { *; }
-keep class * implements io.flutter.plugin.common.PluginRegistry { *; }

# Google Play Core classes (optional, used by Flutter deferred components)
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
-keep class com.google.android.play.core.** { *; }

