// =====================================================
// RIJGEDRAG TEKSTEN - VERKEERSBOETE.NL
// =====================================================
// Standaard teksten voor rijgedrag overtredingen
// =====================================================

export const PMRijgedragVerkeersboetenl = {
    rijgedragAnalyse: {
        titel: "Rijgedrag analyse",
        tekst: "Het waargenomen rijgedrag wijkt af van wat van een zorgvuldige bestuurder mag worden verwacht in de gegeven verkeerssituatie."
    },
    verkeersveiligheid: {
        titel: "Impact op verkeersveiligheid",
        tekst: "Het getoonde rijgedrag had een negatieve impact op de verkeersveiligheid en bracht andere weggebruikers in gevaar."
    },
    rijvaardigheden: {
        titel: "Verwachte rijvaardigheden",
        tekst: "Van een bestuurder met een geldig rijbewijs mogen basale rijvaardigheden en verkeerskennis worden verwacht die in deze situatie niet werden getoond."
    },
    alternatieveHandeling: {
        titel: "Alternatieve handelingsmogelijkheden",
        tekst: "Er waren alternatieve handelingsmogelijkheden beschikbaar waarmee de overtreding voorkomen had kunnen worden."
    },
    voorspelbaarheid: {
        titel: "Voorspelbaarheid verkeerssituatie",
        tekst: "De verkeerssituatie was voorspelbaar en een ervaren bestuurder had hierop adequaat moeten kunnen anticiperen."
    }
};

export const PMRijgedragVerkeersboetenComponent = ({ options, selectedOptions, onChange }) => {
    const { createElement: h } = React;

    return h('div', { className: 'standaard-teksten-container' },
        h('h4', { className: 'section-header' }, 'Voeg standaardteksten toe - Rijgedrag'),
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