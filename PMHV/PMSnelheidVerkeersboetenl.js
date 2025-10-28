// =====================================================
// SNELHEID TEKSTEN - VERKEERSBOETE.NL
// =====================================================
// Standaard teksten voor snelheidsovertredingen
// =====================================================

export const PMSnelheidVerkeersboetenl = {
    kalibratieMeting: {
        titel: "Kalibratie meetapparatuur",
        tekst: "De gebruikte snelheidsmeetapparatuur was ten tijde van de meting gekalibreerd conform de wettelijke voorschriften en functioneerde correct."
    },
    meetmethode: {
        titel: "Meetmethode en nauwkeurigheid",
        tekst: "De toegepaste meetmethode voldoet aan de gestelde eisen. De meting is uitgevoerd met gecertificeerde apparatuur met een bewezen nauwkeurigheid."
    },
    meetomstandigheden: {
        titel: "Meetomstandigheden",
        tekst: "De weersomstandigheden en overige omstandigheden ten tijde van de meting waren geschikt voor een betrouwbare snelheidsmeting."
    },
    correctieFactoren: {
        titel: "Correctiefactoren toegepast",
        tekst: "Alle wettelijk voorgeschreven correctiefactoren zijn conform de regelgeving toegepast op de gemeten snelheid."
    },
    maximumSnelheid: {
        titel: "Geldende maximumsnelheid",
        tekst: "De geldende maximumsnelheid ter plaatse was duidelijk aangegeven door de aanwezige verkeersborden en gold ten tijde van de overtreding."
    },
    meetpunt: {
        titel: "Locatie meetpunt",
        tekst: "Het meetpunt was zodanig gekozen dat een representatieve en betrouwbare snelheidsmeting mogelijk was conform de richtlijnen."
    }
};

export const PMSnelheidVerkeersboetenComponent = ({ options, selectedOptions, onChange }) => {
    const { createElement: h } = React;

    return h('div', { className: 'standaard-teksten-container' },
        h('h4', { className: 'section-header' }, 'Voeg standaardteksten toe - Snelheid'),
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