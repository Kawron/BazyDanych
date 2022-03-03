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
    join trip t on r.trip_id = t.trip_id
    join person p on r.person_id = p.person_id

create view trips_view as
    select t.country, t.trip_date, t.name,
           t.max_no_places, (t.max_no_places - sum(r.no_places)) as no_available_places
    from trip t
    join reservation r on r.reservation_id = t.trip_id
    group by t.country, t.trip_date, t.name, t.max_no_places

create view available_trips as
    select t.country, t.trip_date, t.name,
           t.max_no_places, (t.max_no_places - sum(r.no_places)) as no_available_places
    from trip t
    join reservation r on r.reservation_id = t.trip_id
    group by t.country, t.trip_date, t.name, t.max_no_places
    having (t.max_no_places - sum(r.no_places)) > 0

-- być może napisanie funckji jest dobrym pomysłem

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

-- funkcja sprawdzająca czy istnieje trip
create or replace function trip_exist(id in trip.trip_id%type)
    return boolean
as
    exist number;
begin
    select count(r.trip_id) into exist from reservation r where r.trip_id = id;

    if exist = 0 then
        return false;
    else
        return true;
    end if;
end;

-- main procedure
create or replace function trip_participants(trip_id int)
    return reservation_type_table
as
    result reservation_type_table;
begin
    if not trip_exist(trip_id) then
        raise_application_error(5001, 'Trip does not exist');
    end if;

    select reservation_type(t.country, t.trip_date, t.name,
       p.firstname, p.lastname, r.reservation_id,
       r.no_places, r.status)
    bulk collect
    into result
    from reservation r
    join trip t on r.trip_id = t.trip_id
    join person p on r.person_id = p.person_id
    where t.trip_id = trip_participants.trip_id;

    return result;
end;