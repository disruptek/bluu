
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: SqlManagementClient
## version: 2017-03-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Azure SQL Database management API provides a RESTful set of web APIs that interact with Azure SQL Database services to manage your databases. The API enables users to create, retrieve, update, and delete databases, servers, and other entities.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_567658 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567658](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567658): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "sql-longTermRetention"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LongTermRetentionBackupsListByLocation_567880 = ref object of OpenApiRestCall_567658
proc url_LongTermRetentionBackupsListByLocation_567882(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/longTermRetentionBackups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LongTermRetentionBackupsListByLocation_567881(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the long term retention backups for a given location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   locationName: JString (required)
  ##               : The location of the database
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568055 = path.getOrDefault("subscriptionId")
  valid_568055 = validateParameter(valid_568055, JString, required = true,
                                 default = nil)
  if valid_568055 != nil:
    section.add "subscriptionId", valid_568055
  var valid_568056 = path.getOrDefault("locationName")
  valid_568056 = validateParameter(valid_568056, JString, required = true,
                                 default = nil)
  if valid_568056 != nil:
    section.add "locationName", valid_568056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   databaseState: JString
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  ##   onlyLatestPerDatabase: JBool
  ##                        : Whether or not to only get the latest backup for each database.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568057 = query.getOrDefault("api-version")
  valid_568057 = validateParameter(valid_568057, JString, required = true,
                                 default = nil)
  if valid_568057 != nil:
    section.add "api-version", valid_568057
  var valid_568071 = query.getOrDefault("databaseState")
  valid_568071 = validateParameter(valid_568071, JString, required = false,
                                 default = newJString("All"))
  if valid_568071 != nil:
    section.add "databaseState", valid_568071
  var valid_568072 = query.getOrDefault("onlyLatestPerDatabase")
  valid_568072 = validateParameter(valid_568072, JBool, required = false, default = nil)
  if valid_568072 != nil:
    section.add "onlyLatestPerDatabase", valid_568072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568095: Call_LongTermRetentionBackupsListByLocation_567880;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the long term retention backups for a given location.
  ## 
  let valid = call_568095.validator(path, query, header, formData, body)
  let scheme = call_568095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568095.url(scheme.get, call_568095.host, call_568095.base,
                         call_568095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568095, url, valid)

proc call*(call_568166: Call_LongTermRetentionBackupsListByLocation_567880;
          apiVersion: string; subscriptionId: string; locationName: string;
          databaseState: string = "All"; onlyLatestPerDatabase: bool = false): Recallable =
  ## longTermRetentionBackupsListByLocation
  ## Lists the long term retention backups for a given location.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   locationName: string (required)
  ##               : The location of the database
  ##   databaseState: string
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  ##   onlyLatestPerDatabase: bool
  ##                        : Whether or not to only get the latest backup for each database.
  var path_568167 = newJObject()
  var query_568169 = newJObject()
  add(query_568169, "api-version", newJString(apiVersion))
  add(path_568167, "subscriptionId", newJString(subscriptionId))
  add(path_568167, "locationName", newJString(locationName))
  add(query_568169, "databaseState", newJString(databaseState))
  add(query_568169, "onlyLatestPerDatabase", newJBool(onlyLatestPerDatabase))
  result = call_568166.call(path_568167, query_568169, nil, nil, nil)

var longTermRetentionBackupsListByLocation* = Call_LongTermRetentionBackupsListByLocation_567880(
    name: "longTermRetentionBackupsListByLocation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionBackups",
    validator: validate_LongTermRetentionBackupsListByLocation_567881, base: "",
    url: url_LongTermRetentionBackupsListByLocation_567882,
    schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsListByServer_568208 = ref object of OpenApiRestCall_567658
proc url_LongTermRetentionBackupsListByServer_568210(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "longTermRetentionServerName" in path,
        "`longTermRetentionServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/longTermRetentionServers/"),
               (kind: VariableSegment, value: "longTermRetentionServerName"),
               (kind: ConstantSegment, value: "/longTermRetentionBackups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LongTermRetentionBackupsListByServer_568209(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the long term retention backups for a given server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   longTermRetentionServerName: JString (required)
  ##                              : The name of the server
  ##   locationName: JString (required)
  ##               : The location of the database
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568211 = path.getOrDefault("subscriptionId")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "subscriptionId", valid_568211
  var valid_568212 = path.getOrDefault("longTermRetentionServerName")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "longTermRetentionServerName", valid_568212
  var valid_568213 = path.getOrDefault("locationName")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "locationName", valid_568213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   databaseState: JString
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  ##   onlyLatestPerDatabase: JBool
  ##                        : Whether or not to only get the latest backup for each database.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568214 = query.getOrDefault("api-version")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "api-version", valid_568214
  var valid_568215 = query.getOrDefault("databaseState")
  valid_568215 = validateParameter(valid_568215, JString, required = false,
                                 default = newJString("All"))
  if valid_568215 != nil:
    section.add "databaseState", valid_568215
  var valid_568216 = query.getOrDefault("onlyLatestPerDatabase")
  valid_568216 = validateParameter(valid_568216, JBool, required = false, default = nil)
  if valid_568216 != nil:
    section.add "onlyLatestPerDatabase", valid_568216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568217: Call_LongTermRetentionBackupsListByServer_568208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the long term retention backups for a given server.
  ## 
  let valid = call_568217.validator(path, query, header, formData, body)
  let scheme = call_568217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568217.url(scheme.get, call_568217.host, call_568217.base,
                         call_568217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568217, url, valid)

proc call*(call_568218: Call_LongTermRetentionBackupsListByServer_568208;
          apiVersion: string; subscriptionId: string;
          longTermRetentionServerName: string; locationName: string;
          databaseState: string = "All"; onlyLatestPerDatabase: bool = false): Recallable =
  ## longTermRetentionBackupsListByServer
  ## Lists the long term retention backups for a given server.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   longTermRetentionServerName: string (required)
  ##                              : The name of the server
  ##   locationName: string (required)
  ##               : The location of the database
  ##   databaseState: string
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  ##   onlyLatestPerDatabase: bool
  ##                        : Whether or not to only get the latest backup for each database.
  var path_568219 = newJObject()
  var query_568220 = newJObject()
  add(query_568220, "api-version", newJString(apiVersion))
  add(path_568219, "subscriptionId", newJString(subscriptionId))
  add(path_568219, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_568219, "locationName", newJString(locationName))
  add(query_568220, "databaseState", newJString(databaseState))
  add(query_568220, "onlyLatestPerDatabase", newJBool(onlyLatestPerDatabase))
  result = call_568218.call(path_568219, query_568220, nil, nil, nil)

var longTermRetentionBackupsListByServer* = Call_LongTermRetentionBackupsListByServer_568208(
    name: "longTermRetentionBackupsListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionBackups",
    validator: validate_LongTermRetentionBackupsListByServer_568209, base: "",
    url: url_LongTermRetentionBackupsListByServer_568210, schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsListByDatabase_568221 = ref object of OpenApiRestCall_567658
proc url_LongTermRetentionBackupsListByDatabase_568223(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "longTermRetentionServerName" in path,
        "`longTermRetentionServerName` is a required path parameter"
  assert "longTermRetentionDatabaseName" in path,
        "`longTermRetentionDatabaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/longTermRetentionServers/"),
               (kind: VariableSegment, value: "longTermRetentionServerName"),
               (kind: ConstantSegment, value: "/longTermRetentionDatabases/"),
               (kind: VariableSegment, value: "longTermRetentionDatabaseName"),
               (kind: ConstantSegment, value: "/longTermRetentionBackups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LongTermRetentionBackupsListByDatabase_568222(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all long term retention backups for a database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   longTermRetentionDatabaseName: JString (required)
  ##                                : The name of the database
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   longTermRetentionServerName: JString (required)
  ##                              : The name of the server
  ##   locationName: JString (required)
  ##               : The location of the database
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `longTermRetentionDatabaseName` field"
  var valid_568224 = path.getOrDefault("longTermRetentionDatabaseName")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "longTermRetentionDatabaseName", valid_568224
  var valid_568225 = path.getOrDefault("subscriptionId")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "subscriptionId", valid_568225
  var valid_568226 = path.getOrDefault("longTermRetentionServerName")
  valid_568226 = validateParameter(valid_568226, JString, required = true,
                                 default = nil)
  if valid_568226 != nil:
    section.add "longTermRetentionServerName", valid_568226
  var valid_568227 = path.getOrDefault("locationName")
  valid_568227 = validateParameter(valid_568227, JString, required = true,
                                 default = nil)
  if valid_568227 != nil:
    section.add "locationName", valid_568227
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   databaseState: JString
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  ##   onlyLatestPerDatabase: JBool
  ##                        : Whether or not to only get the latest backup for each database.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568228 = query.getOrDefault("api-version")
  valid_568228 = validateParameter(valid_568228, JString, required = true,
                                 default = nil)
  if valid_568228 != nil:
    section.add "api-version", valid_568228
  var valid_568229 = query.getOrDefault("databaseState")
  valid_568229 = validateParameter(valid_568229, JString, required = false,
                                 default = newJString("All"))
  if valid_568229 != nil:
    section.add "databaseState", valid_568229
  var valid_568230 = query.getOrDefault("onlyLatestPerDatabase")
  valid_568230 = validateParameter(valid_568230, JBool, required = false, default = nil)
  if valid_568230 != nil:
    section.add "onlyLatestPerDatabase", valid_568230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568231: Call_LongTermRetentionBackupsListByDatabase_568221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all long term retention backups for a database.
  ## 
  let valid = call_568231.validator(path, query, header, formData, body)
  let scheme = call_568231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568231.url(scheme.get, call_568231.host, call_568231.base,
                         call_568231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568231, url, valid)

proc call*(call_568232: Call_LongTermRetentionBackupsListByDatabase_568221;
          apiVersion: string; longTermRetentionDatabaseName: string;
          subscriptionId: string; longTermRetentionServerName: string;
          locationName: string; databaseState: string = "All";
          onlyLatestPerDatabase: bool = false): Recallable =
  ## longTermRetentionBackupsListByDatabase
  ## Lists all long term retention backups for a database.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   longTermRetentionDatabaseName: string (required)
  ##                                : The name of the database
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   longTermRetentionServerName: string (required)
  ##                              : The name of the server
  ##   locationName: string (required)
  ##               : The location of the database
  ##   databaseState: string
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  ##   onlyLatestPerDatabase: bool
  ##                        : Whether or not to only get the latest backup for each database.
  var path_568233 = newJObject()
  var query_568234 = newJObject()
  add(query_568234, "api-version", newJString(apiVersion))
  add(path_568233, "longTermRetentionDatabaseName",
      newJString(longTermRetentionDatabaseName))
  add(path_568233, "subscriptionId", newJString(subscriptionId))
  add(path_568233, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_568233, "locationName", newJString(locationName))
  add(query_568234, "databaseState", newJString(databaseState))
  add(query_568234, "onlyLatestPerDatabase", newJBool(onlyLatestPerDatabase))
  result = call_568232.call(path_568233, query_568234, nil, nil, nil)

var longTermRetentionBackupsListByDatabase* = Call_LongTermRetentionBackupsListByDatabase_568221(
    name: "longTermRetentionBackupsListByDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionDatabases/{longTermRetentionDatabaseName}/longTermRetentionBackups",
    validator: validate_LongTermRetentionBackupsListByDatabase_568222, base: "",
    url: url_LongTermRetentionBackupsListByDatabase_568223,
    schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsGet_568235 = ref object of OpenApiRestCall_567658
proc url_LongTermRetentionBackupsGet_568237(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "longTermRetentionServerName" in path,
        "`longTermRetentionServerName` is a required path parameter"
  assert "longTermRetentionDatabaseName" in path,
        "`longTermRetentionDatabaseName` is a required path parameter"
  assert "backupName" in path, "`backupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/longTermRetentionServers/"),
               (kind: VariableSegment, value: "longTermRetentionServerName"),
               (kind: ConstantSegment, value: "/longTermRetentionDatabases/"),
               (kind: VariableSegment, value: "longTermRetentionDatabaseName"),
               (kind: ConstantSegment, value: "/longTermRetentionBackups/"),
               (kind: VariableSegment, value: "backupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LongTermRetentionBackupsGet_568236(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a long term retention backup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   longTermRetentionDatabaseName: JString (required)
  ##                                : The name of the database
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   backupName: JString (required)
  ##             : The backup name.
  ##   longTermRetentionServerName: JString (required)
  ##                              : The name of the server
  ##   locationName: JString (required)
  ##               : The location of the database.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `longTermRetentionDatabaseName` field"
  var valid_568238 = path.getOrDefault("longTermRetentionDatabaseName")
  valid_568238 = validateParameter(valid_568238, JString, required = true,
                                 default = nil)
  if valid_568238 != nil:
    section.add "longTermRetentionDatabaseName", valid_568238
  var valid_568239 = path.getOrDefault("subscriptionId")
  valid_568239 = validateParameter(valid_568239, JString, required = true,
                                 default = nil)
  if valid_568239 != nil:
    section.add "subscriptionId", valid_568239
  var valid_568240 = path.getOrDefault("backupName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "backupName", valid_568240
  var valid_568241 = path.getOrDefault("longTermRetentionServerName")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "longTermRetentionServerName", valid_568241
  var valid_568242 = path.getOrDefault("locationName")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "locationName", valid_568242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568243 = query.getOrDefault("api-version")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "api-version", valid_568243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568244: Call_LongTermRetentionBackupsGet_568235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a long term retention backup.
  ## 
  let valid = call_568244.validator(path, query, header, formData, body)
  let scheme = call_568244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568244.url(scheme.get, call_568244.host, call_568244.base,
                         call_568244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568244, url, valid)

proc call*(call_568245: Call_LongTermRetentionBackupsGet_568235;
          apiVersion: string; longTermRetentionDatabaseName: string;
          subscriptionId: string; backupName: string;
          longTermRetentionServerName: string; locationName: string): Recallable =
  ## longTermRetentionBackupsGet
  ## Gets a long term retention backup.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   longTermRetentionDatabaseName: string (required)
  ##                                : The name of the database
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   backupName: string (required)
  ##             : The backup name.
  ##   longTermRetentionServerName: string (required)
  ##                              : The name of the server
  ##   locationName: string (required)
  ##               : The location of the database.
  var path_568246 = newJObject()
  var query_568247 = newJObject()
  add(query_568247, "api-version", newJString(apiVersion))
  add(path_568246, "longTermRetentionDatabaseName",
      newJString(longTermRetentionDatabaseName))
  add(path_568246, "subscriptionId", newJString(subscriptionId))
  add(path_568246, "backupName", newJString(backupName))
  add(path_568246, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_568246, "locationName", newJString(locationName))
  result = call_568245.call(path_568246, query_568247, nil, nil, nil)

var longTermRetentionBackupsGet* = Call_LongTermRetentionBackupsGet_568235(
    name: "longTermRetentionBackupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionDatabases/{longTermRetentionDatabaseName}/longTermRetentionBackups/{backupName}",
    validator: validate_LongTermRetentionBackupsGet_568236, base: "",
    url: url_LongTermRetentionBackupsGet_568237, schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsDelete_568248 = ref object of OpenApiRestCall_567658
proc url_LongTermRetentionBackupsDelete_568250(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "longTermRetentionServerName" in path,
        "`longTermRetentionServerName` is a required path parameter"
  assert "longTermRetentionDatabaseName" in path,
        "`longTermRetentionDatabaseName` is a required path parameter"
  assert "backupName" in path, "`backupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/longTermRetentionServers/"),
               (kind: VariableSegment, value: "longTermRetentionServerName"),
               (kind: ConstantSegment, value: "/longTermRetentionDatabases/"),
               (kind: VariableSegment, value: "longTermRetentionDatabaseName"),
               (kind: ConstantSegment, value: "/longTermRetentionBackups/"),
               (kind: VariableSegment, value: "backupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LongTermRetentionBackupsDelete_568249(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a long term retention backup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   longTermRetentionDatabaseName: JString (required)
  ##                                : The name of the database
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   backupName: JString (required)
  ##             : The backup name.
  ##   longTermRetentionServerName: JString (required)
  ##                              : The name of the server
  ##   locationName: JString (required)
  ##               : The location of the database
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `longTermRetentionDatabaseName` field"
  var valid_568251 = path.getOrDefault("longTermRetentionDatabaseName")
  valid_568251 = validateParameter(valid_568251, JString, required = true,
                                 default = nil)
  if valid_568251 != nil:
    section.add "longTermRetentionDatabaseName", valid_568251
  var valid_568252 = path.getOrDefault("subscriptionId")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "subscriptionId", valid_568252
  var valid_568253 = path.getOrDefault("backupName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "backupName", valid_568253
  var valid_568254 = path.getOrDefault("longTermRetentionServerName")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "longTermRetentionServerName", valid_568254
  var valid_568255 = path.getOrDefault("locationName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "locationName", valid_568255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568256 = query.getOrDefault("api-version")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "api-version", valid_568256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568257: Call_LongTermRetentionBackupsDelete_568248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a long term retention backup.
  ## 
  let valid = call_568257.validator(path, query, header, formData, body)
  let scheme = call_568257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568257.url(scheme.get, call_568257.host, call_568257.base,
                         call_568257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568257, url, valid)

proc call*(call_568258: Call_LongTermRetentionBackupsDelete_568248;
          apiVersion: string; longTermRetentionDatabaseName: string;
          subscriptionId: string; backupName: string;
          longTermRetentionServerName: string; locationName: string): Recallable =
  ## longTermRetentionBackupsDelete
  ## Deletes a long term retention backup.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   longTermRetentionDatabaseName: string (required)
  ##                                : The name of the database
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   backupName: string (required)
  ##             : The backup name.
  ##   longTermRetentionServerName: string (required)
  ##                              : The name of the server
  ##   locationName: string (required)
  ##               : The location of the database
  var path_568259 = newJObject()
  var query_568260 = newJObject()
  add(query_568260, "api-version", newJString(apiVersion))
  add(path_568259, "longTermRetentionDatabaseName",
      newJString(longTermRetentionDatabaseName))
  add(path_568259, "subscriptionId", newJString(subscriptionId))
  add(path_568259, "backupName", newJString(backupName))
  add(path_568259, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_568259, "locationName", newJString(locationName))
  result = call_568258.call(path_568259, query_568260, nil, nil, nil)

var longTermRetentionBackupsDelete* = Call_LongTermRetentionBackupsDelete_568248(
    name: "longTermRetentionBackupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionDatabases/{longTermRetentionDatabaseName}/longTermRetentionBackups/{backupName}",
    validator: validate_LongTermRetentionBackupsDelete_568249, base: "",
    url: url_LongTermRetentionBackupsDelete_568250, schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsListByResourceGroupLocation_568261 = ref object of OpenApiRestCall_567658
proc url_LongTermRetentionBackupsListByResourceGroupLocation_568263(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/longTermRetentionBackups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LongTermRetentionBackupsListByResourceGroupLocation_568262(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the long term retention backups for a given location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   locationName: JString (required)
  ##               : The location of the database
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568264 = path.getOrDefault("resourceGroupName")
  valid_568264 = validateParameter(valid_568264, JString, required = true,
                                 default = nil)
  if valid_568264 != nil:
    section.add "resourceGroupName", valid_568264
  var valid_568265 = path.getOrDefault("subscriptionId")
  valid_568265 = validateParameter(valid_568265, JString, required = true,
                                 default = nil)
  if valid_568265 != nil:
    section.add "subscriptionId", valid_568265
  var valid_568266 = path.getOrDefault("locationName")
  valid_568266 = validateParameter(valid_568266, JString, required = true,
                                 default = nil)
  if valid_568266 != nil:
    section.add "locationName", valid_568266
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   databaseState: JString
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  ##   onlyLatestPerDatabase: JBool
  ##                        : Whether or not to only get the latest backup for each database.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568267 = query.getOrDefault("api-version")
  valid_568267 = validateParameter(valid_568267, JString, required = true,
                                 default = nil)
  if valid_568267 != nil:
    section.add "api-version", valid_568267
  var valid_568268 = query.getOrDefault("databaseState")
  valid_568268 = validateParameter(valid_568268, JString, required = false,
                                 default = newJString("All"))
  if valid_568268 != nil:
    section.add "databaseState", valid_568268
  var valid_568269 = query.getOrDefault("onlyLatestPerDatabase")
  valid_568269 = validateParameter(valid_568269, JBool, required = false, default = nil)
  if valid_568269 != nil:
    section.add "onlyLatestPerDatabase", valid_568269
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568270: Call_LongTermRetentionBackupsListByResourceGroupLocation_568261;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the long term retention backups for a given location.
  ## 
  let valid = call_568270.validator(path, query, header, formData, body)
  let scheme = call_568270.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568270.url(scheme.get, call_568270.host, call_568270.base,
                         call_568270.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568270, url, valid)

proc call*(call_568271: Call_LongTermRetentionBackupsListByResourceGroupLocation_568261;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          locationName: string; databaseState: string = "All";
          onlyLatestPerDatabase: bool = false): Recallable =
  ## longTermRetentionBackupsListByResourceGroupLocation
  ## Lists the long term retention backups for a given location.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   locationName: string (required)
  ##               : The location of the database
  ##   databaseState: string
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  ##   onlyLatestPerDatabase: bool
  ##                        : Whether or not to only get the latest backup for each database.
  var path_568272 = newJObject()
  var query_568273 = newJObject()
  add(path_568272, "resourceGroupName", newJString(resourceGroupName))
  add(query_568273, "api-version", newJString(apiVersion))
  add(path_568272, "subscriptionId", newJString(subscriptionId))
  add(path_568272, "locationName", newJString(locationName))
  add(query_568273, "databaseState", newJString(databaseState))
  add(query_568273, "onlyLatestPerDatabase", newJBool(onlyLatestPerDatabase))
  result = call_568271.call(path_568272, query_568273, nil, nil, nil)

var longTermRetentionBackupsListByResourceGroupLocation* = Call_LongTermRetentionBackupsListByResourceGroupLocation_568261(
    name: "longTermRetentionBackupsListByResourceGroupLocation",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionBackups",
    validator: validate_LongTermRetentionBackupsListByResourceGroupLocation_568262,
    base: "", url: url_LongTermRetentionBackupsListByResourceGroupLocation_568263,
    schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsListByResourceGroupServer_568274 = ref object of OpenApiRestCall_567658
proc url_LongTermRetentionBackupsListByResourceGroupServer_568276(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "longTermRetentionServerName" in path,
        "`longTermRetentionServerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/longTermRetentionServers/"),
               (kind: VariableSegment, value: "longTermRetentionServerName"),
               (kind: ConstantSegment, value: "/longTermRetentionBackups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LongTermRetentionBackupsListByResourceGroupServer_568275(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the long term retention backups for a given server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   longTermRetentionServerName: JString (required)
  ##                              : The name of the server
  ##   locationName: JString (required)
  ##               : The location of the database
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568277 = path.getOrDefault("resourceGroupName")
  valid_568277 = validateParameter(valid_568277, JString, required = true,
                                 default = nil)
  if valid_568277 != nil:
    section.add "resourceGroupName", valid_568277
  var valid_568278 = path.getOrDefault("subscriptionId")
  valid_568278 = validateParameter(valid_568278, JString, required = true,
                                 default = nil)
  if valid_568278 != nil:
    section.add "subscriptionId", valid_568278
  var valid_568279 = path.getOrDefault("longTermRetentionServerName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "longTermRetentionServerName", valid_568279
  var valid_568280 = path.getOrDefault("locationName")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "locationName", valid_568280
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   databaseState: JString
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  ##   onlyLatestPerDatabase: JBool
  ##                        : Whether or not to only get the latest backup for each database.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568281 = query.getOrDefault("api-version")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "api-version", valid_568281
  var valid_568282 = query.getOrDefault("databaseState")
  valid_568282 = validateParameter(valid_568282, JString, required = false,
                                 default = newJString("All"))
  if valid_568282 != nil:
    section.add "databaseState", valid_568282
  var valid_568283 = query.getOrDefault("onlyLatestPerDatabase")
  valid_568283 = validateParameter(valid_568283, JBool, required = false, default = nil)
  if valid_568283 != nil:
    section.add "onlyLatestPerDatabase", valid_568283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568284: Call_LongTermRetentionBackupsListByResourceGroupServer_568274;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the long term retention backups for a given server.
  ## 
  let valid = call_568284.validator(path, query, header, formData, body)
  let scheme = call_568284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568284.url(scheme.get, call_568284.host, call_568284.base,
                         call_568284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568284, url, valid)

proc call*(call_568285: Call_LongTermRetentionBackupsListByResourceGroupServer_568274;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          longTermRetentionServerName: string; locationName: string;
          databaseState: string = "All"; onlyLatestPerDatabase: bool = false): Recallable =
  ## longTermRetentionBackupsListByResourceGroupServer
  ## Lists the long term retention backups for a given server.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   longTermRetentionServerName: string (required)
  ##                              : The name of the server
  ##   locationName: string (required)
  ##               : The location of the database
  ##   databaseState: string
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  ##   onlyLatestPerDatabase: bool
  ##                        : Whether or not to only get the latest backup for each database.
  var path_568286 = newJObject()
  var query_568287 = newJObject()
  add(path_568286, "resourceGroupName", newJString(resourceGroupName))
  add(query_568287, "api-version", newJString(apiVersion))
  add(path_568286, "subscriptionId", newJString(subscriptionId))
  add(path_568286, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_568286, "locationName", newJString(locationName))
  add(query_568287, "databaseState", newJString(databaseState))
  add(query_568287, "onlyLatestPerDatabase", newJBool(onlyLatestPerDatabase))
  result = call_568285.call(path_568286, query_568287, nil, nil, nil)

var longTermRetentionBackupsListByResourceGroupServer* = Call_LongTermRetentionBackupsListByResourceGroupServer_568274(
    name: "longTermRetentionBackupsListByResourceGroupServer",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionBackups",
    validator: validate_LongTermRetentionBackupsListByResourceGroupServer_568275,
    base: "", url: url_LongTermRetentionBackupsListByResourceGroupServer_568276,
    schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsListByResourceGroupDatabase_568288 = ref object of OpenApiRestCall_567658
proc url_LongTermRetentionBackupsListByResourceGroupDatabase_568290(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "longTermRetentionServerName" in path,
        "`longTermRetentionServerName` is a required path parameter"
  assert "longTermRetentionDatabaseName" in path,
        "`longTermRetentionDatabaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/longTermRetentionServers/"),
               (kind: VariableSegment, value: "longTermRetentionServerName"),
               (kind: ConstantSegment, value: "/longTermRetentionDatabases/"),
               (kind: VariableSegment, value: "longTermRetentionDatabaseName"),
               (kind: ConstantSegment, value: "/longTermRetentionBackups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LongTermRetentionBackupsListByResourceGroupDatabase_568289(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all long term retention backups for a database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   longTermRetentionDatabaseName: JString (required)
  ##                                : The name of the database
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   longTermRetentionServerName: JString (required)
  ##                              : The name of the server
  ##   locationName: JString (required)
  ##               : The location of the database
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568291 = path.getOrDefault("resourceGroupName")
  valid_568291 = validateParameter(valid_568291, JString, required = true,
                                 default = nil)
  if valid_568291 != nil:
    section.add "resourceGroupName", valid_568291
  var valid_568292 = path.getOrDefault("longTermRetentionDatabaseName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "longTermRetentionDatabaseName", valid_568292
  var valid_568293 = path.getOrDefault("subscriptionId")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "subscriptionId", valid_568293
  var valid_568294 = path.getOrDefault("longTermRetentionServerName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "longTermRetentionServerName", valid_568294
  var valid_568295 = path.getOrDefault("locationName")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "locationName", valid_568295
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   databaseState: JString
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  ##   onlyLatestPerDatabase: JBool
  ##                        : Whether or not to only get the latest backup for each database.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568296 = query.getOrDefault("api-version")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = nil)
  if valid_568296 != nil:
    section.add "api-version", valid_568296
  var valid_568297 = query.getOrDefault("databaseState")
  valid_568297 = validateParameter(valid_568297, JString, required = false,
                                 default = newJString("All"))
  if valid_568297 != nil:
    section.add "databaseState", valid_568297
  var valid_568298 = query.getOrDefault("onlyLatestPerDatabase")
  valid_568298 = validateParameter(valid_568298, JBool, required = false, default = nil)
  if valid_568298 != nil:
    section.add "onlyLatestPerDatabase", valid_568298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568299: Call_LongTermRetentionBackupsListByResourceGroupDatabase_568288;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all long term retention backups for a database.
  ## 
  let valid = call_568299.validator(path, query, header, formData, body)
  let scheme = call_568299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568299.url(scheme.get, call_568299.host, call_568299.base,
                         call_568299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568299, url, valid)

proc call*(call_568300: Call_LongTermRetentionBackupsListByResourceGroupDatabase_568288;
          resourceGroupName: string; apiVersion: string;
          longTermRetentionDatabaseName: string; subscriptionId: string;
          longTermRetentionServerName: string; locationName: string;
          databaseState: string = "All"; onlyLatestPerDatabase: bool = false): Recallable =
  ## longTermRetentionBackupsListByResourceGroupDatabase
  ## Lists all long term retention backups for a database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   longTermRetentionDatabaseName: string (required)
  ##                                : The name of the database
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   longTermRetentionServerName: string (required)
  ##                              : The name of the server
  ##   locationName: string (required)
  ##               : The location of the database
  ##   databaseState: string
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  ##   onlyLatestPerDatabase: bool
  ##                        : Whether or not to only get the latest backup for each database.
  var path_568301 = newJObject()
  var query_568302 = newJObject()
  add(path_568301, "resourceGroupName", newJString(resourceGroupName))
  add(query_568302, "api-version", newJString(apiVersion))
  add(path_568301, "longTermRetentionDatabaseName",
      newJString(longTermRetentionDatabaseName))
  add(path_568301, "subscriptionId", newJString(subscriptionId))
  add(path_568301, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_568301, "locationName", newJString(locationName))
  add(query_568302, "databaseState", newJString(databaseState))
  add(query_568302, "onlyLatestPerDatabase", newJBool(onlyLatestPerDatabase))
  result = call_568300.call(path_568301, query_568302, nil, nil, nil)

var longTermRetentionBackupsListByResourceGroupDatabase* = Call_LongTermRetentionBackupsListByResourceGroupDatabase_568288(
    name: "longTermRetentionBackupsListByResourceGroupDatabase",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionDatabases/{longTermRetentionDatabaseName}/longTermRetentionBackups",
    validator: validate_LongTermRetentionBackupsListByResourceGroupDatabase_568289,
    base: "", url: url_LongTermRetentionBackupsListByResourceGroupDatabase_568290,
    schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsGetByResourceGroup_568303 = ref object of OpenApiRestCall_567658
proc url_LongTermRetentionBackupsGetByResourceGroup_568305(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "longTermRetentionServerName" in path,
        "`longTermRetentionServerName` is a required path parameter"
  assert "longTermRetentionDatabaseName" in path,
        "`longTermRetentionDatabaseName` is a required path parameter"
  assert "backupName" in path, "`backupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/longTermRetentionServers/"),
               (kind: VariableSegment, value: "longTermRetentionServerName"),
               (kind: ConstantSegment, value: "/longTermRetentionDatabases/"),
               (kind: VariableSegment, value: "longTermRetentionDatabaseName"),
               (kind: ConstantSegment, value: "/longTermRetentionBackups/"),
               (kind: VariableSegment, value: "backupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LongTermRetentionBackupsGetByResourceGroup_568304(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a long term retention backup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   longTermRetentionDatabaseName: JString (required)
  ##                                : The name of the database
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   backupName: JString (required)
  ##             : The backup name.
  ##   longTermRetentionServerName: JString (required)
  ##                              : The name of the server
  ##   locationName: JString (required)
  ##               : The location of the database.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568306 = path.getOrDefault("resourceGroupName")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = nil)
  if valid_568306 != nil:
    section.add "resourceGroupName", valid_568306
  var valid_568307 = path.getOrDefault("longTermRetentionDatabaseName")
  valid_568307 = validateParameter(valid_568307, JString, required = true,
                                 default = nil)
  if valid_568307 != nil:
    section.add "longTermRetentionDatabaseName", valid_568307
  var valid_568308 = path.getOrDefault("subscriptionId")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "subscriptionId", valid_568308
  var valid_568309 = path.getOrDefault("backupName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "backupName", valid_568309
  var valid_568310 = path.getOrDefault("longTermRetentionServerName")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "longTermRetentionServerName", valid_568310
  var valid_568311 = path.getOrDefault("locationName")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = nil)
  if valid_568311 != nil:
    section.add "locationName", valid_568311
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568312 = query.getOrDefault("api-version")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "api-version", valid_568312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568313: Call_LongTermRetentionBackupsGetByResourceGroup_568303;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a long term retention backup.
  ## 
  let valid = call_568313.validator(path, query, header, formData, body)
  let scheme = call_568313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568313.url(scheme.get, call_568313.host, call_568313.base,
                         call_568313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568313, url, valid)

proc call*(call_568314: Call_LongTermRetentionBackupsGetByResourceGroup_568303;
          resourceGroupName: string; apiVersion: string;
          longTermRetentionDatabaseName: string; subscriptionId: string;
          backupName: string; longTermRetentionServerName: string;
          locationName: string): Recallable =
  ## longTermRetentionBackupsGetByResourceGroup
  ## Gets a long term retention backup.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   longTermRetentionDatabaseName: string (required)
  ##                                : The name of the database
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   backupName: string (required)
  ##             : The backup name.
  ##   longTermRetentionServerName: string (required)
  ##                              : The name of the server
  ##   locationName: string (required)
  ##               : The location of the database.
  var path_568315 = newJObject()
  var query_568316 = newJObject()
  add(path_568315, "resourceGroupName", newJString(resourceGroupName))
  add(query_568316, "api-version", newJString(apiVersion))
  add(path_568315, "longTermRetentionDatabaseName",
      newJString(longTermRetentionDatabaseName))
  add(path_568315, "subscriptionId", newJString(subscriptionId))
  add(path_568315, "backupName", newJString(backupName))
  add(path_568315, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_568315, "locationName", newJString(locationName))
  result = call_568314.call(path_568315, query_568316, nil, nil, nil)

var longTermRetentionBackupsGetByResourceGroup* = Call_LongTermRetentionBackupsGetByResourceGroup_568303(
    name: "longTermRetentionBackupsGetByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionDatabases/{longTermRetentionDatabaseName}/longTermRetentionBackups/{backupName}",
    validator: validate_LongTermRetentionBackupsGetByResourceGroup_568304,
    base: "", url: url_LongTermRetentionBackupsGetByResourceGroup_568305,
    schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsDeleteByResourceGroup_568317 = ref object of OpenApiRestCall_567658
proc url_LongTermRetentionBackupsDeleteByResourceGroup_568319(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "locationName" in path, "`locationName` is a required path parameter"
  assert "longTermRetentionServerName" in path,
        "`longTermRetentionServerName` is a required path parameter"
  assert "longTermRetentionDatabaseName" in path,
        "`longTermRetentionDatabaseName` is a required path parameter"
  assert "backupName" in path, "`backupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/locations/"),
               (kind: VariableSegment, value: "locationName"),
               (kind: ConstantSegment, value: "/longTermRetentionServers/"),
               (kind: VariableSegment, value: "longTermRetentionServerName"),
               (kind: ConstantSegment, value: "/longTermRetentionDatabases/"),
               (kind: VariableSegment, value: "longTermRetentionDatabaseName"),
               (kind: ConstantSegment, value: "/longTermRetentionBackups/"),
               (kind: VariableSegment, value: "backupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_LongTermRetentionBackupsDeleteByResourceGroup_568318(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a long term retention backup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   longTermRetentionDatabaseName: JString (required)
  ##                                : The name of the database
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   backupName: JString (required)
  ##             : The backup name.
  ##   longTermRetentionServerName: JString (required)
  ##                              : The name of the server
  ##   locationName: JString (required)
  ##               : The location of the database
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568320 = path.getOrDefault("resourceGroupName")
  valid_568320 = validateParameter(valid_568320, JString, required = true,
                                 default = nil)
  if valid_568320 != nil:
    section.add "resourceGroupName", valid_568320
  var valid_568321 = path.getOrDefault("longTermRetentionDatabaseName")
  valid_568321 = validateParameter(valid_568321, JString, required = true,
                                 default = nil)
  if valid_568321 != nil:
    section.add "longTermRetentionDatabaseName", valid_568321
  var valid_568322 = path.getOrDefault("subscriptionId")
  valid_568322 = validateParameter(valid_568322, JString, required = true,
                                 default = nil)
  if valid_568322 != nil:
    section.add "subscriptionId", valid_568322
  var valid_568323 = path.getOrDefault("backupName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "backupName", valid_568323
  var valid_568324 = path.getOrDefault("longTermRetentionServerName")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "longTermRetentionServerName", valid_568324
  var valid_568325 = path.getOrDefault("locationName")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "locationName", valid_568325
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568326 = query.getOrDefault("api-version")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = nil)
  if valid_568326 != nil:
    section.add "api-version", valid_568326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568327: Call_LongTermRetentionBackupsDeleteByResourceGroup_568317;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long term retention backup.
  ## 
  let valid = call_568327.validator(path, query, header, formData, body)
  let scheme = call_568327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568327.url(scheme.get, call_568327.host, call_568327.base,
                         call_568327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568327, url, valid)

proc call*(call_568328: Call_LongTermRetentionBackupsDeleteByResourceGroup_568317;
          resourceGroupName: string; apiVersion: string;
          longTermRetentionDatabaseName: string; subscriptionId: string;
          backupName: string; longTermRetentionServerName: string;
          locationName: string): Recallable =
  ## longTermRetentionBackupsDeleteByResourceGroup
  ## Deletes a long term retention backup.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   longTermRetentionDatabaseName: string (required)
  ##                                : The name of the database
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   backupName: string (required)
  ##             : The backup name.
  ##   longTermRetentionServerName: string (required)
  ##                              : The name of the server
  ##   locationName: string (required)
  ##               : The location of the database
  var path_568329 = newJObject()
  var query_568330 = newJObject()
  add(path_568329, "resourceGroupName", newJString(resourceGroupName))
  add(query_568330, "api-version", newJString(apiVersion))
  add(path_568329, "longTermRetentionDatabaseName",
      newJString(longTermRetentionDatabaseName))
  add(path_568329, "subscriptionId", newJString(subscriptionId))
  add(path_568329, "backupName", newJString(backupName))
  add(path_568329, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_568329, "locationName", newJString(locationName))
  result = call_568328.call(path_568329, query_568330, nil, nil, nil)

var longTermRetentionBackupsDeleteByResourceGroup* = Call_LongTermRetentionBackupsDeleteByResourceGroup_568317(
    name: "longTermRetentionBackupsDeleteByResourceGroup",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionDatabases/{longTermRetentionDatabaseName}/longTermRetentionBackups/{backupName}",
    validator: validate_LongTermRetentionBackupsDeleteByResourceGroup_568318,
    base: "", url: url_LongTermRetentionBackupsDeleteByResourceGroup_568319,
    schemes: {Scheme.Https})
type
  Call_BackupLongTermRetentionPoliciesListByDatabase_568331 = ref object of OpenApiRestCall_567658
proc url_BackupLongTermRetentionPoliciesListByDatabase_568333(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"), (
        kind: ConstantSegment, value: "/backupLongTermRetentionPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupLongTermRetentionPoliciesListByDatabase_568332(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a database's long term retention policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568334 = path.getOrDefault("resourceGroupName")
  valid_568334 = validateParameter(valid_568334, JString, required = true,
                                 default = nil)
  if valid_568334 != nil:
    section.add "resourceGroupName", valid_568334
  var valid_568335 = path.getOrDefault("serverName")
  valid_568335 = validateParameter(valid_568335, JString, required = true,
                                 default = nil)
  if valid_568335 != nil:
    section.add "serverName", valid_568335
  var valid_568336 = path.getOrDefault("subscriptionId")
  valid_568336 = validateParameter(valid_568336, JString, required = true,
                                 default = nil)
  if valid_568336 != nil:
    section.add "subscriptionId", valid_568336
  var valid_568337 = path.getOrDefault("databaseName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "databaseName", valid_568337
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568338 = query.getOrDefault("api-version")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "api-version", valid_568338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568339: Call_BackupLongTermRetentionPoliciesListByDatabase_568331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a database's long term retention policy.
  ## 
  let valid = call_568339.validator(path, query, header, formData, body)
  let scheme = call_568339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568339.url(scheme.get, call_568339.host, call_568339.base,
                         call_568339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568339, url, valid)

proc call*(call_568340: Call_BackupLongTermRetentionPoliciesListByDatabase_568331;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; databaseName: string): Recallable =
  ## backupLongTermRetentionPoliciesListByDatabase
  ## Gets a database's long term retention policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  var path_568341 = newJObject()
  var query_568342 = newJObject()
  add(path_568341, "resourceGroupName", newJString(resourceGroupName))
  add(query_568342, "api-version", newJString(apiVersion))
  add(path_568341, "serverName", newJString(serverName))
  add(path_568341, "subscriptionId", newJString(subscriptionId))
  add(path_568341, "databaseName", newJString(databaseName))
  result = call_568340.call(path_568341, query_568342, nil, nil, nil)

var backupLongTermRetentionPoliciesListByDatabase* = Call_BackupLongTermRetentionPoliciesListByDatabase_568331(
    name: "backupLongTermRetentionPoliciesListByDatabase",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/backupLongTermRetentionPolicies",
    validator: validate_BackupLongTermRetentionPoliciesListByDatabase_568332,
    base: "", url: url_BackupLongTermRetentionPoliciesListByDatabase_568333,
    schemes: {Scheme.Https})
type
  Call_BackupLongTermRetentionPoliciesCreateOrUpdate_568356 = ref object of OpenApiRestCall_567658
proc url_BackupLongTermRetentionPoliciesCreateOrUpdate_568358(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"), (
        kind: ConstantSegment, value: "/backupLongTermRetentionPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupLongTermRetentionPoliciesCreateOrUpdate_568357(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets a database's long term retention policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   policyName: JString (required)
  ##             : The policy name. Should always be Default.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568359 = path.getOrDefault("resourceGroupName")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "resourceGroupName", valid_568359
  var valid_568360 = path.getOrDefault("serverName")
  valid_568360 = validateParameter(valid_568360, JString, required = true,
                                 default = nil)
  if valid_568360 != nil:
    section.add "serverName", valid_568360
  var valid_568361 = path.getOrDefault("subscriptionId")
  valid_568361 = validateParameter(valid_568361, JString, required = true,
                                 default = nil)
  if valid_568361 != nil:
    section.add "subscriptionId", valid_568361
  var valid_568362 = path.getOrDefault("databaseName")
  valid_568362 = validateParameter(valid_568362, JString, required = true,
                                 default = nil)
  if valid_568362 != nil:
    section.add "databaseName", valid_568362
  var valid_568363 = path.getOrDefault("policyName")
  valid_568363 = validateParameter(valid_568363, JString, required = true,
                                 default = newJString("default"))
  if valid_568363 != nil:
    section.add "policyName", valid_568363
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568364 = query.getOrDefault("api-version")
  valid_568364 = validateParameter(valid_568364, JString, required = true,
                                 default = nil)
  if valid_568364 != nil:
    section.add "api-version", valid_568364
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The long term retention policy info.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568366: Call_BackupLongTermRetentionPoliciesCreateOrUpdate_568356;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets a database's long term retention policy.
  ## 
  let valid = call_568366.validator(path, query, header, formData, body)
  let scheme = call_568366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568366.url(scheme.get, call_568366.host, call_568366.base,
                         call_568366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568366, url, valid)

proc call*(call_568367: Call_BackupLongTermRetentionPoliciesCreateOrUpdate_568356;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; databaseName: string; parameters: JsonNode;
          policyName: string = "default"): Recallable =
  ## backupLongTermRetentionPoliciesCreateOrUpdate
  ## Sets a database's long term retention policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   policyName: string (required)
  ##             : The policy name. Should always be Default.
  ##   parameters: JObject (required)
  ##             : The long term retention policy info.
  var path_568368 = newJObject()
  var query_568369 = newJObject()
  var body_568370 = newJObject()
  add(path_568368, "resourceGroupName", newJString(resourceGroupName))
  add(query_568369, "api-version", newJString(apiVersion))
  add(path_568368, "serverName", newJString(serverName))
  add(path_568368, "subscriptionId", newJString(subscriptionId))
  add(path_568368, "databaseName", newJString(databaseName))
  add(path_568368, "policyName", newJString(policyName))
  if parameters != nil:
    body_568370 = parameters
  result = call_568367.call(path_568368, query_568369, nil, nil, body_568370)

var backupLongTermRetentionPoliciesCreateOrUpdate* = Call_BackupLongTermRetentionPoliciesCreateOrUpdate_568356(
    name: "backupLongTermRetentionPoliciesCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/backupLongTermRetentionPolicies/{policyName}",
    validator: validate_BackupLongTermRetentionPoliciesCreateOrUpdate_568357,
    base: "", url: url_BackupLongTermRetentionPoliciesCreateOrUpdate_568358,
    schemes: {Scheme.Https})
type
  Call_BackupLongTermRetentionPoliciesGet_568343 = ref object of OpenApiRestCall_567658
proc url_BackupLongTermRetentionPoliciesGet_568345(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  assert "databaseName" in path, "`databaseName` is a required path parameter"
  assert "policyName" in path, "`policyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"), (
        kind: ConstantSegment, value: "/backupLongTermRetentionPolicies/"),
               (kind: VariableSegment, value: "policyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BackupLongTermRetentionPoliciesGet_568344(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a database's long term retention policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   policyName: JString (required)
  ##             : The policy name. Should always be Default.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568346 = path.getOrDefault("resourceGroupName")
  valid_568346 = validateParameter(valid_568346, JString, required = true,
                                 default = nil)
  if valid_568346 != nil:
    section.add "resourceGroupName", valid_568346
  var valid_568347 = path.getOrDefault("serverName")
  valid_568347 = validateParameter(valid_568347, JString, required = true,
                                 default = nil)
  if valid_568347 != nil:
    section.add "serverName", valid_568347
  var valid_568348 = path.getOrDefault("subscriptionId")
  valid_568348 = validateParameter(valid_568348, JString, required = true,
                                 default = nil)
  if valid_568348 != nil:
    section.add "subscriptionId", valid_568348
  var valid_568349 = path.getOrDefault("databaseName")
  valid_568349 = validateParameter(valid_568349, JString, required = true,
                                 default = nil)
  if valid_568349 != nil:
    section.add "databaseName", valid_568349
  var valid_568350 = path.getOrDefault("policyName")
  valid_568350 = validateParameter(valid_568350, JString, required = true,
                                 default = newJString("default"))
  if valid_568350 != nil:
    section.add "policyName", valid_568350
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568351 = query.getOrDefault("api-version")
  valid_568351 = validateParameter(valid_568351, JString, required = true,
                                 default = nil)
  if valid_568351 != nil:
    section.add "api-version", valid_568351
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568352: Call_BackupLongTermRetentionPoliciesGet_568343;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a database's long term retention policy.
  ## 
  let valid = call_568352.validator(path, query, header, formData, body)
  let scheme = call_568352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568352.url(scheme.get, call_568352.host, call_568352.base,
                         call_568352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568352, url, valid)

proc call*(call_568353: Call_BackupLongTermRetentionPoliciesGet_568343;
          resourceGroupName: string; apiVersion: string; serverName: string;
          subscriptionId: string; databaseName: string;
          policyName: string = "default"): Recallable =
  ## backupLongTermRetentionPoliciesGet
  ## Gets a database's long term retention policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   policyName: string (required)
  ##             : The policy name. Should always be Default.
  var path_568354 = newJObject()
  var query_568355 = newJObject()
  add(path_568354, "resourceGroupName", newJString(resourceGroupName))
  add(query_568355, "api-version", newJString(apiVersion))
  add(path_568354, "serverName", newJString(serverName))
  add(path_568354, "subscriptionId", newJString(subscriptionId))
  add(path_568354, "databaseName", newJString(databaseName))
  add(path_568354, "policyName", newJString(policyName))
  result = call_568353.call(path_568354, query_568355, nil, nil, nil)

var backupLongTermRetentionPoliciesGet* = Call_BackupLongTermRetentionPoliciesGet_568343(
    name: "backupLongTermRetentionPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/backupLongTermRetentionPolicies/{policyName}",
    validator: validate_BackupLongTermRetentionPoliciesGet_568344, base: "",
    url: url_BackupLongTermRetentionPoliciesGet_568345, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
