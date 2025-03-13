# Presentation_Paragraph_14_a
Eine kurze Präsentation zu §14a EnWG - Steuerbare Verbraucher, mit Fokus auf Erlangen und Umgebung. Die Präsentation wurde vom Verein [**Energiwende Erlangen e.V.**](https://energiewende-erlangen.de) initiiert.

Die Präsentation ist in folgene Abschnitte unterteilt:

  * Einführung in §14a
  * Technische Umsetzung
  * Wirtschaftliche Aspekte
  * Regionales
  * Und jetzt?

# Beisteuern

Falls man Fehler in der Präsentation findet (und sich ein wenig mit LaTeX auskennt), darf man diese gerne korrigieren und einen Pull-Request erstellen. Ich freue mich über jede Verbesserung.

Der einfachste Weg, die Präsentation zu ändern und zu bauen ist die Verwendung von devcontainer. Hierzu gibt es im Wesentlichen zwei Möglichkeiten.

## Codespaces

GitHub bietet jedem die freie Nutzung von Codespaces für 60 Stunden im Monat. Einfach [Codespaces](shttps://github.com/codespace) aufrufen und einen neuen Codespace erstellen oder den folgenden Link nutzen:

<a href='https://codespaces.new/the78mole/Presentation_Paragraph_14_a?quickstart=1'><img src='https://github.com/codespaces/badge.svg' alt='Open in GitHub Codespaces' style='max-width: 100%;'></a>

## Lokal

Dazu Visual Studio Code installieren und (unter Linux oder WSL) das Repository auschecken und in dessen Stammverzeichnis `code .` ausführen.

Visual Studio Code startet. Es erscheint rechts unten ein kleiner Dialog `Reopen in devcontainer`. Dies bestätigen.

Falls irgendwann Probleme mit dem Container auftauchen, dann `CTRL-SHIFT-P` tippen und `Rebuild Container without Cache` auswählen.

Um ein PDF zu generieren genügt es, eine Datei abzuspeichern. Der Build startet automatisch.

# Anpassungen des LaTeX devcontainers

  * **Probleme mit chktex:** Das Dockerfile wurde angepasst, um die fehlerhafte Zeile der globalen `chktexrc` zu deaktivieren.