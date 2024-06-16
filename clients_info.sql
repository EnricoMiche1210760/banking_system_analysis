select id_cliente, nome, cognome,
DATE_FORMAT(
	from_days(datediff(now(), data_nascita)), '%Y') + 0 as age 
from banca.cliente;

#datediff converte un numero in una rappresentazione anno-mese-giorno
