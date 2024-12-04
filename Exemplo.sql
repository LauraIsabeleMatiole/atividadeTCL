CREATE TABLE contas_bancarias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titular VARCHAR(100),
    saldo DECIMAL(10, 2)
);

CREATE TABLE transacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    conta_origem INT,
    conta_destino INT,
    valor DECIMAL(10, 2),
    data_transacao DATETIME
);

-- Inserir algumas contas com saldo inicial
INSERT INTO contas_bancarias (titular, saldo) VALUES
('João', 1000.00),
('Maria', 500.00);

-- Vamos verificar as contas antes da transação
SELECT * FROM contas_bancarias;

START TRANSACTION;

-- Operação 1: Retirar dinheiro da conta do João
UPDATE contas_bancarias 
SET saldo = saldo - 200.00 
WHERE titular = 'João' AND saldo >= 200.00;

-- Verificar se o saldo do João foi alterado com sucesso
SELECT * FROM contas_bancarias WHERE titular = 'João';

-- Operação 2: Adicionar dinheiro na conta da Maria
UPDATE contas_bancarias 
SET saldo = saldo + 200.00 
WHERE titular = 'Maria';

-- Verificar se o saldo da Maria foi alterado com sucesso
SELECT * FROM contas_bancarias WHERE titular = 'Maria';

-- Operação 3: Registrar a transação na tabela de transações
INSERT INTO transacoes (conta_origem, conta_destino, valor, data_transacao)
VALUES ((SELECT id FROM contas_bancarias WHERE titular = 'João'), 
        (SELECT id FROM contas_bancarias WHERE titular = 'Maria'), 
        200.00, NOW());

-- Se tudo ocorrer bem, confirmamos a transação
COMMIT;

START TRANSACTION;

-- Operação 1: Retirar dinheiro da conta do João
UPDATE contas_bancarias 
SET saldo = saldo - 200.00 
WHERE titular = 'João' AND saldo >= 200.00;

-- Simulando um erro (por exemplo, conta da Maria não encontrada)
-- Vamos forçar um erro ao tentar transferir para uma conta que não existe
UPDATE contas_bancarias 
SET saldo = saldo + 200.00 
WHERE titular = 'Não Existe';

-- Se algum erro ocorrer, a transação será revertida
ROLLBACK;
