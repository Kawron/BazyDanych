--tables
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

insert into person (firstname, lastname)
values('adam', 'kowalski');
insert into person (firstname, lastname)
values('jan', 'nowak');
select * from person;
insert into trip (name, country, trip_date, max_no_places)
values ('wycieczka do paryza','francja',to_date('2021-09-03','yyyy-mm-dd'),3);
insert into trip (name, country, trip_date, max_no_places)
values ('wycieczka do krakowa','polska',to_date('2022-12-05','yyyy-mm-dd'),2);
select * from trip;
insert into reservation(trip_id, person_id, no_places, status)
values (1,1,1,'n');
insert into reservation(trip_id, person_id, no_places, status)
values (2,1,1,'p');

-- 3.WIDOKI
create view reservations_view as
    select t.country, t.trip_date, t.name,
           p.firstname, p.lastname, r.reservation_id,
           r.no_places, r.status
    from reservation r
    join

-- 4.PROCEDURY
create or replace type reservation_type as OBJECT
(
  country varchar2(50),
  trip_date date,
  trip_name varchar2(50),
  firstname varchar2(50),
  lastname varchar2(50),
  reservation_id varchar2(50),
  no_places integer,
  status char(1)
);

create or replace type reservation_type_table is table of reservation_type;
