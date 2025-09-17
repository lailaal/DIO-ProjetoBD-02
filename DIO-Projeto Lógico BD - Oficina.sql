-- Projeto Lógico BD - Oficina
-- Seleção do banco de dados
USE oficina;

--------------------------------------------------------------------------------
-- INSERÇÃO DE DADOS
--------------------------------------------------------------------------------

-- Clientes da oficina
INSERT INTO Clientes (Fname, Minit, Lname, CPF, Endereco) 
VALUES
    ('João', 'M', 'Souza', 12345678901, 'Rua das Flores 120, São Paulo'),
    ('Carla', 'A', 'Mendes', 98765432100, 'Av. Paulista 500, São Paulo'),
    ('Roberto', 'F', 'Alves', 45678912377, 'Rua Verde 88, Rio de Janeiro'),
    ('Fernanda', 'S', 'Lima', 78912345655, 'Rua Azul 300, Belo Horizonte'),
    ('Lucas', 'G', 'Pereira', 32165498722, 'Av. Central 900, Brasília');

-- Veículos dos clientes
INSERT INTO Veiculos (idCliente, Placa, Modelo, Ano, Cor) 
VALUES
    (1, 'ABC1D23', 'Fiat Uno', 2010, 'Prata'),
    (2, 'XYZ9K88', 'Toyota Corolla', 2018, 'Preto'),
    (3, 'JKL3M55', 'Honda Civic', 2020, 'Branco'),
    (4, 'QWE7R44', 'Chevrolet Onix', 2019, 'Vermelho'),
    (5, 'RTY2T11', 'Ford Ka', 2015, 'Cinza');

-- Ordens de serviço
INSERT INTO OrdemServico (idCliente, idVeiculo, StatusOS, Descricao, ValorTotal, PagamentoAVista) 
VALUES 
    (1, 1, DEFAULT, 'Troca de óleo e filtro', 200, 1),
    (2, 2, 'Concluída', 'Revisão completa', 1200, 0),
    (3, 3, DEFAULT, 'Troca de pastilhas de freio', 500, 1),
    (4, 4, DEFAULT, 'Troca de bateria', 450, 0),
    (5, 5, DEFAULT, 'Alinhamento e balanceamento', 150, 1);

-- Peças utilizadas na oficina
INSERT INTO Pecas (NomePeca, Categoria, Avaliacao, Estoque) 
VALUES
    ('Filtro de óleo', 'Motor', 5, 100),
    ('Pastilha de freio', 'Freios', 4, 50),
    ('Bateria Moura', 'Elétrica', 4, 20),
    ('Óleo 5W30', 'Lubrificantes', 5, 200),
    ('Pneu Aro 15', 'Rodas', 3, 30);

-- Associação de peças às ordens de serviço
INSERT INTO PecasOrdem (idPeca, idOrdem, Quantidade, StatusUso) 
VALUES
    (1, 1, 1, 'Utilizada'),
    (4, 1, 2, 'Utilizada'),
    (2, 3, 1, 'Utilizada'),
    (3, 4, 1, 'Utilizada'),
    (5, 5, 4, 'Utilizada');

-- Fornecedores
INSERT INTO Fornecedores (RazaoSocial, CNPJ, Contato) 
VALUES 
    ('Auto Peças Silva', 123456789123456, '11999998888'),
    ('Distribuidora Moura', 854519649143457, '11988887777'),
    ('Auto Center Brasil', 934567893934695, '21977776666');

-- Relação peças-fornecedores
INSERT INTO FornecedorPeca (idFornecedor, idPeca, Quantidade) 
VALUES
    (1, 1, 50),
    (1, 2, 30),
    (2, 3, 10),
    (2, 4, 100),
    (3, 5, 20);

-- Mecânicos
INSERT INTO Mecanicos (Nome, Especialidade, Contato) 
VALUES 
    ('Carlos Mendes', 'Motor', '11987654321'),
    ('Paulo Silva', 'Freios', '11912345678'),
    ('André Souza', 'Elétrica', '11933445566'),
    ('Rafael Lima', 'Suspensão', '11944556677');

-- Associação mecânicos-ordens
INSERT INTO OrdemMecanico (idMecanico, idOrdem) 
VALUES
    (1, 1),
    (2, 3),
    (3, 4),
    (4, 5),
    (1, 2);

--------------------------------------------------------------------------------
-- CONSULTAS SQL
--------------------------------------------------------------------------------

-- 1. Recuperação simples: listar clientes e veículos
SELECT 
    c.idCliente,
    CONCAT(c.Fname, ' ', c.Lname) AS Cliente,
    v.Modelo,
    v.Placa
FROM Clientes c
JOIN Veiculos v ON v.idCliente = c.idCliente;

-- 2. Filtrar ordens de serviço acima de R$ 500
SELECT 
    idOrdem,
    Descricao,
    ValorTotal
FROM OrdemServico
WHERE ValorTotal > 500;

-- 3. Atributo derivado: calcular valor médio gasto por cliente
SELECT 
    idCliente,
    ROUND(AVG(ValorTotal),2) AS ValorMedioGasto
FROM OrdemServico
GROUP BY idCliente;

-- 4. Ordenar ordens de serviço por valor total (decrescente)
SELECT 
    idOrdem,
    Descricao,
    ValorTotal
FROM OrdemServico
ORDER BY ValorTotal DESC;

-- 5. Quantidade de ordens por cliente (HAVING > 1)
SELECT 
    idCliente,
    COUNT(idOrdem) AS TotalOrdens
FROM OrdemServico
GROUP BY idCliente
HAVING COUNT(idOrdem) > 1;

-- 6. Junção complexa: ordens, peças utilizadas e fornecedores
SELECT 
    os.idOrdem,
    c.Fname AS Cliente,
    p.NomePeca,
    f.RazaoSocial AS Fornecedor,
    po.Quantidade
FROM OrdemServico os
JOIN Clientes c ON os.idCliente = c.idCliente
JOIN PecasOrdem po ON os.idOrdem = po.idOrdem
JOIN Pecas p ON p.idPeca = po.idPeca
JOIN FornecedorPeca fp ON fp.idPeca = p.idPeca
JOIN Fornecedores f ON f.idFornecedor = fp.idFornecedor;
