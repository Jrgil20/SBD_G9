import { cambiarSeccion } from './utils.js';

// Event listeners
document.addEventListener('DOMContentLoaded', () => {
    // Event listeners para los enlaces del sidebar
    document.querySelectorAll('.sidebar a').forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            cambiarSeccion(e.target.getAttribute('data-section'));
        });
    });

    // Event listeners para las tarjetas del panel principal
    document.querySelectorAll('.main-card').forEach(card => {
        card.addEventListener('click', (e) => {
            const seccion = e.currentTarget.getAttribute('data-section');
            cambiarSeccion(seccion);
        });
    });

    document.querySelector('.close').addEventListener('click', () => {
        document.getElementById('modal').style.display = 'none';
    });

    window.addEventListener('click', (e) => {
        if (e.target === document.getElementById('modal')) {
            document.getElementById('modal').style.display = 'none';
        }
    });

    // Filtro para facturas
    const aplicarFiltroBtn = document.getElementById('aplicarFiltro');
    if (aplicarFiltroBtn) {
        aplicarFiltroBtn.addEventListener('click', aplicarFiltroFacturas);
    }

    // Event listener para el botón de toggle del sidebar
    const sidebarToggle = document.getElementById('sidebar-toggle');
    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', toggleSidebar);
    }

    // Event listener para el botón de cierre del sidebar
    const sidebarClose = document.getElementById('sidebar-close');
    if (sidebarClose) {
        sidebarClose.addEventListener('click', toggleSidebar);
    }

    // Event listener para cerrar el sidebar al hacer clic en el overlay
    const overlay = document.getElementById('overlay');
    if (overlay) {
        overlay.addEventListener('click', toggleSidebar);
    }

    // Event listener para cerrar el sidebar al hacer clic en un enlace (en móviles)
    document.querySelectorAll('.sidebar a').forEach(link => {
        link.addEventListener('click', () => {
            if (window.innerWidth <= 768) {
                toggleSidebar();
            }
        });
    });

    // Handle submenu clicks in "Insertar Datos" section
    const submenuLinks = document.querySelectorAll('.submenu a');
    const capturarForms = document.querySelectorAll('.capturar-form');

    submenuLinks.forEach(link => {
        link.addEventListener('click', event => {
            event.preventDefault();
            const sectionId = event.currentTarget.getAttribute('data-section') + '-form';
            capturarForms.forEach(form => {
                if (form.id === sectionId) {
                    form.classList.add('active');
                } else {
                    form.classList.remove('active');
                }
            });
        });
    });

    // Event listener for "Contratos" button
    document.addEventListener('click', (event) => {
        if (event.target && event.target.id === 'contratos-btn') {
            const productoraId = event.target.getAttribute('data-productora-id');
            mostrarModalContratos(productoraId);
        }
    });

    // Cargar el panel principal al inicio
    cambiarSeccion('main');
});

// Ajustar el sidebar al cambiar el tamaño de la ventana
window.addEventListener('resize', () => {
    const sidebar = document.querySelector('.sidebar');
    if (sidebar && window.innerWidth > 768) {
        sidebar.classList.remove('active');
    }
});

// Función para mostrar el modal de contratos
function mostrarModalContratos(productoraId) {
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
                    <label for="productoraNombre">Productora:</label>
                    <input type="text" id="productoraNombre" name="productoraNombre" value="${productoraId}" readonly><br><br>

                    <label for="subastadoraSelect">Subastadora:</label>
                    <select id="subastadoraSelect" name="subastadoraSelect" required>
                        <option value="">Seleccione una Subastadora</option>
                        <!-- Opciones se cargarán dinámicamente -->
                    </select><br><br>

                    <!-- Contratos existentes -->
                    <div id="existing-contract" style="display: none;">
                        <h3>Contrato Existente:</h3>
                        <p id="contract-details"></p>
                    </div>

                    <!-- Campos de la tabla CONTRATO -->
                    <label for="nContrato">Número de Contrato:</label>
                    <input type="text" id="nContrato" name="nContrato" required><br><br>

                    <label for="fechaEmision">Fecha de Emisión:</label>
                    <input type="date" id="fechaEmision" name="fechaEmision" required><br><br>

                    <label for="porcentajeProduccion">Porcentaje de Producción:</label>
                    <input type="number" step="0.01" id="porcentajeProduccion" name="porcentajeProduccion" required><br><br>

                    <label for="tipoProductor">Tipo de Productor:</label>
                    <input type="text" id="tipoProductor" name="tipoProductor" required><br><br>

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
    const existingContractDiv = document.getElementById('existing-contract');
    const contractDetailsP = document.getElementById('contract-details');

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
            buscarContratoExistente(productoraId, subastadoraId);
        } else {
            existingContractDiv.style.display = 'none';
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
        const contrato = getExistingContract(productoraId, subastadoraId);
        if (contrato) {
            existingContractDiv.style.display = 'block';
            contractDetailsP.textContent = `Contrato Nº: ${contrato.nContrato}, Fecha Emisión: ${contrato.fechaEmision}`;
        } else {
            existingContractDiv.style.display = 'none';
        }
    }

    // Función para obtener contrato existente (simulación)
    function getExistingContract(productoraId, subastadoraId) {
        // Simulación de obtención de contrato existente
        return null; // Reemplazar con la implementación real
    }
}


