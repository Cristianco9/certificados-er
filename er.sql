-- =====================================================
-- CREACIÓN DE BASE DE DATOS PARA CERTIFICADOS ACADÉMICOS
-- =====================================================
CREATE DATABASE IF NOT EXISTS certificados_academicos
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE certificados_academicos;

-- ======================================
-- TABLA: ESTUDIANTE
-- ======================================
CREATE TABLE estudiante (
    id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
    tipo_documento VARCHAR(10) NOT NULL,
    numero_documento VARCHAR(20) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    genero ENUM('M','F','Otro'),
    direccion VARCHAR(150),
    telefono VARCHAR(20),
    email VARCHAR(100)
);

-- ======================================
-- TABLA: ACUDIENTE
-- ======================================
CREATE TABLE acudiente (
    id_acudiente INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100),
    direccion VARCHAR(150),
    parentesco VARCHAR(50)
);

-- ======================================
-- TABLA INTERMEDIA: ESTUDIANTE_ACUDIENTE (N:M)
-- ======================================
CREATE TABLE estudiante_acudiente (
    id_estudiante INT NOT NULL,
    id_acudiente INT NOT NULL,
    PRIMARY KEY (id_estudiante, id_acudiente),
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
    FOREIGN KEY (id_acudiente) REFERENCES acudiente(id_acudiente) ON DELETE CASCADE
);

-- ======================================
-- TABLA: GRADO
-- ======================================
CREATE TABLE grado (
    id_grado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL -- Ejemplo: 'Sexto', 'Séptimo'
);

-- ======================================
-- TABLA: GRUPO
-- ======================================
CREATE TABLE grupo (
    id_grupo INT AUTO_INCREMENT PRIMARY KEY,
    id_grado INT NOT NULL,
    nombre VARCHAR(10) NOT NULL, -- Ejemplo: '6A', '6B'
    anio YEAR NOT NULL,
    FOREIGN KEY (id_grado) REFERENCES grado(id_grado)
);

-- ======================================
-- TABLA: MATRÍCULA
-- ======================================
CREATE TABLE matricula (
    id_matricula INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_grupo INT NOT NULL,
    fecha_matricula DATE NOT NULL,
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante),
    FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo)
);

-- ======================================
-- TABLA: ASIGNATURA
-- ======================================
CREATE TABLE asignatura (
    id_asignatura INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ih INT NOT NULL -- Intensidad horaria
);

-- ======================================
-- TABLA: CALIFICACIÓN
-- ======================================
CREATE TABLE calificacion (
    id_calificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_matricula INT NOT NULL,
    id_asignatura INT NOT NULL,
    nota_definitiva DECIMAL(3,1), -- Ejemplo: 3.5, 4.0
    valoracion VARCHAR(50),       -- Ejemplo: 'Bs', 'Ss'
    nivelacion VARCHAR(50),       -- Puede ser NULL si no aplica
    FOREIGN KEY (id_matricula) REFERENCES matricula(id_matricula) ON DELETE CASCADE,
    FOREIGN KEY (id_asignatura) REFERENCES asignatura(id_asignatura)
);

-- ============================
-- INSERTAR GRADOS
-- ============================
INSERT INTO grado (nombre) VALUES
('Sexto'), ('Séptimo'), ('Octavo'), ('Noveno'), ('Décimo'), ('Undécimo');

-- ============================
-- INSERTAR GRUPOS
-- ============================
INSERT INTO grupo (id_grado, nombre, anio) VALUES
(1, '6A', 2018),
(2, '7A', 2019),
(3, '8A', 2020),
(4, '9A', 2021),
(5, '10A', 2022),
(6, '11A', 2023),
(1, '6B', 2023), -- Otro grupo para otros estudiantes
(2, '7B', 2024);

-- ============================
-- INSERTAR ASIGNATURAS
-- ============================
INSERT INTO asignatura (nombre, ih) VALUES
('Matemáticas', 5),
('Inglés', 3),
('Lengua Castellana', 4),
('Ciencias Naturales', 4),
('Ciencias Sociales', 3);

-- ============================
-- INSERTAR ESTUDIANTES
-- ============================
INSERT INTO estudiante (tipo_documento, numero_documento, nombres, apellidos, fecha_nacimiento, genero, direccion, telefono, email)
VALUES
('TI', '1001', 'Laura Sofía', 'Ramírez Posso', '2007-05-10', 'F', 'Calle 10 #5-20', '3001111111', 'laura@example.com'),
('TI', '1002', 'Carlos Andrés', 'Gómez López', '2010-03-15', 'M', 'Calle 12 #7-33', '3002222222', 'carlos@example.com'),
('TI', '1003', 'Valentina', 'Martínez Ruiz', '2011-08-21', 'F', 'Carrera 8 #4-55', '3003333333', 'valentina@example.com');

-- ============================
-- INSERTAR ACUDIENTES
-- ============================
INSERT INTO acudiente (nombres, apellidos, telefono, email, direccion, parentesco) VALUES
('Ana María', 'Posso', '3100000001', 'ana@example.com', 'Calle 10 #5-20', 'Madre'),
('Jorge', 'Gómez', '3100000002', 'jorge@example.com', 'Calle 12 #7-33', 'Padre'),
('Claudia', 'Ruiz', '3100000003', 'claudia@example.com', 'Carrera 8 #4-55', 'Madre');

-- ============================
-- RELACION ESTUDIANTE-ACUDIENTE
-- ============================
INSERT INTO estudiante_acudiente VALUES
(1, 1), -- Laura Sofía con Ana María
(2, 2), -- Carlos con Jorge
(3, 3); -- Valentina con Claudia

-- ============================
-- MATRÍCULAS
-- ============================
-- Laura Sofía cursó de Sexto a Undécimo
INSERT INTO matricula (id_estudiante, id_grupo, fecha_matricula) VALUES
(1, 1, '2018-01-15'), -- Sexto
(1, 2, '2019-01-15'), -- Séptimo
(1, 3, '2020-01-15'), -- Octavo
(1, 4, '2021-01-15'), -- Noveno
(1, 5, '2022-01-15'), -- Décimo
(1, 6, '2023-01-15'); -- Undécimo

-- Carlos solo cursó Sexto (grupo 6B)
INSERT INTO matricula (id_estudiante, id_grupo, fecha_matricula) VALUES
(2, 7, '2023-01-20');

-- Valentina solo cursó Séptimo (grupo 7B)
INSERT INTO matricula (id_estudiante, id_grupo, fecha_matricula) VALUES
(3, 8, '2024-01-20');

-- ============================
-- CALIFICACIONES
-- ============================
-- Ejemplo: Laura Sofía en Sexto (Matemáticas, Inglés, Castellana)
INSERT INTO calificacion (id_matricula, id_asignatura, nota_definitiva, valoracion, nivelacion) VALUES
(1, 1, 3.5, 'Bs', NULL),
(1, 2, 4.0, 'As', NULL),
(1, 3, 3.0, 'Bs', '3.5'),
(1, 4, 3.8, 'Bs', NULL),
(1, 5, 4.2, 'As', NULL);

-- Séptimo (id_matricula = 2)
INSERT INTO calificacion (id_matricula, id_asignatura, nota_definitiva, valoracion, nivelacion) VALUES
(2, 1, 3.8, 'Bs', NULL),
(2, 2, 4.1, 'As', NULL),
(2, 3, 3.4, 'Bs', '3.8'),
(2, 4, 4.0, 'As', NULL),
(2, 5, 3.7, 'Bs', NULL);

-- Octavo (id_matricula = 3)
INSERT INTO calificacion (id_matricula, id_asignatura, nota_definitiva, valoracion, nivelacion) VALUES
(3, 1, 4.2, 'As', NULL),
(3, 2, 3.9, 'Bs', NULL),
(3, 3, 4.0, 'As', NULL),
(3, 4, 3.5, 'Bs', NULL),
(3, 5, 3.8, 'Bs', NULL);

-- Noveno (id_matricula = 4)
INSERT INTO calificacion (id_matricula, id_asignatura, nota_definitiva, valoracion, nivelacion) VALUES
(4, 1, 4.5, 'As', NULL),
(4, 2, 4.3, 'As', NULL),
(4, 3, 3.9, 'Bs', NULL),
(4, 4, 4.1, 'As', NULL),
(4, 5, 4.0, 'As', NULL);

-- Décimo (id_matricula = 5)
INSERT INTO calificacion (id_matricula, id_asignatura, nota_definitiva, valoracion, nivelacion) VALUES
(5, 1, 4.7, 'As', NULL),
(5, 2, 4.4, 'As', NULL),
(5, 3, 4.1, 'As', NULL),
(5, 4, 3.9, 'Bs', NULL),
(5, 5, 4.3, 'As', NULL);

-- Undécimo (id_matricula = 6)
INSERT INTO calificacion (id_matricula, id_asignatura, nota_definitiva, valoracion, nivelacion) VALUES
(6, 1, 4.6, 'As', NULL),
(6, 2, 4.5, 'As', NULL),
(6, 3, 4.2, 'As', NULL),
(6, 4, 4.0, 'As', NULL),
(6, 5, 4.4, 'As', NULL);

-- Carlos en Sexto (grupo 6B)
INSERT INTO calificacion (id_matricula, id_asignatura, nota_definitiva, valoracion, nivelacion) VALUES
(7, 1, 2.9, 'Ins', '3.2'),
(7, 2, 3.8, 'Bs', NULL),
(7, 3, 3.5, 'Bs', NULL);

-- Valentina en Séptimo (grupo 7B)
INSERT INTO calificacion (id_matricula, id_asignatura, nota_definitiva, valoracion, nivelacion) VALUES
(8, 1, 4.5, 'As', NULL),
(8, 2, 4.2, 'As', NULL),
(8, 3, 3.9, 'Bs', NULL);



-- ============================
-- Consultas
-- ============================


-- Traer datos personales del estudiante con su acudiente
SELECT e.nombres AS estudiante_nombre, e.apellidos AS estudiante_apellido,
       e.numero_documento, a.nombres AS acudiente_nombre, a.apellidos AS acudiente_apellido, a.parentesco
FROM estudiante e
JOIN estudiante_acudiente ea ON e.id_estudiante = ea.id_estudiante
JOIN acudiente a ON ea.id_acudiente = a.id_acudiente
WHERE e.numero_documento = '1001';


-- Obtener calificaciones de un estudiante en un año específico
SELECT g.nombre AS grado, gr.nombre AS grupo, gr.anio,
       asig.nombre AS asignatura, asig.ih,
       c.nota_definitiva, c.valoracion, c.nivelacion
FROM calificacion c
JOIN asignatura asig ON c.id_asignatura = asig.id_asignatura
JOIN matricula m ON c.id_matricula = m.id_matricula
JOIN grupo gr ON m.id_grupo = gr.id_grupo
JOIN grado g ON gr.id_grado = g.id_grado
WHERE m.id_estudiante = 1 AND gr.anio = 2018;

-- Obtener histórico académico de todos los años cursados por un estudiante
SELECT gr.anio, g.nombre AS grado, gr.nombre AS grupo,
       asig.nombre AS asignatura, asig.ih,
       c.nota_definitiva, c.valoracion, c.nivelacion
FROM calificacion c
JOIN asignatura asig ON c.id_asignatura = asig.id_asignatura
JOIN matricula m ON c.id_matricula = m.id_matricula
JOIN grupo gr ON m.id_grupo = gr.id_grupo
JOIN grado g ON gr.id_grado = g.id_grado
WHERE m.id_estudiante = 1
ORDER BY gr.anio, g.nombre, asig.nombre;


-- Obtener todos los años cursados por un estudiante
SELECT DISTINCT 
       gr.anio,
       g.nombre AS grado,
       gr.nombre AS grupo
FROM matricula m
JOIN grupo gr ON m.id_grupo = gr.id_grupo
JOIN grado g ON gr.id_grado = g.id_grado
WHERE m.id_estudiante = 1
ORDER BY gr.anio;

-- Obtener todas las calificaciones de un estudiante en un grado específico
SELECT 
    e.nombres AS estudiante_nombre,
    e.apellidos AS estudiante_apellido,
    g.nombre   AS grado,
    gr.nombre  AS grupo,
    gr.anio,
    a.nombre   AS asignatura,
    a.ih       AS intensidad_horaria,
    c.nota_definitiva,
    c.valoracion,
    c.nivelacion
FROM calificacion c
JOIN asignatura a ON c.id_asignatura = a.id_asignatura
JOIN matricula m ON c.id_matricula = m.id_matricula
JOIN estudiante e ON m.id_estudiante = e.id_estudiante
JOIN grupo gr ON m.id_grupo = gr.id_grupo
JOIN grado g ON gr.id_grado = g.id_grado
WHERE e.id_estudiante = 1   -- ID del estudiante específico
  AND g.nombre = 'Séptimo'  -- Grado específico
ORDER BY a.nombre;

-- Verificar las matrículas del estudiante:
SELECT e.nombres, e.apellidos, g.nombre AS grado, gr.anio
FROM estudiante e
JOIN matricula m ON e.id_estudiante = m.id_estudiante
JOIN grupo gr ON m.id_grupo = gr.id_grupo
JOIN grado g ON gr.id_grado = g.id_grado
WHERE e.id_estudiante = 1;

-- Verifica en que grados hay calificaciones
SELECT g.nombre AS grado, COUNT(*) AS total_calificaciones
FROM calificacion c
JOIN matricula m ON c.id_matricula = m.id_matricula
JOIN grupo gr ON m.id_grupo = gr.id_grupo
JOIN grado g ON gr.id_grado = g.id_grado
WHERE m.id_estudiante = 1
GROUP BY g.nombre;