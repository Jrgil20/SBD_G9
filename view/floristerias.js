

// Función para cargar datos de floristerías
export function cargarDatosFloristerias() {
    const contenedor = document.querySelector('#floristerias .cards-container .cards');
    if (!contenedor) {
        console.error('Contenedor de cards no encontrado para floristerías');
        return;
    }
    contenedor.innerHTML = '';

    // Asumimos que los datos de floristerías están en window.data.floristerias
    const floristerias = window.data.floristerias;

    floristerias.forEach(floristeria => {
        const card = document.createElement('div');
        card.className = 'card';
        card.innerHTML = `
            <h3>${floristeria.nombre}</h3>
            <p>${floristeria.ciudad || ''}</p>
        `;
        card.addEventListener('click', () => mostrarDetallesFloristeria(floristeria));
        contenedor.appendChild(card);
    });
}

// Función para mostrar detalles de una floristería
function mostrarDetallesFloristeria(floristeria) {
    cambiarSeccion('detalles');
    const titulo = document.getElementById('vista-titulo');
    const info = document.getElementById('detalles-info');
    const catalogo = document.querySelector('#catalogo-flores .cards');
    const volverBtn = document.getElementById('volver-btn');

    titulo.textContent = floristeria.nombre;
    volverBtn.style.display = 'block';
    volverBtn.onclick = () => cambiarSeccion('floristerias');
    
    info.innerHTML = `
        <p>${floristeria.ciudad || ''}</p>
        ${floristeria.email ? `<p>Email: ${floristeria.email}</p>` : ''}
        ${floristeria.telefono ? `<p>Teléfono: ${floristeria.telefono}</p>` : ''}
    `;

    catalogo.innerHTML = '';
    if (floristeria.flores) {
        floristeria.flores.forEach(flor => {
            const florCard = document.createElement('div');
            florCard.className = 'card';
            florCard.innerHTML = `
                <h3>${flor}</h3>
            `;
            florCard.addEventListener('click', () => mostrarDetallesFlor(flor, floristeria.nombre));
            catalogo.appendChild(florCard);
        });
    }
}

window.cargarDatosFloristerias = cargarDatosFloristerias;
window.mostrarDetallesFloristeria = mostrarDetallesFloristeria;