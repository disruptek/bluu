
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593425 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593425](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593425): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_LongTermRetentionBackupsListByLocation_593647 = ref object of OpenApiRestCall_593425
proc url_LongTermRetentionBackupsListByLocation_593649(protocol: Scheme;
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

proc validate_LongTermRetentionBackupsListByLocation_593648(path: JsonNode;
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
  var valid_593822 = path.getOrDefault("subscriptionId")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "subscriptionId", valid_593822
  var valid_593823 = path.getOrDefault("locationName")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "locationName", valid_593823
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
  var valid_593824 = query.getOrDefault("api-version")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "api-version", valid_593824
  var valid_593838 = query.getOrDefault("databaseState")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = newJString("All"))
  if valid_593838 != nil:
    section.add "databaseState", valid_593838
  var valid_593839 = query.getOrDefault("onlyLatestPerDatabase")
  valid_593839 = validateParameter(valid_593839, JBool, required = false, default = nil)
  if valid_593839 != nil:
    section.add "onlyLatestPerDatabase", valid_593839
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593862: Call_LongTermRetentionBackupsListByLocation_593647;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the long term retention backups for a given location.
  ## 
  let valid = call_593862.validator(path, query, header, formData, body)
  let scheme = call_593862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593862.url(scheme.get, call_593862.host, call_593862.base,
                         call_593862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593862, url, valid)

proc call*(call_593933: Call_LongTermRetentionBackupsListByLocation_593647;
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
  var path_593934 = newJObject()
  var query_593936 = newJObject()
  add(query_593936, "api-version", newJString(apiVersion))
  add(path_593934, "subscriptionId", newJString(subscriptionId))
  add(path_593934, "locationName", newJString(locationName))
  add(query_593936, "databaseState", newJString(databaseState))
  add(query_593936, "onlyLatestPerDatabase", newJBool(onlyLatestPerDatabase))
  result = call_593933.call(path_593934, query_593936, nil, nil, nil)

var longTermRetentionBackupsListByLocation* = Call_LongTermRetentionBackupsListByLocation_593647(
    name: "longTermRetentionBackupsListByLocation", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionBackups",
    validator: validate_LongTermRetentionBackupsListByLocation_593648, base: "",
    url: url_LongTermRetentionBackupsListByLocation_593649,
    schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsListByServer_593975 = ref object of OpenApiRestCall_593425
proc url_LongTermRetentionBackupsListByServer_593977(protocol: Scheme;
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

proc validate_LongTermRetentionBackupsListByServer_593976(path: JsonNode;
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
  var valid_593978 = path.getOrDefault("subscriptionId")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "subscriptionId", valid_593978
  var valid_593979 = path.getOrDefault("longTermRetentionServerName")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "longTermRetentionServerName", valid_593979
  var valid_593980 = path.getOrDefault("locationName")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "locationName", valid_593980
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
  var valid_593981 = query.getOrDefault("api-version")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "api-version", valid_593981
  var valid_593982 = query.getOrDefault("databaseState")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = newJString("All"))
  if valid_593982 != nil:
    section.add "databaseState", valid_593982
  var valid_593983 = query.getOrDefault("onlyLatestPerDatabase")
  valid_593983 = validateParameter(valid_593983, JBool, required = false, default = nil)
  if valid_593983 != nil:
    section.add "onlyLatestPerDatabase", valid_593983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593984: Call_LongTermRetentionBackupsListByServer_593975;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the long term retention backups for a given server.
  ## 
  let valid = call_593984.validator(path, query, header, formData, body)
  let scheme = call_593984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593984.url(scheme.get, call_593984.host, call_593984.base,
                         call_593984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593984, url, valid)

proc call*(call_593985: Call_LongTermRetentionBackupsListByServer_593975;
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
  var path_593986 = newJObject()
  var query_593987 = newJObject()
  add(query_593987, "api-version", newJString(apiVersion))
  add(path_593986, "subscriptionId", newJString(subscriptionId))
  add(path_593986, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_593986, "locationName", newJString(locationName))
  add(query_593987, "databaseState", newJString(databaseState))
  add(query_593987, "onlyLatestPerDatabase", newJBool(onlyLatestPerDatabase))
  result = call_593985.call(path_593986, query_593987, nil, nil, nil)

var longTermRetentionBackupsListByServer* = Call_LongTermRetentionBackupsListByServer_593975(
    name: "longTermRetentionBackupsListByServer", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionBackups",
    validator: validate_LongTermRetentionBackupsListByServer_593976, base: "",
    url: url_LongTermRetentionBackupsListByServer_593977, schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsListByDatabase_593988 = ref object of OpenApiRestCall_593425
proc url_LongTermRetentionBackupsListByDatabase_593990(protocol: Scheme;
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

proc validate_LongTermRetentionBackupsListByDatabase_593989(path: JsonNode;
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
  var valid_593991 = path.getOrDefault("longTermRetentionDatabaseName")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "longTermRetentionDatabaseName", valid_593991
  var valid_593992 = path.getOrDefault("subscriptionId")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "subscriptionId", valid_593992
  var valid_593993 = path.getOrDefault("longTermRetentionServerName")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "longTermRetentionServerName", valid_593993
  var valid_593994 = path.getOrDefault("locationName")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "locationName", valid_593994
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
  var valid_593995 = query.getOrDefault("api-version")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "api-version", valid_593995
  var valid_593996 = query.getOrDefault("databaseState")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = newJString("All"))
  if valid_593996 != nil:
    section.add "databaseState", valid_593996
  var valid_593997 = query.getOrDefault("onlyLatestPerDatabase")
  valid_593997 = validateParameter(valid_593997, JBool, required = false, default = nil)
  if valid_593997 != nil:
    section.add "onlyLatestPerDatabase", valid_593997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593998: Call_LongTermRetentionBackupsListByDatabase_593988;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all long term retention backups for a database.
  ## 
  let valid = call_593998.validator(path, query, header, formData, body)
  let scheme = call_593998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593998.url(scheme.get, call_593998.host, call_593998.base,
                         call_593998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593998, url, valid)

proc call*(call_593999: Call_LongTermRetentionBackupsListByDatabase_593988;
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
  var path_594000 = newJObject()
  var query_594001 = newJObject()
  add(query_594001, "api-version", newJString(apiVersion))
  add(path_594000, "longTermRetentionDatabaseName",
      newJString(longTermRetentionDatabaseName))
  add(path_594000, "subscriptionId", newJString(subscriptionId))
  add(path_594000, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_594000, "locationName", newJString(locationName))
  add(query_594001, "databaseState", newJString(databaseState))
  add(query_594001, "onlyLatestPerDatabase", newJBool(onlyLatestPerDatabase))
  result = call_593999.call(path_594000, query_594001, nil, nil, nil)

var longTermRetentionBackupsListByDatabase* = Call_LongTermRetentionBackupsListByDatabase_593988(
    name: "longTermRetentionBackupsListByDatabase", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionDatabases/{longTermRetentionDatabaseName}/longTermRetentionBackups",
    validator: validate_LongTermRetentionBackupsListByDatabase_593989, base: "",
    url: url_LongTermRetentionBackupsListByDatabase_593990,
    schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsGet_594002 = ref object of OpenApiRestCall_593425
proc url_LongTermRetentionBackupsGet_594004(protocol: Scheme; host: string;
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

proc validate_LongTermRetentionBackupsGet_594003(path: JsonNode; query: JsonNode;
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
  var valid_594005 = path.getOrDefault("longTermRetentionDatabaseName")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "longTermRetentionDatabaseName", valid_594005
  var valid_594006 = path.getOrDefault("subscriptionId")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "subscriptionId", valid_594006
  var valid_594007 = path.getOrDefault("backupName")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "backupName", valid_594007
  var valid_594008 = path.getOrDefault("longTermRetentionServerName")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "longTermRetentionServerName", valid_594008
  var valid_594009 = path.getOrDefault("locationName")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "locationName", valid_594009
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594010 = query.getOrDefault("api-version")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "api-version", valid_594010
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594011: Call_LongTermRetentionBackupsGet_594002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a long term retention backup.
  ## 
  let valid = call_594011.validator(path, query, header, formData, body)
  let scheme = call_594011.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594011.url(scheme.get, call_594011.host, call_594011.base,
                         call_594011.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594011, url, valid)

proc call*(call_594012: Call_LongTermRetentionBackupsGet_594002;
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
  var path_594013 = newJObject()
  var query_594014 = newJObject()
  add(query_594014, "api-version", newJString(apiVersion))
  add(path_594013, "longTermRetentionDatabaseName",
      newJString(longTermRetentionDatabaseName))
  add(path_594013, "subscriptionId", newJString(subscriptionId))
  add(path_594013, "backupName", newJString(backupName))
  add(path_594013, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_594013, "locationName", newJString(locationName))
  result = call_594012.call(path_594013, query_594014, nil, nil, nil)

var longTermRetentionBackupsGet* = Call_LongTermRetentionBackupsGet_594002(
    name: "longTermRetentionBackupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionDatabases/{longTermRetentionDatabaseName}/longTermRetentionBackups/{backupName}",
    validator: validate_LongTermRetentionBackupsGet_594003, base: "",
    url: url_LongTermRetentionBackupsGet_594004, schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsDelete_594015 = ref object of OpenApiRestCall_593425
proc url_LongTermRetentionBackupsDelete_594017(protocol: Scheme; host: string;
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

proc validate_LongTermRetentionBackupsDelete_594016(path: JsonNode;
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
  var valid_594018 = path.getOrDefault("longTermRetentionDatabaseName")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "longTermRetentionDatabaseName", valid_594018
  var valid_594019 = path.getOrDefault("subscriptionId")
  valid_594019 = validateParameter(valid_594019, JString, required = true,
                                 default = nil)
  if valid_594019 != nil:
    section.add "subscriptionId", valid_594019
  var valid_594020 = path.getOrDefault("backupName")
  valid_594020 = validateParameter(valid_594020, JString, required = true,
                                 default = nil)
  if valid_594020 != nil:
    section.add "backupName", valid_594020
  var valid_594021 = path.getOrDefault("longTermRetentionServerName")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "longTermRetentionServerName", valid_594021
  var valid_594022 = path.getOrDefault("locationName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "locationName", valid_594022
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594023 = query.getOrDefault("api-version")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "api-version", valid_594023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594024: Call_LongTermRetentionBackupsDelete_594015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a long term retention backup.
  ## 
  let valid = call_594024.validator(path, query, header, formData, body)
  let scheme = call_594024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594024.url(scheme.get, call_594024.host, call_594024.base,
                         call_594024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594024, url, valid)

proc call*(call_594025: Call_LongTermRetentionBackupsDelete_594015;
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
  var path_594026 = newJObject()
  var query_594027 = newJObject()
  add(query_594027, "api-version", newJString(apiVersion))
  add(path_594026, "longTermRetentionDatabaseName",
      newJString(longTermRetentionDatabaseName))
  add(path_594026, "subscriptionId", newJString(subscriptionId))
  add(path_594026, "backupName", newJString(backupName))
  add(path_594026, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_594026, "locationName", newJString(locationName))
  result = call_594025.call(path_594026, query_594027, nil, nil, nil)

var longTermRetentionBackupsDelete* = Call_LongTermRetentionBackupsDelete_594015(
    name: "longTermRetentionBackupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionDatabases/{longTermRetentionDatabaseName}/longTermRetentionBackups/{backupName}",
    validator: validate_LongTermRetentionBackupsDelete_594016, base: "",
    url: url_LongTermRetentionBackupsDelete_594017, schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsListByResourceGroupLocation_594028 = ref object of OpenApiRestCall_593425
proc url_LongTermRetentionBackupsListByResourceGroupLocation_594030(
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

proc validate_LongTermRetentionBackupsListByResourceGroupLocation_594029(
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
  var valid_594031 = path.getOrDefault("resourceGroupName")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "resourceGroupName", valid_594031
  var valid_594032 = path.getOrDefault("subscriptionId")
  valid_594032 = validateParameter(valid_594032, JString, required = true,
                                 default = nil)
  if valid_594032 != nil:
    section.add "subscriptionId", valid_594032
  var valid_594033 = path.getOrDefault("locationName")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = nil)
  if valid_594033 != nil:
    section.add "locationName", valid_594033
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
  var valid_594034 = query.getOrDefault("api-version")
  valid_594034 = validateParameter(valid_594034, JString, required = true,
                                 default = nil)
  if valid_594034 != nil:
    section.add "api-version", valid_594034
  var valid_594035 = query.getOrDefault("databaseState")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = newJString("All"))
  if valid_594035 != nil:
    section.add "databaseState", valid_594035
  var valid_594036 = query.getOrDefault("onlyLatestPerDatabase")
  valid_594036 = validateParameter(valid_594036, JBool, required = false, default = nil)
  if valid_594036 != nil:
    section.add "onlyLatestPerDatabase", valid_594036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594037: Call_LongTermRetentionBackupsListByResourceGroupLocation_594028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the long term retention backups for a given location.
  ## 
  let valid = call_594037.validator(path, query, header, formData, body)
  let scheme = call_594037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594037.url(scheme.get, call_594037.host, call_594037.base,
                         call_594037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594037, url, valid)

proc call*(call_594038: Call_LongTermRetentionBackupsListByResourceGroupLocation_594028;
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
  var path_594039 = newJObject()
  var query_594040 = newJObject()
  add(path_594039, "resourceGroupName", newJString(resourceGroupName))
  add(query_594040, "api-version", newJString(apiVersion))
  add(path_594039, "subscriptionId", newJString(subscriptionId))
  add(path_594039, "locationName", newJString(locationName))
  add(query_594040, "databaseState", newJString(databaseState))
  add(query_594040, "onlyLatestPerDatabase", newJBool(onlyLatestPerDatabase))
  result = call_594038.call(path_594039, query_594040, nil, nil, nil)

var longTermRetentionBackupsListByResourceGroupLocation* = Call_LongTermRetentionBackupsListByResourceGroupLocation_594028(
    name: "longTermRetentionBackupsListByResourceGroupLocation",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionBackups",
    validator: validate_LongTermRetentionBackupsListByResourceGroupLocation_594029,
    base: "", url: url_LongTermRetentionBackupsListByResourceGroupLocation_594030,
    schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsListByResourceGroupServer_594041 = ref object of OpenApiRestCall_593425
proc url_LongTermRetentionBackupsListByResourceGroupServer_594043(
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

proc validate_LongTermRetentionBackupsListByResourceGroupServer_594042(
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
  var valid_594044 = path.getOrDefault("resourceGroupName")
  valid_594044 = validateParameter(valid_594044, JString, required = true,
                                 default = nil)
  if valid_594044 != nil:
    section.add "resourceGroupName", valid_594044
  var valid_594045 = path.getOrDefault("subscriptionId")
  valid_594045 = validateParameter(valid_594045, JString, required = true,
                                 default = nil)
  if valid_594045 != nil:
    section.add "subscriptionId", valid_594045
  var valid_594046 = path.getOrDefault("longTermRetentionServerName")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "longTermRetentionServerName", valid_594046
  var valid_594047 = path.getOrDefault("locationName")
  valid_594047 = validateParameter(valid_594047, JString, required = true,
                                 default = nil)
  if valid_594047 != nil:
    section.add "locationName", valid_594047
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
  var valid_594048 = query.getOrDefault("api-version")
  valid_594048 = validateParameter(valid_594048, JString, required = true,
                                 default = nil)
  if valid_594048 != nil:
    section.add "api-version", valid_594048
  var valid_594049 = query.getOrDefault("databaseState")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = newJString("All"))
  if valid_594049 != nil:
    section.add "databaseState", valid_594049
  var valid_594050 = query.getOrDefault("onlyLatestPerDatabase")
  valid_594050 = validateParameter(valid_594050, JBool, required = false, default = nil)
  if valid_594050 != nil:
    section.add "onlyLatestPerDatabase", valid_594050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594051: Call_LongTermRetentionBackupsListByResourceGroupServer_594041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the long term retention backups for a given server.
  ## 
  let valid = call_594051.validator(path, query, header, formData, body)
  let scheme = call_594051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594051.url(scheme.get, call_594051.host, call_594051.base,
                         call_594051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594051, url, valid)

proc call*(call_594052: Call_LongTermRetentionBackupsListByResourceGroupServer_594041;
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
  var path_594053 = newJObject()
  var query_594054 = newJObject()
  add(path_594053, "resourceGroupName", newJString(resourceGroupName))
  add(query_594054, "api-version", newJString(apiVersion))
  add(path_594053, "subscriptionId", newJString(subscriptionId))
  add(path_594053, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_594053, "locationName", newJString(locationName))
  add(query_594054, "databaseState", newJString(databaseState))
  add(query_594054, "onlyLatestPerDatabase", newJBool(onlyLatestPerDatabase))
  result = call_594052.call(path_594053, query_594054, nil, nil, nil)

var longTermRetentionBackupsListByResourceGroupServer* = Call_LongTermRetentionBackupsListByResourceGroupServer_594041(
    name: "longTermRetentionBackupsListByResourceGroupServer",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionBackups",
    validator: validate_LongTermRetentionBackupsListByResourceGroupServer_594042,
    base: "", url: url_LongTermRetentionBackupsListByResourceGroupServer_594043,
    schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsListByResourceGroupDatabase_594055 = ref object of OpenApiRestCall_593425
proc url_LongTermRetentionBackupsListByResourceGroupDatabase_594057(
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

proc validate_LongTermRetentionBackupsListByResourceGroupDatabase_594056(
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
  var valid_594058 = path.getOrDefault("resourceGroupName")
  valid_594058 = validateParameter(valid_594058, JString, required = true,
                                 default = nil)
  if valid_594058 != nil:
    section.add "resourceGroupName", valid_594058
  var valid_594059 = path.getOrDefault("longTermRetentionDatabaseName")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = nil)
  if valid_594059 != nil:
    section.add "longTermRetentionDatabaseName", valid_594059
  var valid_594060 = path.getOrDefault("subscriptionId")
  valid_594060 = validateParameter(valid_594060, JString, required = true,
                                 default = nil)
  if valid_594060 != nil:
    section.add "subscriptionId", valid_594060
  var valid_594061 = path.getOrDefault("longTermRetentionServerName")
  valid_594061 = validateParameter(valid_594061, JString, required = true,
                                 default = nil)
  if valid_594061 != nil:
    section.add "longTermRetentionServerName", valid_594061
  var valid_594062 = path.getOrDefault("locationName")
  valid_594062 = validateParameter(valid_594062, JString, required = true,
                                 default = nil)
  if valid_594062 != nil:
    section.add "locationName", valid_594062
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
  var valid_594063 = query.getOrDefault("api-version")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "api-version", valid_594063
  var valid_594064 = query.getOrDefault("databaseState")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = newJString("All"))
  if valid_594064 != nil:
    section.add "databaseState", valid_594064
  var valid_594065 = query.getOrDefault("onlyLatestPerDatabase")
  valid_594065 = validateParameter(valid_594065, JBool, required = false, default = nil)
  if valid_594065 != nil:
    section.add "onlyLatestPerDatabase", valid_594065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594066: Call_LongTermRetentionBackupsListByResourceGroupDatabase_594055;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all long term retention backups for a database.
  ## 
  let valid = call_594066.validator(path, query, header, formData, body)
  let scheme = call_594066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594066.url(scheme.get, call_594066.host, call_594066.base,
                         call_594066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594066, url, valid)

proc call*(call_594067: Call_LongTermRetentionBackupsListByResourceGroupDatabase_594055;
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
  var path_594068 = newJObject()
  var query_594069 = newJObject()
  add(path_594068, "resourceGroupName", newJString(resourceGroupName))
  add(query_594069, "api-version", newJString(apiVersion))
  add(path_594068, "longTermRetentionDatabaseName",
      newJString(longTermRetentionDatabaseName))
  add(path_594068, "subscriptionId", newJString(subscriptionId))
  add(path_594068, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_594068, "locationName", newJString(locationName))
  add(query_594069, "databaseState", newJString(databaseState))
  add(query_594069, "onlyLatestPerDatabase", newJBool(onlyLatestPerDatabase))
  result = call_594067.call(path_594068, query_594069, nil, nil, nil)

var longTermRetentionBackupsListByResourceGroupDatabase* = Call_LongTermRetentionBackupsListByResourceGroupDatabase_594055(
    name: "longTermRetentionBackupsListByResourceGroupDatabase",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionDatabases/{longTermRetentionDatabaseName}/longTermRetentionBackups",
    validator: validate_LongTermRetentionBackupsListByResourceGroupDatabase_594056,
    base: "", url: url_LongTermRetentionBackupsListByResourceGroupDatabase_594057,
    schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsGetByResourceGroup_594070 = ref object of OpenApiRestCall_593425
proc url_LongTermRetentionBackupsGetByResourceGroup_594072(protocol: Scheme;
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

proc validate_LongTermRetentionBackupsGetByResourceGroup_594071(path: JsonNode;
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
  var valid_594073 = path.getOrDefault("resourceGroupName")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "resourceGroupName", valid_594073
  var valid_594074 = path.getOrDefault("longTermRetentionDatabaseName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "longTermRetentionDatabaseName", valid_594074
  var valid_594075 = path.getOrDefault("subscriptionId")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "subscriptionId", valid_594075
  var valid_594076 = path.getOrDefault("backupName")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "backupName", valid_594076
  var valid_594077 = path.getOrDefault("longTermRetentionServerName")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "longTermRetentionServerName", valid_594077
  var valid_594078 = path.getOrDefault("locationName")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "locationName", valid_594078
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594079 = query.getOrDefault("api-version")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "api-version", valid_594079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594080: Call_LongTermRetentionBackupsGetByResourceGroup_594070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a long term retention backup.
  ## 
  let valid = call_594080.validator(path, query, header, formData, body)
  let scheme = call_594080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594080.url(scheme.get, call_594080.host, call_594080.base,
                         call_594080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594080, url, valid)

proc call*(call_594081: Call_LongTermRetentionBackupsGetByResourceGroup_594070;
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
  var path_594082 = newJObject()
  var query_594083 = newJObject()
  add(path_594082, "resourceGroupName", newJString(resourceGroupName))
  add(query_594083, "api-version", newJString(apiVersion))
  add(path_594082, "longTermRetentionDatabaseName",
      newJString(longTermRetentionDatabaseName))
  add(path_594082, "subscriptionId", newJString(subscriptionId))
  add(path_594082, "backupName", newJString(backupName))
  add(path_594082, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_594082, "locationName", newJString(locationName))
  result = call_594081.call(path_594082, query_594083, nil, nil, nil)

var longTermRetentionBackupsGetByResourceGroup* = Call_LongTermRetentionBackupsGetByResourceGroup_594070(
    name: "longTermRetentionBackupsGetByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionDatabases/{longTermRetentionDatabaseName}/longTermRetentionBackups/{backupName}",
    validator: validate_LongTermRetentionBackupsGetByResourceGroup_594071,
    base: "", url: url_LongTermRetentionBackupsGetByResourceGroup_594072,
    schemes: {Scheme.Https})
type
  Call_LongTermRetentionBackupsDeleteByResourceGroup_594084 = ref object of OpenApiRestCall_593425
proc url_LongTermRetentionBackupsDeleteByResourceGroup_594086(protocol: Scheme;
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

proc validate_LongTermRetentionBackupsDeleteByResourceGroup_594085(
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
  var valid_594087 = path.getOrDefault("resourceGroupName")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "resourceGroupName", valid_594087
  var valid_594088 = path.getOrDefault("longTermRetentionDatabaseName")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "longTermRetentionDatabaseName", valid_594088
  var valid_594089 = path.getOrDefault("subscriptionId")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = nil)
  if valid_594089 != nil:
    section.add "subscriptionId", valid_594089
  var valid_594090 = path.getOrDefault("backupName")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "backupName", valid_594090
  var valid_594091 = path.getOrDefault("longTermRetentionServerName")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "longTermRetentionServerName", valid_594091
  var valid_594092 = path.getOrDefault("locationName")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = nil)
  if valid_594092 != nil:
    section.add "locationName", valid_594092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594093 = query.getOrDefault("api-version")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "api-version", valid_594093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594094: Call_LongTermRetentionBackupsDeleteByResourceGroup_594084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long term retention backup.
  ## 
  let valid = call_594094.validator(path, query, header, formData, body)
  let scheme = call_594094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594094.url(scheme.get, call_594094.host, call_594094.base,
                         call_594094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594094, url, valid)

proc call*(call_594095: Call_LongTermRetentionBackupsDeleteByResourceGroup_594084;
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
  var path_594096 = newJObject()
  var query_594097 = newJObject()
  add(path_594096, "resourceGroupName", newJString(resourceGroupName))
  add(query_594097, "api-version", newJString(apiVersion))
  add(path_594096, "longTermRetentionDatabaseName",
      newJString(longTermRetentionDatabaseName))
  add(path_594096, "subscriptionId", newJString(subscriptionId))
  add(path_594096, "backupName", newJString(backupName))
  add(path_594096, "longTermRetentionServerName",
      newJString(longTermRetentionServerName))
  add(path_594096, "locationName", newJString(locationName))
  result = call_594095.call(path_594096, query_594097, nil, nil, nil)

var longTermRetentionBackupsDeleteByResourceGroup* = Call_LongTermRetentionBackupsDeleteByResourceGroup_594084(
    name: "longTermRetentionBackupsDeleteByResourceGroup",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/locations/{locationName}/longTermRetentionServers/{longTermRetentionServerName}/longTermRetentionDatabases/{longTermRetentionDatabaseName}/longTermRetentionBackups/{backupName}",
    validator: validate_LongTermRetentionBackupsDeleteByResourceGroup_594085,
    base: "", url: url_LongTermRetentionBackupsDeleteByResourceGroup_594086,
    schemes: {Scheme.Https})
type
  Call_BackupLongTermRetentionPoliciesListByDatabase_594098 = ref object of OpenApiRestCall_593425
proc url_BackupLongTermRetentionPoliciesListByDatabase_594100(protocol: Scheme;
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

proc validate_BackupLongTermRetentionPoliciesListByDatabase_594099(
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
  var valid_594101 = path.getOrDefault("resourceGroupName")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = nil)
  if valid_594101 != nil:
    section.add "resourceGroupName", valid_594101
  var valid_594102 = path.getOrDefault("serverName")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "serverName", valid_594102
  var valid_594103 = path.getOrDefault("subscriptionId")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "subscriptionId", valid_594103
  var valid_594104 = path.getOrDefault("databaseName")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "databaseName", valid_594104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594105 = query.getOrDefault("api-version")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "api-version", valid_594105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594106: Call_BackupLongTermRetentionPoliciesListByDatabase_594098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a database's long term retention policy.
  ## 
  let valid = call_594106.validator(path, query, header, formData, body)
  let scheme = call_594106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594106.url(scheme.get, call_594106.host, call_594106.base,
                         call_594106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594106, url, valid)

proc call*(call_594107: Call_BackupLongTermRetentionPoliciesListByDatabase_594098;
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
  var path_594108 = newJObject()
  var query_594109 = newJObject()
  add(path_594108, "resourceGroupName", newJString(resourceGroupName))
  add(query_594109, "api-version", newJString(apiVersion))
  add(path_594108, "serverName", newJString(serverName))
  add(path_594108, "subscriptionId", newJString(subscriptionId))
  add(path_594108, "databaseName", newJString(databaseName))
  result = call_594107.call(path_594108, query_594109, nil, nil, nil)

var backupLongTermRetentionPoliciesListByDatabase* = Call_BackupLongTermRetentionPoliciesListByDatabase_594098(
    name: "backupLongTermRetentionPoliciesListByDatabase",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/backupLongTermRetentionPolicies",
    validator: validate_BackupLongTermRetentionPoliciesListByDatabase_594099,
    base: "", url: url_BackupLongTermRetentionPoliciesListByDatabase_594100,
    schemes: {Scheme.Https})
type
  Call_BackupLongTermRetentionPoliciesCreateOrUpdate_594123 = ref object of OpenApiRestCall_593425
proc url_BackupLongTermRetentionPoliciesCreateOrUpdate_594125(protocol: Scheme;
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

proc validate_BackupLongTermRetentionPoliciesCreateOrUpdate_594124(
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
  var valid_594126 = path.getOrDefault("resourceGroupName")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "resourceGroupName", valid_594126
  var valid_594127 = path.getOrDefault("serverName")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "serverName", valid_594127
  var valid_594128 = path.getOrDefault("subscriptionId")
  valid_594128 = validateParameter(valid_594128, JString, required = true,
                                 default = nil)
  if valid_594128 != nil:
    section.add "subscriptionId", valid_594128
  var valid_594129 = path.getOrDefault("databaseName")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "databaseName", valid_594129
  var valid_594130 = path.getOrDefault("policyName")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = newJString("default"))
  if valid_594130 != nil:
    section.add "policyName", valid_594130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594131 = query.getOrDefault("api-version")
  valid_594131 = validateParameter(valid_594131, JString, required = true,
                                 default = nil)
  if valid_594131 != nil:
    section.add "api-version", valid_594131
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

proc call*(call_594133: Call_BackupLongTermRetentionPoliciesCreateOrUpdate_594123;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets a database's long term retention policy.
  ## 
  let valid = call_594133.validator(path, query, header, formData, body)
  let scheme = call_594133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594133.url(scheme.get, call_594133.host, call_594133.base,
                         call_594133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594133, url, valid)

proc call*(call_594134: Call_BackupLongTermRetentionPoliciesCreateOrUpdate_594123;
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
  var path_594135 = newJObject()
  var query_594136 = newJObject()
  var body_594137 = newJObject()
  add(path_594135, "resourceGroupName", newJString(resourceGroupName))
  add(query_594136, "api-version", newJString(apiVersion))
  add(path_594135, "serverName", newJString(serverName))
  add(path_594135, "subscriptionId", newJString(subscriptionId))
  add(path_594135, "databaseName", newJString(databaseName))
  add(path_594135, "policyName", newJString(policyName))
  if parameters != nil:
    body_594137 = parameters
  result = call_594134.call(path_594135, query_594136, nil, nil, body_594137)

var backupLongTermRetentionPoliciesCreateOrUpdate* = Call_BackupLongTermRetentionPoliciesCreateOrUpdate_594123(
    name: "backupLongTermRetentionPoliciesCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/backupLongTermRetentionPolicies/{policyName}",
    validator: validate_BackupLongTermRetentionPoliciesCreateOrUpdate_594124,
    base: "", url: url_BackupLongTermRetentionPoliciesCreateOrUpdate_594125,
    schemes: {Scheme.Https})
type
  Call_BackupLongTermRetentionPoliciesGet_594110 = ref object of OpenApiRestCall_593425
proc url_BackupLongTermRetentionPoliciesGet_594112(protocol: Scheme; host: string;
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

proc validate_BackupLongTermRetentionPoliciesGet_594111(path: JsonNode;
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
  var valid_594113 = path.getOrDefault("resourceGroupName")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "resourceGroupName", valid_594113
  var valid_594114 = path.getOrDefault("serverName")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "serverName", valid_594114
  var valid_594115 = path.getOrDefault("subscriptionId")
  valid_594115 = validateParameter(valid_594115, JString, required = true,
                                 default = nil)
  if valid_594115 != nil:
    section.add "subscriptionId", valid_594115
  var valid_594116 = path.getOrDefault("databaseName")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "databaseName", valid_594116
  var valid_594117 = path.getOrDefault("policyName")
  valid_594117 = validateParameter(valid_594117, JString, required = true,
                                 default = newJString("default"))
  if valid_594117 != nil:
    section.add "policyName", valid_594117
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594118 = query.getOrDefault("api-version")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "api-version", valid_594118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594119: Call_BackupLongTermRetentionPoliciesGet_594110;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a database's long term retention policy.
  ## 
  let valid = call_594119.validator(path, query, header, formData, body)
  let scheme = call_594119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594119.url(scheme.get, call_594119.host, call_594119.base,
                         call_594119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594119, url, valid)

proc call*(call_594120: Call_BackupLongTermRetentionPoliciesGet_594110;
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
  var path_594121 = newJObject()
  var query_594122 = newJObject()
  add(path_594121, "resourceGroupName", newJString(resourceGroupName))
  add(query_594122, "api-version", newJString(apiVersion))
  add(path_594121, "serverName", newJString(serverName))
  add(path_594121, "subscriptionId", newJString(subscriptionId))
  add(path_594121, "databaseName", newJString(databaseName))
  add(path_594121, "policyName", newJString(policyName))
  result = call_594120.call(path_594121, query_594122, nil, nil, nil)

var backupLongTermRetentionPoliciesGet* = Call_BackupLongTermRetentionPoliciesGet_594110(
    name: "backupLongTermRetentionPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/backupLongTermRetentionPolicies/{policyName}",
    validator: validate_BackupLongTermRetentionPoliciesGet_594111, base: "",
    url: url_BackupLongTermRetentionPoliciesGet_594112, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
