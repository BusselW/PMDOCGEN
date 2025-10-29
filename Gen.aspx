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
    <!-- Backup DOCX library from different CDN -->
    <script>
        // Check if docx loaded, if not try alternative
        window.addEventListener('load', function() {
            if (typeof window.docx === 'undefined') {
                console.log('Primary DOCX library failed, loading backup...');
                var script = document.createElement('script');
                script.src = 'https://cdn.jsdelivr.net/npm/docx@8.5.0/build/index.js';
                script.onload = function() {
                    console.log('Backup DOCX library loaded successfully');
                };
                script.onerror = function() {
                    console.error('Both DOCX libraries failed to load');
                };
                document.head.appendChild(script);
            } else {
                console.log('DOCX library loaded successfully');
            }
        });
    </script>
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
        .copy-field-button {
            background-color: #f3f4f6; /* gray-100 */
            border: 1px solid #d1d5db; /* gray-300 */
            color: #4b5563; /* gray-600 */
            padding: 0 10px;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.2s ease, border-color 0.2s ease;
            height: 40px; /* Match input height */
            margin-left: 8px;
        }
        .copy-field-button:hover {
            background-color: #e5e7eb; /* gray-200 */
        }
        .copy-field-button svg {
            width: 16px;
            height: 16px;
        }
        .copy-field-button-success {
            background-color: #d1fae5; /* green-100 */
            border-color: #6ee7b7; /* green-300 */
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
        
        // Category-based imports
        import { PMVerkeersbordenVerkeersboetenl, PMVerkeersbordenVerkeersboetenComponent } from './PMHV/PMVerkeersbordenVerkeersboetenl.js';
        import { PMVerkeersbordenSkandara, PMVerkeersbordenSkandaraComponent } from './PMHV/PMVerkeersbordenSkandara.js';
        import { PMSnelheidVerkeersboetenl, PMSnelheidVerkeersboetenComponent } from './PMHV/PMSnelheidVerkeersboetenl.js';
        import { PMSnelheidSkandara, PMSnelheidSkandaraComponent } from './PMHV/PMSnelheidSkandara.js';
        import { PMZvZichtPlichtVerkeersboetenl, PMZvZichtPlichtVerkeersboetenComponent } from './PMHV/PMZvZichtPlichtVerkeersboetenl.js';
        import { PMZvZichtPlichtSkandara, PMZvZichtPlichtSkandaraComponent } from './PMHV/PMZvZichtPlichtSkandara.js';
        import { PMRijgedragVerkeersboetenl, PMRijgedragVerkeersboetenComponent } from './PMHV/PMRijgedragVerkeersboetenl.js';
        import { PMRijgedragSkandara, PMRijgedragSkandaraComponent } from './PMHV/PMRijgedragSkandara.js';
        import { PMParkerenVerkeersboetenl, PMParkerenVerkeersboetenComponent } from './PMHV/PMParkerenVerkeersboetenl.js';
        import { PMParkerenSkandara, PMParkerenSkandaraComponent } from './PMHV/PMParkerenSkandara.js';
        import { PMZvFlitsVerkeersboetenl, PMZvFlitsVerkeersboetenComponent } from './PMHV/PMZvFlitsVerkeersboetenl.js';
        import { PMZvFlitsSkandara, PMZvFlitsSkandaraComponent } from './PMHV/PMZvFlitsSkandara.js';
        
        import { icons, initialFormData, config, categoryOptions } from './util/config.js';

        const { useState, useEffect, createElement: h, Fragment, useRef } = React;

        // =====================
        // 3. Hoofdcomponent App
        // =====================
        const App = () => {
            // 3a. State hooks
            const [activeDocType, setActiveDocType] = useState(config.documentTypes[0].id);
            const [activeSubtype, setActiveSubtype] = useState(config.subtypes[activeDocType]?.[0]?.id || '');
            const [activeFormStep, setActiveFormStep] = useState(1);
            const [formData, setFormData] = useState({ ...initialFormData });
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
            const [copyFeedback, setCopyFeedback] = useState({});
            const [selectedCategory, setSelectedCategory] = useState('verkeersborden');
            
            const previewRef = useRef(null);

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
            
            // Store refs for current state values to avoid stale closures
            const selectedStandaardTekstenRef = useRef(selectedStandaardTeksten);
            const selectedCategoryRef = useRef(selectedCategory);
            const formDataRef = useRef(formData);
            
            // Update refs when state changes
            useEffect(() => {
                selectedStandaardTekstenRef.current = selectedStandaardTeksten;
            }, [selectedStandaardTeksten]);
            
            useEffect(() => {
                selectedCategoryRef.current = selectedCategory;
            }, [selectedCategory]);
            
            useEffect(() => {
                formDataRef.current = formData;
            }, [formData]);

            useEffect(() => {
                if (activeDocType === 'hoorverslag') {
                    // Add a small delay to ensure DOM is ready
                    const timer = setTimeout(() => {
                        HoorverslagNavigatie.initialiseer({
                            opLaden: (opgeslagenData) => {
                                const defaultData = { ...initialFormData, tijdigheidBeroepType: 'tijdigIngediend' };
                                const loadedData = opgeslagenData || defaultData;
                                setFormData(loadedData);
                                // Load the checkbox selections and category specific to this hoorverslag
                                setSelectedStandaardTeksten(loadedData.selectedStandaardTeksten || {});
                                setSelectedCategory(loadedData.selectedCategory || 'verkeersborden');
                            },
                            opOpslaan: (nummerOmOpTeSlaan) => {
                                 // AANGEPAST: Include checkbox data when saving
                                const dataToSave = {
                                    ...formDataRef.current,
                                    selectedStandaardTeksten: selectedStandaardTekstenRef.current,
                                    selectedCategory: selectedCategoryRef.current
                                };
                                HoorverslagNavigatie.slaSpecifiekVerslag(dataToSave, nummerOmOpTeSlaan);
                            },
                            opNummersWijziging: (nieuwNummer) => {
                                setActiveFormStep(1);
                            }
                        });
                    }, 100);

                    return () => {
                        clearTimeout(timer);
                        HoorverslagNavigatie.verwijder();
                    };
                } else {
                    HoorverslagNavigatie.verwijder();
                }
            }, [activeDocType]);

            useEffect(() => {
                if (activeDocType === 'hoorverslag') {
                    const timeoutId = setTimeout(() => {
                        // Include checkbox data and category in autosave using current ref values
                        const dataToSave = {
                            ...formDataRef.current,
                            selectedStandaardTeksten: selectedStandaardTekstenRef.current,
                            selectedCategory: selectedCategoryRef.current
                        };
                        
                        // Explicitly save to the currently active hoorverslag number to avoid
                        // potential races between the navigation module's internal number
                        // and the React component state. Use slaSpecifiekVerslag with the
                        // module-provided current number when available.
                        if (typeof HoorverslagNavigatie.getHuidigNummer === 'function' && typeof HoorverslagNavigatie.slaSpecifiekVerslag === 'function') {
                            try {
                                const nummer = HoorverslagNavigatie.getHuidigNummer();
                                HoorverslagNavigatie.slaSpecifiekVerslag(dataToSave, nummer);
                            } catch (e) {
                                // Fallback to generic save if anything goes wrong
                                HoorverslagNavigatie.slaDataOp(dataToSave);
                            }
                        } else {
                            HoorverslagNavigatie.slaDataOp(dataToSave);
                        }
                    }, 500);

                    return () => clearTimeout(timeoutId);
                }
            }, [formData, activeDocType, selectedStandaardTeksten, selectedCategory]);
            
            // =====================
            // EINDE HOORVERSLAG NAVIGATIE INTEGRATIE
            // =====================

            // 3b. Handler-functies voor formulier en navigatie

            // AANGEPAST: Functie om velden naar ALLE hoorverslagen te kopiëren
            const handleCopyFieldsToAllReports = (fieldsToCopy) => {
                const MAX_REPORTS = 20; // Based on hoorverslag-navigatie.js
                const storageKey = 'hoorverslagen_data';
                let allData = {};

                try {
                    const storedData = sessionStorage.getItem(storageKey);
                    if (storedData) {
                        allData = JSON.parse(storedData);
                    }
                } catch (e) {
                    console.error("Fout bij lezen van sessionStorage", e);
                    return;
                }

                for (let i = 1; i <= MAX_REPORTS; i++) {
                    let reportData = allData[i] ? allData[i].data : { ...initialFormData };

                    fieldsToCopy.forEach(field => {
                        reportData[field] = formData[field];
                    });

                    allData[i] = {
                        data: reportData,
                        tijdstempel: allData[i] ? allData[i].tijdstempel : new Date().toISOString()
                    };
                }

                try {
                    sessionStorage.setItem(storageKey, JSON.stringify(allData));
                    
                    const feedbackKey = fieldsToCopy.join(',');
                    setCopyFeedback(prev => ({ ...prev, [feedbackKey]: true }));
                    setTimeout(() => {
                        setCopyFeedback(prev => ({ ...prev, [feedbackKey]: false }));
                    }, 1500);
                } catch (e) {
                    console.error("Fout bij schrijven naar sessionStorage", e);
                }
            };

            const handleDocTypeChange = (docType) => {
                setActiveDocType(docType);
                const firstSubtypeId = config.subtypes[docType]?.[0]?.id;
                setActiveSubtype(firstSubtypeId || '');
                setActiveFormStep(1);
                setFormData({ ...initialFormData });
                setSelectedStandaardTeksten({});
                setSelectedCategory('verkeersborden');
                setTijdsregistratieVerdeeld(false);
            };

            const handleSubtypeChange = (subtype) => {
                setActiveSubtype(subtype);
                setSelectedStandaardTeksten({});
                setSelectedCategory('verkeersborden');
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

            const handleCategoryChange = (category) => {
                setSelectedCategory(category);
                // Reset selected checkboxes when category changes for current hoorverslag only
                setSelectedStandaardTeksten({});
            };

            const handleSaveDocx = async () => {
                // Check if libraries are loaded
                if (typeof window.docx === 'undefined') {
                    alert('Fout: De DOCX library is niet geladen. Probeer de pagina te verversen.');
                    return;
                }
                if (typeof window.saveAs === 'undefined') {
                    alert('Fout: De FileSaver library is niet geladen. Probeer de pagina te verversen.');
                    return;
                }

                try {
                    const { Document, Packer, Paragraph, TextRun, PageBreak } = window.docx;

                    if (activeDocType === 'hoorverslag') {
                        // For hoorverslagen, create a document with all saved hoorverslagen
                        const allSections = [];
                        const MAX_HOORVERSLAGEN = 20;
                        let addedHoorverslagen = 0;

                        // Get all stored hoorverslag data
                        const storageKey = 'hoorverslagen_data';
                        let allData = {};
                        try {
                            const storedData = sessionStorage.getItem(storageKey);
                            if (storedData) {
                                allData = JSON.parse(storedData);
                            }
                        } catch (e) {
                            console.error("Error reading sessionStorage", e);
                        }

                        // Generate content for each hoorverslag that has data
                        for (let i = 1; i <= MAX_HOORVERSLAGEN; i++) {
                            if (allData[i] && allData[i].data) {
                                const hoorverslagData = allData[i].data;
                                
                                // Generate the document content for this hoorverslag
                                const tempFormData = { ...hoorverslagData };
                                const generatedContent = generateHoorverslagContent(tempFormData, i);
                                
                                if (generatedContent && generatedContent.trim()) {
                                    const paragraphs = generatedContent.split('\n').map(line => 
                                        new Paragraph({ 
                                            children: [new TextRun(line || ' ')] // Ensure empty lines have space
                                        })
                                    );

                                    // Add header with hoorverslag number
                                    const headerParagraphs = [
                                        new Paragraph({ 
                                            children: [new TextRun({ text: `HOORVERSLAG ${i}`, bold: true, size: 28 })] 
                                        }),
                                        new Paragraph({ children: [new TextRun(' ')] }), // Empty line
                                        ...paragraphs
                                    ];

                                    if (addedHoorverslagen > 0) {
                                        // Add page break before each new hoorverslag (except the first)
                                        headerParagraphs.unshift(new Paragraph({ 
                                            children: [new PageBreak()] 
                                        }));
                                    }

                                    allSections.push(...headerParagraphs);
                                    addedHoorverslagen++;
                                }
                            }
                        }

                        if (addedHoorverslagen === 0) {
                            // No saved hoorverslagen found, export current one
                            if (previewRef.current) {
                                const plainTextForExport = previewRef.current.innerText;
                                const textParagraphs = plainTextForExport.split('\n').map(
                                    line => new Paragraph({ children: [new TextRun(line || ' ')] })
                                );
                                allSections.push(...textParagraphs);
                                addedHoorverslagen = 1;
                            }
                        }

                        if (allSections.length > 0) {
                            const doc = new Document({ 
                                sections: [{ 
                                    children: allSections 
                                }] 
                            });
                            const fileName = `Hoorverslagen_${addedHoorverslagen}x_${new Date().toISOString().slice(0, 10)}.docx`;
                            const blob = await Packer.toBlob(doc);
                            window.saveAs(blob, fileName);
                        } else {
                            alert('Geen hoorverslagen om te exporteren gevonden.');
                        }
                    } else {
                        // For non-hoorverslag documents, export current preview
                        if (previewRef.current) {
                            const plainTextForExport = previewRef.current.innerText;
                            const textParagraphs = plainTextForExport.split('\n').map(
                                line => new Paragraph({ children: [new TextRun(line || ' ')] })
                            );
                            const doc = new Document({ sections: [{ children: textParagraphs }] });
                            const fileName = `${activeDocType}_${activeSubtype}_${new Date().toISOString().slice(0, 10)}.docx`;
                            const blob = await Packer.toBlob(doc);
                            window.saveAs(blob, fileName);
                        }
                    }
                } catch (error) {
                    console.error('Error creating Word document:', error);
                    alert('Fout bij het maken van het Word document: ' + error.message);
                }
            };

            const handleCopyDocument = () => {
                if (previewRef.current) {
                    const textToCopy = previewRef.current.innerText;
                    navigator.clipboard.writeText(textToCopy).then(() => {
                        setCopySuccess(true);
                        setTimeout(() => setCopySuccess(false), 2000);
                    });
                }
            };

            const handleSaveAndReset = () => {
                handleSaveDocx();
                setFormData({ ...initialFormData });
                setSelectedStandaardTeksten({});
                setSelectedCategory('verkeersborden');
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
            const startTutorial = () => {
                // Ensure we're on hoorverslag for the full tutorial experience
                if (activeDocType !== 'hoorverslag') {
                    handleDocTypeChange('hoorverslag');
                }
                setTutorialStep(1);
            };
            const endTutorial = () => setTutorialStep(0);
            const nextTutorialStep = () => {
                let nextStep = tutorialStep + 1;
                // Skip steps if target elements don't exist or requirements not met
                while (nextStep <= tutorialSteps.length) {
                    const stepData = tutorialSteps[nextStep - 1];
                    
                    // Check if step requires hoorverslag mode
                    if (stepData.requiresHoorverslag && activeDocType !== 'hoorverslag') {
                        nextStep++;
                        continue;
                    }
                    
                    // Check if target element exists, or use fallback
                    const targetExists = document.getElementById(stepData.targetId);
                    const fallbackExists = stepData.fallbackId ? document.getElementById(stepData.fallbackId) : false;
                    
                    if (targetExists || fallbackExists) {
                        setTutorialStep(nextStep);
                        return;
                    }
                    nextStep++;
                }
                // If no valid next step found, end tutorial
                endTutorial();
            };
            const prevTutorialStep = () => {
                let prevStep = tutorialStep - 1;
                // Skip steps if target elements don't exist or requirements not met
                while (prevStep >= 1) {
                    const stepData = tutorialSteps[prevStep - 1];
                    
                    // Check if step requires hoorverslag mode
                    if (stepData.requiresHoorverslag && activeDocType !== 'hoorverslag') {
                        prevStep--;
                        continue;
                    }
                    
                    // Check if target element exists, or use fallback
                    const targetExists = document.getElementById(stepData.targetId);
                    const fallbackExists = stepData.fallbackId ? document.getElementById(stepData.fallbackId) : false;
                    
                    if (targetExists || fallbackExists) {
                        setTutorialStep(prevStep);
                        return;
                    }
                    prevStep--;
                }
                // If no valid previous step found, stay at current step
            };

            // Function to generate hoorverslag content for Word export
            const generateHoorverslagContent = (hoorverslagFormData, hoorverslagNumber) => {
                try {
                    const templateString = config.templates[activeDocType]?.[activeSubtype];
                    if (!templateString) return '';

                    let data = { ...hoorverslagFormData };
                    const addSingleSpacingIfNeeded = (text) => text && text.trim() ? `\n${text.trim()}` : '';
                    const addDoubleSpacingIfNeeded = (text) => text && text.trim() ? `\n\n${text.trim()}` : '';
                    data.huidigeDatum = new Date().toLocaleDateString('nl-NL', { day: '2-digit', month: '2-digit', year: 'numeric' });

                    const isVerkeersboeteSpecialCase = data.bedrijfsNaam && data.bedrijfsNaam.trim().toLowerCase() === 'verkeersboete.nl';
                    const isSkandaraSpecialCase = data.bedrijfsNaam && data.bedrijfsNaam.trim().toLowerCase() === 'skandara';

                    // Process hoorverslag specific data
                    data.beoordelaarVolledigeNaam = `${data.beoordelaarVoorletters || ''} ${data.beoordelaarAchternaam || ''}`.trim();
                    data.griffierVolledigeNaam = activeSubtype === 'fysiek' ? `${data.griffierVoorletters || ''} ${data.griffierAchternaam || ''}`.trim() : 'n.v.t.';
                    data.aanwezigheidsTekst = data.aanwezigheid === 'aanwezig'
                        ? `${data.vertegenwoordigerType === 'betrokkene' ? 'Betrokkene aanwezig:' : 'Namens betrokkene aanwezig:'} ${data.aanwezigeVoorletters || ''} ${data.aanwezigeAchternaam || ''}`.trim() + (data.bedrijfsNaam ? ` namens ${data.bedrijfsNaam}` : '')
                        : `De ${data.vertegenwoordigerType} was niet aanwezig.`;

                    // Handle standard texts based on company and category
                    let tekstenContent = '';
                    const selectedTexts = data.selectedStandaardTeksten || {};
                    const selectedCat = data.selectedCategory || 'verkeersborden';

                    if (isVerkeersboeteSpecialCase) {
                        const categoryData = getCategoryCheckboxData(selectedCat, 'verkeersboete.nl');
                        if (categoryData) {
                            tekstenContent = Object.keys(selectedTexts)
                                .filter(key => selectedTexts[key] && categoryData.data[key])
                                .map(key => categoryData.data[key].tekst)
                                .join('\n\n');
                        }
                    } else if (isSkandaraSpecialCase) {
                        const categoryData = getCategoryCheckboxData(selectedCat, 'skandara');
                        if (categoryData) {
                            tekstenContent = Object.keys(selectedTexts)
                                .filter(key => selectedTexts[key] && categoryData.data[key])
                                .map(key => categoryData.data[key].tekst)
                                .join('\n\n');
                        }
                    }

                    data.aanvullendeGrondenSectie = tekstenContent ? `Aanvullende gronden op het beroepschrift\n${tekstenContent}` : (data.reactieVerweten ? `Aanvullende gronden op het beroepschrift\n${data.reactieVerweten.trim()}` : '');

                    // Process other sections
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
                    
                    let tijdsregistratieTekst = '';
                    if ((data.startTime && data.startTime.trim().length > 0) || (data.endTime && data.endTime.trim().length > 0)) {
                        tijdsregistratieTekst = 'Tijdsregistratie\nDe zitting begon om ' + (data.startTime || '...') + ' en eindigde om ' + (data.endTime || '...') + '.';
                    }
                    
                    let procesverloopBlok = 'De ' + data.vertegenwoordigerType + ' is op de juiste manier uitgenodigd voor de hoorzitting. De op de zaak betrekking hebbende stukken zijn ' + (data.stukkenVerstrekt === 'wel' ? 'wel' : 'niet') + ' aan de ' + data.vertegenwoordigerType + ' verstrekt voorafgaand aan de hoorzitting.';
                    if (tijdsregistratieTekst) {
                        procesverloopBlok += '\n\n' + tijdsregistratieTekst;
                    }
                    data.procesverloopTekst = procesverloopBlok;
                    
                    data.aanhoudingTekst = (data.aanhoudingBesluitGenomen && data.aanhouding) ? `\n\nEventueel besluit aanhoudingsverzoek/verzoek telefonische hoorzitting${addSingleSpacingIfNeeded(data.aanhouding)}` : '';
                    
                    let tijdigheidContent = '';
                    const selectedTijdigheidOpt = config.dropdownOptions.tijdigheidBeroepOpties.find(opt => opt.value === data.tijdigheidBeroepType);
                    if(selectedTijdigheidOpt){
                       tijdigheidContent = selectedTijdigheidOpt.label;
                    }

                    if (data.tijdigheidBeroepType && data.tijdigheidBeroepType !== 'tijdigIngediend') {
                        if (data.reactieTeLaat) {
                            tijdigheidContent += `\nReactie m.b.t. te late indiening:\n${data.reactieTeLaat.trim()}`;
                        }
                    }
                    data.tijdigheidSectie = tijdigheidContent ? `\nTijdigheid van het administratief beroep\n${tijdigheidContent}` : 'Tijdigheid van het administratief beroep\nHet beroepschrift is tijdig ingediend';

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

                    const compiledTemplate = Handlebars.compile(templateString);
                    let finalDocument = compiledTemplate(data).replace(/\n{3,}/g, '\n\n').trim();
                    finalDocument = `Aanwezigen\n${finalDocument}`;

                    return finalDocument;
                } catch (error) {
                    console.error(`Error generating content for hoorverslag ${hoorverslagNumber}:`, error);
                    return '';
                }
            };

            // Function to get category-specific checkbox data and component
            const getCategoryCheckboxData = (category, company) => {
                const categoryMap = {
                    verkeersborden: {
                        'verkeersboete.nl': { data: PMVerkeersbordenVerkeersboetenl, component: PMVerkeersbordenVerkeersboetenComponent },
                        'skandara': { data: PMVerkeersbordenSkandara, component: PMVerkeersbordenSkandaraComponent }
                    },
                    snelheid: {
                        'verkeersboete.nl': { data: PMSnelheidVerkeersboetenl, component: PMSnelheidVerkeersboetenComponent },
                        'skandara': { data: PMSnelheidSkandara, component: PMSnelheidSkandaraComponent }
                    },
                    zvZichtPlicht: {
                        'verkeersboete.nl': { data: PMZvZichtPlichtVerkeersboetenl, component: PMZvZichtPlichtVerkeersboetenComponent },
                        'skandara': { data: PMZvZichtPlichtSkandara, component: PMZvZichtPlichtSkandaraComponent }
                    },
                    rijgedrag: {
                        'verkeersboete.nl': { data: PMRijgedragVerkeersboetenl, component: PMRijgedragVerkeersboetenComponent },
                        'skandara': { data: PMRijgedragSkandara, component: PMRijgedragSkandaraComponent }
                    },
                    parkeren: {
                        'verkeersboete.nl': { data: PMParkerenVerkeersboetenl, component: PMParkerenVerkeersboetenComponent },
                        'skandara': { data: PMParkerenSkandara, component: PMParkerenSkandaraComponent }
                    },
                    zvFlits: {
                        'verkeersboete.nl': { data: PMZvFlitsVerkeersboetenl, component: PMZvFlitsVerkeersboetenComponent },
                        'skandara': { data: PMZvFlitsSkandara, component: PMZvFlitsSkandaraComponent }
                    }
                };

                return categoryMap[category]?.[company] || null;
            };

            
            // =====================
            // 4. Documentgeneratie useEffect
            // =====================
            useEffect(() => {
                const generateDocument = () => {
                    const templateString = config.templates[activeDocType]?.[activeSubtype];
                    if (!templateString) {
                        if (previewRef.current) {
                            previewRef.current.innerHTML = "Selecteer een geldig documenttype en subtype.";
                        }
                        return;
                    }

                    let data = { ...formData };
                    const addSingleSpacingIfNeeded = (text) => text && text.trim() ? `\n${text.trim()}` : '';
                    const addDoubleSpacingIfNeeded = (text) => text && text.trim() ? `\n\n${text.trim()}` : '';
                    data.huidigeDatum = new Date().toLocaleDateString('nl-NL', { day: '2-digit', month: '2-digit', year: 'numeric' });

                    const isVerkeersboeteSpecialCase = activeDocType === 'hoorverslag' && formData.bedrijfsNaam.trim().toLowerCase() === 'verkeersboete.nl';
                    const isSkandaraSpecialCase = activeDocType === 'hoorverslag' && formData.bedrijfsNaam.trim().toLowerCase() === 'skandara';

                    if (activeDocType === 'hoorverslag') {
                        data.beoordelaarVolledigeNaam = `${data.beoordelaarVoorletters || ''} ${data.beoordelaarAchternaam || ''}`.trim();
                        data.griffierVolledigeNaam = activeSubtype === 'fysiek' ? `${data.griffierVoorletters || ''} ${data.griffierAchternaam || ''}`.trim() : 'n.v.t.';
                        data.aanwezigheidsTekst = data.aanwezigheid === 'aanwezig'
                            ? `${data.vertegenwoordigerType === 'betrokkene' ? 'Betrokkene aanwezig:' : 'Namens betrokkene aanwezig:'} ${data.aanwezigeVoorletters || ''} ${data.aanwezigeAchternaam || ''}`.trim() + (data.bedrijfsNaam ? ` namens ${data.bedrijfsNaam}` : '')
                            : `De ${data.vertegenwoordigerType} was niet aanwezig.`;

                        let tekstenContent = '';
                        if (isVerkeersboeteSpecialCase) {
                            const categoryData = getCategoryCheckboxData(selectedCategory, 'verkeersboete.nl');
                            if (categoryData) {
                                tekstenContent = Object.keys(selectedStandaardTeksten)
                                    .filter(key => selectedStandaardTeksten[key] && categoryData.data[key])
                                    .map(key => categoryData.data[key].tekst)
                                    .join('\n\n');
                            } else {
                                // Fallback to original for verkeersborden
                                tekstenContent = Object.keys(selectedStandaardTeksten)
                                    .filter(key => selectedStandaardTeksten[key] && VerkeersboeteTeksten[key])
                                    .map(key => VerkeersboeteTeksten[key].tekst)
                                    .join('\n\n');
                            }
                        } else if (isSkandaraSpecialCase) {
                            const categoryData = getCategoryCheckboxData(selectedCategory, 'skandara');
                            if (categoryData) {
                                tekstenContent = Object.keys(selectedStandaardTeksten)
                                    .filter(key => selectedStandaardTeksten[key] && categoryData.data[key])
                                    .map(key => categoryData.data[key].tekst)
                                    .join('\n\n');
                            } else {
                                // Fallback to original for verkeersborden
                                tekstenContent = Object.keys(selectedStandaardTeksten)
                                    .filter(key => selectedStandaardTeksten[key] && SkandaraTeksten[key])
                                    .map(key => SkandaraTeksten[key].tekst)
                                    .join('\n\n');
                            }
                        }
                        data.aanvullendeGrondenSectie = tekstenContent ? `Aanvullende gronden op het beroepschrift\n${tekstenContent}` : (data.reactieVerweten ? `Aanvullende gronden op het beroepschrift\n${data.reactieVerweten.trim()}` : '');

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
                        
                        let tijdsregistratieTekst = '';
                        if ((data.startTime && data.startTime.trim().length > 0) || (data.endTime && data.endTime.trim().length > 0)) {
                            tijdsregistratieTekst = 'Tijdsregistratie\nDe zitting begon om ' + (data.startTime || '...') + ' en eindigde om ' + (data.endTime || '...') + '.';
                        }
                        
                        let procesverloopBlok = 'De ' + data.vertegenwoordigerType + ' is op de juiste manier uitgenodigd voor de hoorzitting. De op de zaak betrekking hebbende stukken zijn ' + (data.stukkenVerstrekt === 'wel' ? 'wel' : 'niet') + ' aan de ' + data.vertegenwoordigerType + ' verstrekt voorafgaand aan de hoorzitting.';
                        if (tijdsregistratieTekst) {
                            procesverloopBlok += '\n\n' + tijdsregistratieTekst;
                        }
                        data.procesverloopTekst = procesverloopBlok;
                        
                        data.aanhoudingTekst = (data.aanhoudingBesluitGenomen && data.aanhouding) ? `\n\nEventueel besluit aanhoudingsverzoek/verzoek telefonische hoorzitting${addSingleSpacingIfNeeded(data.aanhouding)}` : '';
                        
                        let tijdigheidContent = '';
                        const selectedTijdigheidOpt = config.dropdownOptions.tijdigheidBeroepOpties.find(opt => opt.value === data.tijdigheidBeroepType);
                        if(selectedTijdigheidOpt){
                           tijdigheidContent = selectedTijdigheidOpt.label;
                        }

                        if (data.tijdigheidBeroepType && data.tijdigheidBeroepType !== 'tijdigIngediend') {
                            if (data.reactieTeLaat) {
                                tijdigheidContent += `\nReactie m.b.t. te late indiening:\n${data.reactieTeLaat.trim()}`;
                            }
                        }
                        data.tijdigheidSectie = tijdigheidContent ? `\nTijdigheid van het administratief beroep\n${tijdigheidContent}` : 'Tijdigheid van het administratief beroep\nHet beroepschrift is tijdig ingediend';

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
                        const selectedOption = config.dropdownOptions.beslissingTypeOpties.find(opt => opt.value === data.beslissingTypeKeuze);
                        data.beslissingTypeInfo = selectedOption ? `Gekozen Type Beslissing: ${selectedOption.label}\n` : '';
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

                    const compiledTemplate = Handlebars.compile(templateString);
                    let finalDocument = compiledTemplate(data).replace(/\n{3,}/g, '\n\n').trim();

                    if (activeDocType === 'hoorverslag') {
                        finalDocument = `Aanwezigen\n${finalDocument}`;
                    }
                    
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

                    if (previewRef.current) {
                        previewRef.current.innerHTML = htmlDocument;
                    }
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
                    
                    // Try primary target first, then fallback
                    let targetElement = document.getElementById(currentStepData.targetId);
                    if (!targetElement && currentStepData.fallbackId) {
                        targetElement = document.getElementById(currentStepData.fallbackId);
                        console.log(`Tutorial step ${tutorialStep}: Using fallback element '${currentStepData.fallbackId}'`);
                    }
                    
                    if (targetElement) {
                        const rect = targetElement.getBoundingClientRect();
                        Object.assign(overlay.style, {
                            left: `${rect.left + window.scrollX - 5}px`,
                            top: `${rect.top + window.scrollY - 5}px`,
                            width: `${rect.width + 10}px`,
                            height: `${rect.height + 10}px`,
                            display: 'block'
                        });
                    } else {
                        // No element found, show message without highlight
                        overlay.style.display = 'none';
                        console.log(`Tutorial step ${tutorialStep}: Neither primary '${currentStepData.targetId}' nor fallback '${currentStepData.fallbackId}' element found`);
                        
                        // For navigation container, add a delay and retry both elements
                        if (currentStepData.targetId === 'hoorverslag-navigatie-container') {
                            setTimeout(() => {
                                let retryElement = document.getElementById(currentStepData.targetId);
                                if (!retryElement && currentStepData.fallbackId) {
                                    retryElement = document.getElementById(currentStepData.fallbackId);
                                }
                                if (retryElement) {
                                    const rect = retryElement.getBoundingClientRect();
                                    Object.assign(overlay.style, {
                                        left: `${rect.left + window.scrollX - 5}px`,
                                        top: `${rect.top + window.scrollY - 5}px`,
                                        width: `${rect.width + 10}px`,
                                        height: `${rect.height + 10}px`,
                                        display: 'block'
                                    });
                                }
                            }, 500);
                        }
                    }
                } else {
                    overlay.style.display = 'none';
                }
            }, [tutorialStep, activeDocType]);

            // =====================
            // 6. Render logica voor stappen
            // =====================
            const renderStepContent = () => {
                const isVerkeersboeteSpecialCase = activeDocType === 'hoorverslag' && formData.bedrijfsNaam.trim().toLowerCase() === 'verkeersboete.nl';

                if (activeDocType === 'hoorverslag') {
                    switch (activeFormStep) {
                        case 1:
                            return h('div', { className: 'step-content-inner' },
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
                                h('div', { className: 'section-header' }, h('span', null, 'Namens CVOM')),
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
                                    ),
                                    h('button', {
                                        className: `copy-field-button ${copyFeedback['beoordelaarVoorletters,beoordelaarAchternaam'] ? 'copy-field-button-success' : ''}`,
                                        title: 'Kopieer naar alle verslagen',
                                        onClick: () => handleCopyFieldsToAllReports(['beoordelaarVoorletters', 'beoordelaarAchternaam'])
                                    }, h('span', { dangerouslySetInnerHTML: { __html: icons.syncAlt } }))
                                ),
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
                                        ),
                                        h('button', {
                                            className: `copy-field-button ${copyFeedback['griffierVoorletters,griffierAchternaam'] ? 'copy-field-button-success' : ''}`,
                                            title: 'Kopieer naar alle verslagen',
                                            onClick: () => handleCopyFieldsToAllReports(['griffierVoorletters', 'griffierAchternaam'])
                                        }, h('span', { dangerouslySetInnerHTML: { __html: icons.syncAlt } }))
                                    )
                                ),
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
                                    ),
                                    h('button', {
                                        className: `copy-field-button ${copyFeedback['aanwezigeVoorletters,aanwezigeAchternaam'] ? 'copy-field-button-success' : ''}`,
                                        title: 'Kopieer naar alle verslagen',
                                        onClick: () => handleCopyFieldsToAllReports(['aanwezigeVoorletters', 'aanwezigeAchternaam'])
                                    }, h('span', { dangerouslySetInnerHTML: { __html: icons.syncAlt } }))
                                ),
                                formData.vertegenwoordigerType === 'gemachtigde' && h('div', { className: 'input-group-row' },
                                    h('div', { className: 'input-group' },
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
                                    ),
                                    h('button', {
                                        className: `copy-field-button ${copyFeedback['bedrijfsNaam'] ? 'copy-field-button-success' : ''}`,
                                        title: 'Kopieer naar alle verslagen',
                                        onClick: () => handleCopyFieldsToAllReports(['bedrijfsNaam'])
                                    }, h('span', { dangerouslySetInnerHTML: { __html: icons.syncAlt } }))
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
                                h('div', { className: 'section-header' }, h('span', null, 'Inhoud')),
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

                                (() => {
                                    if (isVerkeersboeteSpecialCase) {
                                        const categoryData = getCategoryCheckboxData(selectedCategory, 'verkeersboete.nl');
                                        if (categoryData) {
                                            const { data, component: CategoryComponent } = categoryData;
                                            return h(CategoryComponent, { options: data, selectedOptions: selectedStandaardTeksten, onChange: handleStandaardTekstChange });
                                        }
                                        // Fallback to original for verkeersborden
                                        return h(VerkeersboeteTekstenComponent, { options: VerkeersboeteTeksten, selectedOptions: selectedStandaardTeksten, onChange: handleStandaardTekstChange });
                                    } else if (activeDocType === 'hoorverslag' && formData.bedrijfsNaam && formData.bedrijfsNaam.trim().toLowerCase() === 'skandara') {
                                        const categoryData = getCategoryCheckboxData(selectedCategory, 'skandara');
                                        if (categoryData) {
                                            const { data, component: CategoryComponent } = categoryData;
                                            return h(CategoryComponent, { options: data, selectedOptions: selectedStandaardTeksten, onChange: handleStandaardTekstChange });
                                        }
                                        // Fallback to original for verkeersborden
                                        return h(SkandaraTekstenComponent, { options: SkandaraTeksten, selectedOptions: selectedStandaardTeksten, onChange: handleStandaardTekstChange });
                                    } else {
                                        return h(Fragment, null,
                                            h('div', { className: 'input-group' },
                                                h('label', { htmlFor: 'reactie-verweten' }, 'Aanvullende gronden op het beroepschrift:'),
                                                h('textarea', { id: 'reactie-verweten', value: formData.reactieVerweten, placeholder: '(Optioneel) Beschrijf eventuele aanvullende gronden...', rows: 4, onChange: (e) => handleInputChange('reactieVerweten', e.target.value) })
                                            )
                                        );
                                    }
                                })(),

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

            return h(Fragment, null,
                h('div', { className: 'app-container' },
                    h('div', { id: 'steps-sidebar', className: 'sidebar' },
                        h('div', { className: 'logo' }, 'DocGen'),
                        activeDocType === 'hoorverslag' && h('div', { className: 'category-dropdown-container', style: { marginBottom: '16px' } },
                            h('label', { htmlFor: 'category-select', style: { fontSize: '12px', fontWeight: '500', color: '#666', marginBottom: '4px', display: 'block' } }, 'Categorie:'),
                            h('select', {
                                id: 'category-select',
                                value: selectedCategory,
                                onChange: (e) => handleCategoryChange(e.target.value),
                                style: {
                                    width: '100%',
                                    padding: '6px 8px',
                                    fontSize: '12px',
                                    borderRadius: '4px',
                                    border: '1px solid #ddd',
                                    backgroundColor: '#fff'
                                }
                            },
                                categoryOptions.map(option =>
                                    h('option', { key: option.id, value: option.id }, option.name)
                                )
                            )
                        ),
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
                            h('div', { style: { display: 'flex', alignItems: 'center', gap: '16px', flexWrap: 'wrap' } },
                                h('h1', null, `${config.steps[activeDocType]?.find(s => s.number === activeFormStep)?.title || '...'} (Stap ${activeFormStep}/${(config.steps[activeDocType] || []).length})`),
                                h('input', {
                                    type: 'text',
                                    placeholder: 'Zaakcode',
                                    maxLength: 4,
                                    value: formData.zaakCode,
                                    onChange: e => handleInputChange('zaakCode', e.target.value.replace(/\D/g, '')),
                                    style: {
                                        width: '120px',
                                        padding: '10px 12px',
                                        fontSize: '14px',
                                        borderRadius: '6px',
                                        border: '1px solid var(--border-color)',
                                        backgroundColor: '#fff'
                                    }
                                })
                            ),
                            h('button', { id: 'help-button', className: 'action-button help-button', onClick: startTutorial }, h('span', { dangerouslySetInnerHTML: {__html: icons.questionCircle}}), " Tutorial")
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
                                h('button', { id: 'save-docx-button', title: 'Opslaan als DOCX', className: 'action-button save-button icon-only', onClick: handleSaveDocx }, h('span', {dangerouslySetInnerHTML: {__html: icons.fileWord}})),
                                h('button', { title: 'Opslaan & Reset', className: 'action-button reset-button icon-only', onClick: handleSaveAndReset }, h('span', {dangerouslySetInnerHTML: {__html: icons.syncAlt}})),
                                copySuccess && h('span', { className: 'copy-success show' }, '✓ Gekopieerd!'))
                        ),
                        h('div', {
                            ref: previewRef,
                            className: 'preview-text',
                            contentEditable: true,
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


