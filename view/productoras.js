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
        console.log('Productoras:', data);
        data.forEach(productora => {
            
            const card = document.createElement('div');
            card.className = 'card';
            card.innerHTML = `
                <h3>${productora.nombreproductora}</h3>
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

//// Función para mostrar detalles de una productora
async function mostrarDetallesProductora(productora) {
    cambiarSeccion('detalles');
    const titulo = document.getElementById('vista-titulo');
    const info = document.getElementById('detalles-info');
    const catalogo = document.querySelector('#catalogo-flores');
    const volverBtn = document.getElementById('volver-btn');
    
    titulo.textContent = productora.nombreproductora;
    volverBtn.style.display = 'block';
    volverBtn.onclick = () => cambiarSeccion('productores');
    
    info.innerHTML = `
        ${productora.paginaweb ? `<p>Página Web: <a href="http://${productora.paginaweb}" target="_blank">${productora.paginaweb}</a></p>` : ''}
        <p>País: ${productora.pais || 'Desconocido'}</p>
    `;

    // Limpiar el catálogo anterior
    catalogo.innerHTML = '';
    
    try {
        const response = await fetch(`/api/catalogoProductor/${productora.productoraid}`);
        if (!response.ok) {
            throw new Error(`Error fetching catalogo: ${response.statusText}`);
        }
        const catalogoProductor = await response.json();
        console.log('Catalogo:', catalogoProductor);
        // Agrupar flores por nombre_comun
        const floresPorCategoria = catalogoProductor.reduce((acc, flor) => {
            if (!acc[flor.nombrecomun]) {
                acc[flor.nombrecomun] = [];
            }
            acc[flor.nombrecomun].push(flor);
            return acc;
        }, {});

        // Crear elementos del DOM para cada categoría y sus flores
        for (const [nombrecomun, flores] of Object.entries(floresPorCategoria)) {
            const categoriaItem = document.createElement('div');
            categoriaItem.className = 'categoria-item';
            categoriaItem.innerHTML = `<h4> ${nombrecomun}</h4>`;
            catalogo.appendChild(categoriaItem);

            flores.forEach(flor => {
                const florCard = document.createElement('div');
                florCard.className = 'card flor-card';
                florCard.innerHTML = `
                <img src="images/${flor.imagen}" alt="${flor.nombrepropio}" onerror="this.onerror=null;this.src='images/default.jpg';">
                    <p><strong> ${flor.nombrepropio}</strong></p>
                    <p><strong>VBN:</strong> ${flor.vbn}</p>
                `;
                console.log(flor.corteid);
                florCard.addEventListener('click', () => mostrarModalFlor(flor,productora));
                categoriaItem.appendChild(florCard);
            });
        }
    } catch (err) {
        console.error('Error fetching catalogo:', err);
        catalogo.innerHTML = '<p>Error al cargar el catálogo de flores.</p>';
    }
}

// Función para mostrar el modal con la información completa de la flor
async function mostrarModalFlor(flor, productora) {
    const modal = document.getElementById('modal');
    const modalBody = document.getElementById('modal-body');
    
    try {
        const response = await fetch(`/api/detalleFlores/${flor.corteid}/${productora.productoraid}`);
        if (!response.ok) {
            throw new Error(`Error fetching detalle de flores: ${response.statusText}`);
        }
        const detalleFlores = await response.json();
        const detalleFlor = detalleFlores[0]; // Asumiendo que solo hay un resultado

        modalBody.innerHTML = `
            <h2>${detalleFlor.nombrepropio}</h2>
            <img src="images/${flor.imagen}" alt="${detalleFlor.nombrepropio}" onerror="this.onerror=null;this.src='images/default.jpg';">
            <p>VBN: ${flor.vbn}</p>
            <p>Género y Especie: ${detalleFlor.genero_especie}</p>
            <p>Etimología: ${detalleFlor.etimologia}</p>
            <p>Descripción: ${detalleFlor.descripcion}</p>
            <p>Colores: ${detalleFlor.colores}</p>
            <p>Temperatura: ${detalleFlor.temperatura}</p>
        `;
        modal.style.display = 'block';
    } catch (err) {
        console.error('Error fetching detalle de flores:', err);
        modalBody.innerHTML = '<p>Error al cargar los detalles de la flor.</p>';
        modal.style.display = 'block';
    }
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