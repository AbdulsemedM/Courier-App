# OTA updates (Shorebird + Firebase Remote Config)

This app ships Dart/logic fixes over the air with **Shorebird**, and uses **Firebase Remote Config** as a safety net for store-required updates and emergency patch kill-switches.

## What can be patched vs what needs a store release

### Patch via Shorebird (Dart-only)

- Dart business logic and bug fixes
- Most UI / widget / navigation behavior changes
- Text, validation, API client logic that does not require new native plugins

### Store release required (do **not** try to patch)

- Native Android / iOS code changes
- New or changed Flutter plugins with native code
- `pubspec.yaml` dependency version changes
- Permission or platform config changes (`AndroidManifest.xml`, `Info.plist`, entitlements, Gradle native settings)

## One-time Shorebird setup

1. Install CLI: https://docs.shorebird.dev/getting-started/install/
2. Create / log into an account: https://console.shorebird.dev
3. On Windows, if `shorebird init` fails with `Unable to initialize gradlew` / missing `jvm.cfg` under Android Studio’s `jbr`, point Flutter at a working JDK (Shorebird prefers Studio’s JBR first):

```bash
flutter config --jdk-dir="C:\Program Files\Java\jdk-17"
```

Also set the same on Shorebird’s bundled Flutter if needed, or repair/reinstall Android Studio so `...\Android Studio\jbr\lib\jvm.cfg` exists.

4. From the project root:

```bash
shorebird login
shorebird init --force --display-name "HudHud Express"
```

5. Confirm `shorebird.yaml` has a real `app_id` and `auto_update: false`.
6. Confirm `shorebird.yaml` is listed under `flutter.assets` in `pubspec.yaml`.
7. Run `shorebird doctor` and fix any blocking mobile issues.

`auto_update: false` is required so the app can honor the Remote Config kill switch and staged rollout tracks.

## Firebase Remote Config keys

Create these keys in the Firebase Console (project `hudhud-express`) with the same defaults used in-app:

| Key | Type | Default | Purpose |
|-----|------|---------|---------|
| `minimum_supported_version` | String | `0.0.0` | Hard floor; block app if installed version is lower |
| `latest_store_version_android` | String | `0.0.0` | Latest Play Store version (logging / fallback display on Android) |
| `latest_store_version_ios` | String | `0.0.0` | Latest App Store version (logging / fallback display on iOS) |
| `kill_switch_patch_disabled` | Boolean | `false` | When `true`, app skips Shorebird check/download |
| `patch_rollout_percentage` | Number | `100` | Percent of devices (1–100 bucket) that use the `beta` track |

The app reads only the platform-specific latest-store key at runtime (`latest_store_version_android` on Android, `latest_store_version_ios` on iOS). Keep both keys updated when you ship each platform.

Force-update behavior:

1. If local version is below `minimum_supported_version` → blocking update screen.
2. Else existing Play Store check (`new_version_plus`) still runs and can also block.
3. Urovo devices keep the “Continue without updating” bypass for both cases.

## Release workflow (store-bound, patchable builds)

Use Shorebird for release artifacts that should remain patchable:

```bash
shorebird release android
shorebird release ios
```

Then upload the produced AAB / IPA to Play Store / App Store as usual.

Do **not** use plain `flutter build appbundle` / `flutter build ipa` for production builds you intend to patch later.

## Patch workflow (hotfixes)

Target the exact release version already live (example `1.0.21+36`):

```bash
# Staged first
shorebird patch android --release-version=1.0.21+36 --track=beta
shorebird patch ios --release-version=1.0.21+36 --track=beta

# After validation, full track
shorebird patch android --release-version=1.0.21+36 --track=stable
shorebird patch ios --release-version=1.0.21+36 --track=stable
```

### Staged rollout

1. Publish patch to `--track=beta`.
2. Set Remote Config `patch_rollout_percentage` low (e.g. `10`).
3. Devices with a persisted random group `1–100` receive `beta` if `group <= percentage`, otherwise `stable`.
4. Raise percentage as confidence grows; publish the same fix to `stable` when ready for everyone.
5. Set percentage back to `100` when using stable-only flow.

### Emergency kill switch

If a bad patch ships, set `kill_switch_patch_disabled = true` in Remote Config. Clients stop checking/downloading new patches until you turn it off. Users who already downloaded a bad patch may need a corrected patch or a store release depending on severity.

## In-app behavior

- On start and resume, the app silently checks for a Shorebird patch (unless kill switch is on).
- Downloads happen in the background and never force a mid-session restart.
- After a successful download (or when a restart is already required), a dismissible snackbar shows:  
  **“An update will apply next time you open the app”**
- Offline / failed downloads fail silently and retry later; they do not block app usage.

## GitHub Actions

Workflows:

- [`.github/workflows/shorebird-release.yml`](../.github/workflows/shorebird-release.yml) — manual `workflow_dispatch` for Android/iOS release
- [`.github/workflows/shorebird-patch.yml`](../.github/workflows/shorebird-patch.yml) — manual patch against a **required** `release_version` + track (`beta` default)

### Required repository secrets

| Secret | Used for |
|--------|----------|
| `SHOREBIRD_TOKEN` | Shorebird Console API key (`Account → API Keys`) |
| `KEYSTORE_BASE64` | Base64-encoded Android upload keystore |
| `KEY_PROPERTIES` | Contents of `android/key.properties` (alias/passwords/`storeFile`) |

iOS jobs are scaffolded on `macos-latest` but need your Apple signing setup (certificates + profiles, or Match) before they will succeed in CI.

### Patch precondition

A patch job must target a Shorebird release that already exists for that platform/version. Creating a patch before the corresponding `shorebird release` (and store distribution of that build) will fail.

## Manual QA checklist

1. Create an internal/staging Shorebird release; install that exact build on Android and iOS test devices.
2. Publish a trivial Dart-only patch to `--track=beta`.
3. Set `patch_rollout_percentage` so the test device is included; cold-start or resume the app.
4. Confirm logs/Crashlytics breadcrumbs show check → download; confirm snackbar appears.
5. Fully restart the app; confirm the patch behavior is active (`ShorebirdUpdater.readCurrentPatch()` / expected UI change).
6. Toggle `kill_switch_patch_disabled=true`; confirm no further patch downloads.
7. Set `minimum_supported_version` above the installed version; confirm blocking update screen (Urovo bypass still available on Urovo).
8. Airplane mode on launch: app opens normally; OTA fails silently.
9. Interrupt a patch download (network drop): app remains usable; next launch retries.
10. Only after Android + iOS validation, promote to `stable` / raise rollout to 100%.

## Observability

- `debugPrint` logs prefixed with `[OtaPatch]`, `[ForceUpdate]`, `[RemoteConfig]`
- Firebase Crashlytics breadcrumbs for OTA lifecycle events and non-fatal errors on patch failure
