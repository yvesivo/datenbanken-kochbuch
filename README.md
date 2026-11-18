# Szenario
Die Datenbank bildet die Grundlage für eine Rezepte App für Haushalte: Benutzer gehören zu einem Haushalt und pflegen gemeinsam eine Rezeptsammlung. Rezepte bestehen aus Zutaten mit Menge und Einheit sowie Zubereitungsschritten.
Außerdem führt jeder Haushalt seinen Vorrat. Mitglieder tragen ein, welche Zutaten in welcher Menge vorhanden sind und gegebenenfalls wann sie ablaufen.

# Nutzen
- Entscheidungshilfe fürs Kochen
- Lebensmittelverschwendung verringern
- Einkaufsliste direkt aus Rezept und Vorräten ableiten

# Abgrenzung
- Keine Menü Empfehlungen. 
- Keine Benutzeroberfläche.
- Keine Beachtung von Lebensmittelunverträglichkeiten pro Koch
- Keine Ersatzproduktempfehlungen (Margarine statt Butter)

# Drei Fragen 
1. Welche saisonalen Gerichte kann ich mit meinem vorhandenen Vorrat zubereiten?
2. Welche Gerichte eines bestimmten Typs habe ich seit mehr als 90 Tagen nicht mehr gekocht?
3. Welche Rezepte verbrauchen die meisten Zutaten, die bald (in 3 Tagen) ablaufen oder nicht mehr frisch sind?

# Begründung Entwurfsentscheidungen ERM 
Dieser Text wurde von KI auf Rechtschreibung überprüft.

Ein Haushalt ist in unserer Größenordnung eindeutig durch den Namen erkennbar, wodurch dieser den Primärschlüssel darstellt. In diesem Haushalt können mehrere Personen sein, die eindeutig durch den Primärschlüssel E-Mail gekennzeichnet sind und zusätzlich den Vornamen als Attribut besitzen, um den Rezepten einen Vornamen zuzuordnen. Dies hilft beispielsweise bei einer Abfrage wie „Wer hat dieses Rezept gekocht?”. Die Person Attribute werden nun weiter vererbt an entweder Rezeptersteller oder Koch. 

Hierbei handelt es sich um eine total und überlappende Spezialisierung, da eine Person mindestens ein Koch oder Rezeptersteller sein muss, aber ein Koch auch ein Rezeptersteller sein kann. Ein Rezeptersteller kann nun mehrere Rezepte oder Keins erstellen. Somit kann man sich als Rezeptersteller registrieren, ohne direkt ein Rezept erstellen zu müssen. Ein Rezept kann immer nur von einem Ersteller erstellt werden. Mehrere Köche können ein Rezept kochen und mehrere Rezepte können von einem Koch gekocht werden, wobei die Verbindung kocht das Attribut „Notiz” besitzt. Dies nützt bei einer Abfrage von schon gekochten Rezepten, auf vergangene Gedanken zurückzugreifen. 

Ein Rezept besitzt einen künstlichen Primärschlüssel Rezept_ID, da der Name allein nicht ausreicht, um zum Beispiel zwischen verschiedenen Pfannkuchenrezepten von mehreren Erstellern zu unterscheiden und es auch möglich ist, dass ein Ersteller mehrere Pfannkuchenrezepte besitzt. Somit besitzt Rezept noch die Attribute Name und Portionen, welches festlegt in welchen Mengen die Zutaten pro Portion für das Rezept benötigt werden. Ein Rezept hat nun ein Mahlzeitentyp (z.B. Mittagessen), wobei mehrere Rezepte zu einem Mahlzeitentyp gehören können. Ein Mahlzeitentyp wird nun spezialisiert durch ein Gerichttyp (z.B. Suppe), welcher den Namen und Saison als Primärschlüssel besitzt. Mehrere Gerichtstypen können zu einer Mahlzeitentyp gehörenen. 
Zu den Rezepten gehöhren mehrere Schritte. Dies ist eine schwache Entität, da sie nur durch ein bestehendes Rezept existieren kann. Ihr Primärschlüssel wird demnach durch die rezept_id und das Reihenfolge Attribut festgelegt. 

Jedes Rezept benötigt mehere Zutaten. Die benötigt Beziehung besitzt eigene Attribute wie Menge und Einheit, da diese von dem Rezept und der Zutat abhängen. Eine Zutat besitzt als Primärschlüssel ihren Namen (z.B. Zucker) plus ihre Spezifikation (z.B. Puder), wodurch die Zutat eindeutig ist. Bei reinem Zucker bleibt die Spezifikation leer ??? Oder ist „rein”. Jede Zutat hat eine Kategorie, welche ihre Zugehörigkeit (z.B. Obst, Gewürz) und ihre Frischedauer beinhaltet. 

Jede Zutat kann in mehreren Haushalten gespeichert werden. Diese Lagerung Beziehung besitzt die Attribute Menge, MHD, Einheit, Kaufdatum und FrischBis. Die Lagerung ist keine eigene Entität weil ???. Das FrischBis Attribut ist ein berechnetes Attribut aus der Frischedauer und dem Kaufdatum. Dieses Attribut dient für Kategorien wie Obst oder Gemüse die kein klassisches MHD haben, um eine geschätzten Frischezeitraum zu haben.


# Begründung Überführung ERM zu Relationsmodell
# Data Dictionary an dem Beispiel HIER WAS EINFÜGEN