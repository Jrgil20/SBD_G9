

// Función para cargar datos de productoras
export async function cargarDatosProductoras() {
    const contenedor = document.querySelector('#productores .cards-container .cards');
    if (!contenedor) {
        console.error('Contenedor de cards no encontrado para productoras');
        return;
    }
    contenedor.innerHTML = '';

    try {
        const response = await fetch('/api/productoras');
        const data = await response.json();

        data.forEach(productora => {
            const card = document.createElement('div');
            card.className = 'card';
            card.innerHTML = `
                <h3>${productora.nombreproductora}</h3>
                <p>${productora.paginaWeb || productora.pais || ''}</p>
            `;
            card.addEventListener('click', () => mostrarDetallesProductora(productora));
            contenedor.appendChild(card);
        });
    } catch (err) {
        console.error('Error fetching productoras:', err);
    }
}

// Función para mostrar detalles de una productora
function mostrarDetallesProductora(productora) {
    cambiarSeccion('detalles');
    const titulo = document.getElementById('vista-titulo');
    const info = document.getElementById('detalles-info');
    const catalogo = document.querySelector('#catalogo-flores .cards');
    const volverBtn = document.getElementById('volver-btn');

    titulo.textContent = productora.nombreproductora;
    volverBtn.style.display = 'block';
    volverBtn.onclick = () => cambiarSeccion('productores');
    
    info.innerHTML = `
        <p>${productora.pais || ''}</p>
        ${productora.email ? `<p>Email: ${productora.email}</p>` : ''}
        ${productora.paginaWeb ? `<p>Página Web: <a href="http://${productora.paginaWeb}" target="_blank">${productora.paginaWeb}</a></p>` : ''}
    `;

    catalogo.innerHTML = '';
    if (productora.flores) {
        productora.flores.forEach(flor => {
            const florCard = document.createElement('div');
            florCard.className = 'card';
            florCard.innerHTML = `
                <h3>${flor.nombre}</h3>
                <p>${flor.descripcion}</p>
            `;
            catalogo.appendChild(florCard);
        });
    }
}

window.cargarDatosProductoras = cargarDatosProductoras;
window.mostrarDetallesProductora = mostrarDetallesProductora;