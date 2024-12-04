create table cliente(
idCliente int primary key,
nome varchar(100)
);

create table pedido(
idPedido int primary key,
dataPedido date,
idCliente int,
foreign key (idCliente) references cliente(idCliente)
);

START TRANSACTION;

insert into cliente(idCliente, nome) values
(1, 'Laura'),
(2, 'Leonardo'),
(3, 'Samuel');
SAVEPOINT cliente_inserted;

INSERT INTO pedido (idPedido, idCliente, dataPedido) VALUES 
(101, 1, NOW()),
(22, 2, NOW()),
(102, 3, NOW());

COMMIT;
ROLLBACK TO SAVEPOINT cliente_inserted;

