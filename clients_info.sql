# Tabella temporanea per l'età del cliente
create temporary table banca.eta as
select id_cliente,
DATE_FORMAT(
	from_days(datediff(now(), data_nascita)), '%Y') + 0 as eta 
from banca.cliente
order by id_cliente;

/* Tabella temporanea contenente tutte le informazioni riguardanti le transazioni:
 * - numero di transazioni in uscita
 * - numero di transazioni in entrata
 * - importo transato in uscita su tutti i conti
 * - importo transato in entrata su tutti i conti
* - numero di transazioni in uscita per tipologia tipo transazione
 * - numero di transazioni in entrata per tipologia tipo transazione
*/
create temporary table banca.transazioni_info as
select
clt.id_cliente as id_cliente_1, 
sum(case 
	when tipo_trans.segno = '-' then 1 else 0 end
   ) as num_transazioni_uscita,
sum(case 
	when tipo_trans.segno = '+' then 1 else 0 end
   ) as num_transazioni_entrata,
round(sum(case
	when tipo_trans.segno = '-' then trans.importo else 0 end
    ), 2) as importo_trans_uscita,
round(sum(case
	when tipo_trans.segno = '+' then trans.importo else 0 end
    ), 2) as importo_trans_entrata,
sum(
	case
		when tipo_trans.desc_tipo_trans = 'Acquisto su Amazon' then 1 
			else 0 end     
	) as num_transazioni_uscita_amazon,
sum(
	case
		when tipo_trans.desc_tipo_trans = 'Rata mutuo' then 1 
			else 0 end     
	) as num_transazioni_uscita_mutuo,
sum(
	case
		when tipo_trans.desc_tipo_trans = 'Hotel' then 1
			else 0 end     
	) as num_transazioni_uscita_hotel,
sum(
	case
		when tipo_trans.desc_tipo_trans = 'Biglietto aereo' then 1
			else 0 end     
	) as num_transazioni_uscita_biglietto_aereo,
sum(
	case
		when tipo_trans.desc_tipo_trans = 'Supermercato' then 1
			else 0 end     
	) as num_transazioni_uscita_supermercato,
sum(
	case
		when tipo_trans.desc_tipo_trans = 'Stipendio' then 1
			else 0 end     
	) as num_transazioni_entrata_stipendio,
sum(
	case
		when tipo_trans.desc_tipo_trans = 'Pensione' then 1
			else 0 end     
	) as num_transazioni_entrata_pensione,
sum(
	case
		when tipo_trans.desc_tipo_trans = 'Dividendi' then 1
			else 0 end     
	) as num_transazioni_entrata_dividendi
from banca.cliente clt
left join banca.conto cont
on clt.id_cliente = cont.id_cliente
left join  banca.transazioni trans
on trans.id_conto = cont.id_conto
left join banca.tipo_transazione tipo_trans
on trans.id_tipo_trans = tipo_trans.id_tipo_transazione
where clt.id_cliente is not NULL
group by 1
order by 1;

/* Tabella temporanea contenente informazioni sui conti:
 * - numero di conti per cliente
 * - numero di conti per tipologia di conto, per cliente
*/
create temporary table banca.numero_conti as
select
clt.id_cliente as id_cliente_2, 
count(distinct cont.id_conto) as num_tot_conti,
count(distinct 
	case
		when tipo_cont.desc_tipo_conto = 'Conto Base' then cont.id_conto else null end
        ) as num_conto_base,
count(distinct 
	case
		when tipo_cont.desc_tipo_conto = 'Conto Business' then cont.id_conto else null end
        ) as num_conto_business,
count(distinct 
	case
		when tipo_cont.desc_tipo_conto = 'Conto Privati' then cont.id_conto else null end
        ) as num_conto_privati,
count(distinct 
	case
		when tipo_cont.desc_tipo_conto = 'Conto Famiglie' then cont.id_conto else null end
        ) as num_conto_famiglie
from banca.cliente as clt
left join banca.conto as cont
on clt.id_cliente = cont.id_cliente
left join banca.tipo_conto as tipo_cont
on cont.id_tipo_conto = tipo_cont.id_tipo_conto
where clt.id_cliente is not NULL
group by 1
order by 1;

/* Tabella temporanea contententi tutte le informazioni sulle transazioni per tipologia conto
 * - importo transato in uscita su tutti i conti per tipologia conto
 * - importo transato in entrata su tutti i conti per tipologia conto
*/
create temporary table banca.transazioni_per_conto as
select
clt.id_cliente as id_cliente_3, 
sum(case 
	when tipo_trans.segno = '-' and tipo_cont.desc_tipo_conto = 'Conto Base' then 1 else 0 end
   ) as num_transazioni_uscita_base,
sum(case 
	when tipo_trans.segno = '-' and tipo_cont.desc_tipo_conto = 'Conto Business' then 1 else 0 end
   ) as num_transazioni_uscita_business,
sum(case 
	when tipo_trans.segno = '-' and tipo_cont.desc_tipo_conto = 'Conto Privati' then 1 else 0 end
   ) as num_transazioni_uscita_privati,
   sum(case 
	when tipo_trans.segno = '-' and tipo_cont.desc_tipo_conto = 'Conto Famiglie' then 1 else 0 end
   ) as num_transazioni_uscita_famiglie,
sum(case 
	when tipo_trans.segno = '+' and tipo_cont.desc_tipo_conto = 'Conto Base' then 1 else 0 end
   ) as num_transazioni_entrata_base,
sum(case 
	when tipo_trans.segno = '+' and tipo_cont.desc_tipo_conto = 'Conto Business' then 1 else 0 end
   ) as num_transazioni_entrata_business,
sum(case 
	when tipo_trans.segno = '+' and tipo_cont.desc_tipo_conto = 'Conto Privati' then 1 else 0 end
   ) as num_transazioni_entrata_privati,
sum(case 
	when tipo_trans.segno = '+' and tipo_cont.desc_tipo_conto = 'Conto Famiglie' then 1 else 0 end
   ) as num_transazioni_entrata_famiglie   
from banca.cliente clt
left join banca.conto cont
on clt.id_cliente = cont.id_cliente
left join  banca.transazioni trans
on trans.id_conto = cont.id_conto
left join banca.tipo_transazione tipo_trans
on trans.id_tipo_trans = tipo_trans.id_tipo_transazione
left join banca.tipo_conto tipo_cont
on cont.id_tipo_conto = tipo_cont.id_tipo_conto
where clt.id_cliente is not NULL
group by 1
order by 1;

/*
creo la tabella banca.denormalizzata
*/

create table banca.denormalizzata as
select *
from banca.eta beta
left join banca.transazioni_info tr_info
on beta.id_cliente = tr_info.id_cliente_1
left join banca.numero_conti n_conti
on beta.id_cliente = n_conti.id_cliente_2
left join banca.transazioni_per_conto tr_per_conto
on beta.id_cliente = tr_per_conto.id_cliente_3;

/*
elimino le colonne duplicate
*/
alter table banca.denormalizzata 
drop column id_cliente_1, 
drop column id_cliente_2, 
drop column id_cliente_3;

/*
mostro la tabella
*/
select * from banca.denormalizzata;


