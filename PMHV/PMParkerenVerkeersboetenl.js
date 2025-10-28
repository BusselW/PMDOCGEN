// =====================================================
// PARKEREN TEKSTEN - VERKEERSBOETE.NL
// =====================================================
// Standaard teksten voor parkeerovertredingen
// =====================================================

export const PMParkerenVerkeersboetenl = {
    parkeerbordAnalyse: {
        titel: "Parkeerbord analyse",
        tekst: "De parkeerborden ter plaatse waren duidelijk zichtbaar en gaven een ondubbelzinnige indicatie over de parkeerregels die ter plaatse van toepassing waren."
    },
    parkeerdruk: {
        titel: "Parkeerdruk en alternatieven",
        tekst: "Er waren voldoende legale parkeermogelijkheden in de nabije omgeving beschikbaar, waardoor de overtreding niet noodzakelijk was."
    },
    markering: {
        titel: "Wegmarkering en parkeervakken",
        tekst: "De wegmarkering en parkeervakken waren duidelijk aangegeven en in goede staat, zodat de parkeerregels goed waarneembaar waren."
    },
    parkeerverbod: {
        titel: "Geldigheid parkeerverbod",
        tekst: "Het parkeerverbod ter plaatse was rechtsgeldig ingesteld conform de geldende procedures en was van kracht ten tijde van de overtreding."
    },
    betaalmogelijkheden: {
        titel: "Betaalmogelijkheden parkeren",
        tekst: "Er waren voldoende en functionerende betaalmogelijkheden aanwezig om legaal te kunnen parkeren in het betreffende gebied."
    }
};

export const PMParkerenVerkeersboetenComponent = ({ options, selectedOptions, onChange }) => {
    const { createElement: h } = React;

    return h('div', { className: 'standaard-teksten-container' },
        h('h4', { className: 'section-header' }, 'Voeg standaardteksten toe - Parkeren'),
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