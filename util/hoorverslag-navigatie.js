// =====================================================
// HOORVERSLAG NAVIGATIE MODULE
// =====================================================
// Deze module beheert de navigatie tussen meerdere hoorverslagen
// en slaat data op in sessionStorage
// =====================================================

const HoorverslagNavigatie = (() => {
    // Private variabelen
    const MAX_HOORVERSLAGEN = 20;
    const STORAGE_KEY = 'hoorverslagen_data';
    let huidigHoorverslagNummer = 1;
    let navigatieCallbacks = {
        opLaden: null,
        opOpslaan: null,
        opNummersWijziging: null
    };

    // =====================================================
    // SESSIONSTORAGE FUNCTIES (DIRECTE TOEGANG)
    // =====================================================

    /**
     * Laadt alle hoorverslagdata direct uit sessionStorage.
     * @returns {object} Een object met alle opgeslagen hoorverslagen.
     */
    const laadAlleData = () => {
        try {
            const opgeslagenData = sessionStorage.getItem(STORAGE_KEY);
            return opgeslagenData ? JSON.parse(opgeslagenData) : {};
        } catch (error) {
            console.error('Fout bij laden uit sessionStorage:', error);
            return {};
        }
    };

    /**
     * Slaat een object met alle hoorverslagdata direct op in sessionStorage.
     * @param {object} alleData - Het object om op te slaan.
     */
    const slaAlleDataOp = (alleData) => {
        try {
            sessionStorage.setItem(STORAGE_KEY, JSON.stringify(alleData));
        } catch (error) {
            console.error('Fout bij opslaan in sessionStorage:', error);
        }
    };

    /**
     * Sla huidige formulierdata op voor het huidige hoorverslagnummer.
     * Leest eerst alle data, update de betreffende key, en schrijft alles terug.
     */
    const slaHuidigHoorverslagOp = (formData) => {
        const alleData = laadAlleData();
        alleData[huidigHoorverslagNummer] = {
            data: formData,
            tijdstempel: new Date().toISOString()
        };
        slaAlleDataOp(alleData);
    };

    /**
     * Haalt de opgeslagen data op voor een specifiek hoorverslagnummer.
     */
    const haalHoorverslagOp = (nummer) => {
        const alleData = laadAlleData();
        const hoorverslag = alleData[nummer];
        return hoorverslag ? hoorverslag.data : null;
    };


    // =====================================================
    // NAVIGATIE FUNCTIES
    // =====================================================
    
    /**
     * Ga naar volgend hoorverslag
     */
    const naarVolgend = () => {
        if (huidigHoorverslagNummer < MAX_HOORVERSLAGEN) {
            if (navigatieCallbacks.opOpslaan) {
                // Roep opOpslaan aan MET het huidige nummer VOORDAT het wordt gewijzigd
                navigatieCallbacks.opOpslaan(huidigHoorverslagNummer);
            }
            
            huidigHoorverslagNummer++;
            updateNavigatieUI();
            
            const opgeslagenData = haalHoorverslagOp(huidigHoorverslagNummer);
            if (navigatieCallbacks.opLaden) {
                navigatieCallbacks.opLaden(opgeslagenData);
            }
            
            if (navigatieCallbacks.opNummersWijziging) {
                navigatieCallbacks.opNummersWijziging(huidigHoorverslagNummer);
            }
        }
    };

    /**
     * Ga naar vorig hoorverslag
     */
    const naarVorig = () => {
        if (huidigHoorverslagNummer > 1) {
            if (navigatieCallbacks.opOpslaan) {
                // Roep opOpslaan aan MET het huidige nummer VOORDAT het wordt gewijzigd
                navigatieCallbacks.opOpslaan(huidigHoorverslagNummer);
            }
            
            huidigHoorverslagNummer--;
            updateNavigatieUI();

            const opgeslagenData = haalHoorverslagOp(huidigHoorverslagNummer);
            if (navigatieCallbacks.opLaden) {
                navigatieCallbacks.opLaden(opgeslagenData);
            }
            
            if (navigatieCallbacks.opNummersWijziging) {
                navigatieCallbacks.opNummersWijziging(huidigHoorverslagNummer);
            }
        }
    };

    /**
     * Ga naar specifiek hoorverslag nummer
     */
    const naarNummer = (nummer) => {
        const gevalideerdNummer = parseInt(nummer);
        if (isNaN(gevalideerdNummer) || gevalideerdNummer < 1 || gevalideerdNummer > MAX_HOORVERSLAGEN) {
            alert(`Voer een geldig nummer in tussen 1 en ${MAX_HOORVERSLAGEN}`);
            const nrInput = document.getElementById('hoorverslag-nummer-input');
            if(nrInput) nrInput.value = huidigHoorverslagNummer;
            return;
        }

        if (gevalideerdNummer === huidigHoorverslagNummer) {
            return; 
        }

        if (navigatieCallbacks.opOpslaan) {
            // Roep opOpslaan aan MET het huidige nummer VOORDAT het wordt gewijzigd
            navigatieCallbacks.opOpslaan(huidigHoorverslagNummer);
        }
        
        huidigHoorverslagNummer = gevalideerdNummer;
        updateNavigatieUI();
        
        const opgeslagenData = haalHoorverslagOp(huidigHoorverslagNummer);
        if (navigatieCallbacks.opLaden) {
            navigatieCallbacks.opLaden(opgeslagenData);
        }
        
        if (navigatieCallbacks.opNummersWijziging) {
            navigatieCallbacks.opNummersWijziging(huidigHoorverslagNummer);
        }
    };

    /**
     * Update de navigatie UI elementen
     */
    const updateNavigatieUI = () => {
        const nrDisplay = document.getElementById('hoorverslag-nummer-display');
        const nrInput = document.getElementById('hoorverslag-nummer-input');
        const vorigBtn = document.getElementById('hoorverslag-vorig-btn');
        const volgendBtn = document.getElementById('hoorverslag-volgend-btn');

        if (nrDisplay) {
            nrDisplay.textContent = `${huidigHoorverslagNummer}/${MAX_HOORVERSLAGEN}`;
        }

        if (nrInput) {
            nrInput.value = huidigHoorverslagNummer;
        }

        if (vorigBtn) {
            vorigBtn.disabled = huidigHoorverslagNummer === 1;
        }

        if (volgendBtn) {
            volgendBtn.disabled = huidigHoorverslagNummer === MAX_HOORVERSLAGEN;
        }
    };

    /**
     * Maak de navigatie UI aan
     */
    const maakNavigatieUI = () => {
        const bestaandeNavigatie = document.getElementById('hoorverslag-navigatie-container');
        if (bestaandeNavigatie) {
            bestaandeNavigatie.remove();
        }

        const container = document.createElement('div');
        container.id = 'hoorverslag-navigatie-container';
        container.className = 'hoorverslag-navigatie-container';
        
        container.innerHTML = `
            <div class="hoorverslag-navigatie-wrapper">
                <button id="hoorverslag-vorig-btn" class="hoorverslag-nav-btn" title="Vorig hoorverslag (Pijltje Links)">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="15 18 9 12 15 6"></polyline>
                    </svg>
                </button>
                
                <div class="hoorverslag-nummer-sectie">
                    <span class="hoorverslag-label">Hoorverslag:</span>
                    <input 
                        type="number" 
                        id="hoorverslag-nummer-input" 
                        class="hoorverslag-nummer-input" 
                        min="1" 
                        max="${MAX_HOORVERSLAGEN}" 
                        value="${huidigHoorverslagNummer}"
                        title="Ga naar specifiek hoorverslag nummer"
                    />
                    <span id="hoorverslag-nummer-display" class="hoorverslag-nummer">/${MAX_HOORVERSLAGEN}</span>
                </div>
                
                <button id="hoorverslag-volgend-btn" class="hoorverslag-nav-btn" title="Volgend hoorverslag (Pijltje Rechts)">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="9 18 15 12 9 6"></polyline>
                    </svg>
                </button>
            </div>
        `;

        document.body.appendChild(container);

        // Event listeners voor buttons
        document.getElementById('hoorverslag-vorig-btn').addEventListener('click', naarVorig);
        document.getElementById('hoorverslag-volgend-btn').addEventListener('click', naarVolgend);
        
        // Event listener voor nummer input
        const nummerInput = document.getElementById('hoorverslag-nummer-input');
        nummerInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                e.target.blur(); // Triggert het 'blur' event
            }
        });
        nummerInput.addEventListener('blur', () => {
            naarNummer(nummerInput.value);
        });

        updateNavigatieUI();
    };

    /**
     * Keyboard event handler
     */
    const handleKeyboard = (e) => {
        // Negeer als gebruiker aan het typen is in een input veld
        if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA' || e.target.isContentEditable) {
            return;
        }

        if (e.key === 'ArrowLeft') {
            e.preventDefault();
            naarVorig();
        } else if (e.key === 'ArrowRight') {
            e.preventDefault();
            naarVolgend();
        }
    };

    // =====================================================
    // PUBLIEKE API
    // =====================================================
    
    return {
        /**
         * Initialiseer de navigatie module
         * @param {Object} callbacks - Object met callback functies
         * @param {Function} callbacks.opLaden - Wordt aangeroepen wanneer data geladen moet worden
         * @param {Function} callbacks.opOpslaan - Wordt aangeroepen wanneer data opgeslagen moet worden
         * @param {Function} callbacks.opNummersWijziging - Wordt aangeroepen wanneer hoorverslag nummer wijzigt
         */
        initialiseer: (callbacks = {}) => {
            navigatieCallbacks = {
                opLaden: callbacks.opLaden || null,
                opOpslaan: callbacks.opOpslaan || null,
                opNummersWijziging: callbacks.opNummersWijziging || null
            };
            
            maakNavigatieUI();
            
            // Laad de data voor het eerste hoorverslag bij het opstarten
            if (navigatieCallbacks.opLaden) {
                 const initialData = haalHoorverslagOp(huidigHoorverslagNummer);
                 navigatieCallbacks.opLaden(initialData);
            }
            
            // Keyboard events
            document.addEventListener('keydown', handleKeyboard);

            console.log('Hoorverslag Navigatie Module geïnitialiseerd');
        },

        /**
         * Sla huidige formulierdata op
         * @param {Object} formData - De formulierdata om op te slaan
         */
        slaDataOp: (formData) => {
            slaHuidigHoorverslagOp(formData);
        },

        /**
         * Sla formulierdata op voor een specifiek nummer.
         * @param {Object} formData - De formulierdata om op te slaan.
         * @param {Number} nummer - Het hoorverslagnummer om de data voor op te slaan.
         */
        slaSpecifiekVerslag: (formData, nummer) => {
            const alleData = laadAlleData();
            alleData[nummer] = {
                data: formData,
                tijdstempel: new Date().toISOString()
            };
            slaAlleDataOp(alleData);
        },

        /**
         * Haal huidig hoorverslag nummer op
         * @returns {Number} Het huidige hoorverslag nummer
         */
        getHuidigNummer: () => {
            return huidigHoorverslagNummer;
        },

        /**
         * Verwijder navigatie UI en event listeners
         */
        verwijder: () => {
            document.removeEventListener('keydown', handleKeyboard);
            const container = document.getElementById('hoorverslag-navigatie-container');
            if (container) {
                container.remove();
            }
        },

        /**
         * Wis alle opgeslagen hoorverslagen
         */
        wisAlleData: () => {
            if (confirm('Weet je zeker dat je alle opgeslagen hoorverslagen wilt wissen? Deze actie kan niet ongedaan worden gemaakt.')) {
                sessionStorage.removeItem(STORAGE_KEY);
                huidigHoorverslagNummer = 1;
                updateNavigatieUI();
                if (navigatieCallbacks.opLaden) {
                    navigatieCallbacks.opLaden(null); // Reset het formulier
                }
                console.log('Alle hoorverslag data gewist');
            }
        }
    };
})();

// Export voor gebruik in andere modules (blijft ongewijzigd)
if (typeof module !== 'undefined' && module.exports) {
    module.exports = HoorverslagNavigatie;
}


