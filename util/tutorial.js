export const tutorialSteps = [
    {
        targetId: 'document-type-toggle',
        fallbackId: 'steps-sidebar',
        message: "Welkom bij de Document Generator Tutorial! Hier wissel je tussen Hoorverslag en Beslissing. Let op: veel nieuwe functies zijn specifiek voor Hoorverslagen.",
    },
    {
        targetId: 'subtype-tabs',
        fallbackId: 'form-content-area',
        message: "Selecteer hier een subtype, zoals Telefonisch/Fysiek voor een Hoorverslag, of een bedrijf voor een Beslissing.",
    },
    {
        targetId: 'category-select',
        fallbackId: 'steps-sidebar',
        message: "🆕 NIEUW: Voor hoorverslagen kun je hier een categorie selecteren (Verkeersborden, Snelheid, etc.). Dit bepaalt welke standaardteksten beschikbaar zijn in Stap 3. (Alleen zichtbaar bij hoorverslagen)",
        requiresHoorverslag: true,
    },
    {
        targetId: 'steps-sidebar',
        fallbackId: 'form-content-area',
        message: "Navigeer door de formuliersecties met deze stappen. De actieve stap is gemarkeerd.",
    },
    {
        targetId: 'beoordelaar-voorletters',
        fallbackId: 'form-content-area',
        message: "🆕 NIEUW: Let op de sync-knop (⤴) naast naam-velden! Hiermee kopieer je gegevens naar ALLE hoorverslagen in één keer - handig voor beoordelaar/griffier namen. (Ga naar Stap 1 om deze te zien)",
        requiresHoorverslag: true,
    },
    {
        targetId: 'form-content-area',
        message: "💡 PROBEER HET: Vul naam-gegevens in Stap 1 in en klik op de sync-knop (⤴). Deze data wordt naar alle 20 hoorverslagen gekopieerd! Perfect voor beoordelaars die meerdere zaken behandelen.",
    },
    {
        targetId: 'form-content-area',
        message: "Dit is het hoofdformulier. Velden passen zich aan op basis van je keuzes en geselecteerde categorie.",
    },
    {
        targetId: 'bedrijfs-naam',
        fallbackId: 'form-content-area',
        message: "🆕 NIEUW: Voor bedrijven zoals 'verkeersboete.nl' of 'skandara' krijg je automatisch categoriespecifieke standaardteksten in Stap 3! (Ga naar Stap 1 om bedrijfsnaam in te vullen)",
        requiresHoorverslag: true,
    },
    {
        targetId: 'form-content-area',
        message: "💡 TIP: Ga naar Stap 3 om de nieuwe checkbox-functionaliteit te zien! Categorieën bevatten juridische standaardteksten die automatisch in je document verschijnen.",
    },
    {
        targetId: 'hoorverslag-navigatie-container',
        fallbackId: 'preview-panel-area',
        message: "🆕 NIEUW: De hoorverslag-navigatie onderin! Schakel tussen tot 20 verschillende hoorverslagen. Elke heeft eigen gegevens en checkbox-selecties. Gebruik pijltjestoetsen voor snelle navigatie.",
        requiresHoorverslag: true,
    },
    {
        targetId: 'hoorverslag-navigatie-container',
        fallbackId: 'preview-panel-area',
        message: "🔄 PROBEER HET UIT: Klik op de pijl-rechts knop in de navigatiebalk onderin of druk op → om naar hoorverslag 2 te gaan. Je zult zien dat alle velden leeg zijn - elk hoorverslag heeft zijn eigen data!",
        requiresHoorverslag: true,
    },
    {
        targetId: 'preview-panel-area',
        message: "Hier zie je een live voorvertoning van het document. De inhoud past zich automatisch aan op basis van je categorie-keuze en checkbox-selecties.",
    },
    {
        targetId: 'save-docx-button',
        fallbackId: 'preview-panel-area',
        message: "💾 NIEUW: Word Export! Voor hoorverslagen exporteert deze knop ALLE opgeslagen hoorverslagen naar één Word-document met automatische paginaeinden tussen elk hoorverslag.",
        requiresHoorverslag: true,
    },
    {
        targetId: 'help-button',
        fallbackId: 'preview-panel-area',
        message: "🎯 SAMENVATTING VAN NIEUWE FUNCTIES:\n• Categorieën: Verkeersborden, Snelheid, ZV Zicht & Plicht, Rijgedrag, Parkeren, ZV Flits\n• Sync-knoppen (⤴): Kopieer velden naar alle 20 hoorverslagen\n• Multi-hoorverslag navigatie: Pijltjestoetsen ← →\n• Automatische opslag per hoorverslag\n• Bedrijfsspecifieke standaardteksten\n\nDe tutorial is voltooid!",
    }
];