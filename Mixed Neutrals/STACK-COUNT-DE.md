# Konfigurierbare Kampfstack-Anzahl

Im Mixed-Neutrals-Settings-Fenster gibt es jetzt die durchklickbare Option
**Battle stacks** mit fünf Einstellungen. Links/rechts wechseln die Pfeile;
ein Klick auf Beschriftung oder Wert schaltet vorwärts. Rechtsklick zeigt die Hilfe.

| Einstellung | Gewichte für 1 / 2 / 3 / 4 / 5 / 6 / 7 Stacks |
|---|---|
| Classic | Bisheriges Verhalten einschließlich Stack Spread |
| Few stacks | 30 / 25 / 20 / 15 / 5 / 3 / 2 % |
| Balanced | 10 / 15 / 20 / 20 / 15 / 10 / 10 % |
| Many stacks | 2 / 3 / 5 / 15 / 20 / 25 / 30 % |
| Custom JSON | Eigene Werte aus `Lang/mixed neutrals stack count.json` |

Die Erstauswahl ist **Custom JSON**, damit vorhandene Einstellungen weiter gelten.
Confirm speichert die Auswahl über die bestehende Difficulty-Mod-Konfiguration
(`Runtime/difficulty mod.ini`, Abschnitt `mixed neutrals`, Schlüssel
`mix_stackCountPreset`: 0 bis 4 in obiger Reihenfolge). Cancel verwirft die Auswahl.
Die Auswahl gilt für neu initialisierte Karten. Bestehende Armeen werden nicht
nachträglich umgebaut. Die Anzeige unter der Option erklärt die Wirkung auf Spread.

Die JSON-Werte einschließlich `enabled` und Kreaturenausnahmen werden nur bei
**Custom JSON** ausgewertet. Feste Presets verändern die JSON-Datei nicht.
Ohne Difficulty-Mod-Oberfläche verwendet Mixed Neutrals standardmäßig Custom JSON.

Die Datei `Lang/mixed neutrals stack count.json` konfiguriert die eigene Verteilung.
Nach jeder Änderung das Spiel vollständig neu starten und eine neue Karte beginnen.
Bestehende Spielstände behalten ihre beim ersten Spieltag gespeicherten Armeen.

## Einstellungen

- `enabled`: Unter Custom JSON aktiviert `1` die neue Anzahlverteilung; `0` verwendet die bisherigen Regeln einschließlich Stack Spread.
- `chance1` bis `chance7`: Gewichte für die jeweilige Anzahl. Bei Summe 100 entsprechen sie Prozenten. Andere Summen werden proportional ausgewertet: siebenmal 1 bedeutet gleiche Chancen.
- Ein Gewicht von 0 schließt die Anzahl aus. Fehlende globale Gewichte sind 0. Negative Werte werden auf 0 begrenzt, Werte über 1000000 auf 1000000.
- Sind alle Gewichte 0, gelten die bisherigen Regeln einschließlich Stack Spread.

Voreinstellung: 10 / 15 / 20 / 20 / 15 / 10 / 10 Prozent für 1 bis 7 Stacks.
Zum Erzwingen von drei Stacks `chance3` auf `100` und alle anderen Chancen auf `0` setzen.
Für gleichverteilte 1 bis 6 Stacks `chance1` bis `chance6` auf `1` und `chance7` auf `0` setzen.

## Ausnahmen pro Kreaturenart

Innerhalb von `stackCount` kann beispielsweise zusätzlich stehen:

```json
"mon34": {
  "enabled": "1",
  "chance1": "100",
  "chance2": "0",
  "chance3": "0",
  "chance4": "0",
  "chance5": "0",
  "chance6": "0",
  "chance7": "0"
}
```

34 ist die Kartenkreaturen-ID der Magier. Zwischen dem vorangehenden Feld und
`mon34` muss ein Komma stehen. Jedes fehlende Feld einer solchen Ausnahme erbt
den globalen Wert. `enabled: "0"` stellt für diese Kreatur das alte Verhalten her.
Eine lokale Aktivierung funktioniert auch bei globalem `enabled: "0"`.

## Verhalten und Grenzen

Die Anzahl wird einmal bei der automatischen Kartengenerierung des Mods am
ersten Spieltag ausgelost. Der Mod speichert die erzeugte Zusammensetzung und
unterbindet für sie das zusätzliche Aufteilen auf freie Slots. Vorschau und Kampf
lesen dieselbe gespeicherte Konfiguration. Es gibt keine erneute Auslosung beim
Anklicken, Laden oder Angreifen. Nach Verlusten wird wie bisher aus dem verbleibenden
Kampfwert und der gespeicherten Zusammensetzung die aktuelle Armee berechnet.

Bei automatischen Armeen bestimmen `minNumNeutralStacks` und
`maxNumNeutralStacks` weiterhin die Anzahl der Ausgangsstacks der Mischung.
Nur wenn weniger Kampfslots ausgelost wurden, wird diese Mischung auf die
Kampfslotanzahl begrenzt. Anschließend werden die Ausgangsstacks möglichst
gleichmäßig auf die ausgeloste Anzahl aufgeteilt, ohne weitere Arten zu ziehen.
Beispiel: Min/Max Mix 2 und fünf Kampfslots ergibt zwei Ausgangsstacks,
von denen einer in drei und einer in zwei Teilstacks aufgeteilt wird.
Jeder Ausgangsstack behält dabei insgesamt seinen Anteil am Kampfwertbudget.
Die Ausgangsstacks können dieselbe Art enthalten; Min/Max Mix garantiert daher
keine entsprechende Anzahl verschiedener Arten.
Die bisherige anfängliche Slotwahl bleibt bestehen; zusätzliche Teilstacks
belegen freie Slots von oben nach unten. Spread füllt nicht mehr auf sieben auf.
Dies ist keine neue Schlachtfeld-Formation.
Der bestehende Code packt leere Slots beim Kampfaufbau weiterhin zusammen.

Der erste Ausgangsstack enthält die Kartenkreatur. Weitere Ausgangsstacks
verwenden die bisherigen Fraktions-, Level- und Generatorregeln. Dieselbe Art
kann mehrfach vorkommen. Das Kampfwertbudget wird auf die gewünschte Anzahl
verteilt, ohne es zu erhöhen. Bei kleinen Armeen können Rundungen oder fehlende
passende Kreaturen die tatsächliche Anzahl reduzieren. Eine Mindestanzahl von
Kreaturen wird durch diese Erweiterung nicht erzwungen.

Bestehende eigene `mix.mon<ID>`-Vorlagen und `mix.monANY`-Vorlagen mit `custom`
haben Vorrang und behalten einschließlich ihrer Spread-Einstellungen ihr Verhalten.
Die Erweiterung betrifft wie der bisherige Mod Kämpfe menschlicher Angreifer
gegen neutrale Kartenkreaturen. Sie ändert weder KI-Kämpfe noch Erfahrung oder Moral.

## Spieltest

1. Drei Stacks erzwingen, neues Spiel starten und mehrere ausreichend große
   neutrale Armeen in Vorschau und Kampf vergleichen.
2. Dasselbe mit einem und sieben Stacks wiederholen.
3. Gemischte Chancen einstellen und auf einer neuen Karte mehrere Armeen prüfen.
4. Speichern und laden: Zusammensetzung und Anzahl müssen gleich bleiben.
5. `enabled` auf `0` setzen und auf einer neuen Karte das bisherige Spread-Verhalten prüfen.
6. Alle fünf UI-Einstellungen in beide Richtungen durchschalten. Confirm und
   erneutes Öffnen müssen die Auswahl erhalten, Cancel muss die gespeicherte
   Auswahl wiederherstellen. Auch nach Neustart muss sie erhalten bleiben.
7. Mit Few/Balanced/Many jeweils neue Karten erzeugen. Bei ausreichenden Mengen
   sollte sich über viele neutrale Armeen die entsprechende Häufigkeit zeigen.
8. Unter Classic muss das alte Spread-Verhalten gelten; Custom JSON muss die
   eigenen Werte verwenden. Min/Max Mix z. B. auf 2/2 setzen und kontrollieren,
   dass höhere Kampfstackanzahlen nur diese Ausgangsmischung aufteilen.

Die statischen Prüfungen ersetzen keinen Test in der ERA-Spielengine.
