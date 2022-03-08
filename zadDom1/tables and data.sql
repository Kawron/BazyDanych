create table person
(
 person_id int generated always as identity not null
, firstname varchar2(50)
, lastname varchar2(50)
, constraint person_pk primary key
 (
 person_id
 )
 enable
);
create table trip
(
 trip_id int generated always as identity not null
, name varchar2(100)
, country varchar2(50)
, trip_date date
, max_no_places int
, constraint trip_pk primary key
 (
 trip_id
 )
 enable
);
create table reservation
(
 reservation_id int generated always as identity not null
, trip_id int
, person_id int
, status char(1)
, no_places int
, constraint reservation_pk primary key
 (
 reservation_id
 )
 enable
);
alter table reservation
add constraint reservation_fk1 foreign key
(
 person_id
)
references person
(
 person_id
)
enable;
alter table reservation
add constraint reservation_fk2 foreign key
(
 trip_id
)
references trip
(
 trip_id
)
enable;
alter table reservation
add constraint reservation_chk1 check
(status in ('n','p','c'))
enable;

-- more data
insert into person (firstname, lastname)
values('adam', 'kowalski');
insert into person (firstname, lastname)
values('jan', 'nowak');
insert into person (firstname, lastname)
values('maciek', 'pomidor');
insert into person (firstname, lastname)
values('adam', 'cebula');
insert into person (firstname, lastname)
values('zbigniew', 'rzodkiewka');
insert into person (firstname, lastname)
values('maria', 'cukinia');
insert into person (firstname, lastname)
values('ewa', 'truskawka');
insert into person (firstname, lastname)
values('jozef', 'gruszka');
insert into person (firstname, lastname)
values('helena', 'ogorek');
insert into person (firstname, lastname)
values('jan', 'malina');
select * from person;

insert into trip (name, country, trip_date, max_no_places)
values ('wycieczka do paryza','francja',to_date('2021-09-03','yyyy-mm-dd'),3);
insert into trip (name, country, trip_date, max_no_places)
values ('wycieczka do krakowa','polska',to_date('2022-12-05','yyyy-mm-dd'),5);
insert into trip (name, country, trip_date, max_no_places)
values ('wycieczka do berlina','niemcy',to_date('2022-10-09','yyyy-mm-dd'),3);
insert into trip (name, country, trip_date, max_no_places)
values ('wycieczka do rzymu','wlochy',to_date('2022-06-01','yyyy-mm-dd'),2);
select * from trip;

insert into reservation(trip_id, person_id, no_places, status)
values (1,1,2,'n');
insert into reservation(trip_id, person_id, no_places, status)
values (1,2,1,'p');
insert into reservation(trip_id, person_id, no_places, status)
values (1,3,3,'c');
insert into reservation(trip_id, person_id, no_places, status)
values (1,4,1,'c');
insert into reservation(trip_id, person_id, no_places, status)
values (2,5,1,'n');
insert into reservation(trip_id, person_id, no_places, status)
values (2,6,1,'p');
insert into reservation(trip_id, person_id, no_places, status)
values (4,7,1,'p');
insert into reservation(trip_id, person_id, no_places, status)
values (4,8,1,'p');
insert into reservation(trip_id, person_id, no_places, status)
values (4,9,1,'c');
insert into reservation(trip_id, person_id, no_places, status)
values (3,10,1,'p');