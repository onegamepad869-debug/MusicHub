# MusicHub

YouTube Music och SoundCloud i en egen iOS-app: flikar för båda, reklamblockering och bakgrundsuppspelning. Byggs gratis med GitHub Actions och installeras med SideStore. Ingen Mac och ingen dekrypterad IPA behövs.

## Bygga

Varje gång något pushas till `main` byggs appen automatiskt. Du kan också köra bygget för hand: **Actions → Build MusicHub → Run workflow**.

Efter ungefär 5 minuter ligger `MusicHub.ipa` under **Releases**.

## Installera på iPhone (SideStore)

**Enklast: lägg till som källa (görs en gång)**

1. Öppna SideStore → **Sources** → **+**.
2. Klistra in (byt `DITTNAMN` mot ditt GitHub-användarnamn):
   ```
   https://github.com/DITTNAMN/MusicHub/releases/latest/download/apps.json
   ```
3. Öppna källan och tryck **Free / Get** på MusicHub.

Nya versioner dyker sedan upp under **My Apps → Updates**.

**Alternativ: installera filen direkt**

1. Öppna releasesidan i Safari på iPhonen och tryck på `MusicHub.ipa`.
2. SideStore → **My Apps** → **+** → välj filen i Hämtade filer.

Kom ihåg att göra **Refresh** i SideStore minst var 7:e dag.

## Använda

- **Byt tjänst** med flikarna längst ner.
- **Tryck på fliken du redan är på** för att gå tillbaka till startsidan.
- **Svep från vänsterkanten** för att gå bakåt.
- Logga in i varje flik en gång, inloggningen sparas.

## Anpassa

| Vad | Var |
|---|---|
| Lägga till eller ta bort tjänster | `Sources/MusicService.swift` |
| Blockerade reklamadresser | `Sources/ContentBlocker.swift` |
| Skript som håller musiken igång och skippar YouTube-reklam | `Sources/Scripts.swift` |
| Appnamn, version och bundle ID | `project.yml` |
| Ikon | `Resources/Assets.xcassets/AppIcon.appiconset/icon.png` (1024×1024) och `icon.png` |

## Kända begränsningar

- Det är webbversionerna av tjänsterna inuti appen, så känslan blir som mobilsajten.
- Ingen CarPlay och inga nedladdningar för offline.
- Reklamblockeringen kan sluta fungera när YouTube ändrar något. Då behöver `Scripts.swift` uppdateras.
- Om en sajt visar en trasig sida eller "skaffa appen": byt `userAgent` till `desktopSafari` i `MusicService.swift`.
