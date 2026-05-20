require "xcodeproj"

project_path = "ReceiptWarrantyVault.xcodeproj"
project = Xcodeproj::Project.new(project_path)
project.root_object.attributes["LastUpgradeCheck"] = "2650"
project.root_object.attributes["BuildIndependentTargetsInParallel"] = "YES"
project.root_object.development_region = "en"
project.root_object.known_regions = ["en", "it", "Base"]

app_group = project.main_group.new_group("ReceiptWarrantyVault", "ReceiptWarrantyVault")
tests_group = project.main_group.new_group("ReceiptWarrantyVaultTests", "ReceiptWarrantyVaultTests")

app_target = project.new_target(:application, "ReceiptWarrantyVault", :ios, "17.0")
tests_target = project.new_target(:unit_test_bundle, "ReceiptWarrantyVaultTests", :ios, "17.0")
tests_target.add_dependency(app_target)

def add_file(group, path)
  group.find_file_by_path(path) || group.new_file(path)
end

Dir.glob("ReceiptWarrantyVault/**/*.swift").sort.each do |path|
  ref = add_file(app_group, path.sub("ReceiptWarrantyVault/", ""))
  app_target.add_file_references([ref])
end

[
  "Resources/Assets.xcassets",
  "Resources/Localizable.xcstrings",
  "Resources/PrivacyInfo.xcprivacy",
  "Resources/en.lproj/InfoPlist.strings",
  "Resources/it.lproj/InfoPlist.strings"
].each do |path|
  ref = add_file(app_group, path)
  app_target.add_resources([ref])
end

Dir.glob("ReceiptWarrantyVaultTests/**/*.swift").sort.each do |path|
  ref = add_file(tests_group, path.sub("ReceiptWarrantyVaultTests/", ""))
  tests_target.add_file_references([ref])
end

project.build_configurations.each do |config|
  settings = config.build_settings
  settings["ALWAYS_SEARCH_USER_PATHS"] = "NO"
  settings["CLANG_ANALYZER_NONNULL"] = "YES"
  settings["CLANG_ENABLE_MODULES"] = "YES"
  settings["CLANG_ENABLE_OBJC_ARC"] = "YES"
  settings["CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER"] = "YES"
  settings["COPY_PHASE_STRIP"] = config.name == "Release" ? "YES" : "NO"
  settings["ENABLE_STRICT_OBJC_MSGSEND"] = "YES"
  settings["ENABLE_USER_SCRIPT_SANDBOXING"] = "YES"
  settings["GCC_C_LANGUAGE_STANDARD"] = "gnu17"
  settings["IPHONEOS_DEPLOYMENT_TARGET"] = "17.0"
  settings["SDKROOT"] = "iphoneos"
  settings["STRING_CATALOG_GENERATE_SYMBOLS"] = "YES"
  settings["SWIFT_VERSION"] = "5.0"
  settings["SWIFT_EMIT_LOC_STRINGS"] = "YES"
end

app_target.build_configurations.each do |config|
  settings = config.build_settings
  settings["ASSETCATALOG_COMPILER_APPICON_NAME"] = "AppIcon"
  settings["ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME"] = "AccentColor"
  settings["CODE_SIGN_STYLE"] = "Automatic"
  settings["CURRENT_PROJECT_VERSION"] = "1"
  settings["GENERATE_INFOPLIST_FILE"] = "NO"
  settings["INFOPLIST_FILE"] = "ReceiptWarrantyVault/Resources/Info.plist"
  settings["LD_RUNPATH_SEARCH_PATHS"] = ["$(inherited)", "@executable_path/Frameworks"]
  settings["LOCALIZATION_PREFERS_STRING_CATALOGS"] = "YES"
  settings["MARKETING_VERSION"] = "0.1.0"
  settings["PRODUCT_BUNDLE_IDENTIFIER"] = "com.simo.receiptwarrantyvault"
  settings["PRODUCT_NAME"] = "$(TARGET_NAME)"
  settings["SUPPORTED_PLATFORMS"] = "iphoneos iphonesimulator"
  settings["SWIFT_APPROACHABLE_CONCURRENCY"] = "YES"
  settings["SWIFT_DEFAULT_ACTOR_ISOLATION"] = "MainActor"
  settings["SWIFT_UPCOMING_FEATURE_MEMBER_IMPORT_VISIBILITY"] = "YES"
  settings["TARGETED_DEVICE_FAMILY"] = "1"
end

tests_target.build_configurations.each do |config|
  settings = config.build_settings
  settings["BUNDLE_LOADER"] = "$(TEST_HOST)"
  settings["CODE_SIGN_STYLE"] = "Automatic"
  settings["GENERATE_INFOPLIST_FILE"] = "YES"
  settings["LD_RUNPATH_SEARCH_PATHS"] = ["$(inherited)", "@executable_path/Frameworks", "@loader_path/Frameworks"]
  settings["PRODUCT_BUNDLE_IDENTIFIER"] = "com.simo.receiptwarrantyvault.tests"
  settings["PRODUCT_NAME"] = "$(TARGET_NAME)"
  settings["SWIFT_VERSION"] = "5.0"
  settings["TARGETED_DEVICE_FAMILY"] = "1"
  settings["TEST_HOST"] = "$(BUILT_PRODUCTS_DIR)/ReceiptWarrantyVault.app/$(BUNDLE_EXECUTABLE_FOLDER_PATH)/ReceiptWarrantyVault"
end

project.save
