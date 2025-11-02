-- Script de criação das tabelas

CREATE TABLE Endereco ( 
    codigo_endereco NUMBER(6) PRIMARY KEY, 
    logradouro VARCHAR2(200) NOT NULL, 
    bairro     VARCHAR2(100), 
    UF         VARCHAR2(2)     NOT NULL, 
    numero 	   VARCHAR2(4) NOT NULL, 
    cep        VARCHAR2(8) NOT NULL 
);

CREATE TABLE Pessoa ( 
    CPF        VARCHAR2(11) PRIMARY KEY, 
    nome       VARCHAR2(150) NOT NULL, 
    email      VARCHAR2(100), 
    endereco   NUMBER(6), 
     
    CONSTRAINT fk_pessoa_endereco 
        FOREIGN KEY (endereco) 
        REFERENCES Endereco(codigo_endereco) 
);

CREATE TABLE Telefones (
    CPF_pessoa       VARCHAR2(11),
    Numero_telefone  VARCHAR2(15) NOT NULL,
    
    CONSTRAINT pk_telefones 
        PRIMARY KEY (CPF_pessoa, Numero_telefone),
        
    CONSTRAINT fk_telefones_pessoa
        FOREIGN KEY (CPF_pessoa) 
        REFERENCES Pessoa(CPF)
);

CREATE TABLE Tutor (
    CPF_tutor       VARCHAR2(11) PRIMARY KEY,
    data_cadastro   DATE DEFAULT SYSDATE NOT NULL,
    status_tutor    VARCHAR2(50) NOT NULL,
    observacoes     VARCHAR2(1000),
    
    CONSTRAINT fk_tutor_pessoa
        FOREIGN KEY (CPF_tutor)
        REFERENCES Pessoa(CPF)
);

CREATE TABLE Veterinario (
    CPF_veterinario VARCHAR2(11) PRIMARY KEY,
    data_graduacao  DATE,
    numero_CRMV     VARCHAR2(20) NOT NULL,
    UF_CRMV         VARCHAR2(2)  NOT NULL,
    especialidade   VARCHAR2(100),
    
    CONSTRAINT fk_veterinario_pessoa
        FOREIGN KEY (CPF_veterinario)
        REFERENCES Pessoa(CPF),

    CONSTRAINT uk_crmv
        UNIQUE (numero_CRMV, UF_CRMV)
);

CREATE TABLE Animal (
    id_animal       NUMBER PRIMARY KEY,
    nome_animal     VARCHAR2(60) NOT NULL,
    sexo            CHAR(1) CONSTRAINT ck_animal_sexo CHECK (sexo IN ('M','F')),
    data_nascimento DATE,
    peso            NUMBER(5,2) CONSTRAINT ck_animal_peso CHECK (peso > 0),
    especie         VARCHAR2(40) NOT NULL,

    CPF_tutor         VARCHAR2(11) NOT NULL,

    CONSTRAINT fk_animal_tutor
        FOREIGN KEY (CPF_tutor) 
        REFERENCES Tutor(CPF_tutor)
);

CREATE TABLE Alergia_Tipo (
    id_alergia   NUMBER PRIMARY KEY,
    descricao    VARCHAR2(100) NOT NULL UNIQUE 
);

CREATE TABLE Alergias(
    id_alergia        NUMBER NOT NULL,
    id_animal         NUMBER NOT NULL,

    CONSTRAINT pk_animal_alergia 
        PRIMARY KEY (id_animal, id_alergia),
    
    CONSTRAINT fk_alergia_animal
        FOREIGN KEY (id_animal)
        REFERENCES Animal(id_animal),
    
    CONSTRAINT fk_alergia_tipo
        FOREIGN KEY (id_alergia) 
        REFERENCES Alergia_Tipo(id_alergia)
);

CREATE TABLE Servico (
    Id_servico     NUMBER PRIMARY KEY,
    Descricao      VARCHAR2(200) NOT NULL,
    Tipo_servico   VARCHAR2(50),
    Preco          NUMBER(10, 2),
    especie_alvo   VARCHAR2(50),

    CONSTRAINT ck_servico_preco CHECK (Preco > 0)
);

CREATE TABLE Atendimento (
    Id_atendimento       NUMBER PRIMARY KEY,
    Data_hora_inicio     TIMESTAMP NOT NULL,
    Data_hora_fim        TIMESTAMP,
    Status_agendamento   VARCHAR2(30),

    id_servico           NUMBER NOT NULL, 
    id_animal            NUMBER NOT NULL,
    CPF_veterinario      VARCHAR2(11) NOT NULL,

    CONSTRAINT fk_atendimento_servico
        FOREIGN KEY (id_servico) 
        REFERENCES Servico(id_servico),
        
    CONSTRAINT fk_atendimento_animal
        FOREIGN KEY (id_animal) 
        REFERENCES Animal(id_animal),
        
    CONSTRAINT fk_atendimento_veterinario
        FOREIGN KEY (CPF_veterinario) 
        REFERENCES Veterinario(CPF_veterinario)
);

CREATE TABLE Medicamento (
    id_medicamento   NUMBER(10) NOT NULL PRIMARY KEY,
    nome_medicamento VARCHAR2(100) NOT NULL,
    validade         DATE,
    qtd_em_estoque   NUMBER(6),
    especie_alvo     VARCHAR2(100),
    preco            NUMBER(10, 2)
);

CREATE TABLE Prescricao (
    id_atendimento NUMBER(10) NOT NULL,
    id_medicamento NUMBER(10) NOT NULL,
    dose           VARCHAR2(50),
    frequencia     VARCHAR2(50),
    duracao        VARCHAR2(50),

    CONSTRAINT pk_prescricao 
        PRIMARY KEY (id_atendimento, id_medicamento),
    CONSTRAINT fk_presc_medicamento 
        FOREIGN KEY (id_medicamento) 
        REFERENCES Medicamento(id_medicamento),
    CONSTRAINT fk_presc_atendimento 
        FOREIGN KEY (id_atendimento) 
        REFERENCES Atendimento(id_atendimento)
);

CREATE TABLE Pagamento (
    id_pagamento     NUMBER(10) NOT NULL PRIMARY KEY,
    id_atendimento   NUMBER(10) NOT NULL,
    valor_total      NUMBER(10, 2) NOT NULL,
    data_emissao     DATE NOT NULL,
    forma_pagamento  VARCHAR2(50),
    status_pagamento VARCHAR2(50),

    CONSTRAINT fk_pagamento_atendimento
        FOREIGN KEY (id_atendimento) 
        REFERENCES Atendimento(id_atendimento)
);

CREATE TABLE Parcela_Pagamento (
    id_pagamento    NUMBER(10) NOT NULL,
    nr_parcela      NUMBER(3) NOT NULL,
    valor_parcela   NUMBER(10, 2) NOT NULL,
    data_vencimento DATE NOT NULL,
    data_pagamento  DATE,

    CONSTRAINT pk_parcela_pagamento
        PRIMARY KEY (id_pagamento, nr_parcela),
    CONSTRAINT fk_parcela_pagamento
        FOREIGN KEY (id_pagamento)
        REFERENCES Pagamento(id_pagamento)
);