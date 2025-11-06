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

--DELETE

DELETE FROM Telefones
WHERE CPF_pessoa = '11111111101' 
  AND Numero_telefone = '8133331101';

DELETE FROM Telefones
WHERE CPF_pessoa = '11111111105' 
  AND Numero_telefone = '8133331105';

DELETE FROM Telefones
WHERE CPF_pessoa = '11111111110' 
  AND Numero_telefone = '8133331110';

--SELECT-FROM-WHERE

SELECT * FROM PESSOA
WHERE CPF = '11111111111'

SELECT * FROM ENDERECO
WHERE codigo_endereco = 11

SELECT * FROM Telefones
WHERE CPF_pessoa = '11111111111'

SELECT * FROM Tutor
WHERE CPF_tutor = '11111111111'

SELECT * FROM ANIMAL
WHERE id_animal = 11


SELECT * FROM Atendimento
WHERE id_animal = 11

--BETWEEN   

SELECT Descricao, Preco
FROM Servico
WHERE Preco BETWEEN 100.00 AND 300.00;

SELECT nome_animal, data_nascimento
FROM Animal
WHERE data_nascimento BETWEEN TO_DATE('2020-01-01', 'YYYY-MM-DD') AND TO_DATE('2021-12-31', 'YYYY-MM-DD');

SELECT Id_atendimento, id_animal, Data_hora_inicio
FROM Atendimento
WHERE Data_hora_inicio BETWEEN TO_TIMESTAMP('2025-11-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS') AND TO_TIMESTAMP('2025-11-01 23:59:59', 'YYYY-MM-DD HH24:MI:SS');

--IN

SELECT Id_servico, Descricao, Preco
FROM Servico
WHERE Id_servico IN (1, 8, 10);

SELECT nome, email
FROM Pessoa
WHERE CPF IN (
    SELECT CPF_tutor
    FROM Tutor
    WHERE status_tutor = 'Ativo');

SELECT nome, email
FROM Pessoa
WHERE CPF IN (
    SELECT CPF_tutor
    FROM Tutor
    WHERE status_tutor = 'Inativo');

--LIKE

SELECT nome_animal, especie
FROM Animal
WHERE especie LIKE 'Cachorro%';

SELECT Descricao, Preco
FROM Servico
WHERE Descricao LIKE '%Castração%';

SELECT nome_animal
FROM Animal
WHERE nome_animal LIKE '____';

--IS NULL / IS NOT NULL

SELECT Id_atendimento, Status_agendamento, Data_hora_inicio
FROM Atendimento
WHERE Data_hora_fim IS NULL;

SELECT id_pagamento, nr_parcela, valor_parcela, data_pagamento
FROM Parcela_Pagamento
WHERE data_pagamento IS NOT NULL;

SELECT Id_atendimento, Status_agendamento, Data_hora_inicio, Data_hora_fim
FROM Atendimento
WHERE Data_hora_fim IS NOT NULL;

-- INNER JOIN

SELECT
    a.nome_animal,
    a.especie,
    p.nome AS nome_tutor
FROM Animal a
INNER JOIN Tutor t ON a.CPF_tutor = t.CPF_tutor
INNER JOIN Pessoa p ON t.CPF_tutor = p.CPF;

SELECT
    att.Id_atendimento,
    s.Descricao,
    s.Preco
FROM Atendimento att
INNER JOIN Servico s ON att.id_servico = s.Id_servico;

SELECT
    att.Data_hora_inicio,
    a.nome_animal,
    p.nome AS nome_veterinario
FROM Atendimento att
INNER JOIN Animal a ON att.id_animal = a.id_animal
INNER JOIN Veterinario v ON att.CPF_veterinario = v.CPF_veterinario
INNER JOIN Pessoa p ON v.CPF_veterinario = p.CPF;

-- MAX e MIN

SELECT
    Descricao,
    Preco
FROM Servico
WHERE Preco = (SELECT MAX(Preco) FROM Servico);

SELECT
    nome_animal,
    especie,
    peso
FROM Animal
WHERE peso = (SELECT MIN(peso) FROM Animal);

SELECT
    MIN(data_nascimento) AS Animal_Mais_Velho,
    MAX(data_nascimento) AS Animal_Mais_Novo
FROM Animal;

--- AVG
-- Preço médio dos serviços
SELECT ROUND(AVG(Preco), 2) AS preco_medio
FROM Servico;

-- Preço médio dos medicamentos
SELECT ROUND(AVG(preco), 2) AS preco_medio_medicamento
FROM Medicamento;

-- Peso médio dos animais
SELECT ROUND(AVG(peso), 2) AS peso_medio_animais
FROM Animal;

-- COUNT

-- Total de atendimentos
SELECT COUNT(*) AS total_atendimentos
FROM Atendimento;

-- Quantidade de espécies distintas
SELECT COUNT(DISTINCT especie) AS qtde_especies
FROM Animal;


-- LEFT / RIGHT / FULL OUTER JOIN

-- LEFT JOIN: Animais com suas alergias
SELECT a.id_animal, a.nome_animal, atp.descricao AS alergia
FROM Animal a
LEFT JOIN Alergias al     ON al.id_animal = a.id_animal
LEFT JOIN Alergia_Tipo atp ON atp.id_alergia = al.id_alergia;

-- FULL OUTER JOIN: Atendimentos e Pagamentos
SELECT COALESCE(a.Id_atendimento, p.id_atendimento) AS id_referencia,
       a.Id_atendimento AS atendimento,
       p.id_pagamento AS pagamento
FROM Atendimento a
FULL OUTER JOIN Pagamento p
  ON p.id_atendimento = a.Id_atendimento;


-- SUBCONSULTA COM OPERADOR RELACIONAL

-- Serviços mais caros que a média geral
SELECT Id_servico, Descricao, Preco
FROM Servico
WHERE Preco > (SELECT AVG(Preco) FROM Servico);


-- 18) SUBCONSULTA COM IN

-- Pessoas que são tutores ATIVOS
SELECT CPF, nome, email
FROM Pessoa
WHERE CPF IN (
  SELECT CPF_tutor
  FROM Tutor
  WHERE status_tutor = 'Ativo'
);


-- SUBCONSULTA COM ANY

-- Pagamentos maiores que QUALQUER pagamento feito via PIX
SELECT id_pagamento, valor_total
FROM Pagamento
WHERE valor_total > ANY (
  SELECT valor_total
  FROM Pagamento
  WHERE forma_pagamento = 'PIX'
);



-- SUBCONSULTA COM ALL

-- Serviços mais caros do que TODOS os serviços da categoria 'Estética'
SELECT Id_servico, Descricao, Preco
FROM Servico
WHERE Preco > ALL (
  SELECT Preco
  FROM Servico
  WHERE Tipo_servico = 'Estética'
);

-- ORDER BY

-- Ordenar animais por espécie (A-Z) e dentro da espécie por peso (maior → menor)
SELECT nome_animal, especie, peso
FROM Animal
ORDER BY especie ASC, peso DESC;

-- GROUP BY

-- Ticket médio por forma de pagamento
SELECT forma_pagamento,
       ROUND(AVG(valor_total), 2) AS ticket_medio
FROM Pagamento
GROUP BY forma_pagamento
ORDER BY ticket_medio DESC;

-- HAVING

-- Tipos de serviço com média de preço >= 200
SELECT Tipo_servico,
       ROUND(AVG(Preco), 2) AS preco_medio
FROM Servico
GROUP BY Tipo_servico
HAVING AVG(Preco) >= 200
ORDER BY preco_medio DESC;

-- UNION / INTERSECT / MINUS

-- CPFs que são tutores OU veterinários
SELECT CPF_tutor AS cpf FROM Tutor
UNION
SELECT CPF_veterinario FROM Veterinario;

-- CPFs que existem em Pessoa E Veterinario
SELECT CPF FROM Pessoa
INTERSECT
SELECT CPF_veterinario FROM Veterinario;

-- Pessoas que NÃO são tutores
SELECT CPF FROM Pessoa
MINUS
SELECT CPF_tutor FROM Tutor;
-
-- CREATE VIEW

-- View de ticket médio agrupado por espécie de animal
CREATE OR REPLACE VIEW vw_ticket_medio_por_especie AS
SELECT an.especie,
       ROUND(AVG(p.valor_total), 2) AS ticket_medio
FROM Pagamento p
JOIN Atendimento a ON a.Id_atendimento = p.id_atendimento
JOIN Animal an     ON an.id_animal     = a.id_animal
GROUP BY an.especie;

-- Como usar a view:
-- SELECT * FROM vw_ticket_medio_por_especie ORDER BY ticket_medio DESC;

-- GRANT / REVOKE (Explicação)

-- GRANT: dá permissão a outro usuário
-- EXEMPLO:
-- GRANT SELECT ON vw_ticket_medio_por_especie TO ANALISTA;

-- REVOKE: remove permissão
-- EXEMPLO:
-- REVOKE SELECT ON vw_ticket_medio_por_especie FROM ANALISTA;
