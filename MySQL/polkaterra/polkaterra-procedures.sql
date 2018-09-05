-- Script de procedures --

-- Lugares livres de uma viagem
DELIMITER $$
CREATE procedure lugaresLivresViagem(origemV varchar(45), destinoV varchar(45), horaV time, diaV DATE)
BEGIN
	select viagem.id_viagem, lugar.id_comboio, lugar.classe, lugar.carruagem, lugar.número, (Viagem.preço + lugar.preço) as 'Preço da Reserva'
    from viagem
    inner join viagemcomboio
    on viagemcomboio.id_viagem = viagem.id_viagem
    and viagem.hora = horaV
    and viagem.origem = origemV
    and viagem.destino = destinoV
    inner join comboio
    on viagemcomboio.id_comboio = comboio.id_comboio
    and viagemcomboio.data = diaV
    inner join lugar
    on comboio.id_comboio = lugar.id_comboio
    and lugar.número not in 
		(select Reserva.lugar 
		from reserva
		where reserva.id_viagem = viagem.id_viagem and reserva.data = diaV);
END $$;
delimiter ;

-- Lugares ocupados de uma viagem
DELIMITER $$
CREATE procedure lugaresOcupadosViagem(origemV varchar(45), destinoV varchar(45), horaV time, diaV DATE)
BEGIN
	select viagem.id_viagem, lugar.id_comboio, lugar.classe, lugar.carruagem, lugar.número, (Viagem.preço + lugar.preço) as 'Preço da Reserva'
    from reserva
    inner join viagem
    on viagem.id_viagem = reserva.id_viagem
    inner join viagemcomboio
    on viagemcomboio.id_viagem = viagem.id_viagem
    and viagem.hora = horaV
    and viagem.origem = origemV
    and viagem.destino = destinoV
    inner join comboio
    on viagemcomboio.id_comboio = comboio.id_comboio
    and viagemcomboio.data = diaV
    inner join lugar
    on comboio.id_comboio = lugar.id_comboio
    and reserva.lugar = lugar.número;
END $$
DELIMITER ;

-- Todos os lugares reservados por um cliente
DELIMITER $$
CREATE PROCEDURE lugaresDeUmCliente(numero_cc int)
BEGIN
	select num_cc, concat( nome,' ', apelido) as Nome, reserva.id_viagem, comboio.id_comboio, lugar.carruagem, reserva.lugar,reserva.data from cliente
    inner join reserva
	on num_cc = id_cliente and num_cc = numero_cc 
	inner join viagem
	on reserva.id_viagem = viagem.id_viagem
	inner join viagemcomboio
	on viagem.id_viagem = viagemcomboio.id_viagem
	inner join comboio
	on viagemcomboio.id_comboio = comboio.id_comboio
	inner join lugar
	on comboio.id_comboio = lugar.id_comboio 
    where num_cc = numero_cc 
	and reserva.lugar = número;
END$$
DELIMITER ;

-- Dadas duas datas, recebemos todas as viagens entre as mesmas
DELIMITER $$
CREATE procedure viagensEntreDatas(dat1 date, dat2 date)
BEGIN
		select viagem.origem as 'Origem', viagem.destino as 'Destino', viagemcomboio.data as 'Data', viagem.hora as 'Hora de Partida'
        from viagem
        inner join viagemcomboio
        on viagem.id_viagem = viagemcomboio.id_viagem and
        viagemcomboio.data >= dat1 and viagemcomboio.data <= dat2;
END $$
DELIMITER ;

-- Ocupantes de uma viagem
DELIMITER $$
CREATE procedure consultarViajantes(o varchar(45), dest varchar(45), dat date)
BEGIN
		select concat(cliente.nome, ' ', cliente.apelido) as 'Nome Completo', 
        cliente.num_cc as 'Nº de Cartão de Cidadão', cliente.email as 'E-mail'
        from cliente
        inner join reserva
        on num_cc = reserva.id_cliente
        inner join viagem
        on viagem.destino = dest and viagem.origem = o 
        and reserva.id_viagem = viagem.id_viagem
        inner join viagemcomboio 
        on viagemcomboio.data = dat and viagemcomboio.id_viagem = viagem.id_viagem;
END $$
DELIMITER ;

-- Viagens disponiveis naquele dia entre os dois destinos
DELIMITER $$
CREATE procedure viagensDisponiveis(o varchar(45), dest varchar(45), dat DATE)
BEGIN
	select viagem.id_viagem as 'Código da Viagem', viagem.origem as 'Origem', viagem.destino as 'Destino', 
    viagem.hora as 'Hora de Partida' from viagem
    inner join viagemcomboio
    on viagem.id_viagem = viagemcomboio.id_viagem and viagemcomboio.data = dat
    where viagem.destino = dest and viagem.origem = o;
END $$
DELIMITER ;

-- Cliente no lugar numa determinada viagem e dia
DELIMITER $$
CREATE procedure clienteLugar(viagem varchar(8), lugar varchar(45),d Date)
BEGIN
	select concat(c.nome,' ',c.apelido) as Nome
	from Cliente c
    inner join (select * from Reserva where viagem = reserva.id_viagem
                                            and lugar = reserva.lugar
                                            and d = reserva.data) R 
	on c.num_cc = R.id_cliente;
end $$
DELIMITER ;

-- Lugares livres numa viagem num determinado dia
DELIMITER $$
CREATE procedure lugaresLivresDia(idviagem varchar(8), dataviagem date)
BEGIN
	select Lugar.número as 'Lugar', Lugar.id_comboio as 'Comboio', Lugar.classe as 'Classe', Lugar.carruagem as 'Carruagem'
    from viagem
    inner join ViagemComboio 
	on viagem.id_viagem = idviagem and ViagemComboio.id_viagem = idviagem and viagemcomboio.data = dataviagem
	inner join Comboio
	on ViagemComboio.id_comboio = Comboio.id_comboio
	inner join Lugar 
	on Comboio.id_comboio = Lugar.id_comboio
    where Lugar.número not in (
    select Reserva.lugar 
    from reserva
    where reserva.id_viagem = idviagem and reserva.data = dataviagem)
    order by lugar.classe;
END $$
DELIMITER ;

-- Apagar um cliente da base de dados
delimiter $$
create procedure apagaCliente(id_cliente int)
begin
	delete from cliente where cliente.num_cc = id_cliente;
end $$
delimiter ;

-- Apagar uma reserva da base de dados
delimiter $$
create procedure apagaReserva(id_r int)
begin
	delete from reserva where reserva.id_reserva = id_r;
end $$
delimiter ;

-- Apagar uma viagem da base de dados
delimiter $$
create procedure apagaViagem(id_v varchar(8))
begin
	delete from viagem where viagem.id_viagem = id_v;
end $$
delimiter ;

-- Apagar um comboio da base de dados
delimiter $$
create procedure apagaComboio(id_c int)
begin
	delete from comboio where comboio.id_comboio = id_c;
end $$
delimiter ;

-- Apagar um lugar da base de dados
delimiter $$
create procedure apagaLugar(id_l varchar(2))
begin
	delete from lugar where lugar.número = id_l;
end $$
delimiter ;

-- Atualizar e-mail de cliente
delimiter $$
create procedure atualizaEmail(id_c int, m varchar(45))
begin
	update cliente
	set email = m
	where cliente.num_cc = id_c;
end $$
delimiter ;

-- Atualizar nome de cliente
delimiter $$
create procedure atualizaNome(id_c int, n varchar(45))
begin
	update cliente
	set nome = n
	where cliente.num_cc = id_c;
end $$
delimiter ;

-- Atualizar apelido de cliente
delimiter $$
create procedure atualizaApelido(id_c int, a varchar(45))
begin
	update cliente
	set apelido = a
	where cliente.num_cc = id_c;
end $$
delimiter ;

-- Atualizar hora de viagem
delimiter $$
create procedure atualizaHora(id_v varchar(8), h TIME)
begin
	update viagem
	set hora = h
	where viagem.id_viagem = id_v;
end $$
delimiter ;

-- Atualizar preço de viagem
delimiter $$
create procedure atualizaPreçoViagem(id_v varchar(8), p decimal(5,2))
begin
	update viagem
	set viagem.preço = p
	where viagem.id_viagem = id_v;
end $$
delimiter ;

-- Atualizar preço de lugar
delimiter $$
create procedure atualizaPreçoLugar(id_l varchar(2), p decimal(5,2))
begin
	update lugar
	set lugar.preço = p
	where lugar.número = id_l;
end $$
delimiter ;

-- Atualizar classe de lugar
delimiter $$
create procedure atualizaClasse(id_l varchar(45), c int)
begin
	update lugar
	set lugar.classe = c
	where lugar.número = id_l;
end $$
delimiter ;

-- procedure que não permite inserir uma reserva com dados inválidos ou inexistentes
delimiter $$ 
create procedure inserirReserva(numcc int, idviagem varchar(8), dataV date, lugarV varchar(2))
begin
	declare flag int;
    declare ocupado int;
    declare dataInv int;
 
	start transaction;
	
    if(
		lugarV not in(
			select * from todososlugares))
            then set flag = 1;
		else set flag = 0;
	end if;
    
    if (dataV not in (select viagemcomboio.data from viagemcomboio where viagemcomboio.id_viagem = idviagem))
		then set dataInv = 1;
	else set dataInv = 0;
    end if;
    
    if(estadoDoLugar(idviagem, lugarV, dataV) = CONCAT(lugarV, ' - Ocupado'))
			then set ocupado = 1;
	else set ocupado = 0;
    end if;
    
    insert into reserva values(null, lugarV, numcc, idviagem, dataV);
    
    if(ocupado = 0 AND flag = 0 AND dataInv = 0)
    then
		commit;
	else rollback; select 'Dado inválido'; 
	end if;
end $$
delimiter ;

-- Informação de uma reserva de um cliente
delimiter $$
create procedure bilhete(numcc int, idreserva int)
BEGIN
	select id_cliente as 'Número CC', concat(nome, ' ', apelido) as Nome, id_reserva as 'ID da Reserva', preçoReserva(idreserva) as 'Preço do Bilhete',
			reserva.data as Data, viagem.hora as 'Hora de Partida', reserva.Lugar, lugar.Classe, lugar.Carruagem
	from cliente
    inner join reserva
    on num_cc = reserva.id_cliente and id_cliente = numcc
    inner join viagem
    on reserva.id_viagem = viagem.id_viagem and id_reserva = idreserva
    inner join viagemcomboio
    on viagem.id_viagem = viagemcomboio.id_viagem and viagemcomboio.data = reserva.data
    inner join comboio
    on viagemcomboio.id_comboio = comboio.id_comboio
    inner join lugar
    on comboio.id_comboio = lugar.id_comboio
    and reserva.lugar = lugar.número;
END$$
delimiter ;