package io.mosip.kafka.connect.transforms;

import org.apache.kafka.common.config.ConfigException;
import org.apache.kafka.connect.errors.DataException;
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

public class TimestampSelectorTest {
    private final TimestampSelector<SourceRecord> xformValue = new TimestampSelector.Value<>();

    @AfterEach
    public void teardown() {
        xformValue.close();
    }

    // test regular : schema
    @Test
    public void testWithSchema() {
        Map<String, String> config = new HashMap<>();
        config.put(TimestampSelector.TS_ORDER_CONFIG, "ts2,ts1");
        config.put(TimestampSelector.OUTPUT_FIELD_CONFIG, "ts3");

        xformValue.configure(config);

        // ts field is a unix timestamp
        Schema structWithTimestampFieldSchema = SchemaBuilder.struct()
                .field("ts1", Schema.STRING_SCHEMA)
                .field("ts2", Schema.STRING_SCHEMA)
                .field("other", Schema.STRING_SCHEMA)
                .build();
        Struct original = new Struct(structWithTimestampFieldSchema);
        original.put("ts1", "2021-09-13T11:06:09.108Z");
        original.put("ts2", "2021-12-12T11:06:09.108Z");
        original.put("other", "test");

        SourceRecord transformed = xformValue.apply(createRecordWithSchema(structWithTimestampFieldSchema, original));

        Schema expectedSchema = SchemaBuilder.struct()
                .field("ts1", Schema.STRING_SCHEMA)
                .field("ts2", Schema.STRING_SCHEMA)
                .field("other", Schema.STRING_SCHEMA)
                .field("ts3", Schema.STRING_SCHEMA)
                .build();
        assertEquals(expectedSchema, transformed.valueSchema());
        assertEquals("2021-09-13T11:06:09.108Z", ((Struct) transformed.value()).get("ts1"));
        assertEquals("2021-12-12T11:06:09.108Z", ((Struct) transformed.value()).get("ts2"));
        assertEquals("test", ((Struct) transformed.value()).get("other"));
        assertEquals("2021-12-12T11:06:09.108Z", ((Struct) transformed.value()).get("ts3"));
    }

    @Test
    public void testWithSchemaOneNull(){
        Map<String, String> config = new HashMap<>();
        config.put(TimestampSelector.TS_ORDER_CONFIG, "ts2,ts1");
        config.put(TimestampSelector.OUTPUT_FIELD_CONFIG, "ts3");

        xformValue.configure(config);

        // ts field is a unix timestamp
        Schema structWithTimestampFieldSchema = SchemaBuilder.struct()
                .field("ts1", Schema.STRING_SCHEMA)
                .field("other", Schema.STRING_SCHEMA)
                .build();
        Struct original = new Struct(structWithTimestampFieldSchema);
        original.put("ts1", "2021-09-13T11:06:09.108Z");
        original.put("other", "test");

        SourceRecord transformed = xformValue.apply(createRecordWithSchema(structWithTimestampFieldSchema, original));

        Schema expectedSchema = SchemaBuilder.struct()
                .field("ts1", Schema.STRING_SCHEMA)
                .field("other", Schema.STRING_SCHEMA)
                .field("ts3", Schema.STRING_SCHEMA)
                .build();
        assertEquals(expectedSchema, transformed.valueSchema());
        assertEquals("2021-09-13T11:06:09.108Z", ((Struct) transformed.value()).get("ts1"));
        assertThrows(DataException.class, () -> {((Struct) transformed.value()).get("ts2");});
        assertEquals("test", ((Struct) transformed.value()).get("other"));
        assertEquals("2021-09-13T11:06:09.108Z", ((Struct) transformed.value()).get("ts3"));
    }

    // Test null Value: Schemaless : timestamp -> string
    @Test
    public void testSchemalessNullField() {
        Map<String, String> config = new HashMap<>();
        config.put(TimestampSelector.TS_ORDER_CONFIG, "ts2,ts1");
        config.put(TimestampSelector.OUTPUT_FIELD_CONFIG, "ts3");

        xformValue.configure(config);

        // ts field is a unix timestamp
        Schema structWithTimestampFieldSchema = SchemaBuilder.struct()
                .field("other", Schema.STRING_SCHEMA)
                .build();
        Struct original = new Struct(structWithTimestampFieldSchema);
        original.put("other", "test");

        assertThrows(DataException.class, () -> {
            SourceRecord transformed = xformValue.apply(createRecordWithSchema(structWithTimestampFieldSchema, original));
        });
    }

    private SourceRecord createRecordWithSchema(Schema schema, Object value) {
        return new SourceRecord(null, null, "topic", 0, schema, value);
    }

    private SourceRecord createRecordSchemaless(Object value) {
        return createRecordWithSchema(null, value);
    }
}
