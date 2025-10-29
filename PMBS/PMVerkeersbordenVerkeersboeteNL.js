// =====================================================
// PM BESLISSING OPTIES - Verkeersborden Verkeersboete.nl
// =====================================================
// Deze module bevat alle beslissing-specifieke opties voor
// Verkeersborden categorie bij Verkeersboete.nl
// =====================================================

export const PMBSVerkeersbordenVerkeersboeteNL = {
    coreTemplate: {
        tekst: "U hebt beroep ingesteld tegen de opgelegde sanctie en tevens aangegeven gehoord te willen worden. Dit laatste heeft inmiddels plaatsgevonden. Van het horen is een verslag in het dossier gevoegd. In uw beroepschrift en tijdens het horen hebt u aangevoerd dat u de gedraging niet hebt begaan.\n\nDe officier van justitie heeft op basis van de beschikbare informatie, de inhoud van uw beroepschrift en het gesprek een beslissing genomen.\n\nDe officier van justitie heeft een afweging gemaakt tussen de argumenten die u in uw beroepschrift hebt vermeld en de verklaring van de verbalisant. Er wordt doorslaggevende betekenis toegekend aan de verklaring van de verbalisant. De officier van justitie heeft verder geen reden te twijfelen aan de juistheid van de beschikking.\n\nDaarnaast verwijst u naar een rechtszaak met ECLI-nummer: ECLI:NL:GHARL:2022:7566 en draagt u een voorbeeld aan waaruit blijkt dat het hof toetst op de voorwaarden van het \"Beoordelingskader digitale handhaving bij geslotenverklaringen en voetgangersgebieden\". De officier van justitie overweegt dat het voorbeeld dat u aandraagt niet inhoudelijk zal worden meegewogen, omdat het een voorbeeld uit een andere zaak betreft.\n\nVoor de overige gronden overweegt de officier van justitie als volgt:\n\nU stelt dat de bebording aanwezig dient te zijn op de foto in geval van digitale handhaving. De officier van justitie overweegt het volgende. Uit de beschikbare informatie blijkt dat een opsporingsambtenaar enige tijd voor en enige tijd na de pleegdatum de bebording heeft gecontroleerd op zichtbaarheid. De bevindingen hiervan zijn opgenomen in een proces-verbaal. Uit de proces-verbalen blijkt dat de bebording goed zichtbaar was bij deze controles. De schouwrapporten ondervangen de deugdelijke aanwezigheid van het bord voldoende. De officier van justitie ziet geen aanleiding de beschikking te vernietigen of het sanctiebedrag te verlagen op grond van deze stelling.\n\nDaarnaast stelt u dat u geen waarschuwing hebt ontvangen, terwijl u dit wel had verwacht. Het beoordelingskader verwijst daarmee naar een waarschuwingsperiode. De officier van justitie overweegt het volgende. Uit de beschikbare informatie blijkt dat de pleegdatum van uw beschikking buiten de waarschuwingsperiode van deze geslotenverklaring of voetgangersgebied ligt. De beschikking is daarom terecht opgelegd.\n\nTot slot stelt u dat de bebording ter plaatse onvoldoende signalerend werkt, waardoor bestuurders onvoldoende op de hoogte worden gebracht van de verkeersregels ter plaatse. De officier van justitie overweegt dat volgens het Reglement Verkeersregels en Verkeerstekens 1990 (art. 62 RVV 1990) weggebruikers verplicht zijn gevolg te geven aan de verkeerstekens die een gebod of verbod inhouden. Van weggebruikers mag worden verwacht dat zij te allen tijde alert zijn op aanwezige bebording. Er is niet gebleken dat er sprake was van een onduidelijke situatie. Dat u het bord vanwege omstandigheden hebt gemist, is een omstandigheid waarvan de gevolgen voor uw eigen rekening komen. Hierdoor ziet de officier van justitie onvoldoende aanleiding om de beschikking te vernietigen of het sanctiebedrag te verlagen.\n\nOmtrent de bewijsvoering verwijst de officier van justitie naar de eerder toegestuurde stukken.\n\nAlles overwegende verklaart de officier van justitie het beroep ongegrond.",
        label: "Standaard Beslissing Template"
    },
    omInternetStoring: {
        tekst: "Op 17 juli 2025 is het Openbaar Ministerie losgekoppeld van het internet. Hierdoor waren de interne systemen van het Openbaar Ministerie gedurende enkele weken beperkt beschikbaar. Mogelijk heeft dit om die reden langer geduurd voordat de officier van justitie op uw beroep tegen uw verkeersboete (Mulderbeschikking) kon beslissen.",
        label: "OM Internet Storing (17 juli 2025)"
    }
};

export const PMBSVerkeersbordenVerkeersboeteNLComponent = ({ options, selectedOptions, onChange }) => {
    const { createElement: h } = React;

    return h('div', { className: 'input-group' },
        h('label', null, 'Beslissing Elementen (Verkeersboete.nl):'),
        h('div', { className: 'checkbox-group' },
            Object.keys(options).map(key =>
                h('div', { key, className: 'checkbox-item', style: { marginBottom: '8px' } },
                    h('label', { className: 'checkbox-label' },
                        h('input', {
                            type: 'checkbox',
                            checked: selectedOptions[key] || false,
                            onChange: () => onChange(key)
                        }),
                        h('span', { style: { fontWeight: '500' } }, options[key].label)
                    ),
                    // Show preview of content when hovered or selected
                    selectedOptions[key] && h('div', { 
                        className: 'selected-preview',
                        style: { 
                            fontSize: '11px', 
                            color: '#666', 
                            marginTop: '4px', 
                            paddingLeft: '20px',
                            fontStyle: 'italic'
                        }
                    }, `${options[key].tekst.substring(0, 100)}...`)
                )
            )
        ),
        h('div', { 
            style: { 
                fontSize: '12px', 
                color: '#888', 
                marginTop: '8px',
                fontStyle: 'italic'
            }
        }, 'Geselecteerde elementen worden automatisch in de beslissing opgenomen.')
    );
};