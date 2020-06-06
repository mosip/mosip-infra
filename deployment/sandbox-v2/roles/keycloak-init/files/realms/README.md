* The parameter "accessCodeLifespan" has been increased from it's default value of 60 (seconds) to 7200.  The API calls would return a 401 unauthorized access if this time is exceeded.

* Access token life span and SSO Session Idle timeout increased to 1 day for perf testing.
