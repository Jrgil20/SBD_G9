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
        if (!response.ok) {
            throw new Error(`Error fetching productoras: ${response.statusText}`);
        }
        const data = await response.json();

        data.forEach(productora => {
            const card = document.createElement('div');
            card.className = 'card';
            card.innerHTML = `
                <h3>${productora.nombreproductora}</h3>
                <p>${productora.email || ''}</p>
                <p>${productora.paginaweb || ''}</p>
                <p>País: ${productora.pais || 'Desconocido'}</p>
            `;
            card.addEventListener('click', () => mostrarDetallesProductora(productora));
            contenedor.appendChild(card);
        });

        // Generar opciones de países
        const filtroPaisSelect = document.getElementById('filtro-pais-productoras');
        const paises = [...new Set(data.map(productora => productora.pais))];
        paises.forEach(pais => {
            const option = document.createElement('option');
            option.value = pais;
            option.textContent = pais;
            filtroPaisSelect.appendChild(option);
        });

        // Mostrar la fecha de hoy
        const fechaHoy = new Date().toLocaleDateString();
        document.getElementById('fecha-hoy-productoras').textContent = `Fecha: ${fechaHoy}`;
    } catch (err) {
        console.error('Error fetching productoras:', err);
    }
}

// Función para mostrar detalles de una productora
function mostrarDetallesProductora(productora) {
    cambiarSeccion('detalles');
    const titulo = document.getElementById('vista-titulo');
    const info = document.getElementById('detalles-info');
    const catalogo = document.querySelector('#catalogo-flores');
    const volverBtn = document.getElementById('volver-btn');

    titulo.textContent = productora.nombreproductora;
    volverBtn.style.display = 'block';
    volverBtn.onclick = () => cambiarSeccion('productores');
    
    info.innerHTML = `
        <p>${productora.email ? `Email: ${productora.email}` : ''}</p>
        ${productora.paginaweb ? `<p>Página Web: <a href="http://${productora.paginaweb}" target="_blank">${productora.paginaweb}</a></p>` : ''}
        <p>País: ${productora.pais || 'Desconocido'}</p>
    `;

    catalogo.innerHTML = '';

    // Datos de prueba para las flores
    const flores = [
        { categoria: 'Gerberas', nombre: 'Gerbera Roja', vbn: '12345', imagen: 'gerbera_roja.jpg' },
        { categoria: 'Gerberas', nombre: 'Gerbera Amarilla', vbn: '12346', imagen: 'gerbera_amarilla.jpg' },
        { categoria: 'Rosas', nombre: 'Rosa Roja', vbn: '12347', imagen: 'rosa_roja.jpg' },
        { categoria: 'Rosas', nombre: 'Rosa Blanca', vbn: '12348', imagen: 'rosa_blanca.jpg' },
        { categoria: 'Tulipanes', nombre: 'Tulipán Rojo', vbn: '12349', imagen: 'tulipan_rojo.jpg' },
        { categoria: 'Tulipanes', nombre: 'Tulipán Amarillo', vbn: '12350', imagen: 'tulipan_amarillo.jpg' }
    ];

    // Agrupar flores por categoría
    const floresPorCategoria = flores.reduce((acc, flor) => {
        if (!acc[flor.categoria]) {
            acc[flor.categoria] = [];
        }
        acc[flor.categoria].push(flor);
        return acc;
    }, {});

    // Crear contenedor deslizable verticalmente
    const catalogoContainer = document.createElement('div');
    catalogoContainer.className = 'catalogo-container';

    // Mostrar flores por categoría
    Object.keys(floresPorCategoria).forEach(categoria => {
        const categoriaDiv = document.createElement('div');
        categoriaDiv.className = 'categoria';

        const categoriaTitulo = document.createElement('h3');
        categoriaTitulo.textContent = `Catálogo de ${categoria}`;
        categoriaTitulo.className = 'categoria-titulo';
        categoriaDiv.appendChild(categoriaTitulo);

        const floresContainer = document.createElement('div');
        floresContainer.className = 'flores-container';

        floresPorCategoria[categoria].forEach(flor => {
            const florCard = document.createElement('div');
            florCard.className = 'card';
            florCard.innerHTML = `
                <img src="images/${flor.imagen}" alt="${flor.nombre}" onerror="this.onerror=null;this.src='images/default.jpg';">
                <h3>${flor.nombre}</h3>
                <p>VBN: ${flor.vbn}</p>
            `;
            florCard.addEventListener('click', () => mostrarModalFlor(flor));
            floresContainer.appendChild(florCard);
        });

        // Ajustar el estilo de justify-content en función del desbordamiento
        if (floresContainer.scrollWidth > floresContainer.clientWidth) {
            floresContainer.style.justifyContent = 'flex-start';
        } else {
            floresContainer.style.justifyContent = 'center';
        }

        categoriaDiv.appendChild(floresContainer);
        catalogoContainer.appendChild(categoriaDiv);
    });

    catalogo.appendChild(catalogoContainer);
}

// Función para mostrar el modal con la información completa de la flor
function mostrarModalFlor(flor) {
    const modal = document.getElementById('modal');
    const modalBody = document.getElementById('modal-body');
    modalBody.innerHTML = `
        <h2>${flor.nombre}</h2>
        <img src="images/${flor.imagen}" alt="${flor.nombre}" onerror="this.onerror=null;this.src='images/default.jpg';">
        <p>VBN: ${flor.vbn}</p>
        <p>Descripción: ${flor.descripcion}</p>
    `;
    modal.style.display = 'block';
}

// Función para cerrar el modal
function cerrarModal() {
    const modal = document.getElementById('modal');
    modal.style.display = 'none';
}

window.cargarDatosProductoras = cargarDatosProductoras;
window.mostrarDetallesProductora = mostrarDetallesProductora;
window.mostrarModalFlor = mostrarModalFlor;
window.cerrarModal = cerrarModal;

// Cargar datos iniciales
document.addEventListener('DOMContentLoaded', cargarDatosProductoras);