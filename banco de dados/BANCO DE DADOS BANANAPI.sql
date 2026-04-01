create database monitoramentoBananAPI;
use monitoramentoBananAPI;

create table empresa (
idEmpresa int primary key auto_increment,
nome varchar(100),
CNPJ char(14) unique ,
dataCadastro datetime default current_timestamp
);

create table usuario (
idUsuario int primary key auto_increment,
nome varchar(100),
email varchar(100) unique,
senha varchar(250),
fkEmpresa int,
foreign key (fkEmpresa) references empresa(idEmpresa) );

create table entreposto (
idEntreposto int primary key auto_increment,
nome varchar(100),
localizacao varchar(150),
fkEmpresa int,
foreign key (fkEmpresa) references empresa(idEmpresa) );

create table camara (
idCamara int primary key auto_increment,
nome varchar(50),
tipo varchar (50), -- maturação ou conservação
fkEntreposto int, 
foreign key (fkEntreposto) references entreposto(idEntreposto) );

create table sensor (
idSensor int primary key auto_increment,
modelo varchar(50), -- o nosso é o LM35
status1 varchar(20),
fkCamara int,
foreign key (fkCamara) references camara(idCamara) );

create table leitura (
idLeitura int primary key auto_increment,
temperatura decimal (5, 2),
dataHora datetime default current_timestamp,
fkSensor int,
foreign key (fkSensor) references sensor(idSensor) );

create table tipoAlerta (
idTipo int primary key auto_increment,
descricao varchar(100) );

create table alerta (
idAlerta int primary key auto_increment,
mensagem varchar(250),
dataHora datetime default current_timestamp,
fkLeitura int,
fkTipo int,
foreign key (fkLeitura) references leitura(idLeitura),
foreign key (fkTipo) references tipoAlerta(idTipo) );

INSERT INTO empresa (nome, cnpj)
VALUES ('BananaTech', '12345678000199');

INSERT INTO usuario (nome, email, senha, fkEmpresa)
VALUES ('Felipe', 'felipe@email.com', '123456', 1);

INSERT INTO entreposto (nome, localizacao, fkEmpresa)
VALUES ('CEAGESP SP', 'São Paulo', 1);

INSERT INTO camara (nome, tipo, fkEntreposto)
VALUES ('Camara 1', 'Conservacao', 1);

INSERT INTO sensor (modelo, status1, fkCamara)
VALUES ('LM35', 'Ativo', 1);

INSERT INTO leitura (temperatura, fkSensor)
VALUES  
(14.5, 1), (26.2, 1), (11.0, 1);

INSERT INTO tipoAlerta (descricao) VALUES
('Frio Critico'),
('Calor Critico'),
('Fora da Faixa Ideal');

INSERT INTO alerta (mensagem, fkLeitura, fkTipo)
VALUES 
('Temperatura muito baixa', 3, 1),
('Temperatura muito alta', 2, 2);

select * from leitura;

SELECT 
    e.nome AS Empresa,
    en.nome AS Entreposto,
    c.nome AS Camera,
    s.modelo AS Sensor,
    l.temperatura,
    l.dataHora
FROM leitura l
JOIN sensor s ON l.fkSensor = s.idSensor
JOIN camara c ON s.fkCamara = c.idCamara
JOIN entreposto en ON c.fkEntreposto = en.idEntreposto
JOIN empresa e ON en.fkEmpresa = e.idEmpresa; -- MELHOR SELECT PARA APRESENTAÇÃO !!!


-- --------------------------------------------------------
SELECT 
    l.temperatura,
    l.dataHora,
    a.mensagem,
    t.descricao AS Tipo
FROM alerta a
JOIN leitura l ON a.fkLeitura = l.idLeitura
JOIN tipoAlerta t ON a.fkTipo = t.idTipo; -- Leituras de temperatura com alerta

-- ---------------------------------------------------------
select *
from leitura
where temperatura < 13 or temperatura > 24; -- temperatura fora do comum

-- -----------------------------------------------------------
SELECT 
    l.idLeitura,
    l.temperatura,
    a.mensagem
FROM leitura l
LEFT JOIN alerta a ON l.idLeitura = a.fkLeitura; -- leitura com left join

-- ---------------------------------------------------------------
