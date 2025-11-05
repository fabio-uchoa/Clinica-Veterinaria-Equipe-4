-- ALTER TABLE
ALTER TABLE ANIMAL
ADD ALTURA float;

ALTER TABLE PESSOA
ADD SEXO varchar(1);

ALTER TABLE PESSOA
ADD DATA_NASCIMENTO DATE;

-- CREATE INDEX
CREATE INDEX IDX_DATA_NASCIMENTO_PESSOA
ON PESSOA (DATA_NASCIMENTO);

CREATE INDEX IDX_SEXO_PESSOA
ON PESSOA (SEXO);

-- INSERT INTO
INSERT INTO Endereco (codigo_endereco, logradouro, bairro, UF, numero, cep) VALUES (sequence_endereco.NEXTVAL, 'Rua Otaviano Pereira', 'Centro', 'PE', '149', '55805000');
INSERT INTO PESSOA (CPF, NOME, EMAIL, ENDERECO, SEXO, DATA_NASCIMENTO) VALUES ('11111111111', 'João Lucas Tavares', 'Joao.Tavares@email.com', 11, 'M', TO_DATE('2006-04-07', 'YYYY-MM-DD'));
INSERT INTO Telefones (CPF_pessoa, Numero_telefone) VALUES ('11111111111', '81999991111');
INSERT INTO Tutor (CPF_tutor, data_cadastro, status_tutor, observacoes) VALUES ('11111111111', TO_DATE('2025-11-04', 'YYYY-MM-DD'), 'Ativo', 'Cliente novo, 1 animal');
INSERT INTO Animal (id_animal, nome_animal, sexo, data_nascimento, peso, especie, CPF_tutor) VALUES (sequence_animal.NEXTVAL, 'Lampião', 'M', TO_DATE('2020-10-15', 'YYYY-MM-DD'), 10, 'Cachorro (Salsicha)', '11111111111');
INSERT INTO Atendimento (Id_atendimento, Data_hora_inicio, Data_hora_fim, Status_agendamento, id_servico, id_animal, CPF_veterinario) VALUES (sequence_atendimento.NEXTVAL, TO_TIMESTAMP('2025-11-05 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-11-05 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Concluído', 4, 11, '11111111107');

-- UPDATE

UPDATE Pessoa
SET sexo = 'F', data_nascimento = TO_DATE('1990-05-15', 'YYYY-MM-DD')
WHERE CPF = '11111111101'; 

UPDATE Pessoa
SET sexo = 'M', data_nascimento = TO_DATE('1988-11-20', 'YYYY-MM-DD')
WHERE CPF = '11111111102';

UPDATE Pessoa
SET sexo = 'F', data_nascimento = TO_DATE('1995-02-10', 'YYYY-MM-DD')
WHERE CPF = '11111111103';

UPDATE Pessoa
SET sexo = 'M', data_nascimento = TO_DATE('1992-09-30', 'YYYY-MM-DD')
WHERE CPF = '11111111104';

UPDATE Pessoa
SET sexo = 'F', data_nascimento = TO_DATE('1985-07-07', 'YYYY-MM-DD')
WHERE CPF = '11111111105';

UPDATE Pessoa
SET sexo = 'M', data_nascimento = TO_DATE('1980-01-25', 'YYYY-MM-DD')
WHERE CPF = '11111111106'; 

UPDATE Pessoa
SET sexo = 'F', data_nascimento = TO_DATE('1983-03-12', 'YYYY-MM-DD')
WHERE CPF = '11111111107'; 

UPDATE Pessoa
SET sexo = 'M', data_nascimento = TO_DATE('1975-10-05', 'YYYY-MM-DD')
WHERE CPF = '11111111108'; 

UPDATE Pessoa
SET sexo = 'F', data_nascimento = TO_DATE('1990-12-01', 'YYYY-MM-DD')
WHERE CPF = '11111111109'; 

UPDATE Pessoa
SET sexo = 'M', data_nascimento = TO_DATE('1993-06-18', 'YYYY-MM-DD')
WHERE CPF = '11111111110'; 


UPDATE Animal SET altura = 0.40 WHERE id_animal = 1;
UPDATE Animal SET altura = 0.35 WHERE id_animal = 2; 
UPDATE Animal SET altura = 0.25 WHERE id_animal = 3;  
UPDATE Animal SET altura = 0.23 WHERE id_animal = 4;  
UPDATE Animal SET altura = 0.60 WHERE id_animal = 5; 
UPDATE Animal SET altura = 0.38 WHERE id_animal = 6;  
UPDATE Animal SET altura = 0.27 WHERE id_animal = 7;  
UPDATE Animal SET altura = 0.24 WHERE id_animal = 8;  
UPDATE Animal SET altura = 0.25 WHERE id_animal = 9;  
UPDATE Animal SET altura = 0.65 WHERE id_animal = 10; 
UPDATE Animal SET altura = 0.22 WHERE id_animal = 11;
