    /* RELATÓRIO 1 */
    
SELECT emp.nome "Nome Empregado", emp.CPF "CPF Empregado", emp.dataAdm "Data Admissão",
	concat("R$ ", round(emp.salario, 2)) "Salário", ende.cidade "Cidade Moradia", tel.numero "Número de Telefone"
	FROM empregado emp
		INNER JOIN endereco ende ON ende.Empregado_CPF = emp.CPF
		INNER JOIN telefone tel ON tel.Empregado_CPF = emp.CPF
		ORDER BY emp.nome;
            
            
/* RELATÓRIO 2 */
    
SELECT emp.nome "Nome Empregado", emp.CPF "CPF Empregado", emp.dataAdm "Data Admissão",
	CONCAT("R$ ", ROUND(emp.salario, 2)) "Salário", ende.cidade "Cidade Moradia" 
	FROM empregado emp
		INNER JOIN endereco ende ON ende.Empregado_CPF = emp.CPF
		WHERE  emp.salario < (SELECT AVG(salario) FROM empregado)
		ORDER BY emp.nome;
        
/* RELATÓRIO 3 */
   
SELECT emp.nome "Nome Empregado", emp.CPF "CPF Empregado", emp.dataAdm "Data Admissão",
	CONCAT("R$ ", ROUND(emp.salario, 2)) "Salário", ende.cidade "Cidade Moradia", count(dep.cpf) "Quantidade de Dependentes"
    FROM empregado emp
		JOIN endereco ende ON emp.cpf = ende.Empregado_CPF
		LEFT JOIN dependente dep ON emp.CPF = dep.Empregado_CPF
        WHERE ende.cidade = 'Recife'
        GROUP BY emp.nome, emp.CPF, emp.dataAdm, emp.salario, ende.cidade
        HAVING count(dep.cpf) > 0
        ORDER BY emp.nome;
        
/* RELATÓRIO 4 */
    
SELECT emp.nome "Nome Empregado", emp.CPF "CPF Empregado", emp.Sexo "Sexo", 
	CONCAT("R$ ", ROUND(emp.salario, 2)) "Salário", COUNT(ven.idVendas) AS QuantidadeVendas,
	SUM(ven.valorTotal) AS TotalValorVendido
	FROM empregado emp
		LEFT JOIN trabalhar trab ON emp.CPF = trab.Empregado_CPF
		LEFT JOIN vendas ven ON trab.empregado_CPF = ven.Empregado_CPF
		GROUP BY emp.nome, emp.CPF, emp.sexo, emp.salario
		ORDER BY quantidadeVendas DESC;
        
/* RELATÓRIO 5 */
SELECT emp.nome "Nome Empregado",
emp.CPF "CPF Empregado",
emp.salario "Salário",
ocu.nome "Nome da Ocupação",
telEmp.numero "Número do Telefone do Empregado",
dep.nome "Nome do Departamento",
dep.localDep "Local do Departamento",
telDep.numero "Número de Telefone do Departamento",
ger.nome "Nome do Gerente"
	FROM Trabalhar trab
		JOIN Empregado emp ON trab.Empregado_CPF = emp.CPF
		JOIN Ocupacao ocu ON trab.Ocupacao_cbo = ocu.cbo
		LEFT JOIN Telefone telEmp ON emp.CPF = telEmp.Empregado_CPF
		JOIN Departamento dep ON trab.Departamento_idDepartamento = dep.idDepartamento
		LEFT JOIN Telefone telDep ON dep.idDepartamento = telDep.Departamento_idDepartamento
		JOIN Gerente grt ON dep.idDepartamento = grt.Departamento_idDepartamento
		JOIN Empregado ger ON grt.Empregado_CPF = ger.CPF
		ORDER BY dep.nome;

/* RELATÓRIO 6 */
SELECT dep.nome "Nome Departamento",
dep.localDep "Local Departamento",
count(trab.Empregado_CPF) "Total de Empregados do Departamento",
emp.nome "Nome do Gerente",
tel.numero "Número do Telefone do Departamento"
	FROM Departamento dep
	LEFT JOIN Trabalhar trab ON dep.idDepartamento = trab.Departamento_idDepartamento
	LEFT JOIN Telefone tel ON dep.idDepartamento = tel.Departamento_idDepartamento
	INNER JOIN Gerente grt ON dep.idDepartamento = grt.Departamento_idDepartamento
	INNER JOIN Empregado emp ON grt.Empregado_CPF = emp.CPF
	GROUP BY dep.nome, dep.localDep, emp.nome, tel.numero
	ORDER BY dep.nome;

/* RELATÓRIO 7 */
SELECT fp.tipoPag "Forma de Pagamento",
count(fp.Vendas_idVendas) "Quantidade Vendas",
sum(ven.valorTotal) "Total Valor Vendido"
	FROM FormaPag fp
		JOIN Vendas ven ON fp.Vendas_idVendas = ven.idVendas
        GROUP BY fp.tipoPag
        ORDER BY count(fp.Vendas_idVendas);
        
/* RELATÖRIO 08 */
SELECT ven.dataVenda "Data Venda",
est.nome "Nome Produto",
round(itv.quantidade, 0) "Quantidade ItensVenda",
concat("R$ ", round(est.valor, 2)) "Valor Produto",
concat("R$ ", round(ven.valorTotal, 2)) "Valor Total Venda",
emp.nome "Nome Empregado",
dep.nome "Nome do Departamento"
	FROM Vendas ven
		JOIN ItensVenda itv ON ven.idVendas = itv.Vendas_idVendas
		JOIN Estoque est ON itv.Estoque_idProduto = est.idProduto
		JOIN Empregado emp ON ven.Empregado_CPF = emp.CPF
		JOIN Trabalhar trab ON emp.CPF = trab.Empregado_CPF
		JOIN Departamento dep ON trab.Departamento_idDepartamento = dep.idDepartamento
		ORDER BY ven.dataVenda;
        
/* RELATÓRIO 09 */
SELECT date(venda.dataVenda) "Data Venda",
count(venda.idVendas) "Quantidade de Vendas",
sum(venda.valorTotal) "Valor Total Venda"
	FROM Vendas venda
		GROUP BY date(venda.dataVenda)
		ORDER BY date(venda.dataVenda);
        
/* RELATÓRIO 10 */
SELECT est.nome "Nome Produto",
est.valor "Valor do Produto",
est.categoria "Categoria do Produto",
forn.nome "Fornecedor",
forn.email "Email do Fornecedor",
tel.numero "Telefone do Fornecedor"
	FROM estoque est
		JOIN compras comp ON est.idProduto = comp.Estoque_idProduto
        JOIN Fornecedor forn ON comp.Fornecedor_cnpj/cpf = forn.cnpj/cpf
        LEFT JOIN telefone tel ON forn.cnpj/cpf = tel.Fornecedor_cnpj/cpf
		GROUP BY est.nome, est.valor, est.categoria, forn.nome, forn.email, tel.numero
        ORDER BY est.nome;
        
/* RELATÓRIO 11 */
SELECT est.nome "Nome Produto",
sum(itv.quantidade) "Quantidade (Total) Vendas"
	FROM Estoque est
		JOIN ItensVenda itv ON est.idProduto = itv.Estoque_idProduto
		GROUP BY est.nome
		ORDER BY sum(itv.quantidade) DESC;
        
/*RELATÓRIO 12: */
SELECT dep.nome "Nome Departamento",
dep.localDep "Local Departamento",
emp.nome "Nome do Gerente",
count(ven.idVendas) "Total de Vendas",
sum(ven.valorTotal) "Valor Total das Vendas"
	FROM Departamento dep
		JOIN Gerente ger ON dep.idDepartamento = ger.Departamento_idDepartamento
		JOIN Empregado emp ON ger.Empregado_CPF = emp.CPF
		LEFT JOIN Trabalhar trab ON dep.idDepartamento = trab.Departamento_idDepartamento
		LEFT JOIN Vendas ven on trab.Empregado_CPF = ven.Empregado_CPF
		GROUP BY dep.nome, dep.localDep, emp.nome
		order by dep.nome;