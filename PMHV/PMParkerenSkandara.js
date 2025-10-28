// =====================================================
// PARKEREN TEKSTEN - SKANDARA
// =====================================================
// Standaard teksten voor parkeerovertredingen
// =====================================================

export const PMParkerenSkandara = {
    bestrijdtBebording: {
        titel: "Bestrijdt bebording gepasseerd",
        tekst: "Betrokkene bestrijdt bebording te zijn gepasseerd."
    },
    bordNietAantonen: {
        titel: "Bord niet aan te tonen",
        tekst: "Niet aan te tonen dat bord aanwezig was; graag vernietiging van de sanctie."
    },
    geenSchouwrapporten: {
        titel: "Geen schouwrapporten of foto's",
        tekst: "Verbalisant verklaart dat alle bebording in orde was, maar er zijn geen schouwrapporten, foto's of andere stukken toegevoegd aan het dossier. Aanvullende stukken moeten aanwezig zijn, zie uitspraak van 't Hof d.d. 12 september 2022, ECLI:2022:7804."
    },
    kruisingsvlakMeting: {
        titel: "Meting vanaf kruisingsvlak",
        tekst: "Moet vanaf het kruisingsvlak gemeten worden, zie uitspraak van 't Hof d.d. 28 oktober 2022, ECLI:2022:9218."
    },
    deugdelijkheidNietVast: {
        titel: "Deugdelijkheid niet vast te stellen",
        tekst: "Nu er geen aanvullende stukken zijn, zoals schouwrapporten of foto's, kan de deugdelijkheid niet met voldoende mate worden vastgesteld. De verklaring van verbalisant is niet genoeg, zie uitspraak van 't Hof, ECLI:2022:7804."
    },
    betwistDeugdelijkheid: {
        titel: "Betwisting gedraging: Betrokkene betwist de deugdelijkheid van de bebording.",
        tekst: "Betrokkene betwist de deugdelijkheid van de bebording."
    },
    deugdelijkheidBebording: {
        titel: "Deugdelijkheid bebording niet vast",
        tekst: "Deugdelijkheid van bebording niet vast te staan."
    },
    trottoirDefinitie: {
        titel: "Bestrijdt parkeren op trottoir",
        tekst: "Geparkeerd op het trottoir. Betrokkene bestrijdt de gedraging. Trottoir in de zin van art. 10 RVV 1990 moet op basis van de uiterlijke kenmerken voor een weggebruiker als zodanig herkenbaar zijn. Dit volgens uitspraak Gerechtshof Arnhem-Leeuwarden, ECLI:NL:GHRARL:2020:9504. Zo moet bijvoorbeeld sprake zijn van een afwijkende bestrating, een hoogteverschil en een trottoirband. De verbalisant heeft niet aangegeven om welke reden het gedeelte is aangemerkt als trottoir. Derhalve kan de sanctiebeschikking niet in stand blijven."
    },
    artikel5WVW: {
        titel: "Verkeerde feitcode art. 5 WVW",
        tekst: "Betrokkene wordt verweten art. 5 WVW te hebben overtreden: het veroorzaken van gevaar of hinder op de weg. Het hof heeft bepaald dat geen sanctie mag worden opgelegd voor een algemene hinderbepaling, in dit geval art. 5 WVW, indien een specifieke hinderbepaling is overtreden. Dit volgens Gerechtshof Arnhem-Leeuwarden van 17 februari 2021, ECLI:NL:GHARL:2021:1567. Betrokkene stond op een fietsstrook; dat betekent dat feitcode R396B met een lager sanctiebedrag toegepast had moeten worden."
    },
    e1Bebording: {
        titel: "Bestrijdt E1-bebording gepasseerd",
        tekst: "Betrokkene bestrijdt E1-bebording te zijn gepasseerd. Er is een rijroute bekendgemaakt. In het dossier ontbreken de gegevens omtrent de E1-bebording ter plaatse. Dat brengt met zich mee dat de deugdelijkheid van de bebording onvoldoende is komen vast te staan. Betrokkene bestrijdt de gedraging. In het dossier ontbreekt een foto, waardoor het dossier incompleet is. Bij deze stand van zaken is betrokkene geschaad in zijn rechten en te respecteren belangen. De sanctiebeschikking kan niet in stand blijven."
    },
    parkerenE9Bebording: {
        titel: "Betwisting gedraging: Allereerst betwist betrokkene dat er sprake was van parkeren.",
        tekst: "Betrokkene bestrijdt de gedraging. Allereerst betwist betrokkene dat er sprake was van parkeren. De verbalisant heeft geen pardontijd in acht genomen, waardoor onduidelijk is hoe verbalisant heeft vastgesteld dat er sprake was van parkeren. De verweten gedraging komt derhalve niet vast te staan. Voorts betwist betrokkene E9-bebording te zijn gepasseerd. In het dossier ontbreken geheel de gegevens omtrent de E9-bebording ter plaatse. Dat brengt met zich mee dat de deugdelijkheid van de bebording onvoldoende is komen vast te staan. Tot slot is niet duidelijk waarom er geen staande houding kon plaatsvinden. De verbalisant heeft geen reden genoemd voor het achterwege laten van een staande houding. De sanctie is ten onrechte aan de kentekenhouder opgelegd. Betrokkene concludeert tot vernietiging van de sanctiebeschikking."
    }
};

export const PMParkerenSkandaraComponent = ({ options, selectedOptions, onChange }) => {
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