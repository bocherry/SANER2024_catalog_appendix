
# Aggregations
### Lookup without matching index
During an aggregation framework, a lookup is performed on an attribute which has not been indexed. This can result in a performance drop.
### Too many aggregation stages
When there are too many stages in an aggregation. This can hinder code readability.
### Map-reduce for projection
When the dedicated map-reduce function is used. It is non-optimal compared to the aggregation framework.

# Design Oversights
## Application
### Immortal cursor
When a cursor is not properly closed after a query is performed. This can lead to memory issues.
### No dependency injector
When not using a dedicated dependency injector. This can hinder general project maintainability
### Querying too much data
When not using every attributes retrieved by a query (*i.e* specified in the projection part). This can lead to performance and memory overhead.
### Testing only CRUD operations
When limiting testing only the CRUD operations. This results in shallow test coverage.
### Testing queries on the entire ad-hoc big data lake
When performing the test suite on the entire big data lake instead of a dedicated subset. This can result in a global performance drop.
### The single person bridge
When simulating a SQL sequence using a dedicated document and findAndModify/findAthis results inndUpdate methods. This can lead to lower performances as documents are write lock.
## Schema
### Bloated documents
When inserting too large documents in a collection. This can hinder performance and maintainability
### Data oriented instead of application oriented
When modelling the data first without regards on the accessing part (*i.e* as in relational modelling). This results in decreased performance and maintainability.
### Flat Raw Data
When a collection lacks embedding and tends to have its data on the same depth level. This can hinder code readability.
### Inconsistent attribute structure
When using inconsistent attribute structure across the project. It can result in decreased maintainability and sometimes not retrieving the intended data (*e.g.* when dealing with nested attributes).
### Repeated immutable data
When documents are inserted with a recurring immutable data in it, (*e.g.* a complete user configuration). It could indicate the need to move this specific data into another collection.
### Storage of easily calculated values
When storing attributes values which can be easily computed from other ones. This results in storage overhead.
### Too many collections
When having too much collections inside a project. This can lead to decreased maintainability.
### Multiple Schemas in a file
When declaring multiple Mongoose Schema inside a single file. This can lead to a decreased code readability.
### Unbound arrays
When letting a document array grow without limit. This can hurt performance & storage as the arrays is more expensive to access and may reach the document size limit.
### Using a Document only for id field
When using only a document id fields. This is inefficient compared to the index mechanism.
## Index
### Abusive use of indexes
When using too many indexes. This can result in storage overhead and general query performance drop.
### Index intersection rather than compound index
When using multiple attributes that are separately indexed. This results in performance decline compared to a compound index.
### Non-ESR (Equality, Sort, Range) compound index 
When not respecting the ESR rule for compound index. A compound index order should reflect the usage in a query (first the attribute on which the equality is performed, then the one for sorting and then the one for the range) for better performances
### Prefix index of compound indexes
When an index is declared both individually and as a prefix of a compound index. This can lead to memory overhead.
# Performance/Memory
### Large read-ahead
When having a too large read-ahead setting. This can result in a memory overhead and may evict other data used by your application.
### Large WTC (WiredTiger Cache)
When having a too large WTC setting. This can hinder performance as fewer memory is left for file buffering
### Multiple "mongod" instances
When having multiple mongod instances running on the same environment. This can cause memory overhead, higher CPU consumption and hinder code maintenance as all the instances will be competing for the same computing resources.
### Running MongoDB in a shared environment
When running MongoDB (more specifically mongod instances) on a shared environment. This can prevent MongoDB from accessing the required resources and thus resulting in performance drop.
### Running MongoDB on 32-bit systems
MongoDB (more specifically mongod instances) on a 32-bits environment. This results in storage limitation (2GB) and is deprecated by the official MongoDB API.
### Unlimited mongos taskExecutor in a container
When not setting properly the number of taskExecutor of a mongos instance. This can result in performance issue as mongos may endlessly create taskExecutor threads and certain Kubernetes Pods may create even more mongos processes. 
### Using fast writes
When using MongoDB in fast writes enabled. This can result in inconsistency as query results are returned before being written to the database.
### Using GridFS for small binary data
When using GridFS to store small binary data. This result in performance overhead as the GridFS actually performs 2 queries to retrieve a file.
# Sharding
### Low-cardinality shard key
When defining a low-cardinality attribute as a collection shard key. This can result in decreased performances as the data won't be evenly distributed between the data shards.
### Monotonically increasing shard key
When using a Monotonically increasing shard key (*e.g.* counter or ObjectID). This can cause a performance drop as all new documents will be inserted into the same shard resulting into in a non-evenly data distribution.
### Premature sharding
When using sharding for a relatively little data set. This can result in performance drop as other solution (*i.e.* replica set)
### Scatter-gather queries
When using scatter-gather queries in a sharded environment. This can hurt the performance as those queries do not scale linearly with the number of shards.
### Unshardable collection 
When using collection not containing good shard keys candidates. This can hurt performance as sharding is the prefered way of scaling a MongoDB database.
### Working set exceeds memory
When having the MongoDB working set exceeding the memory. This can cause performance drop as MongoDB is designed to run with the working set in memory.
# Backup
### Manual backup
When performing backup manually instead of automatically. This can introduce vulnerability by potentially undermining consistency.
### No backup budget
When not performing backup for budget considerations. This exposes the MongoDB data to irremediable loss.
### Replicas as backup
When using a replica set as a backup environment. This introduces new risks as the replica set won't allow to restore a previous version as they are based onto a leader-follower architecture.

# Query
### Avoid large skips
When using too large skips (*e.g.* for pagination). Those can poorly impact performance.
### Avoid $where operator
When using this $where operator. This creates a code vulnerability as it allows arbitrary JS code execution and hinder performance as it prevents from using indexes.
### Case-insensitive queries without matching indexes
When using a case-insensitive queries without matching (case-insensitive) indexes. This may lead to the failure to retrieve the intended data.
### Confusing null & undefined values
When using an unthis results indefined value for an attribute in an inserted document. This can hinder the code readability as those values are deprecated in BSON, which is the internal MongoDB data format.
### Leading wildcard  searches on indexed columns
When using a leading wildcard to query an indexed column. This can decrease the general performance as it results in a complete collection instead of an index scan.
### Using $limit without $sort
When using a $limit operator without a $sort one. This can hinder code maintainability as it results in a non-deterministic behavior.
#### Using $map, $reduce and $filter with array fields
When using a uses a $map or $reduce or $filter operator. This can decrease the general performance as it is slower than its projection counterpart.
### Negation in queries
When using negation in a query. This can poorly impact performance as it results in a complete collection scan.
### No $elemMatch to match an entire array
When matching an entire array and not using an $elemMatch operator. This can result in performance drop.
### Single update/insert for batches
When not using the right filters operators while updating a whole collection. This can hinder query performance.
### Sorted Monkeys
When using a $push operator alongside a $slice or $sort one. This can result in performance drop as it replaces the whole array instead of updating it.
### Uncovered queries
When querying an attribute which has not been indexed. This can result in a performance drop due to an entire collection scan (instead of an index scan which is slower).
# Security
### Forgetting to tie down MongoDB's attack surface
When not applying recommended security setting to a MongoDB environment. This increases the risk as default setting exposes the project.
### Improper user credential storage
When hard coding the username & password credential into the project and letting the project public. This makes the database vulnerable 
### No database access control 
When not setting up access control to the database. This increases the project vulnerability
### No database user policy 
When not setting up a multi-user access policy to the database. This can increase security risk.
### No input sanitizing
When user input is not properly sanitized, particularly when the data is utilized in a query. It introduces a security vulnerability, potentially resulting in NoSQL injection
### No security patches
When not performing regular patches to keep up with MongoDB vulnerabilities and fixes. This exposes the security of the project.
### Not using LDAP for passwords rotations
When not setting up an LDAP to automatically apply company role changes. This creates security vulnerability
### Server without authentication
When not setting an authentication on a deployed MongoDB server (it has none by default). It increases the risk of undesired database accesses. 
### Too much network exposure
When not limiting network access to the MongoDB environment to a system whitelist. This can expose the project security.
### Unencrypted communication
When not properly setting the communication encryption with a TLS/SSL configuration. This exposes the database communication to the network.
### Unencrypted data
When not encrypting the project data in storage. This could sensitive information, would the security protection be breached.
### Using basic passwords
When not having a complex password. This increase the system vulnerability as MongoDB does not offer a lock-out functionality
### Using default Mongod ports
When not changing the port on a MongoDB instance. This increase the security risk as those are known by the attackers
### Using unofficial packages
When not using official MongoDB drivers. This increases the risks as the pack might not be up to date with the current fix & vulnerabilities.
# Relational design ghosts
### Relying on transactions
When using transaction to insert related data. Their usage is a sign of breaking up related data between different collections, which could harm project maintainability.
### Separating data accessed together
When separating (*i.e.* storing in different collections) data that is accessed together. This could negatively impact performance as such modelling requires the use of $lookup operators, which are slow and resources-intensive.
### Storage of empty values
When storing attributes with empty values (*e.g.* empty string, null) instead of omitting those attributes. This could cause storage overhead or hurt maintenance effort as it complicates queries.
### Use of relational collections
When using collections as pivot table, which is accessing a collection only to access another one. This can cause performance issue as it require the usage of chained $lookup operators, which are slow and resource-intensive.
# Human-oriented decisions
### Bias toward access patterns
When having a bias towards general access patterns instead of having a project-specific approach. This can cause performance issues as MongoDB database accesses projects should be designed with performance in mind.
### Human-readable values
When fostering human readability over machine optimization when it comes to attribute format decision. This can cause performance and storage overhead.
### Too long attribute names
When failing to set a limit to attribute names length. As attributes names are stored in inserted documents, this can take storage overhead.
### Too long document keys
When using excessively long document keys (*e.g.* UUID). This can cause performance and storage issues as these extended keys can lead to the creation of larger indexes.
### Using $-prefixed fields
When using $-prefixed fields. This will result in an error in the MongoDB system.


