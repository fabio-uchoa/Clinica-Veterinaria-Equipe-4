-- BLOCO ANÔNIMO
-- %TYPE
-- SELECT ... INTO
-- IF ELSIF
-- EXCEPTION WHEN
DECLARE
  v_nome_animal   ANIMAL.NOME_ANIMAL%TYPE;
  v_peso_animal   ANIMAL.PESO%TYPE;
  v_classificacao VARCHAR2(100);
  v_id_animal     ANIMAL.ID_ANIMAL%TYPE := 1;
BEGIN
  
  -- Uso de SELECT ... INTO
  SELECT NOME_ANIMAL, PESO
  INTO v_nome_animal, v_peso_animal
  FROM ANIMAL
  WHERE ID_ANIMAL = v_id_animal;

  -- Uso de IF ELSIF
  IF v_peso_animal > 30 THEN
    v_classificacao := 'Porte Grande';
  ELSIF v_peso_animal > 10 THEN
    v_classificacao := 'Porte Médio';
  ELSE
    v_classificacao := 'Porte Pequeno';
  END IF;

EXCEPTION -- Uso de EXCEPTION WHEN
  WHEN NO_DATA_FOUND THEN
    v_classificacao := 'Animal não encontrado'; 
  WHEN OTHERS THEN
    v_classificacao := 'Erro inesperado';
END;
/


-- CREATE PROCEDURE
-- USO DE PARÂMETROS (IN, OUT OU IN OUT)
CREATE OR REPLACE PROCEDURE sp_atualizar_status_tutor (
  p_cpf_tutor   IN  TUTOR.CPF_TUTOR%TYPE,       -- Parâmetro IN (Entrada)
  p_novo_status IN  TUTOR.STATUS_TUTOR%TYPE,    -- Parâmetro IN (Entrada)
  p_status_antigo OUT TUTOR.STATUS_TUTOR%TYPE   -- Parâmetro OUT (Saída)
)
IS
BEGIN
  -- Busca o status antigo para retornar no parâmetro OUT
  SELECT STATUS_TUTOR
  INTO p_status_antigo
  FROM TUTOR
  WHERE CPF_TUTOR = p_cpf_tutor;

  -- Atualiza o status
  UPDATE TUTOR
  SET STATUS_TUTOR = p_novo_status
  WHERE CPF_TUTOR = p_cpf_tutor;
  
  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    p_status_antigo := NULL; -- Define a saída como nula se não encontrar
END;
/


-- CREATE FUNCTION
CREATE OR REPLACE FUNCTION fn_buscar_nome_pessoa (
  p_cpf IN PESSOA.CPF%TYPE -- Parâmetro IN
)
RETURN PESSOA.NOME%TYPE -- Define o tipo de dado de retorno
IS
  v_nome_retorno PESSOA.NOME%TYPE;
BEGIN
  SELECT NOME
  INTO v_nome_retorno
  FROM PESSOA
  WHERE CPF = p_cpf;
  
  RETURN v_nome_retorno;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN '(Pessoa não encontrada)';
END;
/


-- CURSOR (OPEN, FETCH E CLOSE)
-- %ROWTYPE
-- LOOP EXIT WHEN
DECLARE
  -- Declaração do CURSOR
  CURSOR c_animais_cachorros IS
    SELECT * FROM ANIMAL WHERE ESPECIE LIKE 'Cachorro%';
    
  -- Declaração da variável %ROWTYPE (representa uma linha inteira do cursor)
  v_animal_linha c_animais_cachorros%ROWTYPE;
  v_nome_temp ANIMAL.NOME_ANIMAL%TYPE; -- Variável para lógica interna
BEGIN
  -- OPEN (Abrir o CURSOR)
  OPEN c_animais_cachorros;
  
  -- LOOP EXIT WHEN (Início do LOOP)
  LOOP
    -- FETCH (Buscar dados do CURSOR para a variável)
    FETCH c_animais_cachorros INTO v_animal_linha;
    
    -- Condição de saída (LOOP EXIT WHEN)
    EXIT WHEN c_animais_cachorros%NOTFOUND;
    
    -- Processar a linha (lógica interna sem output)
    v_nome_temp := v_animal_linha.NOME_ANIMAL;
    
  END LOOP;
  
  -- CLOSE (Fechar o CURSOR)
  CLOSE c_animais_cachorros;
END;
/


-- FOR IN LOOP
-- CASE WHEN
BEGIN
  -- O FOR IN LOOP é um cursor implícito (não precisa de OPEN/FETCH/CLOSE)
  -- "rec" é um %ROWTYPE implícito
  FOR rec IN (SELECT DESCRICAO, PRECO FROM SERVICO)
  LOOP
    DECLARE
      v_classificacao VARCHAR2(50);
    BEGIN
      -- Uso de CASE WHEN
      v_classificacao := CASE
        WHEN rec.PRECO > 200 THEN 'Caro'
        WHEN rec.PRECO BETWEEN 100 AND 200 THEN 'Médio'
        ELSE 'Barato'
      END;
      
      NULL;
    END;
  END LOOP;
END;
/


-- USO DE RECORD
-- USO DE ESTRUTURA DE DADOS DO TIPO TABLE
-- WHILE LOOP
DECLARE
  -- Definição do tipo RECORD (uma estrutura customizada)
  TYPE t_registro_contato IS RECORD (
    nome  PESSOA.NOME%TYPE,
    email PESSOA.EMAIL%TYPE
  );
  
  -- Definição do TIPO TABLE (uma lista/array de "t_registro_contato")
  TYPE t_lista_de_contatos IS TABLE OF t_registro_contato
    INDEX BY PLS_INTEGER; -- Indexado por um número
    
  -- Declaração das variáveis
  v_contatos t_lista_de_contatos; -- Nossa "lista"
  v_indice   PLS_INTEGER := 1;
  v_nome_temp PESSOA.NOME%TYPE; -- Variável para lógica interna
BEGIN
  -- Populando nossa lista (TIPO TABLE) com dados (RECORDs)
  FOR p IN (SELECT NOME, EMAIL FROM PESSOA WHERE CPF LIKE '1111111110%')
  LOOP
    v_contatos(v_indice).nome := p.NOME;
    v_contatos(v_indice).email := p.EMAIL;
    v_indice := v_indice + 1;
  END LOOP;

  -- Processando a lista com WHILE LOOP (Exemplo mais robusto)
  v_indice := v_contatos.FIRST; -- Pega o primeiro índice (ex: 1)
  
  WHILE v_indice IS NOT NULL LOOP
    -- Lógica de processamento (sem output)
    v_nome_temp := v_contatos(v_indice).nome;
    
    -- Pega o próximo índice da coleção
    v_indice := v_contatos.NEXT(v_indice); 
  END LOOP;
END;
/


-- Tabela de Log para o próximo exemplo de Trigger
CREATE TABLE LOG_AUDITORIA_ANIMAL (
  ID_LOG      NUMBER GENERATED AS IDENTITY,
  ID_ANIMAL   NUMBER,
  PESO_ANTIGO NUMBER,
  PESO_NOVO   NUMBER,
  DATA_MUDANCA DATE
);
/

-- CREATE OR REPLACE TRIGGER (LINHA)
CREATE OR REPLACE TRIGGER trg_auditoria_peso_animal
BEFORE UPDATE OF PESO ON ANIMAL 
FOR EACH ROW -- Define como um TRIGGER DE LINHA 
WHEN (NEW.PESO IS NOT NULL AND NEW.PESO != OLD.PESO)
BEGIN
  -- OLD e NEW referenciam os valores da linha
  INSERT INTO LOG_AUDITORIA_ANIMAL (ID_ANIMAL, PESO_ANTIGO, PESO_NOVO, DATA_MUDANCA)
  VALUES (:OLD.ID_ANIMAL, :OLD.PESO, :NEW.PESO, SYSDATE);
END;
/


-- CREATE OR REPLACE TRIGGER (COMANDO)
CREATE OR REPLACE TRIGGER trg_bloqueio_delete_servico
BEFORE DELETE ON SERVICO

BEGIN
  RAISE_APPLICATION_ERROR(-20001, 'Exclusão de SERVIÇOS está bloqueada por este Trigger de Comando.');
END;
/

-- CREATE OR REPLACE PACKAGE
-- Esta é a ESPECIFICAÇÃO (Specification)
CREATE OR REPLACE PACKAGE pkg_gerenciamento_petshop AS

  -- Procedure pública para agendar atendimento
  PROCEDURE sp_agendar_atendimento (
    p_id_animal     IN ATENDIMENTO.ID_ANIMAL%TYPE,
    p_id_servico    IN ATENDIMENTO.ID_SERVICO%TYPE,
    p_cpf_vet       IN ATENDIMENTO.CPF_VETERINARIO%TYPE,
    p_data_inicio   IN ATENDIMENTO.DATA_HORA_INICIO%TYPE
  );

  -- Função pública para calcular o faturamento de um veterinário
  FUNCTION fn_faturamento_veterinario (
    p_cpf_vet IN VETERINARIO.CPF_VETERINARIO%TYPE
  ) RETURN NUMBER;

END pkg_gerenciamento_petshop;
/


-- CREATE OR REPLACE PACKAGE BODY
CREATE OR REPLACE PACKAGE BODY pkg_gerenciamento_petshop AS

  -- Implementação da Procedure
  PROCEDURE sp_agendar_atendimento (
    p_id_animal     IN ATENDIMENTO.ID_ANIMAL%TYPE,
    p_id_servico    IN ATENDIMENTO.ID_SERVICO%TYPE,
    p_cpf_vet       IN ATENDIMENTO.CPF_VETERINARIO%TYPE,
    p_data_inicio   IN ATendimento.DATA_HORA_INICIO%TYPE
  )
  IS
    v_data_fim ATENDIMENTO.DATA_HORA_FIM%TYPE;
  BEGIN
    v_data_fim := p_data_inicio + INTERVAL '30' MINUTE;
    
    INSERT INTO ATENDIMENTO (ID_ATENDIMENTO, DATA_HORA_INICIO, DATA_HORA_FIM, STATUS_AGENDAMENTO, ID_SERVICO, ID_ANIMAL, CPF_VETERINARIO)
    VALUES (sequence_atendimento.NEXTVAL, p_data_inicio, v_data_fim, 'Agendado', p_id_servico, p_id_animal, p_cpf_vet);
    
    COMMIT;
  END sp_agendar_atendimento;

  FUNCTION fn_faturamento_veterinario (
    p_cpf_vet IN VETERINARIO.CPF_VETERINARIO%TYPE
  ) RETURN NUMBER
  IS
    v_faturamento_total NUMBER := 0;
  BEGIN
    SELECT SUM(s.PRECO)
    INTO v_faturamento_total
    FROM ATENDIMENTO a
    JOIN SERVICO s ON a.ID_SERVICO = s.ID_SERVICO
    WHERE a.CPF_VETERINARIO = p_cpf_vet
      AND a.STATUS_AGENDAMENTO = 'Concluído';
      
    RETURN NVL(v_faturamento_total, 0);
  END fn_faturamento_veterinario;

END pkg_gerenciamento_petshop;
/