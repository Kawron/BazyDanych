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
    join person p on r.person_id = p.person_id;

create view trips_view as
    select t.country, t.trip_date, t.name,
           t.max_no_places, (t.max_no_places - sum(r.no_places)) as no_available_places
    from trip t
    join reservation r on r.reservation_id = t.trip_id
    group by t.country, t.trip_date, t.name, t.max_no_places;

create view available_trips as
    select t.country, t.trip_date, t.name,
           t.max_no_places, (t.max_no_places - sum(r.no_places)) as no_available_places
    from trip t
    join reservation r on r.reservation_id = t.trip_id
    group by t.country, t.trip_date, t.name, t.max_no_places
    having (t.max_no_places - sum(r.no_places)) > 0;

-- być może napisanie funckji jest dobrym pomysłem

-- 4.PROCEDURY
create or replace type reservation_type as OBJECT
(
  country varchar2(50),
  trip_date date,
  trip_name varchar2(50),
  firstname varchar2(50),
  lastname varchar2(50),
  reservation_id int,
  no_places int,
  status char(1)
);

create or replace type reservation_type_table is table of reservation_type;

-- funkcja sprawdzająca czy istnieje trip
create or replace function trip_exist(trip_id in trip.trip_id%type)
    return boolean
as
    exist number;
begin
    select count(r.trip_id) into exist from reservation r where r.trip_id = trip_exist.trip_id;

    if exist = 0 then
        return false;
    else
        return true;
    end if;
end;

-- funckja sprawdzająca czy istnieje osoba
create or replace function person_exist(person_id in person.person_id%type)
    return boolean
as
    exist number;
begin
    select count(p.person_id) into exist from person p where p.person_id = person_exist.person_id;

    if exist = 0 then
        return false;
    else
        return true;
    end if;
end;

-- 1
create or replace function trip_participants(trip_id int)
    return reservation_type_table
as
    result reservation_type_table;
begin
    if not trip_exist(trip_id) then
        raise_application_error(-20000, 'Trip does not exist');
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
--2
create or replace function person_reservations(person_id int)
    return reservation_type_table
as
    result reservation_type_table;
begin
    if not person_exist(person_id) then
        raise_application_error(-20000, 'Person does not exist');
    end if;

    select reservation_type(t.country, t.trip_date, t.name,
       p.firstname, p.lastname, r.reservation_id,
       r.no_places, r.status)
    bulk collect
    into result
    from person p
    join reservation r on p.person_id = r.person_id
    join trip t on t.trip_id = r.trip_id
    where p.person_id = person_reservations.person_id;

    return result;
end;

--3
create or replace type available_trip as OBJECT
(
    trip_id int,
    trip_name varchar2(50),
    country varchar2(50),
    trip_date date,
    available_places int
);

create or replace type available_trip_table is table of available_trip;

create or replace function available_places(trip_id int)
    return int
as
    result int;
begin
    select (t.max_no_places - sum(r.no_places)) as amount into result
    from trip t
    join reservation r on t.TRIP_ID = r.TRIP_ID
    where t.trip_id = available_places.trip_id and r.STATUS <> 'C'
    group by t.MAX_NO_PLACES;

    return result;
end;

create or replace function available_trips_to(country varchar2, date_from date, date_to date)
    return available_trip_table
as
    result available_trip_table;
begin
    select available_trip(t.trip_id, t.name, t.country, t.trip_date, available_places(t.trip_id))
    bulk collect into result
    from trip t
    where t.country = available_trips_to.COUNTRY and
          t.trip_date between date_from and date_to;

    return result;
end;

-- to do:
-- użyć w widokach funckji available_places
-- kontrola argumentów w available_trips_to

--5

--5.1
-- add funckja czy odbyła się
create or replace procedure add_reservation(trip_id int, person_id int, no_places int)
as
begin
    if available_places(trip_id) < no_places then
        RAISE_APPLICATION_ERROR(-20000, 'Not enough places');
    end if;
    if not trip_exist(trip_id) then
        RAISE_APPLICATION_ERROR(-20000, 'Trip does not exist');
    end if;
    if not person_exist(person_id) then
        RAISE_APPLICATION_ERROR(-20000, 'Person does not exist');
    end if;

    insert into reservation(trip_id, person_id, status, no_places)
        values (trip_id, person_id, 'n', no_places);
end;
--5.2

-- dodać wszędzie elseif

create or replace procedure modify_reservation(reservation_id int, status char)
as
    places int;
    trip_id int;
begin
    select r.no_places, r.trip_id into places, trip_id
    from reservation r
    where r.reservation_id = modify_reservation.reservation_id;

    if status = 'c' and places > available_places(trip_id) then
        raise_application_error(-20000, 'Not enough available places');
    end if;
    -- spr czy istnije rezerwacja
    if status <> 'c' and status <> 'n' and status <> 'p' then
        raise_application_error(-2000, 'Incorrect status');
    end if;

    update reservation
        set status = modify_reservation.status
    where reservation_id = modify_reservation.reservation_id;
end;

--5.3

create or replace procedure modify_reservation(reservation_id int, no_places int)
as
    trip_id int;
begin
    select r.trip_id into trip_id
    from reservation r
    where r.reservation_id = modify_reservation.reservation_id;

    if no_places < 1 or no_places > available_places(trip_id) then
        raise_application_error(-20000,'Not enough places');
    end if;

    update reservation
        set no_places = modify_reservation.no_places
    where reservation_id = modify_reservation.reservation_id;
end;

create or replace procedure modify_max_places(trip_id int, no_places int)
as
    reserved_places int;
    current_max int;
begin
    select max_no_places into current_max
    from trip t
    where t.trip_id = modify_max_places.trip_id;

    reserved_places = current_max - available_places(trip_id);

    if no_places < reserved_places then
        raise_application_error(-20000,'New no_places is lower then ongoing reservations');
    end if;

    update trip
        set max_no_places = no_places
    where trip_id = modify_max_places.trip_id;
end;