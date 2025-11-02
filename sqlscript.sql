REM   Script: Equipe 4
REM   Criação de tabelas, sequences e povoamento

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

CREATE SEQUENCE sequence_endereco START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE sequence_animal START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE sequence_alergia START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE sequence_servico START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE sequence_atendimento START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE sequence_medicamento START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE sequence_pagamento START WITH 1 INCREMENT BY 1;

INSERT INTO Endereco (codigo_endereco, logradouro, bairro, UF, numero, cep)  
    VALUES (sequence_endereco.NEXTVAL, 'Rua das Ninfas', 'Boa Vista', 'PE', '100', '50070000');

INSERT INTO Endereco (codigo_endereco, logradouro, bairro, UF, numero, cep)  
    VALUES (sequence_endereco.NEXTVAL, 'Avenida Boa Viagem', 'Boa Viagem', 'PE', '1200', '51020001');

INSERT INTO Endereco (codigo_endereco, logradouro, bairro, UF, numero, cep)  
    VALUES (sequence_endereco.NEXTVAL, 'Rua do Futuro', 'Aflitos', 'PE', '300', '52050010');

INSERT INTO Endereco (codigo_endereco, logradouro, bairro, UF, numero, cep)  
    VALUES (sequence_endereco.NEXTVAL, 'Estrada do Encanamento', 'Parnamirim', 'PE', '450', '52060000');

INSERT INTO Endereco (codigo_endereco, logradouro, bairro, UF, numero, cep)  
    VALUES (sequence_endereco.NEXTVAL, 'Rua da Aurora', 'Santo Amaro', 'PE', '500', '50050000');

INSERT INTO Endereco (codigo_endereco, logradouro, bairro, UF, numero, cep)  
    VALUES (sequence_endereco.NEXTVAL, 'Avenida Dezessete de Agosto', 'Casa Forte', 'PE', '1500', '52061540');

INSERT INTO Endereco (codigo_endereco, logradouro, bairro, UF, numero, cep)  
    VALUES (sequence_endereco.NEXTVAL, 'Rua da Harmonia', 'Casa Amarela', 'PE', '600', '52051390');

INSERT INTO Endereco (codigo_endereco, logradouro, bairro, UF, numero, cep)  
    VALUES (sequence_endereco.NEXTVAL, 'Rua Jerônimo Vilela', 'Tamarineira', 'PE', '700', '52051090');

INSERT INTO Endereco (codigo_endereco, logradouro, bairro, UF, numero, cep)  
    VALUES (sequence_endereco.NEXTVAL, 'Rua do Espinheiro', 'Espinheiro', 'PE', '800', '52020020');

INSERT INTO Endereco (codigo_endereco, logradouro, bairro, UF, numero, cep)  
    VALUES (sequence_endereco.NEXTVAL, 'Avenida Conselheiro Aguiar', 'Pina', 'PE', '900', '51011030');

INSERT INTO Pessoa (CPF, nome, email, endereco)  
    VALUES ('11111111101', 'Ana Clara Silva', 'ana.silva@email.com', 1);

INSERT INTO Pessoa (CPF, nome, email, endereco)  
    VALUES ('11111111102', 'Bruno Costa', 'bruno.costa@email.com', 2);

INSERT INTO Pessoa (CPF, nome, email, endereco)  
    VALUES ('11111111103', 'Carla Dias', 'carla.dias@email.com', 3);

INSERT INTO Pessoa (CPF, nome, email, endereco)  
    VALUES ('11111111104', 'Daniel Moreira', 'daniel.moreira@email.com', 4);

INSERT INTO Pessoa (CPF, nome, email, endereco)  
    VALUES ('11111111105', 'Elisa Fernandes', 'elisa.fernandes@email.com', 5);

INSERT INTO Pessoa (CPF, nome, email, endereco)  
    VALUES ('11111111106', 'Dr. Felipe Alves', 'felipe.alves@vet.com', 6);

INSERT INTO Pessoa (CPF, nome, email, endereco)  
    VALUES ('11111111107', 'Dra. Gabriela Lima', 'gabi.lima@vet.com', 7);

INSERT INTO Pessoa (CPF, nome, email, endereco)  
    VALUES ('11111111108', 'Dr. Heitor Campos', 'heitor.campos@vet.com', 8);

INSERT INTO Pessoa (CPF, nome, email, endereco)  
    VALUES ('11111111109', 'Dra. Isabela Rocha', 'isabela.rocha@vet.com', 9);

INSERT INTO Pessoa (CPF, nome, email, endereco)  
    VALUES ('11111111110', 'Dr. João Mendes', 'joao.mendes@vet.com', 10);

INSERT INTO Telefones (CPF_pessoa, Numero_telefone)  
    VALUES ('11111111101', '81999991101');

INSERT INTO Telefones (CPF_pessoa, Numero_telefone)  
    VALUES ('11111111101', '8133331101');

INSERT INTO Telefones (CPF_pessoa, Numero_telefone)  
    VALUES ('11111111102', '81999991102');

INSERT INTO Telefones (CPF_pessoa, Numero_telefone)  
    VALUES ('11111111103', '81999991103');

INSERT INTO Telefones (CPF_pessoa, Numero_telefone)  
    VALUES ('11111111104', '81999991104');

INSERT INTO Telefones (CPF_pessoa, Numero_telefone)  
    VALUES ('11111111105', '81999991105');

INSERT INTO Telefones (CPF_pessoa, Numero_telefone)  
    VALUES ('11111111105', '8133331105');

INSERT INTO Telefones (CPF_pessoa, Numero_telefone)  
    VALUES ('11111111106', '81988881106');

INSERT INTO Telefones (CPF_pessoa, Numero_telefone)  
    VALUES ('11111111107', '81988881107');

INSERT INTO Telefones (CPF_pessoa, Numero_telefone)  
    VALUES ('11111111108', '81988881108');

INSERT INTO Telefones (CPF_pessoa, Numero_telefone)  
    VALUES ('11111111109', '81988881109');

INSERT INTO Telefones (CPF_pessoa, Numero_telefone)  
    VALUES ('11111111110', '81988881110');

INSERT INTO Telefones (CPF_pessoa, Numero_telefone)  
    VALUES ('11111111110', '8133331110');

INSERT INTO Tutor (CPF_tutor, data_cadastro, status_tutor, observacoes)  
    VALUES ('11111111101', TO_DATE('2023-01-15', 'YYYY-MM-DD'), 'Ativo', 'Cliente antigo, 2 animais');

INSERT INTO Tutor (CPF_tutor, data_cadastro, status_tutor, observacoes)  
    VALUES ('11111111102', TO_DATE('2023-03-20', 'YYYY-MM-DD'), 'Ativo', 'Prefere contato por WhatsApp');

INSERT INTO Tutor (CPF_tutor, data_cadastro, status_tutor, observacoes)  
    VALUES ('11111111103', TO_DATE('2023-05-10', 'YYYY-MM-DD'), 'Inativo', 'Mudou-se de cidade');

INSERT INTO Tutor (CPF_tutor, data_cadastro, status_tutor, observacoes)  
    VALUES ('11111111104', TO_DATE('2023-07-01', 'YYYY-MM-DD'), 'Ativo', 'Dono de 3 cães');

INSERT INTO Tutor (CPF_tutor, data_cadastro, status_tutor, observacoes)  
    VALUES ('11111111105', TO_DATE('2023-09-05', 'YYYY-MM-DD'), 'Ativo', 'Dona de 2 gatos');

INSERT INTO Veterinario (CPF_veterinario, data_graduacao, numero_CRMV, UF_CRMV, especialidade)  
    VALUES ('11111111106', TO_DATE('2010-12-20', 'YYYY-MM-DD'), '1234', 'PE', 'Clínico Geral');

INSERT INTO Veterinario (CPF_veterinario, data_graduacao, numero_CRMV, UF_CRMV, especialidade)  
    VALUES ('11111111107', TO_DATE('2012-06-15', 'YYYY-MM-DD'), '2345', 'PE', 'Dermatologia');

INSERT INTO Veterinario (CPF_veterinario, data_graduacao, numero_CRMV, UF_CRMV, especialidade)  
    VALUES ('11111111108', TO_DATE('2008-01-30', 'YYYY-MM-DD'), '3456', 'PE', 'Cirurgia');

INSERT INTO Veterinario (CPF_veterinario, data_graduacao, numero_CRMV, UF_CRMV, especialidade)  
    VALUES ('11111111109', TO_DATE('2015-12-18', 'YYYY-MM-DD'), '4567', 'PE', 'Clínico Geral');

INSERT INTO Veterinario (CPF_veterinario, data_graduacao, numero_CRMV, UF_CRMV, especialidade)  
    VALUES ('11111111110', TO_DATE('2018-07-22', 'YYYY-MM-DD'), '5678', 'PE', 'Cardiologia');

INSERT INTO Animal (id_animal, nome_animal, sexo, data_nascimento, peso, especie, CPF_tutor)  
    VALUES (sequence_animal.NEXTVAL, 'Thor', 'M', TO_DATE('2020-05-10', 'YYYY-MM-DD'), 12.5, 'Cachorro (Beagle)', '11111111101');

INSERT INTO Animal (id_animal, nome_animal, sexo, data_nascimento, peso, especie, CPF_tutor)  
    VALUES (sequence_animal.NEXTVAL, 'Luna', 'F', TO_DATE('2021-01-15', 'YYYY-MM-DD'), 10.2, 'Cachorro (Poodle)', '11111111101');

INSERT INTO Animal (id_animal, nome_animal, sexo, data_nascimento, peso, especie, CPF_tutor)  
    VALUES (sequence_animal.NEXTVAL, 'Simba', 'M', TO_DATE('2019-11-01', 'YYYY-MM-DD'), 4.5, 'Gato (SRD)', '11111111102');

INSERT INTO Animal (id_animal, nome_animal, sexo, data_nascimento, peso, especie, CPF_tutor)  
    VALUES (sequence_animal.NEXTVAL, 'Bella', 'F', TO_DATE('2022-03-20', 'YYYY-MM-DD'), 3.8, 'Gato (Siamês)', '11111111103');

INSERT INTO Animal (id_animal, nome_animal, sexo, data_nascimento, peso, especie, CPF_tutor)  
    VALUES (sequence_animal.NEXTVAL, 'Max', 'M', TO_DATE('2018-07-30', 'YYYY-MM-DD'), 25.0, 'Cachorro (Golden)', '11111111104');

INSERT INTO Animal (id_animal, nome_animal, sexo, data_nascimento, peso, especie, CPF_tutor)  
    VALUES (sequence_animal.NEXTVAL, 'Rocky', 'M', TO_DATE('2021-06-12', 'YYYY-MM-DD'), 8.0, 'Cachorro (Bulldog)', '11111111104');

INSERT INTO Animal (id_animal, nome_animal, sexo, data_nascimento, peso, especie, CPF_tutor)  
    VALUES (sequence_animal.NEXTVAL, 'Cacau', 'F', TO_DATE('2022-08-01', 'YYYY-MM-DD'), 7.5, 'Cachorro (Shih-tzu)', '11111111104');

INSERT INTO Animal (id_animal, nome_animal, sexo, data_nascimento, peso, especie, CPF_tutor)  
    VALUES (sequence_animal.NEXTVAL, 'Mia', 'F', TO_DATE('2020-02-14', 'YYYY-MM-DD'), 4.0, 'Gato (Persa)', '11111111105');

INSERT INTO Animal (id_animal, nome_animal, sexo, data_nascimento, peso, especie, CPF_tutor)  
    VALUES (sequence_animal.NEXTVAL, 'Oliver', 'M', TO_DATE('2020-02-14', 'YYYY-MM-DD'), 4.2, 'Gato (Persa)', '11111111105');

INSERT INTO Animal (id_animal, nome_animal, sexo, data_nascimento, peso, especie, CPF_tutor)  
    VALUES (sequence_animal.NEXTVAL, 'Zeus', 'M', TO_DATE('2017-04-05', 'YYYY-MM-DD'), 30.0, 'Cachorro (Rottweiler)', '11111111102');

INSERT INTO Alergia_Tipo (id_alergia, descricao)  
    VALUES (sequence_alergia.NEXTVAL, 'Alergia a Picada de Pulga (DAPP)');

INSERT INTO Alergia_Tipo (id_alergia, descricao)  
    VALUES (sequence_alergia.NEXTVAL, 'Alergia Alimentar (Frango)');

INSERT INTO Alergia_Tipo (id_alergia, descricao)  
    VALUES (sequence_alergia.NEXTVAL, 'Alergia Alimentar (Grãos)');

INSERT INTO Alergia_Tipo (id_alergia, descricao)  
    VALUES (sequence_alergia.NEXTVAL, 'Dermatite Atópica (Ambiental)');

INSERT INTO Alergia_Tipo (id_alergia, descricao)  
    VALUES (sequence_alergia.NEXTVAL, 'Alergia a Pólen');

INSERT INTO Alergia_Tipo (id_alergia, descricao)  
    VALUES (sequence_alergia.NEXTVAL, 'Alergia a Ácaros');

INSERT INTO Alergia_Tipo (id_alergia, descricao)  
    VALUES (sequence_alergia.NEXTVAL, 'Alergia a Produtos de Limpeza');

INSERT INTO Alergia_Tipo (id_alergia, descricao)  
    VALUES (sequence_alergia.NEXTVAL, 'Hipersensibilidade a Dipirona');

INSERT INTO Alergia_Tipo (id_alergia, descricao)  
    VALUES (sequence_alergia.NEXTVAL, 'Hipersensibilidade a Ivermectina');

INSERT INTO Alergia_Tipo (id_alergia, descricao)  
    VALUES (sequence_alergia.NEXTVAL, 'Alergia de Contato (Plástico)');

INSERT INTO Alergias (id_animal, id_alergia)  
    VALUES (1, 1);

INSERT INTO Alergias (id_animal, id_alergia)  
    VALUES (1, 2);

INSERT INTO Alergias (id_animal, id_alergia)  
    VALUES (2, 4);

INSERT INTO Alergias (id_animal, id_alergia)  
    VALUES (3, 7);

INSERT INTO Alergias (id_animal, id_alergia)  
    VALUES (5, 3);

INSERT INTO Alergias (id_animal, id_alergia)  
    VALUES (6, 9);

INSERT INTO Alergias (id_animal, id_alergia)  
    VALUES (7, 1);

INSERT INTO Alergias (id_animal, id_alergia)  
    VALUES (8, 5);

INSERT INTO Alergias (id_animal, id_alergia)  
    VALUES (10, 8);

INSERT INTO Servico (Id_servico, Descricao, Tipo_servico, Preco, especie_alvo)  
    VALUES (sequence_servico.NEXTVAL, 'Consulta Clínica Geral', 'Consulta', 180.00, 'Cachorro/Gato');

INSERT INTO Servico (Id_servico, Descricao, Tipo_servico, Preco, especie_alvo)  
    VALUES (sequence_servico.NEXTVAL, 'Consulta Dermatológica', 'Consulta', 250.00, 'Cachorro/Gato');

INSERT INTO Servico (Id_servico, Descricao, Tipo_servico, Preco, especie_alvo)  
    VALUES (sequence_servico.NEXTVAL, 'Consulta Cardiológica + Eco', 'Exame', 450.00, 'Cachorro');

INSERT INTO Servico (Id_servico, Descricao, Tipo_servico, Preco, especie_alvo)  
    VALUES (sequence_servico.NEXTVAL, 'Banho e Tosa (Porte P)', 'Estética', 80.00, 'Cachorro');

INSERT INTO Servico (Id_servico, Descricao, Tipo_servico, Preco, especie_alvo)  
    VALUES (sequence_servico.NEXTVAL, 'Banho (Gato Pelo Curto)', 'Estética', 90.00, 'Gato');

INSERT INTO Servico (Id_servico, Descricao, Tipo_servico, Preco, especie_alvo)  
    VALUES (sequence_servico.NEXTVAL, 'Aplicação de Vacina (V10)', 'Vacinação', 120.00, 'Cachorro');

INSERT INTO Servico (Id_servico, Descricao, Tipo_servico, Preco, especie_alvo)  
    VALUES (sequence_servico.NEXTVAL, 'Aplicação de Vacina (V5)', 'Vacinação', 140.00, 'Gato');

INSERT INTO Servico (Id_servico, Descricao, Tipo_servico, Preco, especie_alvo)  
    VALUES (sequence_servico.NEXTVAL, 'Castração (Felina Fêmea)', 'Cirurgia', 800.00, 'Gato');

INSERT INTO Servico (Id_servico, Descricao, Tipo_servico, Preco, especie_alvo)  
    VALUES (sequence_servico.NEXTVAL, 'Castração (Canina Macho P)', 'Cirurgia', 600.00, 'Cachorro');

INSERT INTO Servico (Id_servico, Descricao, Tipo_servico, Preco, especie_alvo)  
    VALUES (sequence_servico.NEXTVAL, 'Hemograma Completo', 'Exame', 90.00, 'Cachorro/Gato');

INSERT INTO Atendimento (Id_atendimento, Data_hora_inicio, Data_hora_fim, Status_agendamento, id_servico, id_animal, CPF_veterinario) 
    VALUES (sequence_atendimento.NEXTVAL, TO_TIMESTAMP('2025-11-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-11-01 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Concluído', 1, 1, '11111111106');

INSERT INTO Atendimento (Id_atendimento, Data_hora_inicio, Data_hora_fim, Status_agendamento, id_servico, id_animal, CPF_veterinario) 
    VALUES (sequence_atendimento.NEXTVAL, TO_TIMESTAMP('2025-11-01 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-11-01 11:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'Concluído', 2, 2, '11111111107');

INSERT INTO Atendimento (Id_atendimento, Data_hora_inicio, Data_hora_fim, Status_agendamento, id_servico, id_animal, CPF_veterinario) 
    VALUES (sequence_atendimento.NEXTVAL, TO_TIMESTAMP('2025-11-01 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-11-01 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Concluído', 5, 3, '11111111109');

INSERT INTO Atendimento (Id_atendimento, Data_hora_inicio, Data_hora_fim, Status_agendamento, id_servico, id_animal, CPF_veterinario) 
    VALUES (sequence_atendimento.NEXTVAL, TO_TIMESTAMP('2025-11-01 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-11-01 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Concluído', 10, 4, '11111111106');

INSERT INTO Atendimento (Id_atendimento, Data_hora_inicio, Data_hora_fim, Status_agendamento, id_servico, id_animal, CPF_veterinario) 
    VALUES (sequence_atendimento.NEXTVAL, TO_TIMESTAMP('2025-11-01 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-11-01 15:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Concluído', 6, 5, '11111111109');

INSERT INTO Atendimento (Id_atendimento, Data_hora_inicio, Data_hora_fim, Status_agendamento, id_servico, id_animal, CPF_veterinario) 
    VALUES (sequence_atendimento.NEXTVAL, TO_TIMESTAMP('2025-11-02 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-11-02 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Concluído', 9, 6, '11111111108');

INSERT INTO Atendimento (Id_atendimento, Data_hora_inicio, Data_hora_fim, Status_agendamento, id_servico, id_animal, CPF_veterinario) 
    VALUES (sequence_atendimento.NEXTVAL, TO_TIMESTAMP('2025-11-02 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-11-02 10:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Concluído', 1, 7, '11111111106');

INSERT INTO Atendimento (Id_atendimento, Data_hora_inicio, Data_hora_fim, Status_agendamento, id_servico, id_animal, CPF_veterinario)  
    VALUES (sequence_atendimento.NEXTVAL, TO_TIMESTAMP('2025-11-02 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-11-02 11:20:00', 'YYYY-MM-DD HH24:MI:SS'), 'Concluído', 7, 8, '11111111109');

INSERT INTO Atendimento (Id_atendimento, Data_hora_inicio, Data_hora_fim, Status_agendamento, id_servico, id_animal, CPF_veterinario)  
    VALUES (sequence_atendimento.NEXTVAL, TO_TIMESTAMP('2025-11-02 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-11-02 12:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Concluído', 3, 10, '11111111110');

INSERT INTO Atendimento (Id_atendimento, Data_hora_inicio, Data_hora_fim, Status_agendamento, id_servico, id_animal, CPF_veterinario) 
    VALUES (sequence_atendimento.NEXTVAL, TO_TIMESTAMP('2025-11-03 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), NULL, 'Agendado', 8, 9, '11111111108');

INSERT INTO Medicamento (id_medicamento, nome_medicamento, validade, qtd_em_estoque, especie_alvo, preco) 
    VALUES (sequence_medicamento.NEXTVAL, 'Amoxicilina 250mg', TO_DATE('2026-12-31', 'YYYY-MM-DD'), 100, 'Cachorro/Gato', 45.50);

INSERT INTO Medicamento (id_medicamento, nome_medicamento, validade, qtd_em_estoque, especie_alvo, preco) 
    VALUES (sequence_medicamento.NEXTVAL, 'Dipirona Gotas 500mg/ml', TO_DATE('2027-05-30', 'YYYY-MM-DD'), 250, 'Cachorro', 22.00);

INSERT INTO Medicamento (id_medicamento, nome_medicamento, validade, qtd_em_estoque, especie_alvo, preco) 
    VALUES (sequence_medicamento.NEXTVAL, 'Meloxicam 0,5mg', TO_DATE('2026-08-15', 'YYYY-MM-DD'), 80, 'Gato', 75.00);

INSERT INTO Medicamento (id_medicamento, nome_medicamento, validade, qtd_em_estoque, especie_alvo, preco) 
    VALUES (sequence_medicamento.NEXTVAL, 'Prednisolona 5mg', TO_DATE('2027-01-01', 'YYYY-MM-DD'), 120, 'Cachorro/Gato', 60.00);

INSERT INTO Medicamento (id_medicamento, nome_medicamento, validade, qtd_em_estoque, especie_alvo, preco) 
    VALUES (sequence_medicamento.NEXTVAL, 'Bravecto (10-20kg)', TO_DATE('2027-10-01', 'YYYY-MM-DD'), 50, 'Cachorro', 180.00);

INSERT INTO Medicamento (id_medicamento, nome_medicamento, validade, qtd_em_estoque, especie_alvo, preco) 
    VALUES (sequence_medicamento.NEXTVAL, 'Apoquel 3.6mg', TO_DATE('2027-07-01', 'YYYY-MM-DD'), 30, 'Cachorro', 220.00);

INSERT INTO Medicamento (id_medicamento, nome_medicamento, validade, qtd_em_estoque, especie_alvo, preco) 
    VALUES (sequence_medicamento.NEXTVAL, 'Drontal Gatos (até 4kg)', TO_DATE('2028-02-01', 'YYYY-MM-DD'), 200, 'Gato', 40.00);

INSERT INTO Medicamento (id_medicamento, nome_medicamento, validade, qtd_em_estoque, especie_alvo, preco) 
    VALUES (sequence_medicamento.NEXTVAL, 'Shampoo Clorexidina', TO_DATE('2026-06-01', 'YYYY-MM-DD'), 70, 'Cachorro/Gato', 95.00);

INSERT INTO Medicamento (id_medicamento, nome_medicamento, validade, qtd_em_estoque, especie_alvo, preco) 
    VALUES (sequence_medicamento.NEXTVAL, 'Otomax (Otite)', TO_DATE('2026-02-01', 'YYYY-MM-DD'), 40, 'Cachorro', 110.00);

INSERT INTO Medicamento (id_medicamento, nome_medicamento, validade, qtd_em_estoque, especie_alvo, preco) 
    VALUES (sequence_medicamento.NEXTVAL, 'Fortekor 5mg (Cardíaco)', TO_DATE('2027-03-01', 'YYYY-MM-DD'), 25, 'Cachorro', 130.00);

INSERT INTO Prescricao (id_atendimento, id_medicamento, dose, frequencia, duracao) 
    VALUES (1, 5, '1 comprimido', '24h', '3 meses');

INSERT INTO Prescricao (id_atendimento, id_medicamento, dose, frequencia, duracao) 
    VALUES (2, 6, '1/2 comprimido', '12h', '30 dias');

INSERT INTO Prescricao (id_atendimento, id_medicamento, dose, frequencia, duracao) 
    VALUES (2, 8, '1 banho', 'Semanal', '60 dias');

INSERT INTO Prescricao (id_atendimento, id_medicamento, dose, frequencia, duracao) 
    VALUES (4, 7, '1 comprimido', 'Dose Única', '1 dia');

INSERT INTO Prescricao (id_atendimento, id_medicamento, dose, frequencia, duracao) 
    VALUES (6, 1, '1 comprimido', '12h', '7 dias');

INSERT INTO Prescricao (id_atendimento, id_medicamento, dose, frequencia, duracao) 
    VALUES (6, 2, '5 gotas', '8h', '3 dias');

INSERT INTO Prescricao (id_atendimento, id_medicamento, dose, frequencia, duracao) 
    VALUES (7, 9, '3 gotas', '12h', '10 dias');

INSERT INTO Prescricao (id_atendimento, id_medicamento, dose, frequencia, duracao) 
    VALUES (9, 10, '1 comprimido', '24h', 'Contínuo');

INSERT INTO Prescricao (id_atendimento, id_medicamento, dose, frequencia, duracao) 
    VALUES (9, 2, '15 gotas', 'Se dor', 'N/A');

INSERT INTO Prescricao (id_atendimento, id_medicamento, dose, frequencia, duracao) 
    VALUES (1, 2, '10 gotas', '8h', '3 dias');

INSERT INTO Pagamento (id_pagamento, id_atendimento, valor_total, data_emissao, forma_pagamento, status_pagamento) 
    VALUES (sequence_pagamento.NEXTVAL, 1, 180.00, TO_DATE('2025-11-01', 'YYYY-MM-DD'), 'PIX', 'Pago');

INSERT INTO Pagamento (id_pagamento, id_atendimento, valor_total, data_emissao, forma_pagamento, status_pagamento) 
    VALUES (sequence_pagamento.NEXTVAL, 2, 250.00, TO_DATE('2025-11-01', 'YYYY-MM-DD'), 'Cartão de Crédito', 'Pendente');

INSERT INTO Pagamento (id_pagamento, id_atendimento, valor_total, data_emissao, forma_pagamento, status_pagamento) 
    VALUES (sequence_pagamento.NEXTVAL, 3, 90.00, TO_DATE('2025-11-01', 'YYYY-MM-DD'), 'Cartão de Débito', 'Pago');

INSERT INTO Pagamento (id_pagamento, id_atendimento, valor_total, data_emissao, forma_pagamento, status_pagamento) 
    VALUES (sequence_pagamento.NEXTVAL, 4, 90.00, TO_DATE('2025-11-01', 'YYYY-MM-DD'), 'PIX', 'Pago');

INSERT INTO Pagamento (id_pagamento, id_atendimento, valor_total, data_emissao, forma_pagamento, status_pagamento) 
    VALUES (sequence_pagamento.NEXTVAL, 5, 120.00, TO_DATE('2025-11-01', 'YYYY-MM-DD'), 'Dinheiro', 'Pago');

INSERT INTO Pagamento (id_pagamento, id_atendimento, valor_total, data_emissao, forma_pagamento, status_pagamento) 
    VALUES (sequence_pagamento.NEXTVAL, 6, 600.00, TO_DATE('2025-11-02', 'YYYY-MM-DD'), 'Cartão de Crédito', 'Pendente');

INSERT INTO Pagamento (id_pagamento, id_atendimento, valor_total, data_emissao, forma_pagamento, status_pagamento) 
    VALUES (sequence_pagamento.NEXTVAL, 7, 180.00, TO_DATE('2025-11-02', 'YYYY-MM-DD'), 'PIX', 'Pago');

INSERT INTO Pagamento (id_pagamento, id_atendimento, valor_total, data_emissao, forma_pagamento, status_pagamento) 
    VALUES (sequence_pagamento.NEXTVAL, 8, 140.00, TO_DATE('2025-11-02', 'YYYY-MM-DD'), 'Cartão de Débito', 'Pago');

INSERT INTO Pagamento (id_pagamento, id_atendimento, valor_total, data_emissao, forma_pagamento, status_pagamento) 
    VALUES (sequence_pagamento.NEXTVAL, 9, 450.00, TO_DATE('2025-11-02', 'YYYY-MM-DD'), 'Boleto', 'Pendente');

INSERT INTO Pagamento (id_pagamento, id_atendimento, valor_total, data_emissao, forma_pagamento, status_pagamento) 
    VALUES (sequence_pagamento.NEXTVAL, 10, 800.00, TO_DATE('2025-11-03', 'YYYY-MM-DD'), 'Pendente', 'Agendado');

INSERT INTO Parcela_Pagamento (id_pagamento, nr_parcela, valor_parcela, data_vencimento, data_pagamento) 
    VALUES (1, 1, 180.00, TO_DATE('2025-11-01', 'YYYY-MM-DD'), TO_DATE('2025-11-01', 'YYYY-MM-DD'));

INSERT INTO Parcela_Pagamento (id_pagamento, nr_parcela, valor_parcela, data_vencimento, data_pagamento) 
    VALUES (2, 1, 125.00, TO_DATE('2025-12-01', 'YYYY-MM-DD'), NULL);

INSERT INTO Parcela_Pagamento (id_pagamento, nr_parcela, valor_parcela, data_vencimento, data_pagamento) 
    VALUES (2, 2, 125.00, TO_DATE('2026-01-01', 'YYYY-MM-DD'), NULL);

INSERT INTO Parcela_Pagamento (id_pagamento, nr_parcela, valor_parcela, data_vencimento, data_pagamento) 
    VALUES (3, 1, 90.00, TO_DATE('2025-11-01', 'YYYY-MM-DD'), TO_DATE('2025-11-01', 'YYYY-MM-DD'));

INSERT INTO Parcela_Pagamento (id_pagamento, nr_parcela, valor_parcela, data_vencimento, data_pagamento) 
    VALUES (4, 1, 90.00, TO_DATE('2025-11-01', 'YYYY-MM-DD'), TO_DATE('2025-11-01', 'YYYY-MM-DD'));

INSERT INTO Parcela_Pagamento (id_pagamento, nr_parcela, valor_parcela, data_vencimento, data_pagamento) 
    VALUES (5, 1, 120.00, TO_DATE('2025-11-01', 'YYYY-MM-DD'), TO_DATE('2025-11-01', 'YYYY-MM-DD'));

INSERT INTO Parcela_Pagamento (id_pagamento, nr_parcela, valor_parcela, data_vencimento, data_pagamento) 
    VALUES (6, 1, 200.00, TO_DATE('2025-12-02', 'YYYY-MM-DD'), NULL);

INSERT INTO Parcela_Pagamento (id_pagamento, nr_parcela, valor_parcela, data_vencimento, data_pagamento) 
    VALUES (6, 2, 200.00, TO_DATE('2026-01-02', 'YYYY-MM-DD'), NULL);

INSERT INTO Parcela_Pagamento (id_pagamento, nr_parcela, valor_parcela, data_vencimento, data_pagamento) 
    VALUES (6, 3, 200.00, TO_DATE('2026-02-02', 'YYYY-MM-DD'), NULL);

INSERT INTO Parcela_Pagamento (id_pagamento, nr_parcela, valor_parcela, data_vencimento, data_pagamento) 
    VALUES (7, 1, 180.00, TO_DATE('2025-11-02', 'YYYY-MM-DD'), TO_DATE('2025-11-02', 'YYYY-MM-DD'));

INSERT INTO Parcela_Pagamento (id_pagamento, nr_parcela, valor_parcela, data_vencimento, data_pagamento) 
    VALUES (8, 1, 140.00, TO_DATE('2025-11-02', 'YYYY-MM-DD'), TO_DATE('2025-11-02', 'YYYY-MM-DD'));

INSERT INTO Parcela_Pagamento (id_pagamento, nr_parcela, valor_parcela, data_vencimento, data_pagamento) 
    VALUES (9, 1, 450.00, TO_DATE('2025-11-10', 'YYYY-MM-DD'), NULL);

INSERT INTO Parcela_Pagamento (id_pagamento, nr_parcela, valor_parcela, data_vencimento, data_pagamento) 
    VALUES (10, 1, 200.00, TO_DATE('2025-11-10', 'YYYY-MM-DD'), NULL);

INSERT INTO Parcela_Pagamento (id_pagamento, nr_parcela, valor_parcela, data_vencimento, data_pagamento) 
    VALUES (10, 2, 200.00, TO_DATE('2025-12-10', 'YYYY-MM-DD'), NULL);

INSERT INTO Parcela_Pagamento (id_pagamento, nr_parcela, valor_parcela, data_vencimento, data_pagamento) 
    VALUES (10, 3, 200.00, TO_DATE('2026-01-10', 'YYYY-MM-DD'), NULL);

INSERT INTO Parcela_Pagamento (id_pagamento, nr_parcela, valor_parcela, data_vencimento, data_pagamento) 
    VALUES (10, 4, 200.00, TO_DATE('2026-02-10', 'YYYY-MM-DD'), NULL);

COMMIT;

