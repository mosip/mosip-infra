class BookingSlot:
    def __init__(self, slot_date, slot_time_from, slot_time_to, registration_center, prid):
        self._slot_date = slot_date
        self._slot_time_from = slot_time_from
        self._slot_time_to = slot_time_to
        self._registration_center = registration_center
        self._prid = prid

    @property
    def slot_date(self):
        return self._slot_date

    @property
    def slot_time_from(self):
        return self._slot_time_from

    @property
    def slot_time_to(self):
        return self._slot_time_to

    @property
    def registration_center(self):
        return self._registration_center

    @property
    def prid(self):
        return self._prid
