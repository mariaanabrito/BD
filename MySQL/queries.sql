-- Script de execução das queries -- 
use polkaterra;
-- Lista dos clientes
select * from clientes;

-- Lista de reservas
select * from clientesereservas;

-- Lista de todos os lugares
select * from todososlugares;

-- Lista dos comboios e seus lugares
select * from lugarescomboio;

-- Lista ordenada das viagens mais caras
select * from viagensmaiscaras;

-- TOP 5 de viagens mais caras
select * from viagensmaiscaras limit 5;

-- Lista de viagens nacionais mais caras
select * from viagensmaiscaras as VM
where VM.tipo = 'N';

-- Lista ordenada das viagens mais baratas
select * from viagensmaisbaratas;

-- TOP 5 de viagens mais baratas
select * from viagensmaisbaratas limit 5;

-- Lista de viagens internacionais mais baratas
select * from viagensmaisbaratas as VB
where VB.tipo = 'I';

-- Todos os dados da BD
select * from todososdados;

-- Lista de clientes sem reservas efetuadas
select * from clientessemreservas;

-- Lista de clientes em viagens internacionais
select * from clientesviagemi;

-- Lista de clientes em viagens nacionais
select * from clientesviagemn;

-- Lista de número de reservas por cliente
select * from numreservas;

-- Lugares livres de uma viagem
call lugareslivresviagem('Lisboa', 'Porto', '23:45:00', '2017-10-05');

-- Lugares ocupados de uma viagem
call lugaresOcupadosViagem('Lisboa', 'Porto', '23:45:00', '2017-10-05');

-- Lista de lugares ocupados por um cliente e respetivas informações
call lugaresDeUmCliente(14312090);

-- Lista de viagens entre duas datas
call viagensEntreDatas('2017-07-06', '2017-09-13');

-- Lista de viajantes numa viagem
call consultarViajantes('Lisboa', 'Porto', '2017-10-05');

-- Lista de viajantes num viagem
call consultarViajantes('Porto', 'Paris', '2017-11-11');

-- Lista de viajantes num viagem
call consultarViajantes('Castelo Branco', 'Berlim', '2017-07-12');

-- Lista de viagens disponíveis num dia
call viagensDisponiveis('Porto', 'Paris', '2017-11-11');

-- Cliente que se encontra num lugar numa determinada viagem
call clienteLugar('POPA1155', '5A', '2017-11-11');

-- Lista de lugares livres numa viagem num determinado dia
call lugareslivresdia('POPA1155', '2017-11-11');

-- Lista de lugares livres numa viagem num determinado dia
call lugareslivresdia('BCLB1500', '2017-03-09');

-- Insere reserva
call inserirreserva(13844774, 'POPA1155', '2017-11-11', '3A');

-- Insere reserva
call inserirreserva(13844774, 'BCLB1500', '2017-03-09', '8A');

-- Informação de uma reserva
call bilhete(13844774, 6);

-- Apaga um cliente
call apagacliente(13844774);

-- Apaga uma reserva
call apagareserva(12);

-- Apaga uma viagem
call apagaviagem('BCLB1500');

-- Apaga um comboio
call apagacomboio(2);

-- Apaga um lugar
call apagalugar('8A');

-- Atualiza o e-mail
call atualizaemail(13844774, 'emailgenerico@gmail.com');

-- Atualiza o nome próprio
call atualizanome(13844774, 'Ana');

-- Atualiza o apelido
call atualizaapelido(13844774, 'Monteiro');

-- Atualiza hora da viagem
call atualizahora('POPA1155', '12:12:00');

-- Atualiza preço da viagem
call atualizapreçoviagem('POPA1155', 500.99);

-- Atualiza preço de lugar
call atualizapreçolugar('7A', 14.99);

-- Atualiza classe de lugar
call atualizaclasse('1A', 3);

-- Número de reservas de um cliente
select nreservas(13844774) as 'Número de Reservas';

-- Indica se lugar está livre ou ocupado
select estadodolugar('POPA1155', '1A', '2017-11-11') as 'Estado do Lugar';

-- Preço total das reservas de um cliente
select totalcliente(13844774) as 'Preço Total';

-- Preço total de uma reserva
select preçoreserva(23) as 'Preço Total';

-- Verifica se um cliente se encontra numa viagem
select clienteestanaviagem(13844774, 'POPA1155', '2017-11-11') as 'Resultado';

-- Verifica se um cliente se encontra numa viagem
select clienteestanaviagem(13844774, 'BCLB1500', '2017-03-09') as 'Resultado';

-- Lotação de uma viagem
select lotacaoviagem('POPA1155', '2017-11-11') 'Lotação (em %)';

-- Lotação de uma viagem
select lotacaoviagem('BCLB1500', '2017-03-09') 'Lotação (em %)';

-- Lucro de uma viagem
select lucroviagem('POPA1155', '2017-11-11') as 'Lucro';

-- TOP 5 de clientes em viagens internacionais mais caras
select * from clientesviagensmaiscarasi;

-- TOP 5 de clientes em viagens internacionais mais baratas
select * from clientesviagensmaisbaratasi;

-- TOP 5 de clientes em viagens nacionais mais caras
select * from clientesviagensmaiscarasn;

-- TOP 5 de clientes em viagens nacionais mais baratas
select * from clientesviagensmaisbaratasn;

-- Número de clientes sem reservas
select * from nclientessemreservas;

-- TOP 5 de clientes com mais reservas
select * from clientesmaisreservas;

-- Lotação de todas as viagens
select * from lotacaotodasviagens;

-- Preço total das reservas de todos os clientes
select * from precototalclientes;

use polkaterra;

select * from cliente;
