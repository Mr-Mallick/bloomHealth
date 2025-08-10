# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Your app package
-keep class com.manrtitech.med_tracker.** { *; }

# General Android
-dontwarn androidx.**
-keep class androidx.** { *; }

# Play Core (Fix for R8 errors)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Flutter Local Notifications - CRITICAL FIX
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class androidx.core.app.NotificationCompat** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**

# Keep generic signatures for flutter_local_notifications
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Gson (used by flutter_local_notifications)
-keepattributes Signature
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keep public class * implements java.lang.reflect.Type

# Keep serialization classes
-keep class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    !private <fields>;
    !private <methods>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep Parcelable implementations
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# JSON serialization classes
-keep class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep R8 from removing generic type information
-keepattributes RuntimeVisibleAnnotations
-keepattributes RuntimeInvisibleAnnotations
-keepattributes RuntimeVisibleParameterAnnotations
-keepattributes RuntimeInvisibleParameterAnnotations