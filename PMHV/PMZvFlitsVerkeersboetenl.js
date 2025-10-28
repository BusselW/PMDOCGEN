// =====================================================
// ZV FLITS TEKSTEN - VERKEERSBOETE.NL
// =====================================================
// Standaard teksten voor zorgvuldigheid flits overtredingen
// =====================================================

export const PMZvFlitsVerkeersboetenl = {
    flitsApparatuur: {
        titel: "Flitsapparatuur kalibratie",
        tekst: "De flitsapparatuur was ten tijde van de overtreding gekalibreerd en functioneerde conform de technische specificaties en wettelijke voorschriften."
    },
    beeldkwaliteit: {
        titel: "Beeldkwaliteit en herkenbaarheid",
        tekst: "De beeldkwaliteit van de flitsfoto's is voldoende voor een betrouwbare identificatie van het voertuig en de verkeerssituatie."
    },
    tijdregistratie: {
        titel: "Tijdregistratie flitsmoment",
        tekst: "De tijdregistratie van het flitsmoment is accuraat en toont het exacte moment van de geconstateerde overtreding aan."
    },
    locatieGegevens: {
        titel: "Locatiegegevens verificatie",
        tekst: "De locatiegegevens van de flitsapparatuur zijn geverifieerd en komen overeen met de werkelijke locatie waar de overtreding plaatsvond."
    },
    technischeValidatie: {
        titel: "Technische validatie systeem",
        tekst: "Het complete flitssysteem is technisch gevalideerd en voldoet aan alle gestelde eisen voor betrouwbare verkeersovertredingsdetectie."
    }
};

export const PMZvFlitsVerkeersboetenComponent = ({ options, selectedOptions, onChange }) => {
    const { createElement: h } = React;

    return h('div', { className: 'standaard-teksten-container' },
        h('h4', { className: 'section-header' }, 'Voeg standaardteksten toe - ZV Flits'),
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