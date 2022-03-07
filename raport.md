# Laboratorium 1 - Karol Wrona

## 1. Tabele

``` sql
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
```
``` sql
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
```
``` sql
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
```
Tabela log
``` sql
create table log
(
 log_id int generated always as identity not null
, reservation_id int
, log_date date
, status char
, no_places int
, info varchar2(50)
, constraint log_pk primary key
 (
 log_id
 )
 enable
);
alter table log
add constraint log_fk1 foreign key
(
    reservation_id
)
references RESERVATION
(
    reservation_id
)
enable;
```
## 2. Przykładowe dane

```sql
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
```

## 3. Widoki

a)
```sql
create view reservations_view as
    select t.country, t.trip_date, t.name,
           p.firstname, p.lastname, r.reservation_id,
           r.no_places, r.status
    from reservation r
    join trip t on r.trip_id = t.trip_id
    join person p on r.person_id = p.person_id;
```

b) Korzystam z pomocniczej funkcji *available_places* [Link](#1.-Tabele)
```sql
create view trips_view as
    select t.country, t.trip_date, t.name,
           t.max_no_places, available_places(t.trip_id) as no_available_places
    from trip t
    join reservation r on r.reservation_id = t.trip_id;
```