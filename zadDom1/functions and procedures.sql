-- Procedury i funkcje

-- typy

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

create or replace type available_trip as OBJECT
(
    trip_id int,
    trip_name varchar2(50),
    country varchar2(50),
    trip_date date,
    available_places int
);

create or replace type available_trip_table is table of available_trip;

-- pomocnicze

create or replace function trip_exist(trip_id int)
    return boolean
as
    exist number;
begin
    select count(r.trip_id) into exist
    from reservation r
    where r.trip_id = trip_exist.trip_id;

    if exist = 0 then
        return false;
    else
        return true;
    end if;
end;

create or replace function person_exist(person_id int)
    return boolean
as
    exist number;
begin
    select count(p.person_id) into exist
    from person p
    where p.person_id = person_exist.person_id;

    if exist = 0 then
        return false;
    else
        return true;
    end if;
end;

create or replace function reservation_exist(reservation_id int)
    return boolean
as
    exist number;
begin
    select count(r.reservation_id) into exist
    from reservation r
    where r.reservation_id = reservation_exist.reservation_id;

    if exist = 0 then
        return false;
    else
        return true;
    end if;
end;

create or replace function country_exist(country varchar2(50))
    return boolean
as
    exist number;
begin
    select count(t.country) into exist
    from trip t
    where t.country = country_exist.country;

    if exist = 0 then
        return false;
    else
        return true;
    end if;
end;

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

-- Wlasciwe funckje i procedury

--4.a
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
--4.b
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

--4.c

create or replace function available_trips_to(country varchar2, date_from date, date_to date)
    return available_trip_table
as
    result available_trip_table;
begin
    if not country_exist(country) then
        raise_application_error(-20000, 'There is no trip to this destination');
    ElSIF date_from > date_to then
        raise_application_error(-20000, 'Incorrect date');
    end if;

    select available_trip(t.trip_id, t.name, t.country, t.trip_date, available_places(t.trip_id))
    bulk collect into result
    from trip t
    where t.country = available_trips_to.COUNTRY and
          t.trip_date between date_from and date_to;

    return result;
end;

--5.1
create or replace procedure add_reservation(trip_id int, person_id int, no_places int)
as
    trip_start date;
begin
    select t.trip_date into trip_start
    from TRIP t where t.TRIP_ID = add_reservation.trip_id;

    if available_places(trip_id) < no_places then
        RAISE_APPLICATION_ERROR(-20000, 'Not enough places');
    elsif not trip_exist(trip_id) then
        RAISE_APPLICATION_ERROR(-20000, 'Trip does not exist');
    elsif person_exist(person_id) then
        RAISE_APPLICATION_ERROR(-20000, 'Person does not exist');
    elsif current_date > trip_start then
        RAISE_APPLICATION_ERROR(-20000, 'The trip already started');
    end if;

    insert into reservation(trip_id, person_id, status, no_places)
        values (trip_id, person_id, 'n', no_places);
end;
--5.2
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
    elsif not reservation_exist(reservation_id) then
        raise_application_error(-20000, 'Reservation does not exist');
    elsif instr('cpn', status) = 0 then
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

    if no_places > available_places(trip_id) then
        raise_application_error(-20000,'Not enough places');
    elsif not reservation_exist(trip_id) then
        raise_application_error(-20000, 'Reservation does not exist');
    end if;

    update reservation
        set no_places = modify_reservation.no_places
    where reservation_id = modify_reservation.reservation_id;
end;

--5.4
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
        raise_application_error(-20000,'New max_no_places is lower then ongoing reservations');
    elsif not trip_exist(trip_id) then
        raise_application_error(-20000, 'Trip does not exist');
    end if;

    update trip
        set max_no_places = no_places
    where trip_id = modify_max_places.trip_id;
end;