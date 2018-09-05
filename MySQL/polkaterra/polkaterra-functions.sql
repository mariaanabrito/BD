-- Script de functions --

-- Número de reservas de um cliente
delimiter $$
create function nReservas(numcc int) returns int
BEGIN
	declare contador int default 0;
    select count(*) into contador from reserva
    where reserva.id_cliente = numcc;
    return contador;
END $$
delimiter ;

 -- Indica se lugar está livre ou ocupado
delimiter $$
create function estadoDoLugar(id_v varchar(8), n_lugar varchar(3), data_v DATE) returns text
begin 
    declare conta int default 0;
    select count(*) into conta
    from  (select * from reserva where reserva.lugar = n_lugar) as R
    inner join (select viagem.id_viagem from viagem where viagem.id_viagem = id_v) as V
    on R.id_viagem = V.id_viagem
    inner join (select viagemcomboio.id_viagem, viagemcomboio.id_comboio from viagemcomboio where viagemcomboio.data = data_v) as D
    on V.id_viagem = D.id_viagem
    inner join comboio
    on D.id_comboio = comboio.id_comboio;
    if (conta = 1) then 
		return concat(n_lugar, ' - Ocupado');
    else 
		return concat(n_lugar, ' - Livre');
    end if;
end $$
delimiter ;

-- Indica o valor total das reservas de um cliente
delimiter **
CREATE function totalCliente(numcc int) returns decimal(5,2)
BEGIN
	declare total decimal(5,2);
    select sum(preçoReserva(r.id_reserva)) into total
    from Reserva r
    where r.id_cliente = numcc;
    return total;
END **
delimiter ;

-- Indica o valor total de uma reserva
delimiter //
CREATE function preçoReserva(idreserva int) returns decimal(5,2)
BEGIN
	declare total decimal(5,2);
	select (Viagem.preço + Lugar.preço) into total
    from Reserva
    inner join Viagem
    on Viagem.id_viagem = Reserva.id_viagem and Reserva.id_reserva = idreserva
    inner join ViagemComboio 
	on ViagemComboio.id_viagem = Reserva.id_viagem
	inner join Comboio 
	on ViagemComboio.id_comboio = Comboio.id_comboio 
    and ViagemComboio.data = Reserva.data
	inner join Lugar 
	on Comboio.id_comboio = Lugar.id_comboio 
    and Lugar.número = Reserva.lugar;
    return total;
END //
delimiter ;

-- Verifica se um cliente se encontra numa viagem
delimiter $$
create function clienteEstaNaViagem(id_c int, id_v varchar(8), d date) returns text
begin 
	declare conta int default 0;
    
    select count(*) into conta
    from cliente
    inner join (select * from reserva where reserva.id_viagem = id_v
									        and reserva.data = d) as R
	on cliente.num_cc = R.id_cliente
    where num_cc = id_c;
    
    if (conta = 0) then return 'Cliente não se encontra na viagem inserida';
    else return 'Cliente encontra-se na viagem inserida';
    end if;
end $$
delimiter ;

delimiter %%

-- Indica a lotação de uma viagem
create function lotacaoViagem(idviagem varchar(8), dataV date) returns int
BEGIN
	declare total int default 0;
	declare ocupados int default 0;
	
	select count(*) into total from viagem
	inner join viagemcomboio
	on viagemcomboio.id_viagem = viagem.id_viagem
	inner join comboio
	on viagemcomboio.id_comboio = comboio.id_comboio
	inner join lugar
	on comboio.id_comboio = lugar.id_comboio
    where viagem.id_viagem = idviagem
	and viagemcomboio.data = dataV;

	select count(*) into ocupados from reserva
	where reserva.id_viagem = idviagem
	and reserva.data = dataV;

	return(ocupados/total)*100;
    
end%%

delimiter ; 

-- Lucro de uma viagem com as reservas efetuadas
delimiter $$
create function lucroViagem(idv varchar(8), dat date) returns decimal(6,2)
begin
	declare total decimal(6,2);
    
    select sum(preçoReserva(reserva.id_reserva)) into total
    from reserva where reserva.id_viagem = idv and reserva.data = dat;
    
    return total;
    
end $$
delimiter ;


