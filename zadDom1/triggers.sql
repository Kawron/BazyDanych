create or replace trigger log_add_reservation
    after insert
    on RESERVATION
    for each row
begin
    insert into log (reservation_id, log_date, status, no_places, INFO)
    values (:new.reservation_id, current_date, :new.status, :new.no_places, 'add reservation');
end;

create or replace trigger log_modify_reservation
    after update
    on RESERVATION
    for each row
begin
    if :new.status <> :old.status then
        insert into log (RESERVATION_ID, LOG_DATE, STATUS, NO_PLACES, INFO)
        values (:new.reservation_id, current_date, :new.status, :new.no_places, 'changed status');
    elsif :new.no_places <> :old.no_places then
        insert into log (RESERVATION_ID, LOG_DATE, STATUS, NO_PLACES, INFO)
        values (:new.reservation_id, current_date, :new.status, :new.no_places, 'changed no_places');
    end if;
end;

create or replace trigger reservation_add_trigger
    before insert
    on RESERVATION
    for each row
declare
    trip_start date;
begin
    select t.trip_date into trip_start
    from TRIP t where t.TRIP_ID = :new.trip_id;

    if available_places(:new.trip_id) < :new.no_places then
        RAISE_APPLICATION_ERROR(-20000, 'Not enough places');
    elsif current_date > trip_start then
--         RAISE_APPLICATION_ERROR(-20000, 'The trip already started');
        DBMS_OUTPUT.PUT_LINE('Uwaga wycieczka juz sie zaczeła');
    end if;
end;

create or replace trigger change_status_trigger
    before insert
    on RESERVATION
    for each row
declare
    places int;
    trip_id int;
begin
    select r.no_places, r.trip_id into places, trip_id
    from reservation r
    where r.reservation_id = :new.reservation_id;

    if :new.status = 'c' and places > available_places(:new.trip_id) then
        raise_application_error(-20000, 'Not enough available places');
    elsif instr('cpn', :new.status) = 0 then
        raise_application_error(-2000, 'Incorrect status');
    end if;

end;

create or replace trigger modify_reservation_trigger
    before insert
    on RESERVATION
    for each row
declare
    trip_id int;
begin
    select r.trip_id into trip_id
    from reservation r
    where r.reservation_id = :new.reservation_id;

    if :new.no_places > available_places(trip_id) then
        raise_application_error(-20000,'Not enough places');
    end if;
end;

create or replace trigger modify_max_places
    before insert
    on RESERVATION
    for each row
declare
    reserved_places int;
    current_max int;
begin
    select max_no_places into current_max
    from trip t
    where t.trip_id = :new.trip_id;

    reserved_places := current_max - available_places(:new.trip_id);

    if :new.no_places < reserved_places then
        raise_application_error(-20000,'New max_no_places is lower then ongoing reservations');
    end if;
end;