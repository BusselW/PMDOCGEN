// =====================================================
// ZV ZICHT & PLICHT TEKSTEN - VERKEERSBOETE.NL
// =====================================================
// Standaard teksten voor zorgvuldigheid zicht en plicht overtredingen
// =====================================================

export const PMZvZichtPlichtVerkeersboetenl = {
    zichtOnderzoek: {
        titel: "Zichtonderzoek ter plaatse",
        tekst: "Er is een uitgebreid zichtonderzoek uitgevoerd ter plaatse. Het zicht was ten tijde van de overtreding voldoende om de verkeerssituatie adequaat waar te nemen."
    },
    zorgvuldigheidsPlicht: {
        titel: "Zorgvuldigheidsplicht bestuurder",
        tekst: "De bestuurder had een zorgvuldigheidsplicht om het verkeer goed waar te nemen en hierop adequaat te reageren conform artikel 5 WVW 1994."
    },
    waarnemingsomstandigheden: {
        titel: "Waarnemingsomstandigheden",
        tekst: "De omstandigheden ten tijde van de overtreding waren zodanig dat een zorgvuldige bestuurder de verkeerssituatie had kunnen waarnemen."
    },
    reactietijd: {
        titel: "Normale reactietijd",
        tekst: "Een bestuurder heeft voldoende reactietijd gehad om adequaat te reageren op de verkeerssituatie, uitgaande van normale reactietijden."
    },
    verkeerssituatie: {
        titel: "Verkeerssituatie analyse",
        tekst: "De verkeerssituatie was overzichtelijk en voorspelbaar. Een attente bestuurder had tijdig kunnen anticiperen op de situatie."
    }
};

export const PMZvZichtPlichtVerkeersboetenComponent = ({ options, selectedOptions, onChange }) => {
    const { createElement: h } = React;

    return h('div', { className: 'standaard-teksten-container' },
        h('h4', { className: 'section-header' }, 'Voeg standaardteksten toe - ZV Zicht & Plicht'),
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