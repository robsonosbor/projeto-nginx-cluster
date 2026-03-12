-- Criar banco de dados se não existir
CREATE DATABASE IF NOT EXISTS meubanco;
USE meubanco;

-- Tabela de dados com melhor estrutura
CREATE TABLE IF NOT EXISTS dados (
    AlunoID INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(50) NOT NULL,
    Sobrenome VARCHAR(50) NOT NULL,
    Endereco VARCHAR(150),
    Cidade VARCHAR(50),
    Host VARCHAR(50),
    DataCriacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    DataAtualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_host (Host),
    INDEX idx_data (DataCriacao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
