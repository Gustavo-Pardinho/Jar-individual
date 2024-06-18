																		
DROP DATABASE IF EXISTS sisguard;
CREATE DATABASE IF NOT EXISTS sisguard;

use sisguard;
CREATE TABLE empresa (
    idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    nomeEmpresa VARCHAR(40) NOT NULL,
    cnpj CHAR(14) UNIQUE NOT NULL,
    email VARCHAR(100) NOT NULL,
    senha VARCHAR(18) NOT NULL,
    plano INT CHECK (plano IN (1, 2)),
    dataCriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO empresa(nomeEmpresa, cnpj, email, senha) VALUES ("frizza", "123", "frizza", "123");

CREATE TABLE darkstore (
    idDarkstore INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(40),
    canalSlack VARCHAR(100),
    fkEmpresa INT NOT NULL,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa (idEmpresa)
);

INSERT INTO darkstore(nome, fkEmpresa) VALUES ("Setor 1", 1);

CREATE TABLE metrica_ideal (
    idMetricaIdeal INT PRIMARY KEY AUTO_INCREMENT,
    alertaPadrao DOUBLE,
    criticaPadrao DOUBLE,
    alertaCPU DOUBLE,
    criticoCPU DOUBLE,
    alertaRAM DOUBLE,
    criticoRAM DOUBLE,
    alertaDisco DOUBLE,
    criticoDisco DOUBLE,
    fkDarkStore INT NOT NULL,
    FOREIGN KEY (fkDarkStore) REFERENCES darkstore (idDarkstore)
);

INSERT INTO metrica_ideal(fkDarkStore) VALUES (1);

CREATE TABLE maquina (
    idMaquina INT AUTO_INCREMENT PRIMARY KEY,
    numSerie VARCHAR(30),
    nomeMaquina VARCHAR(50),
    fkDarkStore INT NOT NULL,
    UNIQUE (idMaquina, fkDarkStore),
    FOREIGN KEY (fkDarkStore) REFERENCES darkstore(idDarkstore)
);
	INSERT INTO maquina VALUES (null, '2033232BE23', 'aso', 1);
	INSERT INTO maquina VALUES (null, '2033232BE23', 'aso2', 1);
	INSERT INTO maquina VALUES (null, '2033232BE23', 'aso3', 1);
	INSERT INTO maquina VALUES (null, '2033232BE23', 'aso4', 1);
	INSERT INTO maquina VALUES (null, '2033232BE23', 'aso5', 1);
	INSERT INTO maquina VALUES (null, '2033232BE23', 'aso6', 1);
                                
CREATE TABLE funcionario (
    idFuncionario INT PRIMARY KEY AUTO_INCREMENT,
    nomeFuncionario VARCHAR(40),
    sobrenome VARCHAR(40),
    emailFuncionario VARCHAR(100),
    senha VARCHAR(45),
    cargo VARCHAR(45) NOT NULL,
    fkEmpresa INT NOT NULL,
    FOREIGN KEY (fkEmpresa) REFERENCES empresa (idEmpresa)
);

CREATE TABLE endereco (
    idEndereco INT PRIMARY KEY AUTO_INCREMENT,
    cep CHAR(8) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    bairro VARCHAR(50) NOT NULL,
    rua VARCHAR(50) NOT NULL,
    numero INT NOT NULL,
    fkDarkstore INT NOT NULL,
    FOREIGN KEY (fkDarkstore) REFERENCES darkstore (idDarkstore)
);

CREATE TABLE componente (
    idComponente INT AUTO_INCREMENT PRIMARY KEY,
    Maquina_idMaquina INT,
    nome VARCHAR(100),
    INDEX idx_Maquina_idMaquina (Maquina_idMaquina),
    FOREIGN KEY (Maquina_idMaquina) REFERENCES maquina(idMaquina) ON DELETE CASCADE
);

CREATE TABLE processos (
    idProcessos INT PRIMARY KEY AUTO_INCREMENT,
    dado VARCHAR(650),
    pid VARCHAR(20),
    desativar char(3) default "NAO",
    fkMaquina INT,
    FOREIGN KEY (fkMaquina) REFERENCES maquina(idMaquina)
);

ALTER TABLE maquina ADD COLUMN maquinaMetricaIdeal INT;

CREATE TABLE registro (
    idRegistro INT PRIMARY KEY AUTO_INCREMENT,
    dado VARCHAR(200) NOT NULL,
    dataRegistro DATETIME,
    fkComponente INT NOT NULL,
    componente_fkMaquina INT NOT NULL,
    componente_maquina_fkDarkstore INT NOT NULL,
    componente_maquina_fkMetrica_ideal INT NOT NULL,
    FOREIGN KEY (fkComponente) REFERENCES componente(idComponente),
    FOREIGN KEY (componente_fkMaquina) REFERENCES maquina(idMaquina),
    FOREIGN KEY (componente_maquina_fkDarkstore) REFERENCES darkstore(idDarkstore),
    FOREIGN KEY (componente_maquina_fkMetrica_ideal) REFERENCES metrica_ideal(idMetricaIdeal)
);
CREATE TABLE alerta (
    idAlerta INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(250),
    fkMaquina INT,
    maquinaMetricaIdeal INT,
    maquinafkDarkstore INT,
    fkRegistro INT,
    registrofkComponente INT,
    registroComponentefkMaquina INT,
    registroComponenteMaquinafkDarkstore INT,
    registroComponenteMaquinafkMetricaIdeal INT,
    FOREIGN KEY (fkMaquina)
        REFERENCES maquina (idMaquina),
    FOREIGN KEY (maquinafkDarkstore)
        REFERENCES darkstore (idDarkstore),
    FOREIGN KEY (fkRegistro)
        REFERENCES registro (idRegistro),
    FOREIGN KEY (registrofkComponente)
        REFERENCES componente (idComponente),
    FOREIGN KEY (registroComponentefkMaquina)
        REFERENCES maquina (idMaquina),
    FOREIGN KEY (registroComponenteMaquinafkDarkstore)
        REFERENCES darkstore (idDarkstore),
    FOREIGN KEY (registroComponenteMaquinafkMetricaIdeal)
        REFERENCES metrica_ideal (idMetricaIdeal)
);

SET SQL_SAFE_UPDATES = 0;