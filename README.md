# abap-custom-logger

It is a custom made tool created to provide a simple mechanism for creating logs in any application and of any possible events.

The tool is divided here into two files, representing two classes that make up the tool itself - a logger proper and an ENUM-like class to provide a fixed list of available message types for the logger.

In order for the tool to serve its function correctly - to allow the logging of events across any chosen number of applications within a SAP system, both classes should be implemented as global ones - in SE24 transaction.

The logs are saved via a path variable of the string type provided to the save method. That string should refer to the place where the logs should be kept.
