	
    #query 1
    select distinct PagCardeneta from cromo as c
	inner join jogador j on c.jgador = j.nr
	inner join(select id from posicao where designacao = 'Defesa') p on j.posicao = p.id
    inner join(select id from equipa where designacao in('AQUI É BRAGA, ESCREVE TU', 'RIO ABE') e
    on j.equipa = e.id;
    
    #query 2
    select c.nr from cromo c
    join jogador  j on c.jogador=j.nr
    join(select id from posicao where designacao not in ('defesa', 'médio')) p on j.posicao ) p.id
    join (select id from equipa where treinador in ('jorge jesus', 'nuno espírito santo')) e
    on j.equipa = e.id
    order by c.nr asc;
    
    #query 3
    create view cromos_f (N_cromo, Nome_J, Nome_E) as
    select c.nr , j.nome, e.designacao
    from cromo as c
    left outer join jogador as j
    on c.jogador = j.nr
    left outer join equipa as e 
    on j.equipa = e.id;
    
    #query4
    
    delimiter $$ 
    
    create procedure d_cromos(in nome_equipa varchar(100))
		begin
			select c.nr,pagcaderneta from cromo c
            inner join jogador j on c.jogador = j.nr
            inner join ( select id from equipa where designacao = nome_equipa) as e
            on j.equipa = e.id
            order by 1,2;
		end $$
        
	delimiter ;
    
    #query 6
    
    delimiter $$
    
    create function team_cromo(numero INT) returns text
		begin
			declare conta int default 0;
            select count(*) into conta from cromo
            where nr = numero and adquirido = 'S';
            if conta = 1 then
				return concat(numero,' - Repetido');
			else 
				return concat(numero, ' - em Falta');
			end if;
		end $$
        
	delimiter ;
            
    
    # select tem_Cromo(nr) from cromo;
    
    
    
SELECT C.nr, ifnull(j.nome,'na') as nome,ifnull(e.designacao,'na') as designacao,
												case when is null then 'emblema'
                                                else 'jogador' end as tipo
from cromo c left join jogador j on c.jogador = j.nr
			 left join equipa e on j-equipa = e.id
where c.adquirido = 'N';

#trigger

create table audcromos(
	id int primary key auto_increment,
    nr int,
    data datetime);
    
delimiter &
create trigger cromoAdquirido
after update on cromo
for each row
begin
	if(old.adquirido != new.adquirido) then
		insert into `Caderneta`.`audCromos`(`id`,`nr`,`data`)
				values(null,new.nr,current_timestamp());
	end if;
end &

delimiter ;