<!DOCTYPE html>
<html lang="nl">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document Generator</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&family=JetBrains+Mono&display=swap"
        rel="stylesheet">
    <link href="styling/styling.css" rel="stylesheet">
    <script src="https://som.org.om.local/sites/MulderT/CustomPW/UPP/PMDOC/react-production-mins.js"></script>
    <script src="https://som.org.om.local/sites/MulderT/CustomPW/UPP/PMDOC/react-dom.production.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>
    <script src="https://unpkg.com/docx@8.5.0/build/index.js"></script>
    <script src="https://som.org.om.local/sites/MulderT/CustomPW/UPP/PMDOC/handlebars.js"></script>
    <script crossorigin src="https://unpkg.com/react@18/umd/react.production.min.js"></script>
    <script crossorigin src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js"></script>

    <!-- Hoorverslag Navigatie Module -->
    <script src="https://som.org.om.local/sites/MulderT/CustomPW/UPP/PMDOC/util/hoorverslag-navigatie.js"></script>
    <link rel="stylesheet" href="https://som.org.om.local/sites/MulderT/CustomPW/UPP/PMDOC/util/hoorverslag-navigatie.css">
    
    <style>
        .kopje {
            font-weight: bold;
            display: inline;
        }
        .slider-container {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .slider {
            flex-grow: 1;
        }
        .slider-value {
            font-weight: bold;
        }
        .step-icon svg, .action-button svg, .nav-button svg {
            width: 1em;
            height: 1em;
            vertical-align: -0.125em;
        }
    </style>
</head>

<body>
    <div id="root"></div>
    <div id="highlight-overlay" class="tutorial-highlight" style="display: none;"></div>

    <script type="module">
        // =====================
        // 1. Imports en initialisatie
        // =====================
        import { tutorialSteps } from './util/tutorial.js';
        import { VerkeersboeteTeksten, VerkeersboeteTekstenComponent } from './PMHV/Verkeersboetenl.js';
        import { SkandaraTeksten, SkandaraTekstenComponent } from './PMHV/Skandara.js';

        const { useState, useEffect, createElement: h, Fragment } = React;

        const icons = {
            userTie: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>',
            gavel: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m14 13-4.5 4.5"/><path d="m10.5 16.5 7-7"/><path d="m16 16-1.5-1.5"/><path d="M13 19 2.05 7.94a2.5 2.5 0 0 1 0-3.54L5.6 1.84c.98-.98 2.56-.98 3.54 0L19 11.25"/><path d="m18.5 2.5 2 2"/><path d="m12.5 9.5 2 2"/></svg>',
            fileAlt: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line><polyline points="10 9 9 9 8 9"></polyline></svg>',
            flagCheckered: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"></path><line x1="4" y1="22" x2="4" y2="15"></line></svg>',
            infoCircle: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>',
            listAlt: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="8" y1="6" x2="21" y2="6"></line><line x1="8" y1="12" x2="21" y2="12"></line><line x1="8" y1="18" x2="21" y2="18"></line><line x1="3" y1="6" x2="3.01" y2="6"></line><line x1="3" y1="12" x2="3.01" y2="12"></line><line x1="3" y1="18" x2="3.01" y2="18"></line></svg>',
            comments: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>',
            checkCircle: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>',
            questionCircle: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"></path><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>',
            chevronRight: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"></polyline></svg>',
            arrowLeft: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>',
            arrowRight: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>',
            copy: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path></svg>',
            fileWord: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline></svg>',
            syncAlt: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="23 4 23 10 17 10"></polyline><polyline points="1 20 1 14 7 14"></polyline><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path></svg>'
        };

        // =====================
        // 2. Configuratie en initiële state
        // =====================
        const initialFormData = {
            beoordelaarVoorletters: '', beoordelaarAchternaam: '', griffierVoorletters: '',
            griffierAchternaam: '', vertegenwoordigerType: 'gemachtigde', aanwezigheid: 'aanwezig',
            aanwezigeVoorletters: '', aanwezigeAchternaam: '', bedrijfsNaam: '',
            redenNietAanwezig: '', redenAfwezigheidKeuze: '', stukkenVerstrekt: 'wel',
            aanhoudingBesluitGenomen: false, aanhouding: '', tijdigheidBeroepType: '',
            reactieTeLaat: '', reactieVerweten: '', vragenBeoordelaar: '',
            reactieOpnemen: true, reactieBetrokkene: '', vervolgvragenGesteld: false,
            overigeVragen: '', reactieVervolgvragenOpnemen: true, reactieBetrokkene2: '',
            afspraken: '', afloopZaakType: '', mondelingUitspraakTekst: '',
            beslissingTypeKeuze: '', referentieNummer: '', geadresseerde: '',
            accountNummer: '', contactPersoon: '', boeteNummer: '', voertuigInfo: '',
            overtredingDatum: '', overtredingType: '', clientId: '', serviceType: '',
            hoofdTekst: '', disclaimerTekst: '', handtekeningBlok: '', voorwaardenTekst: '',
            betalingsInformatie: '', bezwaarProcedure: '', juridischeGrondslag: '',
            bewijslijst: '', tariefInformatie: '', vertrouwelijkheidsClausule: '',
            aanvullendeArgumenten: '', besluitTekst: '', startTime: '', endTime: '',
            contactpogingen: 2
        };

        const config = {
            documentTypes: [
                { id: 'hoorverslag', name: 'Hoorverslag' },
                { id: 'beslissing', name: 'Beslissing' }
            ],
            subtypes: {
                hoorverslag: [
                    { id: 'telefonisch', name: 'Telefonisch' },
                    { id: 'fysiek', name: 'Fysiek' }
                ],
                beslissing: [
                    { id: 'appjection', name: 'Appjection' }, { id: 'skandara', name: 'Skandara' },
                    { id: 'verkeersboete', name: 'Verkeersboete.nl' },
                    { id: 'bezwaartegenverkeersboetes', name: 'Bezwaartegenverkeersboetes' },
                    { id: 'legalconsultancy', name: 'My Legal Consultancy' }
                ]
            },
            steps: {
                hoorverslag: [
                    { number: 1, title: 'Aanwezigheid', icon: icons.userTie },
                    { number: 2, title: 'Procesverloop', icon: icons.gavel },
                    { number: 3, title: 'Inhoud', icon: icons.fileAlt },
                    { number: 4, title: 'Afloop', icon: icons.flagCheckered }
                ],
                beslissing: [
                    { number: 1, title: 'Algemeen', icon: icons.infoCircle },
                    { number: 2, title: 'Details', icon: icons.listAlt },
                    { number: 3, title: 'Argumenten', icon: icons.comments },
                    { number: 4, title: 'Besluit', icon: icons.checkCircle }
                ]
            },
            templates: {
                hoorverslag: {
                    telefonisch: `Beoordelaar: {{beoordelaarVolledigeNaam}}\nGriffier: n.v.t.\n{{aanwezigheidsTekst}}\n{{redenNietAanwezigSectie}}\n\nProcesverloop\n{{procesverloopTekst}}\n\nCautie\nBij aanvang van het horen is medegedeeld dat het niet verplicht is om antwoord te geven op de gestelde vragen.\n\n{{tijdigheidSectie}}\n\n{{aanvullendeGrondenSectie}}\n\n{{vragenBeoordelaarSectie}}\n\n{{reactieBetrokkeneSectie}}\n\n{{vervolgvragenSectie}}\n\n{{afsprakenSectie}}\n\nAfloop van de zaak\n{{afloopZaakTekst}}`,
                    fysiek: `Beoordelaar: {{beoordelaarVolledigeNaam}}\nGriffier: {{griffierVolledigeNaam}}\n{{aanwezigheidsTekst}}\n{{redenNietAanwezigSectie}}\n\nProcesverloop\n{{procesverloopTekst}}\n\nCautie\nBij aanvang van het horen is medegedeeld dat het niet verplicht is om antwoord te geven op de gestelde vragen.\n\n{{tijdigheidSectie}}\n\n{{aanvullendeGrondenSectie}}\n\n{{vragenBeoordelaarSectie}}\n\n{{reactieBetrokkeneSectie}}\n\n{{vervolgvragenSectie}}\n\n{{afsprakenSectie}}\n\nAfloop van de zaak\n{{afloopZaakTekst}}`
                },
                beslissing: {
                    appjection: `APPJECTION BESLISSING DOCUMENT\n\nReferentie: {{referentieNummer}}\nDatum: {{huidigeDatum}}\nTijdsregistratie: {{startTime}} - {{endTime}}\n\nGeachte {{geadresseerde}},\n\n{{beslissingTypeInfo}}\nHierbij delen wij u mede onze beslissing inzake uw zaak.\n{{hoofdTekstMetSpacing}}\n{{aanvullendeArgumentenMetSpacing}}\n{{besluitTekstMetSpacing}}\n{{disclaimerTekstMetSpacing}}\n{{handtekeningBlokMetSpacing}}\nMet vriendelijke groet,\nAppjection Legal Team`,
                    skandara: `SKANDARA BESLISSING\n\nAccount: {{accountNummer}}\nContactpersoon: {{contactPersoon}}\nDatum: {{huidigeDatum}}\nTijdsregistratie: {{startTime}} - {{endTime}}\n\nGeachte {{geadresseerde}},\n\n{{beslissingTypeInfo}}\nNaar aanleiding van uw verzoek is het volgende besloten:\n{{hoofdTekstMetSpacing}}\n{{aanvullendeArgumentenMetSpacing}}\n{{besluitTekstMetSpacing}}\n{{voorwaardenTekstMetSpacing}}\n{{betalingsInformatieMetSpacing}}\nHoogachtend,\nSkandara Support Team`,
                    verkeersboete: `BESLISSING INZAKE VERKEERSBOETE\n\nKenmerk: {{boeteNummer}}\nVoertuig: {{voertuigInfo}}\nDatum overtreding: {{overtredingDatum}}\nTijdsregistratie: {{startTime}} - {{endTime}}\n\nGeachte heer/mevrouw {{geadresseerde}},\n\n{{beslissingTypeInfo}}\nMet betrekking tot de geconstateerde verkeersovertreding is het volgende besloten:\n{{hoofdTekstMetSpacing}}\n{{aanvullendeArgumentenMetSpacing}}\n{{besluitTekstMetSpacing}}\n{{bezwaarProcedureMetSpacing}}\nHoogachtend,\nVerkeersboete.nl Administration`,
                    bezwaartegenverkeersboetes: `BESLISSING OP BEZWAAR\n\nReferentie: {{referentieNummer}}\nOvertreding: {{overtredingType}}\nDatum: {{huidigeDatum}}\nTijdsregistratie: {{startTime}} - {{endTime}}\n\nGeachte heer/mevrouw {{geadresseerde}},\n\n{{beslissingTypeInfo}}\nNaar aanleiding van uw bezwaarschrift is het volgende besloten:\n{{hoofdTekstMetSpacing}}\n{{juridischeGrondslagMetSpacing}}\n{{bewijslijstMetSpacing}}\n{{aanvullendeArgumentenMetSpacing}}\n{{besluitTekstMetSpacing}}\nHoogachtend,\nBezwaartegenverkeersboetes Team`,
                    legalconsultancy: `JURIDISCH ADVIES\n\nCliënt ID: {{clientId}}\nService: {{serviceType}}\nDatum: {{huidigeDatum}}\nTijdsregistratie: {{startTime}} - {{endTime}}\n\nGeachte cliënt {{geadresseerde}},\n\n{{beslissingTypeInfo}}\nHierbij ontvangt u ons juridisch advies inzake uw zaak:\n{{hoofdTekstMetSpacing}}\n{{aanvullendeArgumentenMetSpacing}}\n{{besluitTekstMetSpacing}}\n{{tariefInformatieMetSpacing}}\n{{vertrouwelijkheidsClausuleMetSpacing}}\nMet vriendelijke groet,\nMy Legal Consultancy`
                }
            },
            dropdownOptions: {
                aanwezigheid: [{ value: 'aanwezig', label: 'Aanwezig' }, { value: 'afwezig', label: 'Afwezig' }],
                vertegenwoordiger: [{ value: 'gemachtigde', label: 'Gemachtigde' }, { value: 'betrokkene', label: 'Betrokkene' }],
                stukkenVerstrekt: [{ value: 'wel', label: 'Wel' }, { value: 'niet', label: 'Niet' }],
                redenAfwezigheidOpties: [{ value: '', label: 'Selecteer reden...' }, { value: 'gebeldZonderGehoor', label: '2 tot 3 keer gebeld zonder gehoor' }, { value: 'laterAanwezigGemeld', label: 'Heeft gemeld later aanwezig te zijn' }],
                afloopZaakOpties: [{ value: '', label: 'Selecteer afloop...' }, { value: 'mondelingUitspraak', label: 'De beoordelaar heeft mondeling uitspraak gedaan tijdens de hoorzitting' }, { value: 'schriftelijkeUitspraak', label: 'De beoordelaar zal schriftelijk uitspraak doen' }, { value: 'aanhoudingVerzuim', label: 'De beoordelaar houdt de zaak aan om verzuim op te vragen' }],
                tijdigheidBeroepOpties: [{ value: '', label: 'Selecteer tijdigheid...' }, { value: 'tijdigIngediend', label: 'Het beroepschrift is tijdig ingediend' }, { value: 'teLaatIngediend', label: 'Het beroepschrift is te laat ingediend' }, { value: 'termijnOverschreden', label: 'De termijn is overschreden met meer dan 14 dagen' }],
                beslissingTypeOpties: [
                    { value: '', label: 'Selecteer type beslissing...' }, { value: 'L601', label: 'L 601 Verzoek horen, wel gehoord, ongegrond' },
                    { value: 'L602', label: 'L 602 Verzoek horen, wel gehoord, wijzigen' }, { value: 'L603', label: 'L 603 Verzoek horen, wel gehoord, niet-ontvankelijk' },
                    { value: 'L604', label: 'L 604 Verzoek horen, wel gehoord, vernietigd' }, { value: 'L605', label: 'L 605 Verzoek horen, niet gehoord, ongegrond' },
                    { value: 'L606', label: 'L 606 Verzoek horen, niet gehoord, wijzigen' }, { value: 'L607', label: 'L 607 Verzoek horen, niet gehoord, niet-ontvankelijk' },
                    { value: 'L608', label: 'L 608 Verzoek horen, niet gehoord, vernietigen' }, { value: 'L609', label: 'L 609 Verzoek horen, wordt afgezien van hoorzitting, ongegrond' },
                    { value: 'L610', label: 'L 610 Verzoek horen, wordt afgezien van hoorzitting, wijzigen' }, { value: 'L611', label: 'L 611 Verzoek horen, wordt afgezien van hoorzitting, vernietigen' },
                    { value: 'L612', label: 'L 612 Verzoek horen, gemachtigde onttrekt zich, ongegrond' }, { value: 'L613', label: 'L 613 Verzoek horen, gemachtigde onttrekt zich, wijzigen' },
                    { value: 'L614', label: 'L 614 Verzoek horen, gemaaktigde onttrekt zich, vernietigen' }, { value: 'L615', label: 'L 615 Verzoek horen, niet aanwezig tijdens hoorzitting, ongegrond' },
                    { value: 'L616', label: 'L 616 Verzoek horen, niet aanwezig tijdens hoorzitting, wijzigen' }, { value: 'L617', label: 'L 617 Verzoek horen, niet aanwezig tijdens hoorzitting, vernietigen' },
                    { value: 'L618', label: 'L 618 Verzoek horen, gemaaktigde neemt telefoon niet op, ongegrond' }, { value: 'L619', label: 'L 619 Verzoek horen, gemaaktigde neemt telefoon niet op, wijziging' },
                    { value: 'L620', label: 'L 620 Verzoek horen, gemaaktigde neemt telefoon niet op, vernietiging' }, { value: 'L635', label: 'L 635 Verzoek horen, geen hoorzitting ivm ingebrekestelling, ongegrond' },
                    { value: 'L636', label: 'L 636 Verzoek horen, geen hoorzitting ivm ingebrekestelling, wijzigen' }, { value: 'L637', label: 'L 637 Verzoek horen, geen hoorzitting ivm ingebrekestelling, vernietigen' }
                ]
            }
        };

        // =====================
        // 3. Hoofdcomponent App
        // =====================
        const App = () => {
            // 3a. State hooks
            const [activeDocType, setActiveDocType] = useState(config.documentTypes[0].id);
            const [activeSubtype, setActiveSubtype] = useState(config.subtypes[activeDocType]?.[0]?.id || '');
            const [activeFormStep, setActiveFormStep] = useState(1);
            const [formData, setFormData] = useState({ ...initialFormData });
            const [generatedDocument, setGeneratedDocument] = useState('Voorvertoning wordt geladen...');
            const [copySuccess, setCopySuccess] = useState(false);
            const [tooltipZichtbaar, setTooltipZichtbaar] = useState(false);
            const [taalTipZichtbaar, setTaalTipZichtbaar] = useState(false);
            const [dialoogTipZichtbaar, setDialoogTipZichtbaar] = useState(false);
            const [bedrijfsSuggesties, setBedrijfsSuggesties] = useState([]);
            const [toonBedrijfsSuggesties, setToonBedrijfsSuggesties] = useState(false);
            const [tijdsregistratieVerdeeld, setTijdsregistratieVerdeeld] = useState(false);
            const [tutorialStep, setTutorialStep] = useState(0);
            const [currentTutorialText, setCurrentTutorialText] = useState("");
            const [selectedStandaardTeksten, setSelectedStandaardTeksten] = useState({});
            const [aanwezigheidOptions, setAanwezigheidOptions] = useState(config.dropdownOptions.aanwezigheid);

            useEffect(() => {
                if (activeDocType === 'hoorverslag' && activeSubtype === 'telefonisch') {
                    setAanwezigheidOptions([
                        { value: 'aanwezig', label: 'Aanwezig' },
                        { value: 'afwezig', label: 'Onbereikbaar' }
                    ]);
                } else {
                    setAanwezigheidOptions(config.dropdownOptions.aanwezigheid);
                }
            }, [activeSubtype, activeDocType]);

            // =====================
            // HOORVERSLAG NAVIGATIE INTEGRATIE
            // =====================
            
            // Initialiseer hoorverslag navigatie module
            useEffect(() => {
                // Toon de navigatiebalk alleen voor het documenttype 'hoorverslag'
                if (activeDocType === 'hoorverslag') {
                    HoorverslagNavigatie.initialiseer({
                        opLaden: (opgeslagenData) => {
                            // ✨ CORRECTIE: De controle is nu correct. 
                            // Als er opgeslagen data is, laad die. Anders, reset het formulier.
                            if (opgeslagenData) {
                                setFormData(opgeslagenData);
                            } else {
                                setFormData({ ...initialFormData });
                            }
                        },
                        opOpslaan: () => {
                            // Gebruik een functionele update om te garanderen dat we de laatste state opslaan
                            setFormData(current => {
                                HoorverslagNavigatie.slaDataOp(current);
                                return current; // State zelf verandert niet, we triggeren alleen de opslag
                            });
                        },
                        opNummersWijziging: (nieuwNummer) => {
                            // Reset naar de eerste stap bij het wisselen van hoorverslag
                            setActiveFormStep(1);
                        }
                    });
                } else {
                    // Verwijder de navigatiebalk als we niet in een hoorverslag zitten
                    HoorverslagNavigatie.verwijder();
                }

                // Cleanup-functie: verwijder de navigatiebalk als de component unmount
                return () => HoorverslagNavigatie.verwijder();
            }, [activeDocType]); // Re-run dit effect als het documenttype verandert

            // Auto-save functionaliteit bij formData wijzigingen (alleen voor hoorverslagen)
            useEffect(() => {
                if (activeDocType === 'hoorverslag') {
                    const timeoutId = setTimeout(() => {
                        HoorverslagNavigatie.slaDataOp(formData);
                    }, 500); // Sla op na 500ms inactiviteit

                    return () => clearTimeout(timeoutId);
                }
            }, [formData, activeDocType]);
            
            // =====================
            // EINDE HOORVERSLAG NAVIGATIE INTEGRATIE
            // =====================

            // 3b. Handler-functies voor formulier en navigatie
            const handleDocTypeChange = (docType) => {
                setActiveDocType(docType);
                const firstSubtypeId = config.subtypes[docType]?.[0]?.id;
                setActiveSubtype(firstSubtypeId || '');
                setActiveFormStep(1);
                setFormData({ ...initialFormData });
                setSelectedStandaardTeksten({});
                setTijdsregistratieVerdeeld(false);
            };

            const handleSubtypeChange = (subtype) => {
                setActiveSubtype(subtype);
                setSelectedStandaardTeksten({});
                 // Reset formulier bij wisselen van subtype om data-inconsistentie te voorkomen
                setFormData({ ...initialFormData });
            };

            const handleInputChange = (veld, waarde) => {
                setFormData(prev => {
                    const newState = { ...prev, [veld]: waarde };
                    if (veld === 'redenNietAanwezig' && waarde.trim() !== '') newState.redenAfwezigheidKeuze = '';
                    else if (veld === 'redenAfwezigheidKeuze' && waarde !== '') newState.redenNietAanwezig = '';
                    return newState;
                });

                if (veld === 'bedrijfsNaam') {
                    const inputWaarde = String(waarde).toLowerCase();
                    if (inputWaarde) {
                        const gefilterd = config.subtypes.beslissing.filter(subtype => subtype.name.toLowerCase().includes(inputWaarde));
                        setBedrijfsSuggesties(gefilterd);
                        setToonBedrijfsSuggesties(gefilterd.length > 0);
                    } else {
                        setBedrijfsSuggesties([]);
                        setToonBedrijfsSuggesties(false);
                    }
                }
            };

            const handleStandaardTekstChange = (key) => {
                setSelectedStandaardTeksten(prev => ({
                    ...prev,
                    [key]: !prev[key]
                }));
            };

            const handleSaveDocx = () => {
                if (typeof window.docx === 'undefined' || typeof window.saveAs === 'undefined') {
                    alert('Fout: Een benodigde library voor het downloaden is niet geladen.');
                    return;
                }
                const { Document, Packer, Paragraph, TextRun } = window.docx;
                
                const tempDiv = document.createElement('div');
                tempDiv.innerHTML = generatedDocument;
                const plainTextForExport = tempDiv.textContent || tempDiv.innerText || "";

                const textParagraphs = plainTextForExport.split('\n').map(
                    line => new Paragraph({ children: [new TextRun(line)] })
                );
                const doc = new Document({ sections: [{ children: textParagraphs }] });
                const fileName = `${activeDocType}_${activeSubtype}_${new Date().toISOString().slice(0, 10)}.docx`;
                Packer.toBlob(doc).then(blob => { window.saveAs(blob, fileName); });
            };

            const handleCopyDocument = () => {
                const tempDiv = document.createElement('div');
                tempDiv.innerHTML = generatedDocument;
                const plainTextForExport = tempDiv.textContent || tempDiv.innerText || "";

                navigator.clipboard.writeText(plainTextForExport).then(() => {
                    setCopySuccess(true);
                    setTimeout(() => setCopySuccess(false), 2000);
                });
            };

            const handleSaveAndReset = () => {
                handleSaveDocx();
                setFormData({ ...initialFormData });
                setSelectedStandaardTeksten({});
            };

            const selecteerBedrijf = (bedrijfsnaam) => {
                setFormData(prev => ({ ...prev, bedrijfsNaam: bedrijfsnaam }));
                setToonBedrijfsSuggesties(false);
            };

            const handleBedrijfsnaamBlur = () => {
                setTimeout(() => { setToonBedrijfsSuggesties(false); }, 150);
            };

            const goToNextFormStep = () => setActiveFormStep(prev => Math.min(prev + 1, (config.steps[activeDocType] || []).length));
            const goToPrevFormStep = () => setActiveFormStep(prev => Math.max(1, prev - 1));
            const startTutorial = () => setTutorialStep(1);
            const endTutorial = () => setTutorialStep(0);
            const nextTutorialStep = () => setTutorialStep(prev => prev + 1);
            const prevTutorialStep = () => setTutorialStep(prev => prev - 1);

            const renderSelect = (label, value, onChange, options, id) => {
                return h('div', { className: 'form-group' },
                    h('label', { htmlFor: id }, label),
                    h('select', {
                        id,
                        value,
                        onChange: (e) => onChange(e.target.value),
                        className: 'form-select'
                    },
                        options.map(option =>
                            h('option', { key: option.value, value: option.value }, option.label)
                        )
                    )
                );
            };

            const renderBeoordelaarGriffier = (isTelefonisch = false) => {
                return h(Fragment, null,
                    h('div', {
                        style: {
                            fontWeight: 'bold',
                            fontSize: '15px',
                            marginBottom: '4px',
                            marginTop: '10px'
                        }
                    }, isTelefonisch ? 'Beoordelaar (telefonisch)' : 'Beoordelaar'),
                    h('div', { className: 'input-group-row' },
                        h('div', { className: 'input-group voorletters' },
                            h('label', { htmlFor: 'beoordelaar-voorletters' }, 'Voorletters:'),
                            h('input', {
                                id: 'beoordelaar-voorletters',
                                type: 'text',
                                value: formData.beoordelaarVoorletters,
                                placeholder: 'bv. J.',
                                onChange: (e) => handleInputChange('beoordelaarVoorletters', e.target.value)
                            })
                        ),
                        h('div', { className: 'input-group' },
                            h('label', { htmlFor: 'beoordelaar-achternaam' }, 'Achternaam:'),
                            h('input', {
                                id: 'beoordelaar-achternaam',
                                type: 'text',
                                value: formData.beoordelaarAchternaam,
                                placeholder: 'Voer achternaam in',
                                onChange: (e) => handleInputChange('beoordelaarAchternaam', e.target.value)
                            })
                        )
                    ),

                    // Griffier subtitel (alleen bij fysiek)
                    activeSubtype === 'fysiek' && h(Fragment, null,
                        h('div', {
                            style: {
                                fontWeight: 'bold',
                                fontSize: '15px',
                                marginBottom: '4px',
                                marginTop: '10px'
                            }
                        }, 'Griffier'),
                        h('div', { className: 'input-group-row' },
                            h('div', { className: 'input-group voorletters' },
                                h('label', { htmlFor: 'griffier-voorletters' }, 'Voorletters:'),
                                h('input', {
                                    id: 'griffier-voorletters',
                                    type: 'text',
                                    value: formData.griffierVoorletters,
                                    placeholder: 'bv. M.',
                                    onChange: (e) => handleInputChange('griffierVoorletters', e.target.value)
                                })
                            ),
                            h('div', { className: 'input-group' },
                                h('label', { htmlFor: 'griffier-achternaam' }, 'Achternaam:'),
                                h('input', {
                                    id: 'griffier-achternaam',
                                    type: 'text',
                                    value: formData.griffierAchternaam,
                                    placeholder: 'Voer achternaam in',
                                    onChange: (e) => handleInputChange('griffierAchternaam', e.target.value)
                                })
                            )
                        )
                    )
                );
            };

            const renderAanwezigheid = () => {
                return renderSelect("Aanwezigheid", formData.aanwezigheid, (val) => handleInputChange('aanwezigheid', val), aanwezigheidOptions, 'aanwezigheid');
            };

            const renderSlider = (label, value, onChange, min, max, step) => {
                return h('div', { className: 'form-group' },
                    h('label', { htmlFor: label }, label),
                    h('div', { className: 'slider-container' },
                        h('input', {
                            type: 'range',
                            id: label,
                            min,
                            max,
                            step,
                            value,
                            onChange: (e) => onChange(e.target.value),
                            className: 'slider'
                        }),
                        h('span', { className: 'slider-value' }, value)
                    )
                );
            };

            const renderToelichtingAfwezigheid = () => {
                const vertegenwoordigerLabel = formData.vertegenwoordigerType === 'betrokkene' ? 'betrokkene' : 'gemachtigde';
                return h(Fragment, null,
                    h('h4', { className: 'sub-kopje' }, `Toelichting op afwezigheid ${vertegenwoordigerLabel}`),
                    renderSlider('Hoe vaak heb je contact opgenomen met de gemachtigde?', formData.contactpogingen, (val) => handleInputChange('contactpogingen', val), 2, 6, 1)
                );
            };

            const renderRedenNietAanwezig = () => {
                return h('div', { className: 'input-group' },
                    h('label', { htmlFor: 'reden-niet-aanwezig' }, 'Reden niet aanwezig:'),
                    h('textarea', {
                        id: 'reden-niet-aanwezig',
                        value: formData.redenNietAanwezig,
                        placeholder: 'Voer de reden in waarom de vertegenwoordiger niet aanwezig was...',
                        rows: 3,
                        onChange: (e) => handleInputChange('redenNietAanwezig', e.target.value)
                    })
                );
            };

            const renderVertegenwoordiger = () => {
                return h(Fragment, null,
                    h('div', { className: 'section-header' }, h('span', null, 'Namens betrokkene')),
                    h('div', { className: 'input-group-row' },
                        h('div', { className: 'input-group voorletters' },
                            h('label', { htmlFor: 'aanwezige-voorletters' }, 'Voorletters betrokkene:'),
                            h('input', {
                                id: 'aanwezige-voorletters',
                                type: 'text',
                                value: formData.aanwezigeVoorletters,
                                placeholder: 'bv. P.',
                                onChange: (e) => handleInputChange('aanwezigeVoorletters', e.target.value)
                            })
                        ),
                        h('div', { className: 'input-group' },
                            h('label', { htmlFor: 'aanwezige-achternaam' }, 'Achternaam betrokkene:'),
                            h('input', {
                                id: 'aanwezige-achternaam',
                                type: 'text',
                                value: formData.aanwezigeAchternaam,
                                placeholder: 'Voer achternaam in',
                                onChange: (e) => handleInputChange('aanwezigeAchternaam', e.target.value)
                            })
                        )
                    ),
                    formData.vertegenwoordigerType === 'gemachtigde' && h('div', { className: 'input-group' },
                        h('label', { htmlFor: 'bedrijfs-naam' }, 'Bedrijfsnaam (alleen indien gemachtigde):'),
                        h('input', {
                            id: 'bedrijfs-naam',
                            type: 'text',
                            value: formData.bedrijfsNaam,
                            placeholder: 'Voer bedrijfsnaam in',
                            onChange: (e) => handleInputChange('bedrijfsNaam', e.target.value),
                            onBlur: handleBedrijfsnaamBlur
                        }),
                        toonBedrijfsSuggesties && bedrijfsSuggesties.length > 0 && h('div', { className: 'autocomplete-suggestions' },
                            bedrijfsSuggesties.map((suggestie, index) =>
                                h('div', {
                                    key: index,
                                    className: 'suggestion-item',
                                    onClick: () => selecteerBedrijf(suggestie.name)
                                }, suggestie.name)
                            )
                        )
                    )
                );
            };

            const renderStep1 = () => {
                const isFysiek = activeSubtype === 'fysiek';
                const isTelefonisch = activeSubtype === 'telefonisch';

                return h(Fragment, null,
                    h('h3', { className: 'stap-titel' }, h('span', { className: 'step-icon', dangerouslySetInnerHTML: { __html: config.steps.hoorverslag[0].icon } }), ' Stap 1: Aanwezigheid'),
                    renderSelect("Subtype", activeSubtype, handleSubtypeChange, config.subtypes.hoorverslag),
                    isFysiek && renderBeoordelaarGriffier(),
                    isTelefonisch && renderBeoordelaarGriffier(true),
                    renderAanwezigheid(),
                    formData.aanwezigheid === 'afwezig' && (
                        isFysiek ? renderRedenNietAanwezig() :
                        isTelefonisch ? renderToelichtingAfwezigheid() : null
                    ),
                    renderVertegenwoordiger()
                );
            };

            // =====================
            // 4. Documentgeneratie useEffect
            // =====================
            useEffect(() => {
                // 4a. Functie om document te genereren
                const generateDocument = () => {
                    // 1. Template ophalen en fallback als niet gevonden
                    const templateString = config.templates[activeDocType]?.[activeSubtype];
                    if (!templateString) {
                        setGeneratedDocument("Selecteer een geldig documenttype en subtype.");
                        return;
                    }

                    // 2. Data voorbereiden voor template
                    let data = { ...formData };
                    const addSingleSpacingIfNeeded = (text) => text && text.trim() ? `\n${text.trim()}` : '';
                    const addDoubleSpacingIfNeeded = (text) => text && text.trim() ? `\n\n${text.trim()}` : '';
                    data.huidigeDatum = new Date().toLocaleDateString('nl-NL', { day: '2-digit', month: '2-digit', year: 'numeric' });

                    // 3. Speciale gevallen bepalen (Verkeersboete.nl, Skandara)
                    const isVerkeersboeteSpecialCase = activeDocType === 'hoorverslag' && formData.bedrijfsNaam.trim().toLowerCase() === 'verkeersboete.nl';
                    const isSkandaraSpecialCase = activeDocType === 'hoorverslag' && formData.bedrijfsNaam.trim().toLowerCase() === 'skandara';

                    // 4. Velden vullen voor hoorverslag
                    if (activeDocType === 'hoorverslag') {
                        // 4a. Naamvelden samenstellen
                        data.beoordelaarVolledigeNaam = `${data.beoordelaarVoorletters || ''} ${data.beoordelaarAchternaam || ''}`.trim();
                        data.griffierVolledigeNaam = activeSubtype === 'fysiek' ? `${data.griffierVoorletters || ''} ${data.griffierAchternaam || ''}`.trim() : 'n.v.t.';

                        // 4b. Aanwezigheidstekst opbouwen
                        data.aanwezigheidsTekst = data.aanwezigheid === 'aanwezig'
                            ? `${data.vertegenwoordigerType === 'betrokkene' ? 'Betrokkene aanwezig:' : 'Namens betrokkene aanwezig:'} ${data.aanwezigeVoorletters || ''} ${data.aanwezigeAchternaam || ''}`.trim() + (data.bedrijfsNaam ? ` namens ${data.bedrijfsNaam}` : '')
                            : `De ${data.vertegenwoordigerType} was niet aanwezig.`;

                        // 4c. Standaardteksten verwerken
                        let tekstenContent = '';
                        if (isVerkeersboeteSpecialCase) {
                            tekstenContent = Object.keys(selectedStandaardTeksten)
                                .filter(key => selectedStandaardTeksten[key] && VerkeersboeteTeksten[key])
                                .map(key => VerkeersboeteTeksten[key].tekst)
                                .join('\n\n');
                        } else if (isSkandaraSpecialCase) {
                            tekstenContent = Object.keys(selectedStandaardTeksten)
                                .filter(key => selectedStandaardTeksten[key] && SkandaraTeksten[key])
                                .map(key => SkandaraTeksten[key].tekst)
                                .join('\n\n');
                        }
                        data.aanvullendeGrondenSectie = tekstenContent ? `Aanvullende gronden op het beroepschrift\n${tekstenContent}` : (data.reactieVerweten ? `Aanvullende gronden op het beroepschrift\n${data.reactieVerweten.trim()}` : '');

                        // 4d. Reden afwezigheid verwerken
                        let redenContent = '';
                        if (data.aanwezigheid === 'afwezig') {
                            if (activeSubtype === 'telefonisch' && data.redenAfwezigheidKeuze) {
                                const gekozenOptie = config.dropdownOptions.redenAfwezigheidOpties.find(opt => opt.value === data.redenAfwezigheidKeuze);
                                redenContent = gekozenOptie ? gekozenOptie.label : '';
                            } else if (data.redenNietAanwezig) {
                                redenContent = data.redenNietAanwezig;
                            }
                        }
                        data.redenNietAanwezigSectie = redenContent ? `\n\nReden geen ${data.vertegenwoordigerType} aanwezig:${addSingleSpacingIfNeeded(redenContent)}` : '';
                        
                        // 4e. Tijdsregistratie verwerken
                        let tijdsregistratieTekst = '';
                        if ((data.startTime && data.startTime.trim().length > 0) || (data.endTime && data.endTime.trim().length > 0)) {
                            tijdsregistratieTekst = 'Tijdsregistratie\nDe zitting begon om ' + (data.startTime || '...') + ' en eindigde om ' + (data.endTime || '...') + '.';
                        }
                        // Procesverloop altijd boven tijdsregistratie
                        let procesverloopBlok = 'De ' + data.vertegenwoordigerType + ' is op de juiste manier uitgenodigd voor de hoorzitting. De op de zaak betrekking hebbende stukken zijn ' + (data.stukkenVerstrekt === 'wel' ? 'wel' : 'niet') + ' aan de ' + data.vertegenwoordigerType + ' verstrekt voorafgaand aan de hoorzitting.';
                        if (tijdsregistratieTekst) {
                            procesverloopBlok += '\n\n' + tijdsregistratieTekst;
                        }
                        data.procesverloopTekst = procesverloopBlok;
                        
                        // 4f. Overige secties vullen (aanhouding, tijdigheid, vragen, reacties, afspraken, afloop)
                        data.aanhoudingTekst = (data.aanhoudingBesluitGenomen && data.aanhouding) ? `\n\nEventueel besluit aanhoudingsverzoek/verzoek telefonische hoorzitting${addSingleSpacingIfNeeded(data.aanhouding)}` : '';
                        let tijdigheidContent = '';
                        if (data.tijdigheidBeroepType && data.tijdigheidBeroepType !== 'tijdigIngediend') {
                            const selectedOpt = config.dropdownOptions.tijdigheidBeroepOpties.find(opt => opt.value === data.tijdigheidBeroepType);
                            tijdigheidContent = selectedOpt.label;
                            if (data.reactieTeLaat) {
                                tijdigheidContent += `\nReactie m.b.t. te late indiening:\n${data.reactieTeLaat.trim()}`;
                            }
                        }
                        data.tijdigheidSectie = tijdigheidContent ? `\nTijdigheid van het administratief beroep\n${tijdigheidContent}` : '';
                        data.vragenBeoordelaarSectie = data.vragenBeoordelaar ? `Vragen/standpunt van de beoordelaar\n${data.vragenBeoordelaar.trim()}` : '';
                        data.reactieBetrokkeneSectie = (data.reactieOpnemen && data.reactieBetrokkene) ? `\nEventuele reactie ${data.vertegenwoordigerType}\n${data.reactieBetrokkene.trim()}` : '';

                        let vervolgVragen = '';
                        if (data.vervolgvragenGesteld) {
                            vervolgVragen = `\nOverige vragen vanuit de beoordelaar${addSingleSpacingIfNeeded(data.overigeVragen)}`;
                            if (data.reactieVervolgvragenOpnemen && data.reactieBetrokkene2) {
                                vervolgVragen += `\n\nEventuele reactie ${data.vertegenwoordigerType}\n${data.reactieBetrokkene2.trim()}`;
                            }
                        }
                        data.vervolgvragenSectie = vervolgVragen;
                        data.afsprakenSectie = data.afspraken ? `\nAfspraken\n${data.afspraken.trim()}` : '';

                        const afloopOptie = config.dropdownOptions.afloopZaakOpties.find(opt => opt.value === data.afloopZaakType);
                        data.afloopZaakTekst = afloopOptie ? afloopOptie.label : '(Geen afloop geselecteerd)';
                        if (data.afloopZaakType === 'mondelingUitspraak' && data.mondelingUitspraakTekst) {
                            data.afloopZaakTekst += `, namelijk:\n${data.mondelingUitspraakTekst.trim()}`;
                        }
                    } else if (activeDocType === 'beslissing') {
                        // 5a. Type beslissing info
                        const selectedOption = config.dropdownOptions.beslissingTypeOpties.find(opt => opt.value === data.beslissingTypeKeuze);
                        data.beslissingTypeInfo = selectedOption ? `Gekozen Type Beslissing: ${selectedOption.label}\n` : '';

                        // 5b. Tekstvelden met spacing
                        data.hoofdTekstMetSpacing = addDoubleSpacingIfNeeded(data.hoofdTekst);
                        data.aanvullendeArgumentenMetSpacing = addDoubleSpacingIfNeeded(data.aanvullendeArgumenten);
                        data.besluitTekstMetSpacing = addDoubleSpacingIfNeeded(data.besluitTekst);
                        data.disclaimerTekstMetSpacing = addDoubleSpacingIfNeeded(data.disclaimerTekst);
                        data.handtekeningBlokMetSpacing = addDoubleSpacingIfNeeded(data.handtekeningBlok);
                        data.voorwaardenTekstMetSpacing = addDoubleSpacingIfNeeded(data.voorwaardenTekst);
                        data.betalingsInformatieMetSpacing = addDoubleSpacingIfNeeded(data.betalingsInformatie);
                        data.bezwaarProcedureMetSpacing = addDoubleSpacingIfNeeded(data.bezwaarProcedure);
                        data.juridischeGrondslagMetSpacing = addDoubleSpacingIfNeeded(data.juridischeGrondslag);
                        data.bewijslijstMetSpacing = addDoubleSpacingIfNeeded(data.bewijslijst);
                        data.tariefInformatieMetSpacing = addDoubleSpacingIfNeeded(data.tariefInformatie);
                        data.vertrouwelijkheidsClausuleMetSpacing = addDoubleSpacingIfNeeded(data.vertrouwelijkheidsClausule);
                    }

                    // 6. Template compileren en document genereren
                    const compiledTemplate = Handlebars.compile(templateString);
                    let finalDocument = compiledTemplate(data).replace(/\n{3,}/g, '\n\n').trim();

                    // 7. Kopje toevoegen voor hoorverslag
                    if (activeDocType === 'hoorverslag') {
                        // Voeg kopje toe bovenaan het document
                        finalDocument = `Aanwezigen\n${finalDocument}`;
                    }
                    
                    // 8. HTML opmaak toevoegen
                    const kopjes = [
                        'Aanwezigen', 'Procesverloop', 'Tijdsregistratie', 
                        'Eventueel besluit aanhoudingsverzoek/verzoek telefonische hoorzitting',
                        'Cautie', 'Afloop van de zaak', 'Tijdigheid van het administratief beroep',
                        'Aanvullende gronden op het beroepschrift', 'Vragen/standpunt van de beoordelaar',
                        'Eventuele reactie gemachtigde', 'Eventuele reactie betrokkene',
                        'Overige vragen vanuit de beoordelaar', 'Afspraken',
                        'Reden geen gemachtigde aanwezig:', 'Reden geen betrokkene aanwezig:'
                    ];
                    let htmlDocument = finalDocument.split('\n').map(line => {
                        const trimmedLine = line.trim();
                        if (kopjes.includes(trimmedLine)) {
                            return `<strong>${trimmedLine}</strong>`;
                        }
                        return line;
                    }).join('<br>');


                    // 9. Preview updaten
                    setGeneratedDocument(htmlDocument);
                };
                generateDocument();
            }, [formData, activeDocType, activeSubtype, tijdsregistratieVerdeeld, selectedStandaardTeksten]);

            // =====================
            // 5. Tutorial overlay useEffect
            // =====================
            useEffect(() => {
                const overlay = document.getElementById('highlight-overlay');
                if (!overlay) return;
                if (tutorialStep > 0 && tutorialStep <= tutorialSteps.length) {
                    const currentStepData = tutorialSteps[tutorialStep - 1];
                    setCurrentTutorialText(currentStepData.message);
                    const targetElement = document.getElementById(currentStepData.targetId);
                    if (targetElement) {
                        const rect = targetElement.getBoundingClientRect();
                        Object.assign(overlay.style, {
                            left: `${rect.left + window.scrollX - 5}px`,
                            top: `${rect.top + window.scrollY - 5}px`,
                            width: `${rect.width + 10}px`,
                            height: `${rect.height + 10}px`,
                            display: 'block'
                        });
                    }
                } else {
                    overlay.style.display = 'none';
                }
            }, [tutorialStep]);

            // =====================
            // 6. Render logica voor stappen
            // =====================
            const renderStepContent = () => {
                const isVerkeersboeteSpecialCase = activeDocType === 'hoorverslag' && formData.bedrijfsNaam.trim().toLowerCase() === 'verkeersboete.nl';

                if (activeDocType === 'hoorverslag') {
                    switch (activeFormStep) {
                        case 1:
                            return h('div', { className: 'step-content-inner' },
                                // 1. Aanwezigheid
                                h('div', { className: 'section-header' }, h('span', null, 'Aanwezigheid')),
                                h('div', { className: 'input-group-row' },
                                    h('div', { className: 'input-group' },
                                        h('label', { htmlFor: 'vertegenwoordiger-type' }, 'Zittingsvertegenwoordiger:'),
                                        h('select', {
                                            id: 'vertegenwoordiger-type',
                                            value: formData.vertegenwoordigerType,
                                            onChange: (e) => handleInputChange('vertegenwoordigerType', e.target.value)
                                        },
                                            config.dropdownOptions.vertegenwoordiger.map(option =>
                                                h('option', { key: option.value, value: option.value }, option.label)
                                            )
                                        )
                                    ),
                                    h('div', { className: 'input-group' },
                                        h('label', { htmlFor: 'aanwezigheid' }, 'De vertegenwoordiger is:'),
                                        h('select', {
                                            id: 'aanwezigheid',
                                            value: formData.aanwezigheid,
                                            onChange: (e) => handleInputChange('aanwezigheid', e.target.value)
                                        },
                                            aanwezigheidOptions.map(option =>
                                                h('option', { key: option.value, value: option.value }, option.label)
                                            )
                                        )
                                    )
                                ),

                                // 2. Namens CVOM
                                h('div', { className: 'section-header' }, h('span', null, 'Namens CVOM')),

                                // Beoordelaar subtitel
                                h('div', {
                                    style: {
                                        fontWeight: 'bold',
                                        fontSize: '15px',
                                        marginBottom: '4px',
                                        marginTop: '10px'
                                    }
                                }, 'Beoordelaar'),
                                h('div', { className: 'input-group-row' },
                                    h('div', { className: 'input-group voorletters' },
                                        h('label', { htmlFor: 'beoordelaar-voorletters' }, 'Voorletters:'),
                                        h('input', {
                                            id: 'beoordelaar-voorletters',
                                            type: 'text',
                                            value: formData.beoordelaarVoorletters,
                                            placeholder: 'bv. J.',
                                            onChange: (e) => handleInputChange('beoordelaarVoorletters', e.target.value)
                                        })
                                    ),
                                    h('div', { className: 'input-group' },
                                        h('label', { htmlFor: 'beoordelaar-achternaam' }, 'Achternaam:'),
                                        h('input', {
                                            id: 'beoordelaar-achternaam',
                                            type: 'text',
                                            value: formData.beoordelaarAchternaam,
                                            placeholder: 'Voer achternaam in',
                                            onChange: (e) => handleInputChange('beoordelaarAchternaam', e.target.value)
                                        })
                                    )
                                ),

                                // Griffier subtitel (alleen bij fysiek)
                                activeSubtype === 'fysiek' && h(Fragment, null,
                                    h('div', {
                                        style: {
                                            fontWeight: 'bold',
                                            fontSize: '15px',
                                            marginBottom: '4px',
                                            marginTop: '10px'
                                        }
                                    }, 'Griffier'),
                                    h('div', { className: 'input-group-row' },
                                        h('div', { className: 'input-group voorletters' },
                                            h('label', { htmlFor: 'griffier-voorletters' }, 'Voorletters:'),
                                            h('input', {
                                                id: 'griffier-voorletters',
                                                type: 'text',
                                                value: formData.griffierVoorletters,
                                                placeholder: 'bv. M.',
                                                onChange: (e) => handleInputChange('griffierVoorletters', e.target.value)
                                            })
                                        ),
                                        h('div', { className: 'input-group' },
                                            h('label', { htmlFor: 'griffier-achternaam' }, 'Achternaam:'),
                                            h('input', {
                                                id: 'griffier-achternaam',
                                                type: 'text',
                                                value: formData.griffierAchternaam,
                                                placeholder: 'Voer achternaam in',
                                                onChange: (e) => handleInputChange('griffierAchternaam', e.target.value)
                                            })
                                        )
                                    )
                                ),

                                // 3. Namens betrokkene
                                h('div', { className: 'section-header' }, h('span', null, 'Namens betrokkene')),
                                h('div', { className: 'input-group-row' },
                                    h('div', { className: 'input-group voorletters' },
                                        h('label', { htmlFor: 'aanwezige-voorletters' }, 'Voorletters betrokkene:'),
                                        h('input', {
                                            id: 'aanwezige-voorletters',
                                            type: 'text',
                                            value: formData.aanwezigeVoorletters,
                                            placeholder: 'bv. P.',
                                            onChange: (e) => handleInputChange('aanwezigeVoorletters', e.target.value)
                                        })
                                    ),
                                    h('div', { className: 'input-group' },
                                        h('label', { htmlFor: 'aanwezige-achternaam' }, 'Achternaam betrokkene:'),
                                        h('input', {
                                            id: 'aanwezige-achternaam',
                                            type: 'text',
                                            value: formData.aanwezigeAchternaam,
                                            placeholder: 'Voer achternaam in',
                                            onChange: (e) => handleInputChange('aanwezigeAchternaam', e.target.value)
                                        })
                                    )
                                ),
                                formData.vertegenwoordigerType === 'gemachtigde' && h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'bedrijfs-naam' }, 'Bedrijfsnaam (alleen indien gemachtigde):'),
                                    h('input', {
                                        id: 'bedrijfs-naam',
                                        type: 'text',
                                        value: formData.bedrijfsNaam,
                                        placeholder: 'Voer bedrijfsnaam in',
                                        onChange: (e) => handleInputChange('bedrijfsNaam', e.target.value),
                                        onBlur: handleBedrijfsnaamBlur
                                    }),
                                    toonBedrijfsSuggesties && bedrijfsSuggesties.length > 0 && h('div', { className: 'autocomplete-suggestions' },
                                        bedrijfsSuggesties.map((suggestie, index) =>
                                            h('div', {
                                                key: index,
                                                className: 'suggestion-item',
                                                onClick: () => selecteerBedrijf(suggestie.name)
                                            }, suggestie.name)
                                        )
                                    )
                                )
                            );
                        case 2:
                            return h('div', { className: 'step-content-inner' },
                                h('div', { className: 'section-header' }, h('span', null, 'Procesverloop gegevens')),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'stukken-verstrekt' }, 'Stukken verstrekt:'),
                                    h('select', { id: 'stukken-verstrekt', value: formData.stukkenVerstrekt, onChange: (e) => handleInputChange('stukkenVerstrekt', e.target.value) },
                                        config.dropdownOptions.stukkenVerstrekt.map(option => h('option', { key: option.value, value: option.value }, option.label))
                                    )
                                ),
                                h('div', { className: 'input-group' },
                                    h('label', { className: 'checkbox-label' },
                                        h('input', { type: 'checkbox', id: 'aanhouding-besluit', checked: formData.aanhoudingBesluitGenomen, onChange: (e) => handleInputChange('aanhoudingBesluitGenomen', e.target.checked) }),
                                        'Besluit aanhoudingsverzoek/verzoek telefonische hoorzitting genomen?'
                                    )
                                ),
                                formData.aanhoudingBesluitGenomen && h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'aanhouding-details' }, 'Aanhouding details:'),
                                    h('textarea', { id: 'aanhouding-details', value: formData.aanhouding, placeholder: 'Beschrijf de details van het aanhoudingsbesluit...', rows: 3, onChange: (e) => handleInputChange('aanhouding', e.target.value) })
                                ),
                                // Tijdsregistratie sectie
                                h('div', { className: 'section-header' }, h('span', null, 'Tijdsregistratie')),
                                h('div', { className: 'input-group-row' },
                                    h('div', { className: 'input-group' },
                                        h('label', { htmlFor: 'start-tijd' }, 'Starttijd (HH:MM):'),
                                        h('input', { id: 'start-tijd', type: 'text', value: formData.startTime, placeholder: 'bv. 09:30', pattern: '[0-9]{2}:[0-9]{2}', onChange: (e) => handleInputChange('startTime', e.target.value) })
                                    ),
                                    h('div', { className: 'input-group' },
                                        h('label', { htmlFor: 'eind-tijd' }, 'Eindtijd (HH:MM):'),
                                        h('input', { id: 'eind-tijd', type: 'text', value: formData.endTime, placeholder: 'bv. 10:15', pattern: '[0-9]{2}:[0-9]{2}', onChange: (e) => handleInputChange('endTime', e.target.value) })
                                    )
                                ),
                                // Afwezigheid reden sectie
                                formData.aanwezigheid === 'afwezig' && h(Fragment, null,
                                    h('div', { className: 'section-header' }, h('span', null, 'Reden afwezigheid')),
                                    activeSubtype === 'telefonisch' ? h('div', { className: 'input-group' },
                                        h('label', { htmlFor: 'reden-afwezigheid-keuze' }, 'Selecteer reden:'),
                                        h('select', { id: 'reden-afwezigheid-keuze', value: formData.redenAfwezigheidKeuze, onChange: (e) => handleInputChange('redenAfwezigheidKeuze', e.target.value) },
                                            config.dropdownOptions.redenAfwezigheidOpties.map(option => h('option', { key: option.value, value: option.value }, option.label))
                                        )
                                    ) : h('div', { className: 'input-group' },
                                        h('label', { htmlFor: 'reden-niet-aanwezig' }, 'Reden niet aanwezig:'),
                                        h('textarea', { id: 'reden-niet-aanwezig', value: formData.redenNietAanwezig, placeholder: 'Voer de reden in waarom de vertegenwoordiger niet aanwezig was...', rows: 3, onChange: (e) => handleInputChange('redenNietAanwezig', e.target.value) })
                                    )
                                )
                            );
                        case 3:
                            return h('div', { className: 'step-content-inner' },
                                h('div', { className: 'section-header' }, h('span', null, 'Tijdigheid van het beroep')),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'tijdigheid-beroep' }, 'Tijdigheid status:'),
                                    h('select', { id: 'tijdigheid-beroep', value: formData.tijdigheidBeroepType, onChange: (e) => handleInputChange('tijdigheidBeroepType', e.target.value) },
                                        config.dropdownOptions.tijdigheidBeroepOpties.map(option => h('option', { key: option.value, value: option.value }, option.label))
                                    )
                                ),
                                (formData.tijdigheidBeroepType === 'teLaatIngediend' || formData.tijdigheidBeroepType === 'termijnOverschreden') && h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'reactie-te-laat' }, 'Reactie m.b.t. te late indiening:'),
                                    h('textarea', { id: 'reactie-te-laat', value: formData.reactieTeLaat, placeholder: 'Beschrijf de reactie op de te late indiening...', rows: 3, onChange: (e) => handleInputChange('reactieTeLaat', e.target.value) })
                                ),

                                isVerkeersboeteSpecialCase ?
                                    h(VerkeersboeteTekstenComponent, { options: VerkeersboeteTeksten, selectedOptions: selectedStandaardTeksten, onChange: handleStandaardTekstChange }) :
                                    (activeDocType === 'hoorverslag' && formData.bedrijfsNaam && formData.bedrijfsNaam.trim().toLowerCase() === 'skandara') ?
                                        h(SkandaraTekstenComponent, { options: SkandaraTeksten, selectedOptions: selectedStandaardTeksten, onChange: handleStandaardTekstChange }) :
                                        h(Fragment, null,
                                            h('div', { className: 'section-header' }, h('span', null, 'Aanvullende gronden')),
                                            h('div', { className: 'input-group' },
                                                h('label', { htmlFor: 'reactie-verweten' }, 'Aanvullende gronden op het beroepschrift:'),
                                                h('textarea', { id: 'reactie-verweten', value: formData.reactieVerweten, placeholder: '(Optioneel) Beschrijf eventuele aanvullende gronden...', rows: 4, onChange: (e) => handleInputChange('reactieVerweten', e.target.value) })
                                            )
                                        ),

                                h('div', { className: 'section-header' }, h('span', null, 'Vragen en reacties')),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'vragen-beoordelaar' }, 'Vragen/standpunt van de beoordelaar:'),
                                    h('textarea', { id: 'vragen-beoordelaar', value: formData.vragenBeoordelaar, placeholder: '(Optioneel) Voer vragen of standpunt in...', rows: 4, onChange: (e) => handleInputChange('vragenBeoordelaar', e.target.value) })
                                ),
                                h('div', { className: 'input-group' },
                                    h('label', { className: 'checkbox-label' },
                                        h('input', { type: 'checkbox', id: 'reactie-opnemen', checked: formData.reactieOpnemen, onChange: (e) => handleInputChange('reactieOpnemen', e.target.checked) }),
                                        `Reactie ${formData.vertegenwoordigerType} opnemen?`
                                    )
                                ),
                                formData.reactieOpnemen && h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'reactie-betrokkene' }, `Reactie ${formData.vertegenwoordigerType}:`),
                                    h('textarea', { id: 'reactie-betrokkene', value: formData.reactieBetrokkene, placeholder: 'Voer de reactie in...', rows: 4, onChange: (e) => handleInputChange('reactieBetrokkene', e.target.value) })
                                ),
                                h('div', { className: 'section-header' }, h('span', null, 'Vervolgvragen')),
                                h('div', { className: 'input-group' },
                                    h('label', { className: 'checkbox-label' },
                                        h('input', { type: 'checkbox', id: 'vervolgvragen-gesteld', checked: formData.vervolgvragenGesteld, onChange: (e) => handleInputChange('vervolgvragenGesteld', e.target.checked) }),
                                        'Zijn er vervolgvragen gesteld?'
                                    )
                                ),
                                formData.vervolgvragenGesteld && h(Fragment, null,
                                    h('div', { className: 'input-group' },
                                        h('label', { htmlFor: 'overige-vragen' }, 'Overige vragen vanuit de beoordelaar:'),
                                        h('textarea', { id: 'overige-vragen', value: formData.overigeVragen, placeholder: '(Optioneel) Voer overige vragen in...', rows: 3, onChange: (e) => handleInputChange('overigeVragen', e.target.value) })
                                    ),
                                    h('div', { className: 'input-group' },
                                        h('label', { className: 'checkbox-label' },
                                            h('input', { type: 'checkbox', id: 'reactie-vervolgvragen-opnemen', checked: formData.reactieVervolgvragenOpnemen, onChange: (e) => handleInputChange('reactieVervolgvragenOpnemen', e.target.checked) }),
                                            `Reactie ${formData.vertegenwoordigerType} op vervolgvragen opnemen?`
                                        )
                                    ),
                                    formData.reactieVervolgvragenOpnemen && h('div', { className: 'input-group' },
                                        h('label', { htmlFor: 'reactie-betrokkene2' }, `Reactie ${formData.vertegenwoordigerType} op vervolgvragen:`),
                                        h('textarea', { id: 'reactie-betrokkene2', value: formData.reactieBetrokkene2, placeholder: 'Voer de reactie op vervolgvragen in...', rows: 4, onChange: (e) => handleInputChange('reactieBetrokkene2', e.target.value) })
                                    )
                                )
                            );

                        case 4:
                            return h('div', { className: 'step-content-inner' },
                                h('div', { className: 'section-header' }, h('span', null, 'Afspraken')),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'afspraken' }, 'Gemaakte afspraken:'),
                                    h('textarea', { id: 'afspraken', value: formData.afspraken, placeholder: '(Optioneel) Voer eventuele afspraken in...', rows: 4, onChange: (e) => handleInputChange('afspraken', e.target.value) })
                                ),
                                h('div', { className: 'section-header' }, h('span', null, 'Afloop van de zaak')),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'afloop-zaak' }, 'Type afloop:'),
                                    h('select', { id: 'afloop-zaak', value: formData.afloopZaakType, onChange: (e) => handleInputChange('afloopZaakType', e.target.value) },
                                        config.dropdownOptions.afloopZaakOpties.map(option => h('option', { key: option.value, value: option.value }, option.label))
                                    )
                                ),
                                formData.afloopZaakType === 'mondelingUitspraak' && h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'mondeling-uitspraak' }, 'Inhoud mondeling uitspraak:'),
                                    h('textarea', { id: 'mondeling-uitspraak', value: formData.mondelingUitspraakTekst, placeholder: 'Beschrijf de mondeling gedane uitspraak...', rows: 5, onChange: (e) => handleInputChange('mondelingUitspraakTekst', e.target.value) })
                                )
                            );
                        default: return null;
                    }
                }
                else if (activeDocType === 'beslissing') {
                    switch (activeFormStep) {
                        case 1:
                            return h('div', { className: 'step-content-inner' },
                                h('div', { className: 'section-header' }, h('span', null, 'Algemene Gegevens')),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'beslissing-type-keuze' }, 'Type Beslissing:'),
                                    h('select', { id: 'beslissing-type-keuze', value: formData.beslissingTypeKeuze, onChange: (e) => handleInputChange('beslissingTypeKeuze', e.target.value) },
                                        config.dropdownOptions.beslissingTypeOpties.map(opt => h('option', { key: opt.value, value: opt.value }, opt.label))
                                    )
                                ),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'geadresseerde' }, 'Geadresseerde:'),
                                    h('input', { id: 'geadresseerde', type: 'text', value: formData.geadresseerde, placeholder: 'Naam van de geadresseerde', onChange: (e) => handleInputChange('geadresseerde', e.target.value) })
                                ),
                                h('div', { className: 'input-group-row' },
                                    h('div', { className: 'input-group' },
                                        h('label', { htmlFor: 'referentieNummer' }, 'Referentienummer:'),
                                        h('input', { id: 'referentieNummer', type: 'text', value: formData.referentieNummer, placeholder: 'bv. 12345', onChange: (e) => handleInputChange('referentieNummer', e.target.value) })
                                    ),
                                    h('div', { className: 'input-group' },
                                        h('label', { htmlFor: 'accountNummer' }, 'Accountnummer:'),
                                        h('input', { id: 'accountNummer', type: 'text', value: formData.accountNummer, placeholder: 'bv. ACC67890', onChange: (e) => handleInputChange('accountNummer', e.target.value) })
                                    )
                                ),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'contactPersoon' }, 'Contactpersoon:'),
                                    h('input', { id: 'contactPersoon', type: 'text', value: formData.contactPersoon, placeholder: 'Naam contactpersoon', onChange: (e) => handleInputChange('contactPersoon', e.target.value) })
                                )
                            );
                        case 2:
                            return h('div', { className: 'step-content-inner' },
                                h('div', { className: 'section-header' }, h('span', null, 'Details van de Zaak')),
                                h('div', { className: 'input-group-row' },
                                    h('div', { className: 'input-group' },
                                        h('label', { htmlFor: 'boeteNummer' }, 'Boetnummer:'),
                                        h('input', { id: 'boeteNummer', type: 'text', value: formData.boeteNummer, placeholder: 'bv. 11.22.333.444', onChange: (e) => handleInputChange('boeteNummer', e.target.value) })
                                    ),
                                    h('div', { className: 'input-group' },
                                        h('label', { htmlFor: 'overtredingDatum' }, 'Datum Overtreding:'),
                                        h('input', { id: 'overtredingDatum', type: 'date', value: formData.overtredingDatum, onChange: (e) => handleInputChange('overtredingDatum', e.target.value) })
                                    )
                                ),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'voertuigInfo' }, 'Voertuiginformatie:'),
                                    h('input', { id: 'voertuigInfo', type: 'text', value: formData.voertuigInfo, placeholder: 'bv. Kenteken, merk, model', onChange: (e) => handleInputChange('voertuigInfo', e.target.value) })
                                ),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'overtredingType' }, 'Type Overtreding:'),
                                    h('input', { id: 'overtredingType', type: 'text', value: formData.overtredingType, placeholder: 'bv. Snelheidsovertreding', onChange: (e) => handleInputChange('overtredingType', e.target.value) })
                                ),
                                h('div', { className: 'input-group-row' },
                                    h('div', { className: 'input-group' },
                                        h('label', { htmlFor: 'clientId' }, 'Cliënt ID:'),
                                        h('input', { id: 'clientId', type: 'text', value: formData.clientId, placeholder: 'bv. C-54321', onChange: (e) => handleInputChange('clientId', e.target.value) })
                                    ),
                                    h('div', { className: 'input-group' },
                                        h('label', { htmlFor: 'serviceType' }, 'Type Service:'),
                                        h('input', { id: 'serviceType', type: 'text', value: formData.serviceType, placeholder: 'bv. Juridisch Advies', onChange: (e) => handleInputChange('serviceType', e.target.value) })
                                    )
                                )
                            );
                        case 3:
                            return h('div', { className: 'step-content-inner' },
                                h('div', { className: 'section-header' }, h('span', null, 'Argumenten en Onderbouwing')),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'hoofdTekst' }, 'Hoofdtekst:'),
                                    h('textarea', { id: 'hoofdTekst', value: formData.hoofdTekst, placeholder: 'Voer de hoofdtekst van de beslissing in...', rows: 6, onChange: (e) => handleInputChange('hoofdTekst', e.target.value) })
                                ),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'juridischeGrondslag' }, 'Juridische Grondslag:'),
                                    h('textarea', { id: 'juridischeGrondslag', value: formData.juridischeGrondslag, placeholder: 'Beschrijf de juridische grondslag...', rows: 4, onChange: (e) => handleInputChange('juridischeGrondslag', e.target.value) })
                                ),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'bewijslijst' }, 'Bewijslijst:'),
                                    h('textarea', { id: 'bewijslijst', value: formData.bewijslijst, placeholder: 'Lijst van bewijsstukken...', rows: 4, onChange: (e) => handleInputChange('bewijslijst', e.target.value) })
                                ),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'aanvullendeArgumenten' }, 'Aanvullende Argumenten:'),
                                    h('textarea', { id: 'aanvullendeArgumenten', value: formData.aanvullendeArgumenten, placeholder: 'Voer aanvullende argumenten in...', rows: 4, onChange: (e) => handleInputChange('aanvullendeArgumenten', e.target.value) })
                                )
                            );
                        case 4:
                            return h('div', { className: 'step-content-inner' },
                                h('div', { className: 'section-header' }, h('span', null, 'Definitief Besluit en Clausules')),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'besluitTekst' }, 'Besluit Tekst:'),
                                    h('textarea', { id: 'besluitTekst', value: formData.besluitTekst, placeholder: 'De uiteindelijke beslissing...', rows: 5, onChange: (e) => handleInputChange('besluitTekst', e.target.value) })
                                ),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'bezwaarProcedure' }, 'Bezwaarprocedure:'),
                                    h('textarea', { id: 'bezwaarProcedure', value: formData.bezwaarProcedure, placeholder: 'Informatie over de bezwaarprocedure...', rows: 3, onChange: (e) => handleInputChange('bezwaarProcedure', e.target.value) })
                                ),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'betalingsInformatie' }, 'Betalingsinformatie:'),
                                    h('textarea', { id: 'betalingsInformatie', value: formData.betalingsInformatie, placeholder: 'Details over betalingen...', rows: 3, onChange: (e) => handleInputChange('betalingsInformatie', e.target.value) })
                                ),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'voorwaardenTekst' }, 'Voorwaarden:'),
                                    h('textarea', { id: 'voorwaardenTekst', value: formData.voorwaardenTekst, placeholder: 'Algemene voorwaarden...', rows: 3, onChange: (e) => handleInputChange('voorwaardenTekst', e.target.value) })
                                ),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'disclaimerTekst' }, 'Disclaimer:'),
                                    h('textarea', { id: 'disclaimerTekst', value: formData.disclaimerTekst, placeholder: 'Disclaimer tekst...', rows: 3, onChange: (e) => handleInputChange('disclaimerTekst', e.target.value) })
                                ),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'vertrouwelijkheidsClausule' }, 'Vertrouwelijkheidsclausule:'),
                                    h('textarea', { id: 'vertrouwelijkheidsClausule', value: formData.vertrouwelijkheidsClausule, placeholder: 'Clausule over vertrouwelijkheid...', rows: 3, onChange: (e) => handleInputChange('vertrouwelijkheidsClausule', e.target.value) })
                                ),
                                h('div', { className: 'input-group' },
                                    h('label', { htmlFor: 'handtekeningBlok' }, 'Handtekening Blok:'),
                                    h('textarea', { id: 'handtekeningBlok', value: formData.handtekeningBlok, placeholder: 'bv. Met vriendelijke groet,\n\nNaam\nFunctie', rows: 4, onChange: (e) => handleInputChange('handtekeningBlok', e.target.value) })
                                )
                            );
                        default: return null;
                    }
                }
                return null;
            };
            
            // =====================
            // 7. Hoofdreturn van de App-component (UI)
            // =====================
            const handlePreviewChange = (event) => {
                setGeneratedDocument(event.target.innerHTML);
            };

            return h(Fragment, null,
                h('div', { className: 'app-container' },
                    h('div', { id: 'steps-sidebar', className: 'sidebar' },
                        h('div', { className: 'logo' }, 'DocGen'),
                        h('div', { id: 'document-type-toggle', className: 'theme-toggle' },
                            config.documentTypes.map(doc => h('button', {
                                key: doc.id,
                                className: activeDocType === doc.id ? 'active' : '',
                                onClick: () => handleDocTypeChange(doc.id)
                            }, doc.name))
                        ),
                        h('div', { id: 'steps-navigation', className: 'steps' },
                            (config.steps[activeDocType] || []).map(step => h('button', {
                                key: step.number,
                                className: `step-button ${activeFormStep === step.number ? 'active' : ''}`,
                                onClick: () => setActiveFormStep(step.number)
                            },
                                h('span', { className: 'step-icon', dangerouslySetInnerHTML: { __html: step.icon } }),
                                h('span', { className: 'step-title' }, step.title),
                                h('span', { className: 'step-arrow', dangerouslySetInnerHTML: { __html: icons.chevronRight } })
                            ))
                        )
                    ),
                    h('div', { id: 'form-content-area', className: 'main-content' },
                        h('div', { className: 'content-header' },
                            h('h1', null, `${config.steps[activeDocType]?.find(s => s.number === activeFormStep)?.title || '...'} (Stap ${activeFormStep}/${(config.steps[activeDocType] || []).length})`),
                            h('button', { className: 'action-button help-button', onClick: startTutorial }, h('span', { dangerouslySetInnerHTML: {__html: icons.questionCircle}}), " Tutorial")
                        ),
                        h('div', { id: 'subtype-tabs', className: 'company-tabs' },
                            (config.subtypes[activeDocType] || []).map(sub => h('button', {
                                key: sub.id,
                                className: `company-tab ${activeSubtype === sub.id ? 'active' : ''}`,
                                onClick: () => handleSubtypeChange(sub.id)
                            }, sub.name))
                        ),
                        tutorialStep > 0 && tutorialStep <= tutorialSteps.length && h('div', { className: 'tutorial-explanation' },
                            h('p', null, currentTutorialText),
                            h('div', { className: 'tutorial-nav' },
                                h('button', { className: 'nav-button', onClick: prevTutorialStep, disabled: tutorialStep === 1 }, "Vorige"),
                                tutorialStep < tutorialSteps.length
                                    ? h('button', { className: 'nav-button next-button', onClick: nextTutorialStep }, "Volgende")
                                    : h('button', { className: 'nav-button next-button', onClick: endTutorial }, "Voltooien")
                            )
                        ),
                        h('div', { className: 'form-content' },
                            h('div', { className: 'step-content' },
                                renderStepContent(),
                                h('div', { className: 'nav-button-container' },
                                    h('button', {
                                        className: 'nav-button',
                                        onClick: goToPrevFormStep,
                                        disabled: activeFormStep === 1
                                    }, h('span', {dangerouslySetInnerHTML: {__html: icons.arrowLeft}}), ' Vorige'),
                                    h('button', {
                                        className: 'nav-button next-button',
                                        onClick: goToNextFormStep,
                                        disabled: activeFormStep === (config.steps[activeDocType] || []).length
                                    }, 'Volgende ', h('span', {dangerouslySetInnerHTML: {__html: icons.arrowRight}}))
                                )
                            )
                        )
                    ),
                    h('div', { id: 'preview-panel-area', className: 'preview-panel' },
                        h('div', { className: 'preview-header' },
                            h('h2', null, 'Voorvertoning'),
                            h('div', { className: 'preview-actions' },
                                h('button', { title: 'Kopieer naar klembord', className: 'action-button copy-button icon-only', onClick: handleCopyDocument }, h('span', {dangerouslySetInnerHTML: {__html: icons.copy}})),
                                h('button', { title: 'Opslaan als DOCX', className: 'action-button save-button icon-only', onClick: handleSaveDocx }, h('span', {dangerouslySetInnerHTML: {__html: icons.fileWord}})),
                                h('button', { title: 'Opslaan & Reset', className: 'action-button reset-button icon-only', onClick: handleSaveAndReset }, h('span', {dangerouslySetInnerHTML: {__html: icons.syncAlt}})),
                                copySuccess && h('span', { className: 'copy-success show' }, '✓ Gekopieerd!'))
                        ),
                        h('div', {
                            className: 'preview-text',
                            contentEditable: true,
                            dangerouslySetInnerHTML: { __html: generatedDocument },
                            onInput: handlePreviewChange,
                            style: {
                                whiteSpace: 'pre-wrap',
                                fontFamily: 'inherit',
                                minHeight: '300px',
                                background: '#fff',
                                border: '1px solid #ccc',
                                borderRadius: '6px',
                                padding: '12px',
                                fontSize: '1rem',
                                overflow: 'auto',
                                lineHeight: '1.6'
                            }
                        })
                    )
                ));
        };

        const root = ReactDOM.createRoot(document.getElementById('root'));
        root.render(h(App));
    </script>
</body>

</html>
