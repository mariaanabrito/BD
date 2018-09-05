-- Script de views -- 

-- Mostra os números do cartão de cidadão, os nomes e os e-mails dos clientes
create view clientes
as select num_cc as 'Número de CC', concat(nome,' ', apelido) as 'Nome Completo', email 
from cliente;

-- Mostra as informações de todas as reservas organizadas pelo número de cartão de cidadão
create view clientesEreservas
as select num_cc as 'Número de CC', concat(nome,' ', apelido) as 'Nome Completo', email, 
id_reserva as 'ID da Reserva', lugar, id_viagem as 'ID da Viagem', data
from cliente
inner join reserva
on num_cc = id_cliente
order by num_cc; 

-- Mostra todos os lugares
create view todosOsLugares as
select distinct número from lugar;

-- Mostra os lugares de todos os comboios
create view lugaresComboio
as select comboio.id_comboio, número, carruagem, lugar.preço  from comboio
inner join lugar
on comboio.id_comboio = lugar.id_comboio;

-- Mostra as viagens mais caras por ordem decrescente
create view viagensMaisCaras
as select viagem.id_viagem, viagem.preço, origem, destino, viagem.hora, tipo, viagemcomboio.data, comboio.id_comboio  from viagem
inner join viagemcomboio
on viagem.id_viagem = viagemcomboio.id_viagem
inner join comboio
on viagemcomboio.id_comboio = comboio.id_comboio
order by viagem.preço DESC;
 
-- Mostra as viagens mais baratas por ordem crescente
create view viagensMaisBaratas
as select viagem.id_viagem, viagem.preço, origem, destino, viagem.hora, tipo, viagemcomboio.data, comboio.id_comboio  from viagem
inner join viagemcomboio
on viagem.id_viagem = viagemcomboio.id_viagem
inner join comboio
on viagemcomboio.id_comboio = comboio.id_comboio
order by viagem.preço ASC;

-- Mostra todos os dados da base de dados
create view todosOsDados
as select distinct num_cc, email,  CONCAT(nome,' ', apelido) as 'Nome Completo', 
reserva.id_reserva, reserva.data, reserva.id_viagem, origem, destino, hora, tipo,
comboio.id_comboio, reserva.lugar, classe, carruagem, viagem.preço as preço_viagem ,lugar.preço as preço_lugar, (viagem.preço + lugar.preço) as 'Preço Total'
from cliente
left outer join reserva
on num_cc = id_cliente
left outer join viagem
on reserva.id_viagem = viagem.id_viagem
left outer join viagemcomboio
on viagem.id_viagem = viagemcomboio.id_viagem
left outer join comboio
on viagemcomboio.id_comboio = comboio.id_comboio
left outer join lugar
on comboio.id_comboio = lugar.id_comboio
and número = reserva.lugar
order by nome,apelido;

-- Mostra clientes que não têm reservas efetuadas
create view clientesSemReservas
as select concat(cliente.nome, ' ', cliente.apelido) as Nome
   from cliente
   where cliente.num_cc not in (select distinct cliente.num_cc from cliente
		inner join reserva on num_cc = reserva.id_cliente);

-- Consulta todos os clientes que reservaram viagens internacionais
create view clientesViagemI
as select concat(cliente.nome, ' ', cliente.apelido) as Nome, concat(V.origem, ' - ', V.destino) as Viagem
   from cliente
   inner join reserva
   on cliente.num_cc = reserva.id_cliente
   inner join (select * from viagem where viagem.tipo = 'I') as V
   on reserva.id_viagem = V.id_viagem;

-- Consulta todos os clientes que reservaram viagens nacionais
create view clientesViagemN
as select concat(cliente.nome, ' ', cliente.apelido) as Nome, concat(V.origem, ' - ', V.destino) as Viagem
   from cliente
   inner join reserva
   on cliente.num_cc = reserva.id_cliente
   inner join (select * from viagem where viagem.tipo = 'N') as V
   on reserva.id_viagem = V.id_viagem;

-- Consultar número de reservas de cada cliente, ordenado pelo seu número de cartão de cidadão
create view numReservas as
	select distinct id_cliente as 'Número CC', nReservas(id_cliente) as 'Número de Reservas' 
    from reserva
    order by id_cliente;
    
-- TOP 5 de clientes em viagens internacionais mais caras
create view clientesViagensMaisCarasI as
select *
from clientesviagemi as VI
inner join (select * from viagensmaiscaras where viagensmaiscaras.tipo = 'I') as TOP
on VI.Viagem = concat(TOP.origem, ' - ', TOP.destino)
order by TOP.preço DESC
limit 5;

-- TOP 5 de clientes em viagens internacionais mais baratas
create view clientesViagensMaisBaratasI as
select *
from clientesviagemi as VI
inner join (select * from viagensmaisbaratas where viagensmaisbaratas.tipo = 'I') as TOP
on VI.Viagem = concat(TOP.origem, ' - ', TOP.destino)
order by TOP.preço
limit 5;

-- TOP 5 de clientes em viagens nacionais mais caras
create view clientesViagensMaisCarasN as
select *
from clientesviagemn as VN
inner join (select * from viagensmaiscaras where viagensmaiscaras.tipo = 'N') as TOP
on VN.Viagem = concat(TOP.origem, ' - ', TOP.destino)
order by TOP.preço DESC
limit 5;

-- TOP 5 de clientes em viagens nacionais mais baratas
create view clientesViagensMaisBaratasN as
select *
from clientesviagemn as VN
inner join (select * from viagensmaisbaratas where viagensmaisbaratas.tipo = 'N') as TOP
on VN.Viagem = concat(TOP.origem, ' - ', TOP.destino)
order by TOP.preço
limit 5;

-- Número de clientes sem reservas
create view nClientesSemReservas as
select count(*) as 'Número Total'
from cliente
where nreservas(num_cc) = 0;

-- TOP 5 de clientes com mais reservas
create view clientesMaisReservas as
select concat(nome, ' ', apelido)
from cliente
order by nreservas(num_cc) DESC
limit 5;

-- Lotação de todas as viagens
create view lotacaoTodasViagens as
select viagem.id_viagem as 'ID Viagem', 
concat(lotacaoviagem(viagem.id_viagem,viagemcomboio.data), '%') AS 'Lotação',
viagem.origem as 'Origem',
viagem.destino as 'Destino',
viagem.hora as 'Hora',
viagemcomboio.data as 'Data'
from viagem
inner join viagemcomboio
on viagem.id_viagem = viagemcomboio.id_viagem
order by viagemcomboio.data asc;

-- Preço total das reservas de todos os clientes
create view precoTotalClientes as
select num_cc as 'Cartão de Cidadão', concat(nome, ' ', apelido) as 'Nome', totalCliente(num_cc) as Preço
from cliente
order by Preço desc;
