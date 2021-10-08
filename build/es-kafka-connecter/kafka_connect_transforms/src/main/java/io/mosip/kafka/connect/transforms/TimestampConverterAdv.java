package io.mosip.kafka.connect.transforms;

import org.apache.kafka.common.cache.Cache;
import org.apache.kafka.common.cache.LRUCache;
import org.apache.kafka.common.cache.SynchronizedCache;
import org.apache.kafka.connect.transforms.Transformation;
import org.apache.kafka.connect.connector.ConnectRecord;
import org.apache.kafka.common.config.ConfigDef;
import org.apache.kafka.common.config.AbstractConfig;
import org.apache.kafka.common.config.ConfigException;
import org.apache.kafka.connect.data.Field;
import org.apache.kafka.connect.data.Schema;
import org.apache.kafka.connect.data.SchemaBuilder;
import org.apache.kafka.connect.data.Struct;

import org.apache.kafka.connect.errors.DataException;


import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Date;
import java.util.TimeZone;

import io.mosip.kafka.connect.transforms.SchemaUtil;
import static io.mosip.kafka.connect.transforms.Requirements.requireMap;
import static io.mosip.kafka.connect.transforms.Requirements.requireStructOrNull;


public abstract class TimestampConverterAdv<R extends ConnectRecord<R>> implements Transformation<R> {

    private static class Config {
        String field;
        int inType;
        int outType;
        SimpleDateFormat format;

        Config(String field, int inType, int outType, SimpleDateFormat format) {
            this.field = field;
            this.inType = inType;
            this.outType = outType;
            this.format = format;
        }
    }
    private Config config;
    private Cache<Schema, Schema> schemaUpdateCache;

    private String PURPOSE = "converting timestamp formats";

    public static String FIELD_CONFIG = "field";
    public static String INPUT_TYPE_CONFIG = "input.type";
    public static String OUTPUT_TYPE_CONFIG = "output.type";
    public static String OUTPUT_FORMAT_CONFIG = "output.format";
    public static ConfigDef CONFIG_DEF = new ConfigDef()
        .define(FIELD_CONFIG, ConfigDef.Type.STRING, "", ConfigDef.Importance.HIGH, "The field containing the timestamp, or empty if the entire value is a timestamp")
        .define(INPUT_TYPE_CONFIG, ConfigDef.Type.STRING, "milli_sec", ConfigDef.Importance.HIGH, "The field containing the type of the input milli_sec(default)/micro_sec/days_epoch")
        .define(OUTPUT_TYPE_CONFIG, ConfigDef.Type.STRING, "string", ConfigDef.Importance.HIGH, "For now this field is ignored and set to string by default")
        .define(OUTPUT_FORMAT_CONFIG, ConfigDef.Type.STRING, "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", ConfigDef.Importance.HIGH, "This field contains format of the output string");

    @Override
    public void configure(Map<String, ?> configs) {
        AbstractConfig absconf = new AbstractConfig(CONFIG_DEF, configs, false);

        String field = absconf.getString(FIELD_CONFIG);
        String inType = absconf.getString(INPUT_TYPE_CONFIG);
        String outType = "string";
        String outFormatPattern = absconf.getString(OUTPUT_FORMAT_CONFIG);

        schemaUpdateCache = new SynchronizedCache<>(new LRUCache<Schema,Schema>(16));

        SimpleDateFormat format = null;
        try {
            format = new SimpleDateFormat(outFormatPattern);
            format.setTimeZone(TimeZone.getTimeZone("UTC"));
        } catch (IllegalArgumentException e) {
            throw new ConfigException("TimestampConverter requires a SimpleDateFormat-compatible pattern for string timestamps: " + outFormatPattern, e);
        }

        config = new Config(field,0,0,format);

        if(inType.equals("milli_sec")) config.inType = 0;
        else if(inType.equals("micro_sec")) config.inType = 1;
        // else if(inType.equals("nano")) config.inType = 2;
        else if(inType.equals("days_epoch")) config.inType = 10;
        else throw new ConfigException("Unknown input type : " + inType + ". Valid values are \"milli\", \"micro\" & \"days_epoch\"");
        // rest go here .. if necessary

        config.outType = 0;

    }

    @Override
    public R apply(R record) {
        if (operatingSchema(record) == null) {
            return applySchemaless(record);
        } else {
            return applyWithSchema(record);
        }
    }

    @Override
    public ConfigDef config() {
        return CONFIG_DEF;
    }

    @Override
    public void close() {
    }

    protected abstract Schema operatingSchema(R record);

    protected abstract Object operatingValue(R record);

    protected abstract R newRecord(R record, Schema updatedSchema, Object updatedValue);

    public static class Key<R extends ConnectRecord<R>> extends TimestampConverterAdv<R> {
        @Override
        protected Schema operatingSchema(R record) {
            return record.keySchema();
        }

        @Override
        protected Object operatingValue(R record) {
            return record.key();
        }

        @Override
        protected R newRecord(R record, Schema updatedSchema, Object updatedValue) {
            return record.newRecord(record.topic(), record.kafkaPartition(), updatedSchema, updatedValue, record.valueSchema(), record.value(), record.timestamp());
        }
    }

    public static class Value<R extends ConnectRecord<R>> extends TimestampConverterAdv<R> {
        @Override
        protected Schema operatingSchema(R record) {
            return record.valueSchema();
        }

        @Override
        protected Object operatingValue(R record) {
            return record.value();
        }

        @Override
        protected R newRecord(R record, Schema updatedSchema, Object updatedValue) {
            return record.newRecord(record.topic(), record.kafkaPartition(), record.keySchema(), record.key(), updatedSchema, updatedValue, record.timestamp());
        }
    }

    private Schema typeSchema(boolean isOptional){
        return isOptional ? Schema.OPTIONAL_STRING_SCHEMA : Schema.STRING_SCHEMA;
    }

    private R applyWithSchema(R record) {
        final Schema schema = operatingSchema(record);
        if (config.field.isEmpty()) {
            Object value = operatingValue(record);
            // New schema is determined by the requested target timestamp type
            // For now hardocde this to string schema
            Schema updatedSchema = typeSchema(schema.isOptional());
            return newRecord(record, updatedSchema, convertTimestamp(value, config.inType, config.format));
        } else {
            final Struct value = requireStructOrNull(operatingValue(record), PURPOSE);
            Schema updatedSchema = schemaUpdateCache.get(schema);
            if (updatedSchema == null) {
                SchemaBuilder builder = SchemaUtil.copySchemaBasics(schema, SchemaBuilder.struct());
                for (Field field : schema.fields()) {
                    if (field.name().equals(config.field)) {
                        builder.field(field.name(), typeSchema(field.schema().isOptional()));
                    } else {
                        builder.field(field.name(), field.schema());
                    }
                }
                if (schema.isOptional())
                    builder.optional();
                if (schema.defaultValue() != null) {
                    Struct updatedDefaultValue = applyValueWithSchema((Struct) schema.defaultValue(), builder);
                    builder.defaultValue(updatedDefaultValue);
                }

                updatedSchema = builder.build();
                schemaUpdateCache.put(schema, updatedSchema);
            }

            Struct updatedValue = applyValueWithSchema(value, updatedSchema);
            return newRecord(record, updatedSchema, updatedValue);
        }
    }

    private Struct applyValueWithSchema(Struct value, Schema updatedSchema) {
        if (value == null) {
            return null;
        }
        Struct updatedValue = new Struct(updatedSchema);
        for (Field field : value.schema().fields()) {
            final Object updatedFieldValue;
            if (field.name().equals(config.field)) {
                updatedFieldValue = convertTimestamp(value.get(field), config.inType, config.format);
            } else {
                updatedFieldValue = value.get(field);
            }
            updatedValue.put(field.name(), updatedFieldValue);
        }
        return updatedValue;
    }

    private R applySchemaless(R record) {
        Object rawValue = operatingValue(record);
        if (rawValue == null || config.field.isEmpty()) {
            return newRecord(record, null, convertTimestamp(rawValue, config.inType, config.format));
        } else {
            final Map<String, Object> value = requireMap(rawValue,PURPOSE);
            final HashMap<String, Object> updatedValue = new HashMap<>(value);
            updatedValue.put(config.field, convertTimestamp(value.get(config.field), config.inType, config.format));
            return newRecord(record, null, updatedValue);
        }
    }

    private String convertTimestamp(Object timestamp, int inType, SimpleDateFormat format) {
        if (timestamp == null) {
            return null;
        }

        String output;
        long tsLong;

        if(inType == 0){ // epoch milli_seconds
            tsLong = (long)timestamp;
            output = format.format(new Date(tsLong));
        }
        else if(inType == 1){ // epoch micro_seconds
            tsLong = (long)timestamp;
            output = format.format(new Date(tsLong/1000));
            // // the following is if there are more micro digits... right now ignoring
            // if((tsLong%1000) != 0) {
            //     output = output.substring(0,s.length()-1);
            //     output += (tsLong%1000);
            //     output += "Z";
            // }
        }
        else if(inType == 10){
            tsLong = (int)timestamp;
            output = format.format(new Date(tsLong*24*60*60*1000));
        }
        else{
            // it should never come here
            return "";
        }

        // System.out.println("Input: " + tsLong + "\tOutput: " + output);

        return output;
    }
}
