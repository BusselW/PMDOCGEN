// ==========================
// File: skandara-module.js
// ==========================

const { createElement: h } = React;

/**
 * Dit object bevat de standaardteksten die gekoppeld zijn aan de vinkjes
 * voor de specifieke "Skandara" workflow.
 */
export const SkandaraTeksten = {
    onvoldoendeOndervangen: {
        label: "Beleidskader, althans niet gehouden aan eisen bebording.",
        tekst: "Onvoldoende ondervangen: Het beoordelingskader geeft nadere vereisten aan de wijze waarop de gedraging moet worden vastgesteld. De beleidsregels bepalen onder meer dat het bord zichtbaar moet zijn op de foto. Op de foto zie ik geen C of G bord en dat is in strijd met de beleidsregels. De vraag is of het een of ander op andere wijze is ondervangen. Daarvan blijkt niet, althans niet voldoende uit het dossier."
    },
    geenInstemmingOM: {
        label: "geen aanvraag/instemming OM (boa niet bevoegd)",
        tekst: "Geen aanvraag/instemming OM(BOA niet bevoegd): Voor beschikkingen die zijn opgelegd na 01-7-2021 dient de bevoegdheid te worden beoordeeld op basis van de regeling domeinlijsten BOA. Hierin staat vermeld digitaal handhaven is slechts mogelijk op overtreding van het Rvv en na instemming van het Openbaar Ministerie. Een aanvraag tot instemming wordt getoetst aan de aan het Openbaar ministerie vastgestelde kaders. Het Hof Arnhem/Leeuwarden overweegt omtrent dit beoordelingskader digitale handhaving geslotenverklaring en voetgangersgebieden dat het beoordelingskader formuleert op welke wijze en onder welke omstandigheden een verbalisant bevoegd is tot handhaving. A contrario zie arrest d.d. 01-09-2022: ECLI: 7566. Aldus toetst het Hof indringend aan het beoordelingskader welke voorwaarden. De toepasselijke kaders zijn te vinden op WWW.OM.nl/digitaalhandhavenrvv."
    },
    geenWaarschuwingsbrieven: {
        label: "Geen waarschuwingsbrieven ontvangen.",
        tekst: "Geen waarschuwingsbrieven ontvangen: Betrokkene heeft verklaard dat hij nimmer een waarschuwingsbrief heeft ontvangen door de instantie . In het arrest van het Hof Arnhem/Leeuwarden d.d. 07-12-2022 ECLI:NL:GHARL:2022:10521. Kan worden afgeleid dat wanneer in een zaak waarin het beoordelingskader van toepassing is en betrokkene geen waarschuwingsbrief heeft ontvangen, dat de gevolgtrekking van vernietiging van de inleidende beschikking dient te worden gemaakt. Ik ben van oordeel dat ook nu het beoordelingskader van toepassing is. De regel omtrent het waarschuwen eerste overtreders van toepassing moet zijn."
    },
    beleidskadersNietInAchtGenomen: {
        label: "Beleidsregels digitale handhaving/bebording niet in acht genomen.",
        tekst: "Betrokkene betwist de gedraging. In casu is sprake van digitale handhaving. Betrokkene bestrijdt dat de daarvoor geldende beleidsregels in acht zijn genomen, in ieder geval niet ten aanzien van de bebording. Nu uit het dossier niet, althans onvoldoende, is gebleken dat de BOA heeft gehandeld conform de geldende beleidskaders. Dit volgt uit de Regeling Buitengewoon Opsporingsambtenaren en Digitale Handhaving, Voetgangers en Gesloten Verklaringen. Mocht de BOA geen gebruik hebben mogen maken van zijn bevoegdheid tot het opleggen van de sanctie (1 september 2022, ECLI:NL:GHARL:2022:7566), dan kan de sanctiebeschikking niet in stand blijven."
    },
    tegenstrijdigeBebordingLijnbus: {
        label: "Tegenstrijdige bebording (lijnbus wel toegestaan).",
        tekst: "Betrokkene wordt verweten te hebben gehandeld in strijd met een geslotenverklaring voor alle motorvoertuigen. Deze gedraging kan echter op basis van de beschikbare gegevens niet worden vastgesteld. Lijnbussen zijn wel toegestaan op de pleeglocatie, terwijl een lijnbus ook een motorvoertuig is. Derhalve kan de verweten gedraging — dat ter plaatse geen motorvoertuigen mochten inrijden — niet worden vastgesteld. Betrokkene concludeert tot vernietiging van de sanctiebeschikking."
    },
    verkeerdeFeitcodeR311A: {
        label: "Verkeerde feitcode toegepast (R311A voor bromfiets).",
        tekst: "Betrokkene betwist de gedraging. Verbalisant heeft de verkeerde feitcode toegepast. Feitcode R311A moet worden toegepast, omdat betrokkene reed op een bromfiets. Subsidiair verzoekt betrokkene om de feitcode te wijzigen en primair verzoekt betrokkene om de sanctie te vernietigen."
    },
    onduidelijkeVooraankondiging: {
        label: "Vooraankondigingsborden onvoldoende duidelijk.",
        tekst: "De vooraankondigingsborden zijn niet duidelijk genoeg. Betrokkene stond al voor de geslotenverklaring. Voordat betrokkene het wist, kon hij niet meer keren en handelde hij in strijd met de verklaring. De borden moeten duidelijker zijn en op een plaats staan waar bestuurders nog de kans hebben een andere route te kiezen. Dat is hier niet het geval en is in strijd met het beleidskader."
    },
    onterechteGeenStaandehouding: {
        label: "Onterecht niet staande gehouden (mogelijkheid was er).",
        tekst: "Vast staat dat er geen staandehouding heeft plaatsgevonden en dat de verbalisant langs de kant van de weg is gaan staan om overtreders te bekeuren. Uit het dossier volgt niet op welke wijze de controle zodanig was ingericht dat staandehouding niet mogelijk was. Bij die stand van zaken kan de beschikking niet in stand blijven. Wij verwijzen naar een uitspraak van het Hof Arnhem-Leeuwarden van 8 februari 2022, ECLI:NL:GHARL:2022:1534."
    },
    verkeerdeFeitcodeR611AEnGeenStaandehouding: {
        label: "Verkeerde feitcode (R611A) en geen staandehouding.",
        tekst: "Betrokkene betwist de gedraging. Verbalisant heeft de verkeerde feitcode toegepast. Feitcode R611A had toegepast moeten worden. Verbalisant had ook een staandehouding moeten verrichten. Verbalisant had een andere verbalisant kunnen inroepen om een staandehouding te verrichten. Betrokkene concludeert tot vernietiging van de sanctiebeschikking."
    },
    ontbrekendeSchouwrapporten: {
        label: "Schouwrapporten ontbreken in dossier.",
        tekst: "Betrokkene betwist de gedraging. In het dossier zitten geen schouwrapporten. Nu de schouwrapporten ontbreken, komt de deugdelijkheid onvoldoende vast te staan. Betrokkene concludeert tot vernietiging van de sanctiebeschikking."
    }
};

/**
 * Een React component dat een set van vinkjes (checkboxes) rendert.
 * @param {object} props - De properties van de component.
 * @param {object} props.options - Een object met de beschikbare opties (zoals standaardTeksten).
 * @param {object} props.selectedOptions - Een object dat de huidige staat van de vinkjes bijhoudt (true/false).
 * @param {function} props.onChange - De functie die wordt aangeroepen als een vinkje wordt gewijzigd.
 */
export const SkandaraTekstenComponent = ({ options, selectedOptions, onChange }) => {
    return h('div', { className: 'standaard-teksten-container' },
        h('h4', { className: 'section-header' }, 'Voeg standaardteksten toe'),
        Object.keys(options).map(key => {
            const option = options[key];
            return h('div', { key: key, className: 'input-group' },
                h('label', { className: 'checkbox-label' },
                    h('input', {
                        type: 'checkbox',                        
                        checked: selectedOptions[key] === true,
                        onChange: () => onChange(key)
                    }),
                    option.label
                )
            );
        })
    );
};
