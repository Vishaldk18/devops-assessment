USE hoteldb;

DELIMITER $$

DROP PROCEDURE IF EXISTS seed_hotel_bookings $$

CREATE PROCEDURE seed_hotel_bookings()
BEGIN
    DECLARE i INT DEFAULT 1;

    DECLARE booking_uuid CHAR(36);
    DECLARE org_uuid CHAR(36);
    DECLARE city_name VARCHAR(100);
    DECLARE hotel_name VARCHAR(100);
    DECLARE booking_status VARCHAR(50);

    WHILE i <= 150 DO

        SET booking_uuid = UUID();

        -- Random Organization
        SET org_uuid = ELT(
            FLOOR(1 + RAND() * 5),
            '11111111-1111-1111-1111-111111111111',
            '22222222-2222-2222-2222-222222222222',
            '33333333-3333-3333-3333-333333333333',
            '44444444-4444-4444-4444-444444444444',
            '55555555-5555-5555-5555-555555555555'
        );

        -- Random Hotel
        SET hotel_name = ELT(
            FLOOR(1 + RAND() * 5),
            'TAJ_DELHI',
            'OBEROI_MUMBAI',
            'JW_MARRIOTT_PUNE',
            'ITC_GARDENIA',
            'HYATT_HYDERABAD'
        );

        -- Random City
        SET city_name = ELT(
            FLOOR(1 + RAND() * 5),
            'delhi',
            'mumbai',
            'pune',
            'bangalore',
            'hyderabad'
        );

        -- Random Booking Status
        SET booking_status = ELT(
            FLOOR(1 + RAND() * 4),
            'CONFIRMED',
            'PENDING',
            'CANCELLED',
            'COMPLETED'
        );

        INSERT INTO hotel_bookings (
            id,
            org_id,
            hotel_id,
            city,
            checkin_date,
            checkout_date,
            amount,
            status,
            created_at
        )
        VALUES (
            booking_uuid,
            org_uuid,
            hotel_name,
            city_name,
            CURDATE() + INTERVAL FLOOR(RAND() * 20) DAY,
            CURDATE() + INTERVAL FLOOR(21 + RAND() * 20) DAY,
            ROUND(1000 + RAND() * 9000, 2),
            booking_status,
            NOW() - INTERVAL FLOOR(RAND() * 30) DAY
        );

        -- Create booking event for around 70% of bookings
        IF RAND() > 0.30 THEN

            INSERT INTO booking_events (
                booking_id,
                event_type,
                payload,
                created_at
            )
            VALUES (
                booking_uuid,
                'BOOKING_CREATED',
                JSON_OBJECT(
                    'source', 'website',
                    'status', booking_status
                ),
                NOW()
            );

        END IF;

        SET i = i + 1;

    END WHILE;

END $$

DELIMITER ;

CALL seed_hotel_bookings();

DROP PROCEDURE seed_hotel_bookings;