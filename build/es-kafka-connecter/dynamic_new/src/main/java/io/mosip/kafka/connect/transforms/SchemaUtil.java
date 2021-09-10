package io.mosip.kafka.connect.transforms;

import org.apache.kafka.connect.data.Schema;
import org.apache.kafka.connect.data.SchemaBuilder;

import java.util.Map;

public class SchemaUtil {

    public static SchemaBuilder copySchemaBasics(Schema source) {
        SchemaBuilder builder;
        if (source.type() == Schema.Type.ARRAY) {
            builder = SchemaBuilder.array(source.valueSchema());
        } else {
            builder = new SchemaBuilder(source.type());
        }
        return copySchemaBasics(source, builder);
    }

    public static SchemaBuilder copySchemaBasics(Schema source, SchemaBuilder builder) {
        builder.name(source.name());
        builder.version(source.version());
        builder.doc(source.doc());

        final Map<String, String> params = source.parameters();
        if (params != null) {
            builder.parameters(params);
        }

        return builder;
    }

}
