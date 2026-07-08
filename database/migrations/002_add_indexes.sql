USE hoteldb;

CREATE INDEX idx_city_created_at
ON hotel_bookings(city, created_at);

CREATE INDEX idx_org_status
ON hotel_bookings(org_id, status);

CREATE INDEX idx_booking_events_booking_id
ON booking_events(booking_id);