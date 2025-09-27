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

