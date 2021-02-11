## Source
The chart used here is a modification of
webcenter/activemq:latest  on Docker Hub. 

## Documentation bug

The parameters mentioned in documentation is incorret.  Here are some params from the code inside `/opt/activemq`:

```
  # We set the main parameters
        self.do_setting_activemq_main(os.getenv('ACTIVEMQ_NAME', 'localhost'),
                                            os.getenv('ACTIVEMQ_PENDING_MESSAGE_LIMIT', '1000'),
                                            os.getenv('ACTIVEMQ_STORAGE_USAGE', '100 gb'),
                                            os.getenv('ACTIVEMQ_TEMP_USAGE', '50 gb'),
                                            os.getenv('ACTIVEMQ_MAX_CONNECTION', '1000'),
                                            os.getenv('ACTIVEMQ_FRAME_SIZE', '104857600'),
                                            os.getenv('ACTIVEMQ_STATIC_TOPICS'), os.getenv('ACTIVEMQ_STATIC_QUEUES'),
                                            os.getenv('ACTIVEMQ_ENABLED_SCHEDULER', 'true'),
                                            os.getenv('ACTIVEMQ_ENABLED_AUTH', 'false'))

        # We setting wrapper
        self.do_setting_activemq_wrapper(os.getenv('ACTIVEMQ_MIN_MEMORY', '128'),
                                               os.getenv('ACTIVEMQ_MAX_MEMORY', '1024'))
```

## Modification
The following was modified in original docker:
In `/app/entrypoint/Init.py` a statement was added to modify `/opt/activemq/conf.tmp/jetty.xml` webconsole `contextPath` to `activemq/admin`.  This makes the console accessible with `<sandbox domain name>/activemq/admin` rather than `<sandbox domain name>/admin`.

