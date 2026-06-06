let currentIndex = 0;
let maxIndex = 3;

let state = {
    amount: 1, 
    sumMode: true 
};

let locales = {};

const menu = document.getElementById('native-menu');
const items = document.querySelectorAll('.menu-item');
const descText = document.getElementById('menu-desc');
const toggleKnob = document.getElementById('val-mode-toggle');

function updateUI() {
    // Label Updates
    document.getElementById('val-amount').innerText = state.amount;
    
    // Update iPhone toggle animation
    if (state.sumMode) {
        toggleKnob.classList.add('active');
    } else {
        toggleKnob.classList.remove('active');
    }

    // Highlight the active row and change the description
    items.forEach((el, index) => {
        if (index === currentIndex) {
            el.classList.add('active');
            
            // Animate the description (fade out briefly, then fade in)
            descText.style.opacity = 0;
            setTimeout(() => {
                if (index === 0) descText.innerText = locales.desc_amount;
                if (index === 1) descText.innerText = locales.desc_mode;
                if (index === 2) descText.innerText = locales.desc_roll;
                if (index === 3) descText.innerText = locales.desc_cancel;
                descText.style.opacity = 1;
            }, 150);
            
        } else {
            el.classList.remove('active');
        }
    });
}

function handleKey(key) {
    if (key === "up") {
        currentIndex--;
        if (currentIndex < 0) currentIndex = maxIndex;
    } 
    else if (key === "down") {
        currentIndex++;
        if (currentIndex > maxIndex) currentIndex = 0;
    } 
    else if (key === "left" || key === "right") {
        // Left/Right only changes the values if you are on row 0 or 1
        if (currentIndex === 0) {
            state.amount = state.amount === 1 ? 2 : 1;
        } else if (currentIndex === 1) {
            state.sumMode = !state.sumMode;
        }
    } 
    else if (key === "enter") {
        if (currentIndex === 0) {
            state.amount = state.amount === 1 ? 2 : 1;
        } else if (currentIndex === 1) {
            state.sumMode = !state.sumMode;
        } else if (currentIndex === 2) { 
            // WÜRFELN
            closeUI();
            fetch(`https://${GetParentResourceName()}/rollDice`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ amount: state.amount, calcSum: state.sumMode })
            });
        } else if (currentIndex === 3) { 
            // SCHLIESSEN
            closeUI();
            fetch(`https://${GetParentResourceName()}/closeMenu`, { method: 'POST', body: JSON.stringify({}) });
        }
    }
    else if (key === "back") {
        closeUI();
        fetch(`https://${GetParentResourceName()}/closeMenu`, { method: 'POST', body: JSON.stringify({}) });
    }
    updateUI();
}

function closeUI() {
    menu.classList.remove('show');
}

window.addEventListener('message', (event) => {
    let data = event.data;
    
    if (data.action === "openMenu") {
        locales = data.locales;
        
        // Translate titles and labels
        document.getElementById('lbl-title').innerText = locales.title;
        document.getElementById('lbl-amount').innerText = locales.amount;
        document.getElementById('lbl-mode').innerText = locales.mode;
        document.getElementById('lbl-roll').innerText = locales.roll;
        document.getElementById('lbl-cancel').innerText = locales.cancel;
        document.getElementById('ft-nav').innerText = locales.footer_nav;
        document.getElementById('ft-change').innerText = locales.footer_change;
        document.getElementById('ft-confirm').innerText = locales.footer_confirm;
        document.getElementById('ft-back').innerText = locales.footer_back;

        // Reset values on opening
        currentIndex = 0;
        state.amount = 1;
        state.sumMode = false;
        
        updateUI();
        menu.classList.add('show');
    }
    
    if (data.action === "key") {
        handleKey(data.key);
    }
});