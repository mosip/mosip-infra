package io.mosip.kafka.connect.transforms;

import org.apache.kafka.common.config.ConfigException;
import org.apache.kafka.connect.data.Date;
import org.apache.kafka.connect.data.Schema;
import org.apache.kafka.connect.data.SchemaBuilder;
import org.apache.kafka.connect.data.Struct;
import org.apache.kafka.connect.data.Time;
import org.apache.kafka.connect.data.Timestamp;
import org.apache.kafka.connect.source.SourceRecord;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;

import java.util.Calendar;
import java.util.Collections;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Map;
import java.util.TimeZone;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertThrows;

public class TimestampConverterAdvTest {
    private static final TimeZone UTC = TimeZone.getTimeZone("UTC");
    private static final Calendar EPOCH;
    private static final Calendar TIME;
    private static final Calendar DATE;
    private static final Calendar DATE_PLUS_TIME;
    private static final long DATE_PLUS_TIME_UNIX;
    private static final String DATE_PLUS_TIME_STRING_MILLI;

    private final TimestampConverterAdv<SourceRecord> xformKey = new TimestampConverterAdv.Key<>();
    private final TimestampConverterAdv<SourceRecord> xformValue = new TimestampConverterAdv.Value<>();

    static {
        EPOCH = GregorianCalendar.getInstance(UTC);
        EPOCH.setTimeInMillis(0L);

        TIME = GregorianCalendar.getInstance(UTC);
        TIME.setTimeInMillis(0L);
        TIME.add(Calendar.MILLISECOND, 1234);

        DATE = GregorianCalendar.getInstance(UTC);
        DATE.setTimeInMillis(0L);
        DATE.set(1970, Calendar.JANUARY, 1, 0, 0, 0);
        DATE.add(Calendar.DATE, 1);

        DATE_PLUS_TIME = GregorianCalendar.getInstance(UTC);
        DATE_PLUS_TIME.setTimeInMillis(0L);
        DATE_PLUS_TIME.add(Calendar.DATE, 1);
        DATE_PLUS_TIME.add(Calendar.MILLISECOND, 1234);

        DATE_PLUS_TIME_UNIX = DATE_PLUS_TIME.getTime().getTime();
        DATE_PLUS_TIME_STRING_MILLI = "1970-01-02T00:00:01.234Z";
    }


    // Configuration

    @AfterEach
    public void teardown() {
        xformKey.close();
        xformValue.close();
    }

    // Test regular: schemaless: timestamp in milli -> string : entire field

    @Test
    public void testSchemalessTimestampMilliToString() {
        Map<String, String> config = new HashMap<>();
        xformValue.configure(config);
        SourceRecord transformed = xformValue.apply(createRecordSchemaless(DATE_PLUS_TIME_UNIX));

        assertNull(transformed.valueSchema());
        assertEquals(DATE_PLUS_TIME_STRING_MILLI, transformed.value());
    }

    // Test regular: schemaless: timestamp in micro -> string : entire field

    @Test
    public void testSchemalessTimestampMicroToString() {
        Map<String, String> config = new HashMap<>();
        config.put(TimestampConverterAdv.INPUT_TYPE_CONFIG, "micro_sec");
        xformValue.configure(config);
        SourceRecord transformed = xformValue.apply(createRecordSchemaless(DATE_PLUS_TIME_UNIX*1000 + 567));

        assertNull(transformed.valueSchema());
        assertEquals(DATE_PLUS_TIME_STRING_MILLI, transformed.value());
    }

    // Test regular: schemaless: timestamp in milli -> string : Map

    @Test
    public void testSchemalessTimestampMilliToStringMap() {
        Map<String, String> config = new HashMap<>();
        Map<String, Long> input = new HashMap<>();

        config.put(TimestampConverterAdv.FIELD_CONFIG, "ts");
        input.put("ts",DATE_PLUS_TIME_UNIX);

        xformValue.configure(config);
        SourceRecord transformed = xformValue.apply(createRecordSchemaless(input));

        assertNull(transformed.valueSchema());
        assertEquals(DATE_PLUS_TIME_STRING_MILLI, ((Map<String, Long>)transformed.value()).get("ts"));
    }

    // Test regular: schemaless: timestamp in micro -> string : Map

    @Test
    public void testSchemalessTimestampMicroToStringMap() {
        Map<String, String> config = new HashMap<>();
        Map<String, Long> input = new HashMap<>();

        config.put(TimestampConverterAdv.FIELD_CONFIG, "ts");
        config.put(TimestampConverterAdv.INPUT_TYPE_CONFIG, "micro_sec");
        input.put("ts",DATE_PLUS_TIME_UNIX*1000 + 567);

        xformValue.configure(config);
        SourceRecord transformed = xformValue.apply(createRecordSchemaless(input));

        assertNull(transformed.valueSchema());
        assertEquals(DATE_PLUS_TIME_STRING_MILLI, ((Map<String, Long>)transformed.value()).get("ts"));
    }

    // test regular : schema
    @Test
    public void testWithSchemaTimestampToString() {
        Map<String, String> config = new HashMap<>();
        config.put(TimestampConverterAdv.FIELD_CONFIG, "ts");
        config.put(TimestampConverterAdv.INPUT_TYPE_CONFIG, "micro_sec");
        xformValue.configure(config);

        // ts field is a unix timestamp
        Schema structWithTimestampFieldSchema = SchemaBuilder.struct()
                .field("ts", Schema.INT64_SCHEMA)
                .field("other", Schema.STRING_SCHEMA)
                .build();
        Struct original = new Struct(structWithTimestampFieldSchema);
        original.put("ts", DATE_PLUS_TIME_UNIX*1000+567);
        original.put("other", "test");

        SourceRecord transformed = xformValue.apply(createRecordWithSchema(structWithTimestampFieldSchema, original));

        Schema expectedSchema = SchemaBuilder.struct()
                .field("ts", Schema.STRING_SCHEMA)
                .field("other", Schema.STRING_SCHEMA)
                .build();
        assertEquals(expectedSchema, transformed.valueSchema());
        assertEquals(DATE_PLUS_TIME_STRING_MILLI, ((Struct) transformed.value()).get("ts"));
        assertEquals("test", ((Struct) transformed.value()).get("other"));
    }

    // test regular : schema : days_epoch
    @Test
    public void testWithSchemaTimestampToStringDays() {
        Map<String, String> config = new HashMap<>();
        config.put(TimestampConverterAdv.FIELD_CONFIG, "ts");
        config.put(TimestampConverterAdv.INPUT_TYPE_CONFIG, "days_epoch");
        config.put(TimestampConverterAdv.OUTPUT_FORMAT_CONFIG, "yyyy-MM-dd");
        xformValue.configure(config);

        // ts field is a unix timestamp
        Schema structWithTimestampFieldSchema = SchemaBuilder.struct()
                .field("ts", Schema.INT32_SCHEMA)
                .field("other", Schema.STRING_SCHEMA)
                .build();
        Struct original = new Struct(structWithTimestampFieldSchema);
        original.put("ts", 18877);
        original.put("other", "test");

        SourceRecord transformed = xformValue.apply(createRecordWithSchema(structWithTimestampFieldSchema, original));

        Schema expectedSchema = SchemaBuilder.struct()
                .field("ts", Schema.STRING_SCHEMA)
                .field("other", Schema.STRING_SCHEMA)
                .build();
        assertEquals(expectedSchema, transformed.valueSchema());
        assertEquals("2021-09-07", ((Struct) transformed.value()).get("ts"));
        assertEquals("test", ((Struct) transformed.value()).get("other"));
    }

    // test regular : schema : only micro_seconds
    @Test
    public void testWithSchemaTimestampToStringOnlyMicro() {
        Map<String, String> config = new HashMap<>();
        config.put(TimestampConverterAdv.FIELD_CONFIG, "ts");
        config.put(TimestampConverterAdv.INPUT_TYPE_CONFIG, "micro_sec");
        config.put(TimestampConverterAdv.OUTPUT_FORMAT_CONFIG, "HH:mm:ss");
        xformValue.configure(config);

        // ts field is a unix timestamp
        Schema structWithTimestampFieldSchema = SchemaBuilder.struct()
                .field("ts", Schema.INT64_SCHEMA)
                .field("other", Schema.STRING_SCHEMA)
                .build();
        Struct original = new Struct(structWithTimestampFieldSchema);
        original.put("ts", 33300000000L);
        original.put("other", "test");

        SourceRecord transformed = xformValue.apply(createRecordWithSchema(structWithTimestampFieldSchema, original));

        Schema expectedSchema = SchemaBuilder.struct()
                .field("ts", Schema.STRING_SCHEMA)
                .field("other", Schema.STRING_SCHEMA)
                .build();
        assertEquals(expectedSchema, transformed.valueSchema());
        assertEquals("09:15:00", ((Struct) transformed.value()).get("ts"));
        assertEquals("test", ((Struct) transformed.value()).get("other"));
    }

    // Test null Value: Schemaless : timestamp -> string

    @Test
    public void testSchemalessNullValueToString() {
        testSchemalessNullValueConversion();
        testSchemalessNullFieldConversion();
    }

    private void testSchemalessNullValueConversion() {
        Map<String, String> config = new HashMap<>();
        xformValue.configure(config);
        SourceRecord transformed = xformValue.apply(createRecordSchemaless(null));

        assertNull(transformed.valueSchema());
        assertNull(transformed.value());
    }

    private void testSchemalessNullFieldConversion() {
        Map<String, String> config = new HashMap<>();
        config.put(TimestampConverterAdv.FIELD_CONFIG, "ts");
        xformValue.configure(config);
        SourceRecord transformed = xformValue.apply(createRecordSchemaless(null));

        assertNull(transformed.valueSchema());
        assertNull(transformed.value());
    }

    private SourceRecord createRecordWithSchema(Schema schema, Object value) {
        return new SourceRecord(null, null, "topic", 0, schema, value);
    }

    private SourceRecord createRecordSchemaless(Object value) {
        return createRecordWithSchema(null, value);
    }
}
