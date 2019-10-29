
import
  json, options, hashes, uri, rest, os, uri, httpcore

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

  OpenApiRestCall_563556 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563556](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563556): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "sql-longTermRetention"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_LongTermRetentionBackupsListByLocation_563778 = ref object of OpenApiRestCall_563556
proc url_LongTermRetentionBackupsListByLocation_563780(protocol: Scheme;
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

proc validate_LongTermRetentionBackupsListByLocation_563779(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the long term retention backups for a given location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : The location of the database
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_563955 = path.getOrDefault("locationName")
  valid_563955 = validateParameter(valid_563955, JString, required = true,
                                 default = nil)
  if valid_563955 != nil:
    section.add "locationName", valid_563955
  var valid_563956 = path.getOrDefault("subscriptionId")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "subscriptionId", valid_563956
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   onlyLatestPerDatabase: JBool
  ##                        : Whether or not to only get the latest backup for each database.
  ##   databaseState: JString
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563957 = query.getOrDefault("api-version")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = nil)
  if valid_563957 != nil:
    section.add "api-version", valid_563957
  var valid_563958 = query.getOrDefault("onlyLatestPerDatabase")
  valid_563958 = validateParameter(valid_563958, JBool, required = false, default = nil)
  if valid_563958 != nil:
    section.add "onlyLatestPerDatabase", valid_563958
  var valid_563972 = query.getOrDefault("databaseState")
  valid_563972 = validateParameter(valid_563972, JString, required = false,
                                 default = newJString("All"))
  if valid_563972 != nil:
    section.add "databaseState", valid_563972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563995: Call_LongTermRetentionBackupsListByLocation_563778;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the long term retention backups for a given location.
  ## 
  let valid = call_563995.validator(path, query, header, formData, body)
  let scheme = call_563995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563995.url(scheme.get, call_563995.host, call_563995.base,
                         call_563995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563995, url, valid)

proc call*(call_564066: Call_LongTermRetentionBackupsListByLocation_563778;
          apiVersion: string; locationName: string; subscriptionId: string;
          onlyLatestPerDatabase: bool = false; databaseState: string = "All"): Recallable =
  ## longTermRetentionBackupsListByLocation
  ## Lists the long term retention backups for a given location.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   onlyLatestPerDatabase: bool
  ##                        : Whether or not to only get the latest backup for each database.
  ##   locationName: string (required)
  ##               : The location of the database
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseState: string
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  var path_564067 = newJObject()
  var query_564069 = newJObject()
  add(query_564069, "api-version", newJString(apiVersion))
  add(query_564069, "onlyLatestPerDatabase", newJBool(onlyLatestPerDatabase))
  add(path_564067, "locationName", newJString(locationName))
  add(path_564067, "subscriptionId", newJString(subscriptionId))
  add(query_564069, "databaseState", newJString(databaseState))
  result = call_564066.call(path_564067, query_564069, nil, nil, nil)

var longTermRetentionBackupsListByLocation* = Call_LongTermRetentionBackupsListByLocation_563778(
    name: "longTermRetentionBackupsListByLocation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionBackups",
    validator: validate_LongTermRetentionBackupsListByLocation_563779, base: "",
    url: url_LongTermRetentionBackupsListByLocation_563780,
    schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsListByServer_564108 = ref object of OpenApiRestCall_563556
proc url_LongTermRetentionBackupsListByServer_564110(protocol: Scheme;
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

proc validate_LongTermRetentionBackupsListByServer_564109(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the long term retention backups for a given server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : The location of the database
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   longTermRetentionServerName: JString (required)
  ##                              : The name of the server
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_564111 = path.getOrDefault("locationName")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "locationName", valid_564111
  var valid_564112 = path.getOrDefault("subscriptionId")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "subscriptionId", valid_564112
  var valid_564113 = path.getOrDefault("longTermRetentionServerName")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "longTermRetentionServerName", valid_564113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   onlyLatestPerDatabase: JBool
  ##                        : Whether or not to only get the latest backup for each database.
  ##   databaseState: JString
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564114 = query.getOrDefault("api-version")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "api-version", valid_564114
  var valid_564115 = query.getOrDefault("onlyLatestPerDatabase")
  valid_564115 = validateParameter(valid_564115, JBool, required = false, default = nil)
  if valid_564115 != nil:
    section.add "onlyLatestPerDatabase", valid_564115
  var valid_564116 = query.getOrDefault("databaseState")
  valid_564116 = validateParameter(valid_564116, JString, required = false,
                                 default = newJString("All"))
  if valid_564116 != nil:
    section.add "databaseState", valid_564116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564117: Call_LongTermRetentionBackupsListByServer_564108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the long term retention backups for a given server.
  ## 
  let valid = call_564117.validator(path, query, header, formData, body)
  let scheme = call_564117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564117.url(scheme.get, call_564117.host, call_564117.base,
                         call_564117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564117, url, valid)

proc call*(call_564118: Call_LongTermRetentionBackupsListByServer_564108;
          apiVersion: string; locationName: string; subscriptionId: string;
          longTermRetentionServerName: string;
          onlyLatestPerDatabase: bool = false; databaseState: string = "All"): Recallable =
  ## longTermRetentionBackupsListByServer
  ## Lists the long term retention backups for a given server.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   onlyLatestPerDatabase: bool
  ##                        : Whether or not to only get the latest backup for each database.
  ##   locationName: string (required)
  ##               : The location of the database
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseState: string
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  ##   longTermRetentionServerName: string (required)
  ##                              : The name of the server
  var path_564119 = newJObject()
  var query_564120 = newJObject()
  add(query_564120, "api-version", newJString(apiVersion))
  add(query_564120, "onlyLatestPerDatabase", newJBool(onlyLatestPerDatabase))
  add(path_564119, "locationName", newJString(locationName))
  add(path_564119, "subscriptionId", newJString(subscriptionId))
  add(query_564120, "databaseState", newJString(databaseState))
  add(path_564119, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  result = call_564118.call(path_564119, query_564120, nil, nil, nil)

var longTermRetentionBackupsListByServer* = Call_LongTermRetentionBackupsListByServer_564108(
    name: "longTermRetentionBackupsListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionBackups",
    validator: validate_LongTermRetentionBackupsListByServer_564109, base: "",
    url: url_LongTermRetentionBackupsListByServer_564110, schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsListByDatabase_564121 = ref object of OpenApiRestCall_563556
proc url_LongTermRetentionBackupsListByDatabase_564123(protocol: Scheme;
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

proc validate_LongTermRetentionBackupsListByDatabase_564122(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all long term retention backups for a database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : The location of the database
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   longTermRetentionServerName: JString (required)
  ##                              : The name of the server
  ##   longTermRetentionDatabaseName: JString (required)
  ##                                : The name of the database
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_564124 = path.getOrDefault("locationName")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = nil)
  if valid_564124 != nil:
    section.add "locationName", valid_564124
  var valid_564125 = path.getOrDefault("subscriptionId")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "subscriptionId", valid_564125
  var valid_564126 = path.getOrDefault("longTermRetentionServerName")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "longTermRetentionServerName", valid_564126
  var valid_564127 = path.getOrDefault("longTermRetentionDatabaseName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "longTermRetentionDatabaseName", valid_564127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   onlyLatestPerDatabase: JBool
  ##                        : Whether or not to only get the latest backup for each database.
  ##   databaseState: JString
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564128 = query.getOrDefault("api-version")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "api-version", valid_564128
  var valid_564129 = query.getOrDefault("onlyLatestPerDatabase")
  valid_564129 = validateParameter(valid_564129, JBool, required = false, default = nil)
  if valid_564129 != nil:
    section.add "onlyLatestPerDatabase", valid_564129
  var valid_564130 = query.getOrDefault("databaseState")
  valid_564130 = validateParameter(valid_564130, JString, required = false,
                                 default = newJString("All"))
  if valid_564130 != nil:
    section.add "databaseState", valid_564130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564131: Call_LongTermRetentionBackupsListByDatabase_564121;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all long term retention backups for a database.
  ## 
  let valid = call_564131.validator(path, query, header, formData, body)
  let scheme = call_564131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564131.url(scheme.get, call_564131.host, call_564131.base,
                         call_564131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564131, url, valid)

proc call*(call_564132: Call_LongTermRetentionBackupsListByDatabase_564121;
          apiVersion: string; locationName: string; subscriptionId: string;
          longTermRetentionServerName: string;
          longTermRetentionDatabaseName: string;
          onlyLatestPerDatabase: bool = false; databaseState: string = "All"): Recallable =
  ## longTermRetentionBackupsListByDatabase
  ## Lists all long term retention backups for a database.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   onlyLatestPerDatabase: bool
  ##                        : Whether or not to only get the latest backup for each database.
  ##   locationName: string (required)
  ##               : The location of the database
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseState: string
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  ##   longTermRetentionServerName: string (required)
  ##                              : The name of the server
  ##   longTermRetentionDatabaseName: string (required)
  ##                                : The name of the database
  var path_564133 = newJObject()
  var query_564134 = newJObject()
  add(query_564134, "api-version", newJString(apiVersion))
  add(query_564134, "onlyLatestPerDatabase", newJBool(onlyLatestPerDatabase))
  add(path_564133, "locationName", newJString(locationName))
  add(path_564133, "subscriptionId", newJString(subscriptionId))
  add(query_564134, "databaseState", newJString(databaseState))
  add(path_564133, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_564133, "longTermRetentionDatabaseName",
      newJString(longTermRetentionDatabaseName))
  result = call_564132.call(path_564133, query_564134, nil, nil, nil)

var longTermRetentionBackupsListByDatabase* = Call_LongTermRetentionBackupsListByDatabase_564121(
    name: "longTermRetentionBackupsListByDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionDatabases/{longTermRetentionDatabaseName}/longTermRetentionBackups",
    validator: validate_LongTermRetentionBackupsListByDatabase_564122, base: "",
    url: url_LongTermRetentionBackupsListByDatabase_564123,
    schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsGet_564135 = ref object of OpenApiRestCall_563556
proc url_LongTermRetentionBackupsGet_564137(protocol: Scheme; host: string;
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

proc validate_LongTermRetentionBackupsGet_564136(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a long term retention backup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : The location of the database.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   longTermRetentionServerName: JString (required)
  ##                              : The name of the server
  ##   longTermRetentionDatabaseName: JString (required)
  ##                                : The name of the database
  ##   backupName: JString (required)
  ##             : The backup name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_564138 = path.getOrDefault("locationName")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = nil)
  if valid_564138 != nil:
    section.add "locationName", valid_564138
  var valid_564139 = path.getOrDefault("subscriptionId")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "subscriptionId", valid_564139
  var valid_564140 = path.getOrDefault("longTermRetentionServerName")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "longTermRetentionServerName", valid_564140
  var valid_564141 = path.getOrDefault("longTermRetentionDatabaseName")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "longTermRetentionDatabaseName", valid_564141
  var valid_564142 = path.getOrDefault("backupName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "backupName", valid_564142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564143 = query.getOrDefault("api-version")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "api-version", valid_564143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564144: Call_LongTermRetentionBackupsGet_564135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a long term retention backup.
  ## 
  let valid = call_564144.validator(path, query, header, formData, body)
  let scheme = call_564144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564144.url(scheme.get, call_564144.host, call_564144.base,
                         call_564144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564144, url, valid)

proc call*(call_564145: Call_LongTermRetentionBackupsGet_564135;
          apiVersion: string; locationName: string; subscriptionId: string;
          longTermRetentionServerName: string;
          longTermRetentionDatabaseName: string; backupName: string): Recallable =
  ## longTermRetentionBackupsGet
  ## Gets a long term retention backup.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   locationName: string (required)
  ##               : The location of the database.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   longTermRetentionServerName: string (required)
  ##                              : The name of the server
  ##   longTermRetentionDatabaseName: string (required)
  ##                                : The name of the database
  ##   backupName: string (required)
  ##             : The backup name.
  var path_564146 = newJObject()
  var query_564147 = newJObject()
  add(query_564147, "api-version", newJString(apiVersion))
  add(path_564146, "locationName", newJString(locationName))
  add(path_564146, "subscriptionId", newJString(subscriptionId))
  add(path_564146, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_564146, "longTermRetentionDatabaseName",
      newJString(longTermRetentionDatabaseName))
  add(path_564146, "backupName", newJString(backupName))
  result = call_564145.call(path_564146, query_564147, nil, nil, nil)

var longTermRetentionBackupsGet* = Call_LongTermRetentionBackupsGet_564135(
    name: "longTermRetentionBackupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionDatabases/{longTermRetentionDatabaseName}/longTermRetentionBackups/{backupName}",
    validator: validate_LongTermRetentionBackupsGet_564136, base: "",
    url: url_LongTermRetentionBackupsGet_564137, schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsDelete_564148 = ref object of OpenApiRestCall_563556
proc url_LongTermRetentionBackupsDelete_564150(protocol: Scheme; host: string;
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

proc validate_LongTermRetentionBackupsDelete_564149(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a long term retention backup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : The location of the database
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   longTermRetentionServerName: JString (required)
  ##                              : The name of the server
  ##   longTermRetentionDatabaseName: JString (required)
  ##                                : The name of the database
  ##   backupName: JString (required)
  ##             : The backup name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_564151 = path.getOrDefault("locationName")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "locationName", valid_564151
  var valid_564152 = path.getOrDefault("subscriptionId")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "subscriptionId", valid_564152
  var valid_564153 = path.getOrDefault("longTermRetentionServerName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "longTermRetentionServerName", valid_564153
  var valid_564154 = path.getOrDefault("longTermRetentionDatabaseName")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = nil)
  if valid_564154 != nil:
    section.add "longTermRetentionDatabaseName", valid_564154
  var valid_564155 = path.getOrDefault("backupName")
  valid_564155 = validateParameter(valid_564155, JString, required = true,
                                 default = nil)
  if valid_564155 != nil:
    section.add "backupName", valid_564155
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564156 = query.getOrDefault("api-version")
  valid_564156 = validateParameter(valid_564156, JString, required = true,
                                 default = nil)
  if valid_564156 != nil:
    section.add "api-version", valid_564156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564157: Call_LongTermRetentionBackupsDelete_564148; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a long term retention backup.
  ## 
  let valid = call_564157.validator(path, query, header, formData, body)
  let scheme = call_564157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564157.url(scheme.get, call_564157.host, call_564157.base,
                         call_564157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564157, url, valid)

proc call*(call_564158: Call_LongTermRetentionBackupsDelete_564148;
          apiVersion: string; locationName: string; subscriptionId: string;
          longTermRetentionServerName: string;
          longTermRetentionDatabaseName: string; backupName: string): Recallable =
  ## longTermRetentionBackupsDelete
  ## Deletes a long term retention backup.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   locationName: string (required)
  ##               : The location of the database
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   longTermRetentionServerName: string (required)
  ##                              : The name of the server
  ##   longTermRetentionDatabaseName: string (required)
  ##                                : The name of the database
  ##   backupName: string (required)
  ##             : The backup name.
  var path_564159 = newJObject()
  var query_564160 = newJObject()
  add(query_564160, "api-version", newJString(apiVersion))
  add(path_564159, "locationName", newJString(locationName))
  add(path_564159, "subscriptionId", newJString(subscriptionId))
  add(path_564159, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_564159, "longTermRetentionDatabaseName",
      newJString(longTermRetentionDatabaseName))
  add(path_564159, "backupName", newJString(backupName))
  result = call_564158.call(path_564159, query_564160, nil, nil, nil)

var longTermRetentionBackupsDelete* = Call_LongTermRetentionBackupsDelete_564148(
    name: "longTermRetentionBackupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionDatabases/{longTermRetentionDatabaseName}/longTermRetentionBackups/{backupName}",
    validator: validate_LongTermRetentionBackupsDelete_564149, base: "",
    url: url_LongTermRetentionBackupsDelete_564150, schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsListByResourceGroupLocation_564161 = ref object of OpenApiRestCall_563556
proc url_LongTermRetentionBackupsListByResourceGroupLocation_564163(
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

proc validate_LongTermRetentionBackupsListByResourceGroupLocation_564162(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the long term retention backups for a given location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : The location of the database
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_564164 = path.getOrDefault("locationName")
  valid_564164 = validateParameter(valid_564164, JString, required = true,
                                 default = nil)
  if valid_564164 != nil:
    section.add "locationName", valid_564164
  var valid_564165 = path.getOrDefault("subscriptionId")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = nil)
  if valid_564165 != nil:
    section.add "subscriptionId", valid_564165
  var valid_564166 = path.getOrDefault("resourceGroupName")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "resourceGroupName", valid_564166
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   onlyLatestPerDatabase: JBool
  ##                        : Whether or not to only get the latest backup for each database.
  ##   databaseState: JString
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564167 = query.getOrDefault("api-version")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "api-version", valid_564167
  var valid_564168 = query.getOrDefault("onlyLatestPerDatabase")
  valid_564168 = validateParameter(valid_564168, JBool, required = false, default = nil)
  if valid_564168 != nil:
    section.add "onlyLatestPerDatabase", valid_564168
  var valid_564169 = query.getOrDefault("databaseState")
  valid_564169 = validateParameter(valid_564169, JString, required = false,
                                 default = newJString("All"))
  if valid_564169 != nil:
    section.add "databaseState", valid_564169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564170: Call_LongTermRetentionBackupsListByResourceGroupLocation_564161;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the long term retention backups for a given location.
  ## 
  let valid = call_564170.validator(path, query, header, formData, body)
  let scheme = call_564170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564170.url(scheme.get, call_564170.host, call_564170.base,
                         call_564170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564170, url, valid)

proc call*(call_564171: Call_LongTermRetentionBackupsListByResourceGroupLocation_564161;
          apiVersion: string; locationName: string; subscriptionId: string;
          resourceGroupName: string; onlyLatestPerDatabase: bool = false;
          databaseState: string = "All"): Recallable =
  ## longTermRetentionBackupsListByResourceGroupLocation
  ## Lists the long term retention backups for a given location.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   onlyLatestPerDatabase: bool
  ##                        : Whether or not to only get the latest backup for each database.
  ##   locationName: string (required)
  ##               : The location of the database
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseState: string
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564172 = newJObject()
  var query_564173 = newJObject()
  add(query_564173, "api-version", newJString(apiVersion))
  add(query_564173, "onlyLatestPerDatabase", newJBool(onlyLatestPerDatabase))
  add(path_564172, "locationName", newJString(locationName))
  add(path_564172, "subscriptionId", newJString(subscriptionId))
  add(query_564173, "databaseState", newJString(databaseState))
  add(path_564172, "resourceGroupName", newJString(resourceGroupName))
  result = call_564171.call(path_564172, query_564173, nil, nil, nil)

var longTermRetentionBackupsListByResourceGroupLocation* = Call_LongTermRetentionBackupsListByResourceGroupLocation_564161(
    name: "longTermRetentionBackupsListByResourceGroupLocation",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionBackups",
    validator: validate_LongTermRetentionBackupsListByResourceGroupLocation_564162,
    base: "", url: url_LongTermRetentionBackupsListByResourceGroupLocation_564163,
    schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsListByResourceGroupServer_564174 = ref object of OpenApiRestCall_563556
proc url_LongTermRetentionBackupsListByResourceGroupServer_564176(
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

proc validate_LongTermRetentionBackupsListByResourceGroupServer_564175(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists the long term retention backups for a given server.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : The location of the database
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   longTermRetentionServerName: JString (required)
  ##                              : The name of the server
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_564177 = path.getOrDefault("locationName")
  valid_564177 = validateParameter(valid_564177, JString, required = true,
                                 default = nil)
  if valid_564177 != nil:
    section.add "locationName", valid_564177
  var valid_564178 = path.getOrDefault("subscriptionId")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = nil)
  if valid_564178 != nil:
    section.add "subscriptionId", valid_564178
  var valid_564179 = path.getOrDefault("resourceGroupName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "resourceGroupName", valid_564179
  var valid_564180 = path.getOrDefault("longTermRetentionServerName")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "longTermRetentionServerName", valid_564180
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   onlyLatestPerDatabase: JBool
  ##                        : Whether or not to only get the latest backup for each database.
  ##   databaseState: JString
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564181 = query.getOrDefault("api-version")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "api-version", valid_564181
  var valid_564182 = query.getOrDefault("onlyLatestPerDatabase")
  valid_564182 = validateParameter(valid_564182, JBool, required = false, default = nil)
  if valid_564182 != nil:
    section.add "onlyLatestPerDatabase", valid_564182
  var valid_564183 = query.getOrDefault("databaseState")
  valid_564183 = validateParameter(valid_564183, JString, required = false,
                                 default = newJString("All"))
  if valid_564183 != nil:
    section.add "databaseState", valid_564183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564184: Call_LongTermRetentionBackupsListByResourceGroupServer_564174;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the long term retention backups for a given server.
  ## 
  let valid = call_564184.validator(path, query, header, formData, body)
  let scheme = call_564184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564184.url(scheme.get, call_564184.host, call_564184.base,
                         call_564184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564184, url, valid)

proc call*(call_564185: Call_LongTermRetentionBackupsListByResourceGroupServer_564174;
          apiVersion: string; locationName: string; subscriptionId: string;
          resourceGroupName: string; longTermRetentionServerName: string;
          onlyLatestPerDatabase: bool = false; databaseState: string = "All"): Recallable =
  ## longTermRetentionBackupsListByResourceGroupServer
  ## Lists the long term retention backups for a given server.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   onlyLatestPerDatabase: bool
  ##                        : Whether or not to only get the latest backup for each database.
  ##   locationName: string (required)
  ##               : The location of the database
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseState: string
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   longTermRetentionServerName: string (required)
  ##                              : The name of the server
  var path_564186 = newJObject()
  var query_564187 = newJObject()
  add(query_564187, "api-version", newJString(apiVersion))
  add(query_564187, "onlyLatestPerDatabase", newJBool(onlyLatestPerDatabase))
  add(path_564186, "locationName", newJString(locationName))
  add(path_564186, "subscriptionId", newJString(subscriptionId))
  add(query_564187, "databaseState", newJString(databaseState))
  add(path_564186, "resourceGroupName", newJString(resourceGroupName))
  add(path_564186, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  result = call_564185.call(path_564186, query_564187, nil, nil, nil)

var longTermRetentionBackupsListByResourceGroupServer* = Call_LongTermRetentionBackupsListByResourceGroupServer_564174(
    name: "longTermRetentionBackupsListByResourceGroupServer",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionBackups",
    validator: validate_LongTermRetentionBackupsListByResourceGroupServer_564175,
    base: "", url: url_LongTermRetentionBackupsListByResourceGroupServer_564176,
    schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsListByResourceGroupDatabase_564188 = ref object of OpenApiRestCall_563556
proc url_LongTermRetentionBackupsListByResourceGroupDatabase_564190(
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

proc validate_LongTermRetentionBackupsListByResourceGroupDatabase_564189(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all long term retention backups for a database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : The location of the database
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   longTermRetentionServerName: JString (required)
  ##                              : The name of the server
  ##   longTermRetentionDatabaseName: JString (required)
  ##                                : The name of the database
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_564191 = path.getOrDefault("locationName")
  valid_564191 = validateParameter(valid_564191, JString, required = true,
                                 default = nil)
  if valid_564191 != nil:
    section.add "locationName", valid_564191
  var valid_564192 = path.getOrDefault("subscriptionId")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "subscriptionId", valid_564192
  var valid_564193 = path.getOrDefault("resourceGroupName")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "resourceGroupName", valid_564193
  var valid_564194 = path.getOrDefault("longTermRetentionServerName")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "longTermRetentionServerName", valid_564194
  var valid_564195 = path.getOrDefault("longTermRetentionDatabaseName")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "longTermRetentionDatabaseName", valid_564195
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  ##   onlyLatestPerDatabase: JBool
  ##                        : Whether or not to only get the latest backup for each database.
  ##   databaseState: JString
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564196 = query.getOrDefault("api-version")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "api-version", valid_564196
  var valid_564197 = query.getOrDefault("onlyLatestPerDatabase")
  valid_564197 = validateParameter(valid_564197, JBool, required = false, default = nil)
  if valid_564197 != nil:
    section.add "onlyLatestPerDatabase", valid_564197
  var valid_564198 = query.getOrDefault("databaseState")
  valid_564198 = validateParameter(valid_564198, JString, required = false,
                                 default = newJString("All"))
  if valid_564198 != nil:
    section.add "databaseState", valid_564198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564199: Call_LongTermRetentionBackupsListByResourceGroupDatabase_564188;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all long term retention backups for a database.
  ## 
  let valid = call_564199.validator(path, query, header, formData, body)
  let scheme = call_564199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564199.url(scheme.get, call_564199.host, call_564199.base,
                         call_564199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564199, url, valid)

proc call*(call_564200: Call_LongTermRetentionBackupsListByResourceGroupDatabase_564188;
          apiVersion: string; locationName: string; subscriptionId: string;
          resourceGroupName: string; longTermRetentionServerName: string;
          longTermRetentionDatabaseName: string;
          onlyLatestPerDatabase: bool = false; databaseState: string = "All"): Recallable =
  ## longTermRetentionBackupsListByResourceGroupDatabase
  ## Lists all long term retention backups for a database.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   onlyLatestPerDatabase: bool
  ##                        : Whether or not to only get the latest backup for each database.
  ##   locationName: string (required)
  ##               : The location of the database
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseState: string
  ##                : Whether to query against just live databases, just deleted databases, or all databases.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   longTermRetentionServerName: string (required)
  ##                              : The name of the server
  ##   longTermRetentionDatabaseName: string (required)
  ##                                : The name of the database
  var path_564201 = newJObject()
  var query_564202 = newJObject()
  add(query_564202, "api-version", newJString(apiVersion))
  add(query_564202, "onlyLatestPerDatabase", newJBool(onlyLatestPerDatabase))
  add(path_564201, "locationName", newJString(locationName))
  add(path_564201, "subscriptionId", newJString(subscriptionId))
  add(query_564202, "databaseState", newJString(databaseState))
  add(path_564201, "resourceGroupName", newJString(resourceGroupName))
  add(path_564201, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_564201, "longTermRetentionDatabaseName",
      newJString(longTermRetentionDatabaseName))
  result = call_564200.call(path_564201, query_564202, nil, nil, nil)

var longTermRetentionBackupsListByResourceGroupDatabase* = Call_LongTermRetentionBackupsListByResourceGroupDatabase_564188(
    name: "longTermRetentionBackupsListByResourceGroupDatabase",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionDatabases/{longTermRetentionDatabaseName}/longTermRetentionBackups",
    validator: validate_LongTermRetentionBackupsListByResourceGroupDatabase_564189,
    base: "", url: url_LongTermRetentionBackupsListByResourceGroupDatabase_564190,
    schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsGetByResourceGroup_564203 = ref object of OpenApiRestCall_563556
proc url_LongTermRetentionBackupsGetByResourceGroup_564205(protocol: Scheme;
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

proc validate_LongTermRetentionBackupsGetByResourceGroup_564204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a long term retention backup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : The location of the database.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   longTermRetentionServerName: JString (required)
  ##                              : The name of the server
  ##   longTermRetentionDatabaseName: JString (required)
  ##                                : The name of the database
  ##   backupName: JString (required)
  ##             : The backup name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_564206 = path.getOrDefault("locationName")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "locationName", valid_564206
  var valid_564207 = path.getOrDefault("subscriptionId")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "subscriptionId", valid_564207
  var valid_564208 = path.getOrDefault("resourceGroupName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "resourceGroupName", valid_564208
  var valid_564209 = path.getOrDefault("longTermRetentionServerName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "longTermRetentionServerName", valid_564209
  var valid_564210 = path.getOrDefault("longTermRetentionDatabaseName")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "longTermRetentionDatabaseName", valid_564210
  var valid_564211 = path.getOrDefault("backupName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "backupName", valid_564211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564212 = query.getOrDefault("api-version")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "api-version", valid_564212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564213: Call_LongTermRetentionBackupsGetByResourceGroup_564203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a long term retention backup.
  ## 
  let valid = call_564213.validator(path, query, header, formData, body)
  let scheme = call_564213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564213.url(scheme.get, call_564213.host, call_564213.base,
                         call_564213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564213, url, valid)

proc call*(call_564214: Call_LongTermRetentionBackupsGetByResourceGroup_564203;
          apiVersion: string; locationName: string; subscriptionId: string;
          resourceGroupName: string; longTermRetentionServerName: string;
          longTermRetentionDatabaseName: string; backupName: string): Recallable =
  ## longTermRetentionBackupsGetByResourceGroup
  ## Gets a long term retention backup.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   locationName: string (required)
  ##               : The location of the database.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   longTermRetentionServerName: string (required)
  ##                              : The name of the server
  ##   longTermRetentionDatabaseName: string (required)
  ##                                : The name of the database
  ##   backupName: string (required)
  ##             : The backup name.
  var path_564215 = newJObject()
  var query_564216 = newJObject()
  add(query_564216, "api-version", newJString(apiVersion))
  add(path_564215, "locationName", newJString(locationName))
  add(path_564215, "subscriptionId", newJString(subscriptionId))
  add(path_564215, "resourceGroupName", newJString(resourceGroupName))
  add(path_564215, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_564215, "longTermRetentionDatabaseName",
      newJString(longTermRetentionDatabaseName))
  add(path_564215, "backupName", newJString(backupName))
  result = call_564214.call(path_564215, query_564216, nil, nil, nil)

var longTermRetentionBackupsGetByResourceGroup* = Call_LongTermRetentionBackupsGetByResourceGroup_564203(
    name: "longTermRetentionBackupsGetByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionDatabases/{longTermRetentionDatabaseName}/longTermRetentionBackups/{backupName}",
    validator: validate_LongTermRetentionBackupsGetByResourceGroup_564204,
    base: "", url: url_LongTermRetentionBackupsGetByResourceGroup_564205,
    schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsDeleteByResourceGroup_564217 = ref object of OpenApiRestCall_563556
proc url_LongTermRetentionBackupsDeleteByResourceGroup_564219(protocol: Scheme;
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

proc validate_LongTermRetentionBackupsDeleteByResourceGroup_564218(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a long term retention backup.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   locationName: JString (required)
  ##               : The location of the database
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   longTermRetentionServerName: JString (required)
  ##                              : The name of the server
  ##   longTermRetentionDatabaseName: JString (required)
  ##                                : The name of the database
  ##   backupName: JString (required)
  ##             : The backup name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `locationName` field"
  var valid_564220 = path.getOrDefault("locationName")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "locationName", valid_564220
  var valid_564221 = path.getOrDefault("subscriptionId")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "subscriptionId", valid_564221
  var valid_564222 = path.getOrDefault("resourceGroupName")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "resourceGroupName", valid_564222
  var valid_564223 = path.getOrDefault("longTermRetentionServerName")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "longTermRetentionServerName", valid_564223
  var valid_564224 = path.getOrDefault("longTermRetentionDatabaseName")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "longTermRetentionDatabaseName", valid_564224
  var valid_564225 = path.getOrDefault("backupName")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "backupName", valid_564225
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564226 = query.getOrDefault("api-version")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "api-version", valid_564226
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564227: Call_LongTermRetentionBackupsDeleteByResourceGroup_564217;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long term retention backup.
  ## 
  let valid = call_564227.validator(path, query, header, formData, body)
  let scheme = call_564227.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564227.url(scheme.get, call_564227.host, call_564227.base,
                         call_564227.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564227, url, valid)

proc call*(call_564228: Call_LongTermRetentionBackupsDeleteByResourceGroup_564217;
          apiVersion: string; locationName: string; subscriptionId: string;
          resourceGroupName: string; longTermRetentionServerName: string;
          longTermRetentionDatabaseName: string; backupName: string): Recallable =
  ## longTermRetentionBackupsDeleteByResourceGroup
  ## Deletes a long term retention backup.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   locationName: string (required)
  ##               : The location of the database
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   longTermRetentionServerName: string (required)
  ##                              : The name of the server
  ##   longTermRetentionDatabaseName: string (required)
  ##                                : The name of the database
  ##   backupName: string (required)
  ##             : The backup name.
  var path_564229 = newJObject()
  var query_564230 = newJObject()
  add(query_564230, "api-version", newJString(apiVersion))
  add(path_564229, "locationName", newJString(locationName))
  add(path_564229, "subscriptionId", newJString(subscriptionId))
  add(path_564229, "resourceGroupName", newJString(resourceGroupName))
  add(path_564229, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_564229, "longTermRetentionDatabaseName",
      newJString(longTermRetentionDatabaseName))
  add(path_564229, "backupName", newJString(backupName))
  result = call_564228.call(path_564229, query_564230, nil, nil, nil)

var longTermRetentionBackupsDeleteByResourceGroup* = Call_LongTermRetentionBackupsDeleteByResourceGroup_564217(
    name: "longTermRetentionBackupsDeleteByResourceGroup",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionDatabases/{longTermRetentionDatabaseName}/longTermRetentionBackups/{backupName}",
    validator: validate_LongTermRetentionBackupsDeleteByResourceGroup_564218,
    base: "", url: url_LongTermRetentionBackupsDeleteByResourceGroup_564219,
    schemes: {Scheme.Https})
type
  Call_BackupLongTermRetentionPoliciesListByDatabase_564231 = ref object of OpenApiRestCall_563556
proc url_BackupLongTermRetentionPoliciesListByDatabase_564233(protocol: Scheme;
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

proc validate_BackupLongTermRetentionPoliciesListByDatabase_564232(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a database's long term retention policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564234 = path.getOrDefault("serverName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "serverName", valid_564234
  var valid_564235 = path.getOrDefault("subscriptionId")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "subscriptionId", valid_564235
  var valid_564236 = path.getOrDefault("databaseName")
  valid_564236 = validateParameter(valid_564236, JString, required = true,
                                 default = nil)
  if valid_564236 != nil:
    section.add "databaseName", valid_564236
  var valid_564237 = path.getOrDefault("resourceGroupName")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = nil)
  if valid_564237 != nil:
    section.add "resourceGroupName", valid_564237
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564238 = query.getOrDefault("api-version")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "api-version", valid_564238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564239: Call_BackupLongTermRetentionPoliciesListByDatabase_564231;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a database's long term retention policy.
  ## 
  let valid = call_564239.validator(path, query, header, formData, body)
  let scheme = call_564239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564239.url(scheme.get, call_564239.host, call_564239.base,
                         call_564239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564239, url, valid)

proc call*(call_564240: Call_BackupLongTermRetentionPoliciesListByDatabase_564231;
          apiVersion: string; serverName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string): Recallable =
  ## backupLongTermRetentionPoliciesListByDatabase
  ## Gets a database's long term retention policy.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564241 = newJObject()
  var query_564242 = newJObject()
  add(query_564242, "api-version", newJString(apiVersion))
  add(path_564241, "serverName", newJString(serverName))
  add(path_564241, "subscriptionId", newJString(subscriptionId))
  add(path_564241, "databaseName", newJString(databaseName))
  add(path_564241, "resourceGroupName", newJString(resourceGroupName))
  result = call_564240.call(path_564241, query_564242, nil, nil, nil)

var backupLongTermRetentionPoliciesListByDatabase* = Call_BackupLongTermRetentionPoliciesListByDatabase_564231(
    name: "backupLongTermRetentionPoliciesListByDatabase",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/backupLongTermRetentionPolicies",
    validator: validate_BackupLongTermRetentionPoliciesListByDatabase_564232,
    base: "", url: url_BackupLongTermRetentionPoliciesListByDatabase_564233,
    schemes: {Scheme.Https})
type
  Call_BackupLongTermRetentionPoliciesCreateOrUpdate_564256 = ref object of OpenApiRestCall_563556
proc url_BackupLongTermRetentionPoliciesCreateOrUpdate_564258(protocol: Scheme;
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

proc validate_BackupLongTermRetentionPoliciesCreateOrUpdate_564257(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets a database's long term retention policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : The policy name. Should always be Default.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564259 = path.getOrDefault("policyName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = newJString("default"))
  if valid_564259 != nil:
    section.add "policyName", valid_564259
  var valid_564260 = path.getOrDefault("serverName")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "serverName", valid_564260
  var valid_564261 = path.getOrDefault("subscriptionId")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "subscriptionId", valid_564261
  var valid_564262 = path.getOrDefault("databaseName")
  valid_564262 = validateParameter(valid_564262, JString, required = true,
                                 default = nil)
  if valid_564262 != nil:
    section.add "databaseName", valid_564262
  var valid_564263 = path.getOrDefault("resourceGroupName")
  valid_564263 = validateParameter(valid_564263, JString, required = true,
                                 default = nil)
  if valid_564263 != nil:
    section.add "resourceGroupName", valid_564263
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564264 = query.getOrDefault("api-version")
  valid_564264 = validateParameter(valid_564264, JString, required = true,
                                 default = nil)
  if valid_564264 != nil:
    section.add "api-version", valid_564264
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

proc call*(call_564266: Call_BackupLongTermRetentionPoliciesCreateOrUpdate_564256;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets a database's long term retention policy.
  ## 
  let valid = call_564266.validator(path, query, header, formData, body)
  let scheme = call_564266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564266.url(scheme.get, call_564266.host, call_564266.base,
                         call_564266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564266, url, valid)

proc call*(call_564267: Call_BackupLongTermRetentionPoliciesCreateOrUpdate_564256;
          apiVersion: string; serverName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; parameters: JsonNode;
          policyName: string = "default"): Recallable =
  ## backupLongTermRetentionPoliciesCreateOrUpdate
  ## Sets a database's long term retention policy.
  ##   policyName: string (required)
  ##             : The policy name. Should always be Default.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The long term retention policy info.
  var path_564268 = newJObject()
  var query_564269 = newJObject()
  var body_564270 = newJObject()
  add(path_564268, "policyName", newJString(policyName))
  add(query_564269, "api-version", newJString(apiVersion))
  add(path_564268, "serverName", newJString(serverName))
  add(path_564268, "subscriptionId", newJString(subscriptionId))
  add(path_564268, "databaseName", newJString(databaseName))
  add(path_564268, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564270 = parameters
  result = call_564267.call(path_564268, query_564269, nil, nil, body_564270)

var backupLongTermRetentionPoliciesCreateOrUpdate* = Call_BackupLongTermRetentionPoliciesCreateOrUpdate_564256(
    name: "backupLongTermRetentionPoliciesCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/backupLongTermRetentionPolicies/{policyName}",
    validator: validate_BackupLongTermRetentionPoliciesCreateOrUpdate_564257,
    base: "", url: url_BackupLongTermRetentionPoliciesCreateOrUpdate_564258,
    schemes: {Scheme.Https})
type
  Call_BackupLongTermRetentionPoliciesGet_564243 = ref object of OpenApiRestCall_563556
proc url_BackupLongTermRetentionPoliciesGet_564245(protocol: Scheme; host: string;
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

proc validate_BackupLongTermRetentionPoliciesGet_564244(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a database's long term retention policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   policyName: JString (required)
  ##             : The policy name. Should always be Default.
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `policyName` field"
  var valid_564246 = path.getOrDefault("policyName")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = newJString("default"))
  if valid_564246 != nil:
    section.add "policyName", valid_564246
  var valid_564247 = path.getOrDefault("serverName")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "serverName", valid_564247
  var valid_564248 = path.getOrDefault("subscriptionId")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "subscriptionId", valid_564248
  var valid_564249 = path.getOrDefault("databaseName")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "databaseName", valid_564249
  var valid_564250 = path.getOrDefault("resourceGroupName")
  valid_564250 = validateParameter(valid_564250, JString, required = true,
                                 default = nil)
  if valid_564250 != nil:
    section.add "resourceGroupName", valid_564250
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564251 = query.getOrDefault("api-version")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "api-version", valid_564251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564252: Call_BackupLongTermRetentionPoliciesGet_564243;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a database's long term retention policy.
  ## 
  let valid = call_564252.validator(path, query, header, formData, body)
  let scheme = call_564252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564252.url(scheme.get, call_564252.host, call_564252.base,
                         call_564252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564252, url, valid)

proc call*(call_564253: Call_BackupLongTermRetentionPoliciesGet_564243;
          apiVersion: string; serverName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string;
          policyName: string = "default"): Recallable =
  ## backupLongTermRetentionPoliciesGet
  ## Gets a database's long term retention policy.
  ##   policyName: string (required)
  ##             : The policy name. Should always be Default.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  var path_564254 = newJObject()
  var query_564255 = newJObject()
  add(path_564254, "policyName", newJString(policyName))
  add(query_564255, "api-version", newJString(apiVersion))
  add(path_564254, "serverName", newJString(serverName))
  add(path_564254, "subscriptionId", newJString(subscriptionId))
  add(path_564254, "databaseName", newJString(databaseName))
  add(path_564254, "resourceGroupName", newJString(resourceGroupName))
  result = call_564253.call(path_564254, query_564255, nil, nil, nil)

var backupLongTermRetentionPoliciesGet* = Call_BackupLongTermRetentionPoliciesGet_564243(
    name: "backupLongTermRetentionPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/backupLongTermRetentionPolicies/{policyName}",
    validator: validate_BackupLongTermRetentionPoliciesGet_564244, base: "",
    url: url_BackupLongTermRetentionPoliciesGet_564245, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
