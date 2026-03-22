allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

subprojects {
    fun ensureNamespaceIfMissing() {
        val androidExtension = extensions.findByName("android") ?: return
        val getNamespace = androidExtension::class.java.methods.firstOrNull { it.name == "getNamespace" }
        val currentNamespace = getNamespace?.invoke(androidExtension) as? String
        if (!currentNamespace.isNullOrBlank()) return

        val manifest = file("src/main/AndroidManifest.xml")
        if (!manifest.exists()) return

        val packageName = Regex("package=\"([^\"]+)\"")
            .find(manifest.readText())
            ?.groupValues
            ?.getOrNull(1)
            ?: return

        val setNamespace = androidExtension::class.java.methods.firstOrNull {
            it.name == "setNamespace" && it.parameterTypes.size == 1
        }
        setNamespace?.invoke(androidExtension, packageName)
    }

    plugins.withId("com.android.library") {
        ensureNamespaceIfMissing()
    }
    plugins.withId("com.android.application") {
        ensureNamespaceIfMissing()
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
