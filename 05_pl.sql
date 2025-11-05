-- Especificação do Pacote (Header)
CREATE OR REPLACE PACKAGE pkg_gestao_atendimento
AS
    -- 5) FUNCTION: Calcula o valor total a receber de parcelas pendentes para um Pagamento.
    FUNCTION fn_valor_pendente (
        p_id_pagamento IN Pagamento.id_pagamento%TYPE -- 6) %TYPE
    )
    RETURN NUMBER;

    -- 4) PROCEDURE: Insere um novo atendimento e registra o sucesso
    PROCEDURE prc_inserir_atendimento_e_log (
        p_data_inicio       IN Atendimento.Data_hora_inicio%TYPE,
        p_status_agendamento IN Atendimento.Status_agendamento%TYPE,
        p_id_servico        IN Atendimento.id_servico%TYPE,
        p_id_animal         IN Atendimento.id_animal%TYPE,
        p_cpf_veterinario   IN Atendimento.CPF_veterinario%TYPE
    );

END pkg_gestao_atendimento;
/

-- Corpo do Pacote
CREATE OR REPLACE PACKAGE BODY pkg_gestao_atendimento
AS
    -- Implementação da FUNCTION
    FUNCTION fn_valor_pendente (
        p_id_pagamento IN Pagamento.id_pagamento%TYPE
    )
    RETURN NUMBER
    IS
        v_total_pendente NUMBER(10, 2);
    BEGIN
        -- 13) SELECT ... INTO
        SELECT
            SUM(valor_parcela) INTO v_total_pendente
        FROM
            Parcela_Pagamento
        WHERE
                id_pagamento = p_id_pagamento
            AND data_pagamento IS NULL; -- Filtra apenas pendente (IS NULL)

        RETURN NVL(v_total_pendente, 0);
    END fn_valor_pendente;

    -- Implementação da PROCEDURE
    PROCEDURE prc_inserir_atendimento_e_log (
        p_data_inicio       IN Atendimento.Data_hora_inicio%TYPE,
        p_status_agendamento IN Atendimento.Status_agendamento%TYPE,
        p_id_servico        IN Atendimento.id_servico%TYPE,
        p_id_animal         IN Atendimento.id_animal%TYPE,
        p_cpf_veterinario   IN Atendimento.CPF_veterinario%TYPE
    )
    IS
        v_id_atendimento Atendimento.Id_atendimento%TYPE;
    BEGIN
        -- Insere o novo atendimento
        v_id_atendimento := sequence_atendimento.NEXTVAL;

        INSERT INTO Atendimento (
            Id_atendimento, Data_hora_inicio, Data_hora_fim, Status_agendamento, id_servico, id_animal, CPF_veterinario
        ) VALUES (
            v_id_atendimento, p_data_inicio, NULL, p_status_agendamento, p_id_servico, p_id_animal, p_cpf_veterinario
        );

        DBMS_OUTPUT.PUT_LINE('INFO: Novo atendimento ' || v_id_atendimento || ' agendado para o animal ' || p_id_animal || '.');

        COMMIT;
    END prc_inserir_atendimento_e_log;

END pkg_gestao_atendimento;
/

-- ==============================================================================
-- 19) CREATE OR REPLACE TRIGGER (COMANDO) - Exemplo: Prevenir DELETE em horários de pico
-- ==============================================================================
CREATE OR REPLACE TRIGGER trg_protecao_dados_horario_pico
BEFORE DELETE ON Pagamento
BEGIN
    -- 8) IF ELSIF
    IF TO_CHAR(SYSDATE, 'HH24') BETWEEN '08' AND '18' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Proibido deletar pagamentos durante o horário comercial (8h-18h) devido à auditoria.');
    END IF;
END;
/

-- ==============================================================================
-- 20) CREATE OR REPLACE TRIGGER (LINHA) - Exemplo: Ajustar status do tutor ao ter um animal
-- ==============================================================================
CREATE OR REPLACE TRIGGER trg_animal_status_tutor
BEFORE INSERT OR UPDATE OF CPF_tutor ON Animal
FOR EACH ROW
BEGIN
    -- Atualiza o status do tutor para 'Ativo' se ele tiver um animal sendo inserido/atualizado
    UPDATE Tutor
    SET status_tutor = 'Ativo'
    WHERE CPF_tutor = :NEW.CPF_tutor;
END;
/


-- ==============================================================================
-- 3) BLOCO ANÔNIMO - Exemplo de Processamento de Dados
-- 1) USO DE RECORD, 2) USO DE ESTRUTURA DE DADOS DO TIPO TABLE (Coleção)
-- 7) %ROWTYPE, 14) CURSOR, 10) LOOP EXIT WHEN, 11) WHILE LOOP, 12) FOR IN LOOP, 15) EXCEPTION WHEN
-- ==============================================================================

SET SERVEROUTPUT ON;

DECLARE
    -- 7) %ROWTYPE
    r_atendimento Atendimento%ROWTYPE;

    -- 6) %TYPE
    v_total_animais NUMBER(3);
    v_total_pagamentos Pagamento.valor_total%TYPE := 0;

    -- 1) USO DE RECORD (Registro customizado)
    TYPE r_info_tutor IS RECORD (
        nome_tutor Pessoa.nome%TYPE,
        cpf_tutor Pessoa.cpf%TYPE
    );
    v_tutor r_info_tutor;

    -- 2) USO DE ESTRUTURA DE DADOS DO TIPO TABLE (Coleção/Array)
    TYPE t_cpf_veterinarios IS TABLE OF Veterinario.CPF_veterinario%TYPE INDEX BY BINARY_INTEGER;
    v_veterinarios t_cpf_veterinarios;

    -- 14) CURSOR (para percorrer atendimentos pendentes)
    CURSOR cur_atendimentos_pendentes IS
        SELECT *
        FROM Atendimento
        WHERE Status_agendamento = 'Agendado'
        ORDER BY Data_hora_inicio;

BEGIN
    -- -------------------------------------------------------------------------
    -- 12) FOR IN LOOP: Preenche a coleção de veterinários (para demonstração)
    -- -------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('--- 12) FOR IN LOOP: Carregando Veterinários em Collection ---');
    
    FOR i IN (SELECT CPF_veterinario FROM Veterinario ORDER BY CPF_veterinario)
    LOOP
        v_veterinarios(v_veterinarios.COUNT + 1) := i.CPF_veterinario;
        DBMS_OUTPUT.PUT_LINE('Veterinário ID: ' || i.CPF_veterinario);
    END LOOP;
    
    -- -------------------------------------------------------------------------
    -- 14) CURSOR (OPEN, FETCH, CLOSE) e 10) LOOP EXIT WHEN
    -- -------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- 14) CURSOR + 10) LOOP EXIT WHEN: Processando Agendamentos ---');

    OPEN cur_atendimentos_pendentes;

    LOOP
        FETCH cur_atendimentos_pendentes INTO r_atendimento;

        EXIT WHEN cur_atendimentos_pendentes%NOTFOUND; -- 10) LOOP EXIT WHEN

        DBMS_OUTPUT.PUT_LINE('Agendamento ' || r_atendimento.Id_atendimento || ' em ' || TO_CHAR(r_atendimento.Data_hora_inicio, 'DD/MM/YYYY HH24:MI'));

        -- Calcula total pendente
        v_total_pagamentos := v_total_pagamentos + pkg_gestao_atendimento.fn_valor_pendente(r_atendimento.Id_atendimento);
        
        -- Obtém dados do tutor (uso do RECORD)
        SELECT p.nome, t.CPF_tutor INTO v_tutor.nome_tutor, v_tutor.cpf_tutor
        FROM Animal a
        JOIN Tutor t ON a.CPF_tutor = t.CPF_tutor
        JOIN Pessoa p ON t.CPF_tutor = p.CPF
        WHERE a.id_animal = r_atendimento.id_animal;
        
        DBMS_OUTPUT.PUT_LINE('   > Tutor: ' || v_tutor.nome_tutor || ' (CPF: ' || v_tutor.cpf_tutor || ')');

    END LOOP;

    CLOSE cur_atendimentos_pendentes;
    
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Total de valores pendentes em Agendamentos: ' || v_total_pagamentos);

    -- -------------------------------------------------------------------------
    -- 11) WHILE LOOP: Simula uma iteração de decremento
    -- -------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- 11) WHILE LOOP: Contagem Regressiva de Animais (Exemplo Tutor 11111111104) ---');
    
    SELECT COUNT(*) INTO v_total_animais FROM Animal WHERE CPF_tutor = '11111111104'; -- Tutor Daniel Moreira
    
    WHILE v_total_animais > 0
    LOOP
        DBMS_OUTPUT.PUT_LINE('Animais restantes para o tutor 11111111104: ' || v_total_animais);
        v_total_animais := v_total_animais - 1;
    END LOOP;

    -- -------------------------------------------------------------------------
    -- 15) EXCEPTION WHEN: Tratamento de exceção
    -- -------------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- 15) EXCEPTION WHEN: Teste de Exceção ---');
    
    BEGIN
        -- Tenta buscar algo que não existe para forçar o NO_DATA_FOUND
        SELECT COUNT(*) INTO v_total_animais FROM Animal WHERE especie = 'Cobra'; 

        IF v_total_animais = 0 THEN
             RAISE NO_DATA_FOUND; 
        END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('AVISO: A espécie procurada (Cobra) não foi encontrada no banco de dados.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERRO GENÉRICO: ' || SQLERRM);
    END;

END;
/