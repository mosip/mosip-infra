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

public class DynamicNewFieldTest {
    private final DynamicNewField<SourceRecord> xformValue = new DynamicNewField.Value<>();

    @AfterEach
    public void teardown() {
        xformValue.close();
    }

    // test regular : schema
    @Test
    public void testWithSchema() {
        Map<String, String> config = new HashMap<>();
        config.put(DynamicNewField.ES_URL_CONFIG, "http://elasticsearch-master.cattle-logging-system:9200");
        config.put(DynamicNewField.ES_INDEX_CONFIG, "reg_cen");
        config.put(DynamicNewField.ES_INPUT_FIELDS_CONFIG, "id,lang_code");
        config.put(DynamicNewField.ES_OUTPUT_FIELD_CONFIG, "name");
        config.put(DynamicNewField.INPUT_FIELDS_CONFIG, "regcntr_id,lang_code");
        config.put(DynamicNewField.OUTPUT_FIELD_CONFIG, "regcntr_name");

        xformValue.configure(config);

        // ts field is a unix timestamp
        Schema structWithTimestampFieldSchema = SchemaBuilder.struct()
                .field("regcntr_id", Schema.STRING_SCHEMA)
                .field("lang_code", Schema.STRING_SCHEMA)
                .field("other", Schema.STRING_SCHEMA)
                .build();
        Struct original = new Struct(structWithTimestampFieldSchema);
        original.put("regcntr_id", "10001");
        original.put("lang_code", "fra");
        original.put("other", "test");

        SourceRecord transformed = xformValue.apply(createRecordWithSchema(structWithTimestampFieldSchema, original));

        Schema expectedSchema = SchemaBuilder.struct()
                .field("regcntr_id", Schema.STRING_SCHEMA)
                .field("lang_code", Schema.STRING_SCHEMA)
                .field("other", Schema.STRING_SCHEMA)
                .field("regcntr_name", Schema.STRING_SCHEMA)
                .build();
        assertEquals(expectedSchema, transformed.valueSchema());
        assertEquals("10001", ((Struct) transformed.value()).get("regcntr_id"));
        assertEquals("fra", ((Struct) transformed.value()).get("lang_code"));
        assertEquals("REGCEN12", ((Struct) transformed.value()).get("regcntr_name"));
        assertEquals("test", ((Struct) transformed.value()).get("other"));
    }

    // Test null Value: Schemaless : timestamp -> string
    // Not working somehow
    @Test
    public void testSchemalessNullField() {
        Map<String, String> config = new HashMap<>();
        config.put(DynamicNewField.ES_URL_CONFIG, "http://elasticsearch-master.cattle-logging-system:9200");
        config.put(DynamicNewField.ES_INDEX_CONFIG, "reg_cen");
        config.put(DynamicNewField.ES_INPUT_FIELDS_CONFIG, "id");
        config.put(DynamicNewField.ES_OUTPUT_FIELD_CONFIG, "name");
        config.put(DynamicNewField.INPUT_FIELDS_CONFIG, "regcntr_id");
        config.put(DynamicNewField.OUTPUT_FIELD_CONFIG, "regcntr_name");

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
