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