// =====================================================
// SNELHEID TEKSTEN - SKANDARA
// =====================================================
// Standaard teksten voor snelheidsovertredingen
// =====================================================

export const PMSnelheidSkandara = {
    technischeValidatie: {
        titel: "Technische validatie meetapparatuur",
        tekst: "Een uitgebreide technische validatie van de meetapparatuur heeft aangetoond dat deze volledig conform specificaties functioneert en accuraat meet."
    },
    meetProtocol: {
        titel: "Meetprotocol en procedures",
        tekst: "Het gehanteerde meetprotocol voldoet aan alle relevante technische standaarden en is uitgevoerd door gecertificeerd personeel."
    },
    dataIntegriteit: {
        titel: "Data-integriteit en opslag",
        tekst: "De integriteit van de meetdata is gewaarborgd door gebruik van gevalideerde systemen en veilige opslagmethoden."
    },
    omgevingsfactoren: {
        titel: "Analyse omgevingsfactoren",
        tekst: "Alle relevante omgevingsfactoren die de meting zouden kunnen beïnvloeden zijn geanalyseerd en bleken geen invloed te hebben op de meetresultaten."
    },
    referentiemetingen: {
        titel: "Referentiemetingen uitgevoerd",
        tekst: "Ter verificatie zijn referentiemetingen uitgevoerd die de betrouwbaarheid en nauwkeurigheid van de primaire meting bevestigen."
    },
    kwaliteitsborging: {
        titel: "Kwaliteitsborging meetproces",
        tekst: "Het gehele meetproces valt onder een gecertificeerd kwaliteitsborgingsysteem dat voldoet aan de hoogste industriestandaarden."
    }
};

export const PMSnelheidSkandaraComponent = ({ options, selectedOptions, onChange }) => {
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