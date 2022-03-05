create or replace trigger log_add_reservation
    after insert or update
    on RESERVATION
    for each row
begin
    insert into log (reservation_id, log_date, status, no_places)
    values (:new.reservation_id, current_date, :new.status, :new.no_places);
end;