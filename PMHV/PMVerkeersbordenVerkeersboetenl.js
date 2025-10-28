// =====================================================
// VERKEERSBORDEN TEKSTEN - VERKEERSBOETE.NL
// =====================================================
// Standaard teksten voor verkeersborden overtredingen
// =====================================================

export const PMVerkeersbordenVerkeersboetenl = {
    nietVoldaanKader: {
        titel: "Niet voldaan aan vereiste beoordelingskader",
        tekst: "Niet voldaan aan vereist beoordelingskader\nBetrokkene ontkent de gedraging te hebben verricht en is van oordeel dat niet is voldaan aan een of meerdere vereisten uit het Beoordelingskader digitale handhaving geslotenverklaringen (hierna: het beoordelingskader). Indien een gemeente digitaal wil handhaven op C- of G-borden, gelden strikte vereisten. Deze vereisten staan vermeld in het beoordelingskader. Het hof toetst indringend aan dit kader, en wel per voorwaarde. Zie het arrest van 1 september 2022 (ECLI:NL:GHARL:2022:7566). Uit het dossier volgt bijvoorbeeld dat weggebruikers onvoldoende worden gewaarschuwd middels vooraankondigingsborden. Het gevolg is dat ze in een fuik zijn gereden."
    },
    onvoldoendeOndervangen: {
        titel: "onvoldoende ondervangen",
        tekst: "Onvoldoende ondervangen\nHet beoordelingskader geeft nadere vereisten aan de wijze waarop de gedraging moet worden vastgesteld. De beleidsregels bepalen onder meer dat het bord zichtbaar moet zijn op de foto. Op de foto zie ik geen C- of G-bord en dat is in strijd met de beleidsregels. De vraag is of een en ander op andere wijze is ondervangen. Daarvan blijkt niet, althans onvoldoende, uit het dossier."
    },
    geenInstemmingOM: {
        titel: "geen aanvraag/instemming OM (boa niet bevoegd)",
        tekst: "Geen aanvraag/instemming OM (boa niet bevoegd)\nVoor beschikkingen die zijn opgelegd na 1 juli 2021 dient de bevoegdheid te worden beoordeeld op basis van de Regeling domeinlijsten BOA. Hierin staat vermeld dat digitaal handhaven slechts mogelijk is op overtredingen van het RVV en na instemming van het Openbaar Ministerie. Een aanvraag tot instemming wordt getoetst aan de door het Openbaar Ministerie vastgestelde kaders. Het Hof Arnhem-Leeuwarden overweegt omtrent dit 'Beoordelingskader digitale handhaving geslotenverklaringen en voetgangersgebieden' dat het de wijze en omstandigheden formuleert waaronder een verbalisant bevoegd is tot handhaving. A contrario het arrest van 1 september 2022 (ECLI:NL:GHARL:2022:7566). Aldus toetst het hof indringend aan de voorwaarden van het beoordelingskader. De toepasselijke kaders zijn te vinden op www.om.nl."
    },
    geenWaarschuwingsbrieven: {
        titel: "Geen waarschuwingsbrieven ontvangen.",
        tekst: "Geen waarschuwingsbrieven ontvangen\nBetrokkene heeft verklaard dat hij nimmer een waarschuwingsbrief van de instantie heeft ontvangen. Uit het arrest van het Hof Arnhem-Leeuwarden van 7 december 2022 (ECLI:NL:GHARL:2022:10521) kan worden afgeleid dat wanneer in een zaak het beoordelingskader van toepassing is en betrokkene geen waarschuwingsbrief heeft ontvangen, de inleidende beschikking vernietigd dient te worden. Ik ben van oordeel dat ook nu het beoordelingskader van toepassing is, de regel omtrent het waarschuwen van eerste overtreders van toepassing moet zijn."
    },
    onvoldoendeSignalering: {
        titel: "Onvoldoende signalerende werking.",
        tekst: "Onvoldoende signalerende werking\nDe bebording aldaar heeft een dusdanig onvoldoende signalerende werking dat weggebruikers als gevolg daarvan niet, althans onvoldoende, op de hoogte worden gebracht van het geldende verkeersregime."
    },
    onjuisteBebording: {
        titel: "onjuiste bebording.",
        tekst: "Betrokkene betwist dat de juiste bebording is geplaatst. Uit het dossier blijkt niet dat kort voor aanvang van de gedraging de bebording is gecontroleerd. Nu de aanwezigheid van de vermeende bebording cruciaal is om de gedraging vast te kunnen stellen, ligt het op de weg van de officier van justitie om informatie te verstrekken waaruit blijkt dat vlak voor en na de vermeende pleegdatum de bebording in orde was."
    },
    gedragingNietVastTeStellen: {
        titel: "gedraging niet vast te stellen.",
        tekst: "Gedraging niet vast te stellen. Betrokkene is van oordeel dat de gedraging niet is vast te stellen op basis van de beschikbare gegevens. De gedraging kan niet worden vastgesteld. De inleidende beschikking komt voor vernietiging in aanmerking."
    },
    onterechtNietStaandeGehouden: {
        titel: "onterecht niet staande gehouden.",
        tekst: "Indien een reële mogelijkheid bestaat om betrokkene staande te houden dan mag daarvan niet worden afgeweken. Zie art. 5 WAHV. Verbalisant dient zich zo mogelijk ervan te vergewissen dat degene die de overtreding begaat ook de bestuurder is. Voor zover de verbalisant aanstonds kan vaststellen wie de gedraging heeft verricht zou hij de bestuurder moeten staande houden. Schending van art. 5 WAHV rechtvaardigt vernietiging van de inleidende beschikking."
    }
};

export const PMVerkeersbordenVerkeersboetenComponent = ({ options, selectedOptions, onChange }) => {
    const { createElement: h } = React;

    return h('div', { className: 'standaard-teksten-container' },
        h('h4', { className: 'section-header' }, 'Voeg standaardteksten toe - Verkeersborden'),
        Object.keys(options).map(key => {
            const option = options[key];
            return h('div', { key: key, className: 'input-group' },
                h('label', { className: 'checkbox-label' },
                    h('input', {
                        type: 'checkbox',                        
                        checked: selectedOptions[key] === true,
                        onChange: () => onChange(key)
                    }),
                    option.titel
                )
            );
        })
    );
};