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
    const catalogo = document.querySelector('#catalogo-flores');
    const volverBtn = document.getElementById('volver-btn');

    titulo.textContent = productora.nombreproductora;
    volverBtn.style.display = 'block';
    volverBtn.onclick = () => cambiarSeccion('productores');
    
    // Crear contenedor flex para la información y el botón de contratos
    const infoContainer = document.createElement('div');
    infoContainer.className = 'info-container';

    // Crear contenedor para la información de la productora
    const info = document.createElement('div');
    info.className = 'info';
    info.innerHTML = `
        <p>${productora.email ? `Email: ${productora.email}` : ''}</p>
        ${productora.paginaweb ? `<p>Página Web: <a href="http://${productora.paginaweb}" target="_blank">${productora.paginaweb}</a></p>` : ''}
        <p>País: ${productora.pais || 'Desconocido'}</p>
    `;

    // Crear botón de "Contratos"
    const contratosBtn = document.createElement('button');
    contratosBtn.id = 'contratos-btn';
    contratosBtn.className = 'contratos-btn';
    contratosBtn.innerHTML = '<i class="fas fa-file-contract"></i> Contratos';

    // Añadir event listener para mostrar el modal de contratos
    contratosBtn.addEventListener('click', () => {
        mostrarModalContratos(productora);
    });

    // Añadir la información y el botón al contenedor flex
    infoContainer.appendChild(info);
    infoContainer.appendChild(contratosBtn);

    // Añadir el contenedor flex al contenedor de detalles
    const detallesInfo = document.getElementById('detalles-info');
    detallesInfo.innerHTML = '';
    detallesInfo.appendChild(infoContainer);

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

// Función para mostrar el modal de contratos
function mostrarModalContratos(productora) {
    // Crear modal
    const modal = document.createElement('div');
    modal.className = 'modal';
    modal.id = 'contratos-modal';
    modal.innerHTML = `
        <div class="modal-content">
            <span class="close" id="close-contratos-modal">&times;</span>
            <h2>Contratos</h2>
            <div class="contratos-options">
                <button id="nuevo-contrato-btn" class="card contrato-card">
                    <i class="fas fa-plus-circle"></i>
                    <h3>Nuevo Contrato</h3>
                </button>
                <button id="renovar-contrato-btn" class="card contrato-card">
                    <i class="fas fa-sync-alt"></i>
                    <h3>Renovar Contrato</h3>
                </button>
            </div>
            <!-- Nuevo Contrato Formulario -->
            <div id="nuevo-contrato-form" class="contrato-form" style="display: none;">
                <form action="/insert-contrato" method="post" class="formulario-insertar">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="productoraNombre">Productora:</label>
                            <input type="text" id="productoraNombre" name="productoraNombre" value="${productora.nombre}" readonly>
                        </div>
                        <div class="form-group">
                            <label for="subastadoraSelect">Subastadora:</label>
                            <select id="subastadoraSelect" name="subastadoraSelect" required>
                                <option value="">Seleccione una Subastadora</option>
                                <!-- Opciones se cargarán dinámicamente -->
                            </select>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="nContrato">Número de Contrato:</label>
                            <input type="text" id="nContrato" name="nContrato" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="tipoProductor">Tipo de Productor:</label>
                            <select id="tipoProductor" name="tipoProductor" required>
                                <option value="CA">CA</option>
                                <option value="CB">CB</option>
                                <option value="CC">CC</option>
                                <option value="CG">CG</option>
                                <option value="KA">KA</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="porcentajeProduccion">Porcentaje de Producción:</label>
                            <input type="number" step="0.01" id="porcentajeProduccion" name="porcentajeProduccion" required>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="existingContract">Contrato Existente:</label>
                            <input type="text" id="existingContract" name="existingContract" readonly>
                        </div>
                    </div>
                    <input type="submit" value="Enviar">
                </form>
            </div>
            <!-- Renovar Contrato Formulario (en construcción) -->
            <div id="renovar-contrato-form" class="contrato-form" style="display: none;">
                <p>Funcionalidad para renovar contrato en construcción.</p>
            </div>
        </div>
    `;

    document.body.appendChild(modal);

    // Mostrar el modal
    modal.style.display = 'block';

    // Event listeners del modal
    const closeModal = document.getElementById('close-contratos-modal');
    closeModal.addEventListener('click', () => {
        modal.remove();
    });

    window.addEventListener('click', (e) => {
        if (e.target === modal) {
            modal.remove();
        }
    });

    const nuevoContratoBtn = document.getElementById('nuevo-contrato-btn');
    const renovarContratoBtn = document.getElementById('renovar-contrato-btn');
    const nuevoContratoForm = document.getElementById('nuevo-contrato-form');
    const renovarContratoForm = document.getElementById('renovar-contrato-form');
    const subastadoraSelect = document.getElementById('subastadoraSelect');
    const existingContractInput = document.getElementById('existingContract');
    const contractDetailsP = document.getElementById('contract-details');
    const tipoProductorSelect = document.getElementById('tipoProductor');
    const porcentajeProduccionInput = document.getElementById('porcentajeProduccion');

    nuevoContratoBtn.addEventListener('click', () => {
        nuevoContratoForm.style.display = 'block';
        renovarContratoForm.style.display = 'none';
        // Cargar opciones de subastadoras
        cargarSubastadoras();
    });

    renovarContratoBtn.addEventListener('click', () => {
        renovarContratoForm.style.display = 'block';
        nuevoContratoForm.style.display = 'none';
    });

    subastadoraSelect.addEventListener('change', () => {
        const subastadoraId = subastadoraSelect.value;
        if (subastadoraId) {
            // Buscar contrato existente
            buscarContratoExistente(productora.id, subastadoraId);
        } else {
            existingContractInput.value = '';
        }
    });

    tipoProductorSelect.addEventListener('change', () => {
        const tipoProductor = tipoProductorSelect.value;
        switch (tipoProductor) {
            case 'CA':
                porcentajeProduccionInput.value = '';
                porcentajeProduccionInput.min = 50;
                porcentajeProduccionInput.max = 100;
                porcentajeProduccionInput.disabled = false;
                break;
            case 'CB':
                porcentajeProduccionInput.value = '';
                porcentajeProduccionInput.min = 20;
                porcentajeProduccionInput.max = 49;
                porcentajeProduccionInput.disabled = false;
                break;
            case 'CC':
                porcentajeProduccionInput.value = '';
                porcentajeProduccionInput.min = 0;
                porcentajeProduccionInput.max = 19;
                porcentajeProduccionInput.disabled = false;
                break;
            case 'KA':
                porcentajeProduccionInput.value = 100;
                porcentajeProduccionInput.disabled = true;
                break;
            default:
                porcentajeProduccionInput.value = '';
                porcentajeProduccionInput.disabled = true;
                break;
        }
    });

    // Validación al enviar el formulario
    const formularioInsertar = document.querySelector('.formulario-insertar');
    formularioInsertar.addEventListener('submit', (e) => {
        const tipoProductor = tipoProductorSelect.value;
        const porcentaje = parseFloat(porcentajeProduccionInput.value);
        let isValid = true;
        let mensaje = '';

        if (!porcentajeProduccionInput.disabled) {
            switch (tipoProductor) {
                case 'CA':
                    if (porcentaje < 50 || porcentaje > 100) {
                        isValid = false;
                        mensaje = 'Para Tipo CA, el porcentaje debe ser entre 50% y 100%.';
                    }
                    break;
                case 'CB':
                    if (porcentaje < 20 || porcentaje > 49) {
                        isValid = false;
                        mensaje = 'Para Tipo CB, el porcentaje debe ser entre 20% y 49%.';
                    }
                    break;
                case 'CC':
                    if (porcentaje < 0 || porcentaje > 19) {
                        isValid = false;
                        mensaje = 'Para Tipo CC, el porcentaje debe ser menos del 20%.';
                    }
                    break;
                default:
                    break;
            }

            if (!isValid) {
                e.preventDefault();
                alert(mensaje);
            }
        }
    });

    // Función para cargar subastadoras
    function cargarSubastadoras() {
        // Simulación de obtención de subastadoras
        const subastadoras = [
            { id: 1, nombre: 'Subastadora A' },
            { id: 2, nombre: 'Subastadora B' },
            // ...más subastadoras
        ];
        subastadoraSelect.innerHTML = '<option value="">Seleccione una Subastadora</option>';
        subastadoras.forEach(subastadora => {
            const option = document.createElement('option');
            option.value = subastadora.id;
            option.textContent = subastadora.nombre;
            subastadoraSelect.appendChild(option);
        });
    }

    // Función para buscar contrato existente
    function buscarContratoExistente(productoraId, subastadoraId) {
        // Simulación de búsqueda de contrato existente
        const contrato = obtenerContratoExistente(productoraId, subastadoraId);
        if (contrato) {
            existingContractInput.value = `Contrato Nº: ${contrato.nContrato}, Fecha Emisión: ${contrato.fechaEmision}`;
        } else {
            existingContractInput.value = 'No hay contrato existente';
        }
    }

    // Función simulada para obtener contrato existente
    function obtenerContratoExistente(productoraId, subastadoraId) {
        // Retorna un contrato si existe, o null
        return null; // Reemplazar con implementación real
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