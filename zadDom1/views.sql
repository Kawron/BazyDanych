-- 3.WIDOKI
--3.1
create view reservations_view as
    select t.country, t.trip_date, t.name,
           p.firstname, p.lastname, r.reservation_id,
           r.no_places, r.status
    from reservation r
    join trip t on r.trip_id = t.trip_id
    join person p on r.person_id = p.person_id;
--3.2
 
--3.3
create view available_trips as
    select t.country, t.trip_date, t.name,
           t.max_no_places, available_places(t.trip_id) as no_available_places
    from trip t
    join reservation r on r.reservation_id = t.trip_id
    where available_places(t.trip_id) > 0;