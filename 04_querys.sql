-- ALTER TABLE
ALTER TABLE ANIMAL
ADD ALTURA float;

ALTER TABLE PESSOA
ADD SEXO varchar;

ALTER TABLE PESSOA
ADD DATA_NASCIMENTO DATE;

-- CREATE INDEX
CREATE INDEX IDX_DATA_NASCIMENTO_PESSOA
ON PESSOA (DATA_NASCIMENTO);

CREATE INDEX IDX_SEXO_PESSOA
ON PESSOA (SEXO);

-- INSERT INTO
INSERT INTO Endereco (codigo_endereco, logradouro, bairro, UF, numero, cep) VALUES (sequence_endereco.NEXTVAL, 'Rua Otaviano Pereira', 'Centro', 'PE', '149', '55805000');
INSERT INTO PESSOA (CPF, NOME, EMAIL, ENDERECO, SEXO, DATA_NASCIMENTO) VALUES ('11111111111', 'João Lucas Tavares', 'Joao.Tavares@email.com', 11, 'M', '2006-04-07');
INSERT INTO Telefones (CPF_pessoa, Numero_telefone) VALUES ('11111111111', '81999991111');
INSERT INTO Tutor (CPF_tutor, data_cadastro, status_tutor, observacoes) VALUES ('11111111111', TO_DATE('2025-11-04', 'YYYY-MM-DD'), 'Ativo', 'Cliente novo, 1 animal');
INSERT INTO Animal (id_animal, nome_animal, sexo, data_nascimento, peso, especie, CPF_tutor) VALUES (sequence_animal.NEXTVAL, 'Lampião', 'M', TO_DATE('2020-10-15', 'YYYY-MM-DD'), 10, 'Cachorro (Salsicha)', '11111111111');
INSERT INTO Atendimento (Id_atendimento, Data_hora_inicio, Data_hora_fim, Status_agendamento, id_servico, id_animal, CPF_veterinario) VALUES (sequence_atendimento.NEXTVAL, TO_TIMESTAMP('2025-11-05 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2025-11-05 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Concluído', 4, 11, '11111111107');



