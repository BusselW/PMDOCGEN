// ==========================
// File: skandara-module.js
// ==========================

const { createElement: h } = React;

/**
 * Dit object bevat de standaardteksten die gekoppeld zijn aan de vinkjes
 * voor de specifieke "Verkeersboete.nl" workflow.
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
