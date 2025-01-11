export async function cargarDatosSubastadoras() {
    // Datos de prueba de Subastadoras
    const subastadoras = [
        { id: 1, nombre: 'Subastadora Demo 1', pais: 'País X' },
        { id: 2, nombre: 'Subastadora Demo 2', pais: 'País Y' }
    ];

    const contenedor = document.getElementById('subastadoras-cards');
    contenedor.innerHTML = '';
    
    subastadoras.forEach(sub => {
        const card = document.createElement('div');
        card.className = 'card subastadora-card';
        card.innerHTML = `
            <h3>${sub.nombre}</h3>
            <p>País: ${sub.pais}</p>
        `;
        card.addEventListener('click', () => mostrarDetalleSubastadora(sub));
        contenedor.appendChild(card);
    });
}

function mostrarDetalleSubastadora(subastadora) {
    const detalleDiv = document.getElementById('subastadora-detalle');
    detalleDiv.innerHTML = `
        <h2>${subastadora.nombre}</h2>
        <p>Ubicada en: ${subastadora.pais}</p>
        <p>Más detalles de prueba...</p>
    `;
}

// Exponer la función para cargar Subastadoras
window.cargarDatosSubastadoras = cargarDatosSubastadoras;

