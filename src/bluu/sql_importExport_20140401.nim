
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure SQL Database Import/Export spec
## version: 2014-04-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Provides create and read functionality for Import/Export operations on Azure SQL databases.
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

  OpenApiRestCall_563540 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563540](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563540): Option[Scheme] {.used.} =
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
  macServiceName = "sql-importExport"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DatabasesExport_563762 = ref object of OpenApiRestCall_563540
proc url_DatabasesExport_563764(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
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
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/export")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesExport_563763(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Exports a database to a bacpac.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database to be exported.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_563956 = path.getOrDefault("serverName")
  valid_563956 = validateParameter(valid_563956, JString, required = true,
                                 default = nil)
  if valid_563956 != nil:
    section.add "serverName", valid_563956
  var valid_563957 = path.getOrDefault("subscriptionId")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = nil)
  if valid_563957 != nil:
    section.add "subscriptionId", valid_563957
  var valid_563958 = path.getOrDefault("databaseName")
  valid_563958 = validateParameter(valid_563958, JString, required = true,
                                 default = nil)
  if valid_563958 != nil:
    section.add "databaseName", valid_563958
  var valid_563959 = path.getOrDefault("resourceGroupName")
  valid_563959 = validateParameter(valid_563959, JString, required = true,
                                 default = nil)
  if valid_563959 != nil:
    section.add "resourceGroupName", valid_563959
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563960 = query.getOrDefault("api-version")
  valid_563960 = validateParameter(valid_563960, JString, required = true,
                                 default = nil)
  if valid_563960 != nil:
    section.add "api-version", valid_563960
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The required parameters for exporting a database.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_563984: Call_DatabasesExport_563762; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports a database to a bacpac.
  ## 
  let valid = call_563984.validator(path, query, header, formData, body)
  let scheme = call_563984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563984.url(scheme.get, call_563984.host, call_563984.base,
                         call_563984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563984, url, valid)

proc call*(call_564055: Call_DatabasesExport_563762; apiVersion: string;
          serverName: string; subscriptionId: string; databaseName: string;
          resourceGroupName: string; parameters: JsonNode): Recallable =
  ## databasesExport
  ## Exports a database to a bacpac.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database to be exported.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The required parameters for exporting a database.
  var path_564056 = newJObject()
  var query_564058 = newJObject()
  var body_564059 = newJObject()
  add(query_564058, "api-version", newJString(apiVersion))
  add(path_564056, "serverName", newJString(serverName))
  add(path_564056, "subscriptionId", newJString(subscriptionId))
  add(path_564056, "databaseName", newJString(databaseName))
  add(path_564056, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564059 = parameters
  result = call_564055.call(path_564056, query_564058, nil, nil, body_564059)

var databasesExport* = Call_DatabasesExport_563762(name: "databasesExport",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/export",
    validator: validate_DatabasesExport_563763, base: "", url: url_DatabasesExport_563764,
    schemes: {Scheme.Https})
type
  Call_DatabasesCreateImportOperation_564098 = ref object of OpenApiRestCall_563540
proc url_DatabasesCreateImportOperation_564100(protocol: Scheme; host: string;
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
  assert "extensionName" in path, "`extensionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/databases/"),
               (kind: VariableSegment, value: "databaseName"),
               (kind: ConstantSegment, value: "/extensions/"),
               (kind: VariableSegment, value: "extensionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesCreateImportOperation_564099(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an import operation that imports a bacpac into an existing database. The existing database must be empty.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   extensionName: JString (required)
  ##                : The name of the operation to perform
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: JString (required)
  ##               : The name of the database to import into
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `extensionName` field"
  var valid_564114 = path.getOrDefault("extensionName")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = newJString("import"))
  if valid_564114 != nil:
    section.add "extensionName", valid_564114
  var valid_564115 = path.getOrDefault("serverName")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "serverName", valid_564115
  var valid_564116 = path.getOrDefault("subscriptionId")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "subscriptionId", valid_564116
  var valid_564117 = path.getOrDefault("databaseName")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "databaseName", valid_564117
  var valid_564118 = path.getOrDefault("resourceGroupName")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "resourceGroupName", valid_564118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564119 = query.getOrDefault("api-version")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "api-version", valid_564119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The required parameters for importing a Bacpac into a database.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564121: Call_DatabasesCreateImportOperation_564098; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an import operation that imports a bacpac into an existing database. The existing database must be empty.
  ## 
  let valid = call_564121.validator(path, query, header, formData, body)
  let scheme = call_564121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564121.url(scheme.get, call_564121.host, call_564121.base,
                         call_564121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564121, url, valid)

proc call*(call_564122: Call_DatabasesCreateImportOperation_564098;
          apiVersion: string; serverName: string; subscriptionId: string;
          databaseName: string; resourceGroupName: string; parameters: JsonNode;
          extensionName: string = "import"): Recallable =
  ## databasesCreateImportOperation
  ## Creates an import operation that imports a bacpac into an existing database. The existing database must be empty.
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   extensionName: string (required)
  ##                : The name of the operation to perform
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   databaseName: string (required)
  ##               : The name of the database to import into
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The required parameters for importing a Bacpac into a database.
  var path_564123 = newJObject()
  var query_564124 = newJObject()
  var body_564125 = newJObject()
  add(query_564124, "api-version", newJString(apiVersion))
  add(path_564123, "extensionName", newJString(extensionName))
  add(path_564123, "serverName", newJString(serverName))
  add(path_564123, "subscriptionId", newJString(subscriptionId))
  add(path_564123, "databaseName", newJString(databaseName))
  add(path_564123, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564125 = parameters
  result = call_564122.call(path_564123, query_564124, nil, nil, body_564125)

var databasesCreateImportOperation* = Call_DatabasesCreateImportOperation_564098(
    name: "databasesCreateImportOperation", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/databases/{databaseName}/extensions/{extensionName}",
    validator: validate_DatabasesCreateImportOperation_564099, base: "",
    url: url_DatabasesCreateImportOperation_564100, schemes: {Scheme.Https})
type
  Call_DatabasesImport_564126 = ref object of OpenApiRestCall_563540
proc url_DatabasesImport_564128(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "serverName" in path, "`serverName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Sql/servers/"),
               (kind: VariableSegment, value: "serverName"),
               (kind: ConstantSegment, value: "/import")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DatabasesImport_564127(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Imports a bacpac into a new database. 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serverName: JString (required)
  ##             : The name of the server.
  ##   subscriptionId: JString (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serverName` field"
  var valid_564129 = path.getOrDefault("serverName")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "serverName", valid_564129
  var valid_564130 = path.getOrDefault("subscriptionId")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "subscriptionId", valid_564130
  var valid_564131 = path.getOrDefault("resourceGroupName")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "resourceGroupName", valid_564131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the request.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564132 = query.getOrDefault("api-version")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "api-version", valid_564132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The required parameters for importing a Bacpac into a database.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564134: Call_DatabasesImport_564126; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a bacpac into a new database. 
  ## 
  let valid = call_564134.validator(path, query, header, formData, body)
  let scheme = call_564134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564134.url(scheme.get, call_564134.host, call_564134.base,
                         call_564134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564134, url, valid)

proc call*(call_564135: Call_DatabasesImport_564126; apiVersion: string;
          serverName: string; subscriptionId: string; resourceGroupName: string;
          parameters: JsonNode): Recallable =
  ## databasesImport
  ## Imports a bacpac into a new database. 
  ##   apiVersion: string (required)
  ##             : The API version to use for the request.
  ##   serverName: string (required)
  ##             : The name of the server.
  ##   subscriptionId: string (required)
  ##                 : The subscription ID that identifies an Azure subscription.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   parameters: JObject (required)
  ##             : The required parameters for importing a Bacpac into a database.
  var path_564136 = newJObject()
  var query_564137 = newJObject()
  var body_564138 = newJObject()
  add(query_564137, "api-version", newJString(apiVersion))
  add(path_564136, "serverName", newJString(serverName))
  add(path_564136, "subscriptionId", newJString(subscriptionId))
  add(path_564136, "resourceGroupName", newJString(resourceGroupName))
  if parameters != nil:
    body_564138 = parameters
  result = call_564135.call(path_564136, query_564137, nil, nil, body_564138)

var databasesImport* = Call_DatabasesImport_564126(name: "databasesImport",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Sql/servers/{serverName}/import",
    validator: validate_DatabasesImport_564127, base: "", url: url_DatabasesImport_564128,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
