# material_ui_packages_migration

A small Flutter app that depends on four third-party packages, migrated from
the SDK's Material to the standalone
[`material_ui`](https://pub.dev/packages/material_ui) package, with every step
measured.

It is the companion repository of the article
**Your packages haven't migrated to `material_ui`. Can you?**
The first article, on an app with no third-party UI package, has its own
repository: [material_ui_migration](https://github.com/marwaMejri/material_ui_migration).

Tested with Flutter 3.47.7, Dart 3.13.5 and `material_ui` 1.7.0, between 15 and
19 October 2026.

## The app and its packages

Notely is a fictional note-taking app. This repository only contains its
release notes reader: three screens, and four packages, each where a real app
would use it.

| Screen | Package | Version before | Version after | Case |
|---|---|---|---|---|
| The whole app (theme font) | `google_fonts` | 8.2.1 | 9.0.0 | loud, fixed by an upgrade |
| Settings (form field) | `dropdown_button2` | 3.1.0 | 3.1.0 | loud, no migrated version |
| Release details (Markdown) | `flutter_markdown_plus` | 1.0.12 | 1.0.12 | silent |
| Release list (navigation) | `go_router` | 17.5.0 | 18.1.0 | silent, and reversed |

The theme is far from the default on purpose (teal, Merriweather, a pale yellow
`cardTheme`), so that a widget that loses it is easy to see.

## Tags and commits

One commit per step, so that each result can be checked out.

| Commit | Tag | State |
|---|---|---|
| `78411b8` | `before-migration` | the app on the SDK Material, versions pinned, 5 tests green |
| `9c9b845` | `after-dart-fix` | right after `dart fix --apply --code=migrate_design_widgets`. **Does not compile**, on purpose |
| `0922224` | `after-google-fonts` | `google_fonts` 9.0.0: one error left, in the settings screen |
| `db45ab3` | | `dropdown_button2`, try 1 (SDK `InputDecoration` under a prefix): compiles, red screen. Also fixes the Markdown font test |
| `aeb1a1b` | | `dropdown_button2`, try 2 (SDK `Material` around the field): second red screen |
| `b912688` | | `dropdown_button2`, try 3 (`MaterialUiCompatibilityBridge`): the field works |
| `66c43ec` | | `go_router` 18.1.0: page transitions are back |
| `9c28faf` | `after-migration` | Markdown style sheet, real version constraints, bridge documented. 5 tests green, `flutter analyze` clean |

The script in `tool/` was added after the migration.

## Measurements

Every command output quoted in the article is in `measurements/`.

| File | What it shows |
|---|---|
| `before-deps.txt`, `before-outdated.txt` | the dependencies before the migration, and the latest versions on 15 October |
| `before-analyze.txt`, `before-test.txt` | the app before the migration: no issues, 5 tests green |
| `02-dryrun.txt` | `dart fix --dry-run`: 7 fixes in 7 files, nothing about the packages |
| `03-apply.txt`, `04-dartfix.diff`, `05-pubget.txt` | what `dart fix` changed, and the dependencies it added |
| `06-analyze.txt`, `07-test.txt` | two type errors, and the tests do not load |
| `08-google-fonts-9.txt`, `09-analyze.txt` | `google_fonts` 9.0.0 removes the first error |
| `10-analyze.txt`, `11-test.txt` | `dropdown_button2` try 1: it compiles, then three tests fail |
| `12-baseline-markdown-test.txt` | the corrected Markdown tests pass on the app before the migration |
| `13-markdown-test.txt` | the same tests fail on the migrated app: Roboto instead of Merriweather |
| `14-debug-markdown.txt` | why the first version of the font test passed for the wrong reason |
| `15-analyze.txt`, `16-settings-test.txt` | `dropdown_button2` try 2 |
| `17-analyze-bridge.txt`, `17b-analyze-exit-code.txt` | the bridge is deprecated, and its `info` makes `flutter analyze` exit with code 1 |
| `18-test-bridge.txt` | with the bridge: the Markdown text is fixed, not the code block |
| `19-go-router-18.txt`, `20-analyze.txt`, `21-navigation-test.txt` | `go_router` 18.1.0 brings the transitions back |
| `22-baseline-add-go-router.txt`, `23-baseline-navigation-test.txt` | the reversed case: `go_router` 18.1.0 in the app before the migration |
| `24-analyze-fromtheme.txt` | `MarkdownStyleSheet.fromTheme` does not accept the `material_ui` theme |
| `25-analyze.txt`, `26-test.txt` | the hand-written style sheet: 5 tests green |
| `27-final-analyze.txt`, `28-final-test.txt` | the final state: no issues, exit code 0, 5 tests green |
| `29-baseline-google-fonts-9.txt` | `google_fonts` 9.0.0 also breaks the app before the migration |
| `30-check-after.txt`, `31-check-before.txt` | the output of the dependency check script, after and before |

## Run it

```bash
flutter pub get
flutter test
```

## Check your own dependencies

`tool/check_design_imports.dart` lists the dependencies that still import the
SDK's Material or Cupertino, and the ones that already use `material_ui` or
`cupertino_ui`. Copy it into your project, then from its root:

```bash
flutter pub get
dart run tool/check_design_imports.dart
```

It only reads the imports in each package's `lib/` folder. The number of
`Theme.of` reads it prints is a hint, not a proof: `go_router` 17.5.0 reads the
theme zero times and still breaks in a migrated app. It was run on Windows only.

## Reproduce the reversed case

On the app before the migration, an unversioned upgrade of `go_router` brings
`material_ui` in, and the page transitions stop:

```bash
git checkout before-migration
flutter pub add go_router
flutter test test/navigation_test.dart
git checkout -- .
git checkout main
```