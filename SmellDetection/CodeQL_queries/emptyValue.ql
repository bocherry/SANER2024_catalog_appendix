/**
 * @name empty value inserted
 * @id emptyValue
 * @kind problem
 * @description Checks if an insert is performed with an empty vlaue
 */
import javascript
import mongodb_mongoose_API_tracking.mongoCall 


from MongoCall mce, ObjectExpr queryFilter
where 
    mce.getMethodName() = "insert" and
    mce.getAnArgument() = queryFilter and
    queryFilter.getAProperty().getInit().getStringValue() in ["null", "undefined", "", "''", "[]"]
select mce, "this inserts holds null values"